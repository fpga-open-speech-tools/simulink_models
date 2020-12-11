% modelparameters.m
%
% Copyright 2020 AudioLogic, Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Connor Dack
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Add the Model Referencing Paths
addpath(genpath('dynamic_range_compression')); % Open MHA Dynamic Range Compression Block
addpath(genpath('..\dpr_interface'));          % Dual Port RAM Interface
addpath(genpath('..\fast_fourier_transform')); % Fast Fourier Transform Refence Models
    
%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'acoustic.wav'];

mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 1e-3;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;
mp.useAvalonInterface = false;

stop_time = mp.simDuration;
%% FFT Parameters 
mp.FFT_size                = 256;
mp.FFT_size_Nbits          = log2(mp.FFT_size);
mp.FFT_size_half           = mp.FFT_size/2;
mp.FFT_frame_shift         = mp.FFT_size/4;  % Changiing this from a divide by four implies substantial architectural changes
mp.FFT_frame_shift_Nbits   = log2(mp.FFT_frame_shift);

mp.DPRAM1_size             = mp.FFT_size*2;  % number of words
mp.DPRAM1_address_size     = log2(mp.DPRAM1_size);

mp.SysRate_Upsample_Factor = mp.FFT_size/mp.FFT_frame_shift * 8 * 4;  % How much faster the fast clock must be to complete a FFT within the time of FFT_frame_shift number of samples

%% Open MHA Parameters
coeff_size  = 8;             % Coefficient Address Size
num_bands   = 8;             % Number of Frequency Bands
band_number = 1:1:num_bands; % Create an array of band numbers
num_coeff   = 2;             % Number of C1 Coefficients required by the Attack and Decay Filter
ef          = [0 250 500 750 1000 2000 4000 12000 24000];

% Pre Lookup Parameters
dB_min  = 0;
dB_max  = 92;
dB_step = 4;
X_high  = dB_max-dB_step;            % Declare maximum dB output suitable for Gain Table  
prelookup_table_size = (dB_max - dB_min)/dB_step + 1;

% Gain Parameters
dB_gain_low  = 20;
dB_gain_high = 50;

%% Sampling Frequencies
audio_fs           = 48e3;                          % Audio Sampling Rate from the AD1939
fft_up_sample_rate = 128;                           % FFT Up Sample Rate
fs                 = audio_fs * fft_up_sample_rate; % Samplig Frequency

%% Simulation Type - Either 'double' or 'fxpt'
sim_type = 'fxpt';                  

% Data Input/Feedback Fixed Point Paramters
in_fp_size = 40; % Word Size
in_fp_dec  = 32; % Fractional Bits
in_fp_sign = 1;  % Unsigned = 0, Signed = 1
input_type = fixdt(in_fp_sign,in_fp_size,in_fp_dec);

% Attack and Decay Coefficient Fixed Point Paramters
ad_coeff_fp_size = 16; % Word Size
ad_coeff_fp_dec  = 16; % Fractional Bits
ad_coeff_fp_sign = 0;  % Unsigned = 0, Signed = 1
ad_coeff_type    = fixdt(ad_coeff_fp_sign,ad_coeff_fp_size,ad_coeff_fp_dec);

% Gain - Fixed Point Paramters
gain_coeff_fp_size = 16; % Word Size
gain_coeff_fp_dec  = 8;  % Fractional Bits
gain_coeff_fp_sign = 1;  % Unsigned = 0, Signed = 1
gain_coeff_type    = fixdt(gain_coeff_fp_sign,gain_coeff_fp_size,gain_coeff_fp_dec);

% Prelook Up Table: Fractional - Fixed Point Paramters
frac_coeff_fp_size = 32; % Word Size
frac_coeff_fp_dec  = 32; % Fractional Bits
frac_coeff_fp_sign = 0;  % Unsigned = 0, Signed = 1
frac_coeff_type    = fixdt(frac_coeff_fp_sign,frac_coeff_fp_size,frac_coeff_fp_dec);

%% Declare FFT Parameters
FFTsize  = mp.FFT_size;
num_bins = FFTsize/2 + 1;
freq     = linspace(0,24000,129);
binwidth = (audio_fs/2)/(FFTsize/2);

%% Calculate Freq Band State Controller Parameters
band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);
band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands);
mirrored_band_edges = calculate_mirrored_band_edges(band_sizes, FFTsize, num_bins, num_bands);
band_edges = [band_edges mirrored_band_edges];

%% Look Up Table Parameters
maxInput = 1;
binaryOffset = ceil(log2(maxInput)); % used for binary tricks, as well as identifying input range
IGOTTHIS = false;
floorParam = 2^-31;
errorParam = 1;
db_table_fn = '10.*log10(2500000000.*xIn)';
ERR_DIAG   = 0;
PLOT_TABLE = 0;
SAVE_TABLE = 0;
W_bits = 40;
F_bits = 32;
ram_size = 8;
% Initialization Function
N_bits = ceil(log2(binaryOffset-log2(floorParam)+1));
M_bits = 1; %this will be updated later as needed

repeatFlag = true;
while(repeatFlag)
    % Define a N point log2 spaced range of inputs, from 2^(d-(2^N_bits -1)) to almost 2^(d+1), 
    % this effectively covers the user defined input range, down to a floor
    % value.
    xIn = zeros(1, 2^(M_bits+N_bits));
    addr = 1;
    for NShifts = 2^N_bits-1:-1:0
        for M = 0:2^M_bits - 1
            xIn(addr) = 2^(binaryOffset-NShifts) + M*2^(binaryOffset-NShifts-M_bits);
            addr = addr+1;
        end
    end

    % use function to define output. note: function must contain input xIn
    % within the string to work properly, and the only output of the function
    % must be the table values.
    tableInit = eval(db_table_fn);
    Table_Init = tableInit;

    RAM_SIZE = N_bits+M_bits;
    maxVal = 2^binaryOffset+ (2^M_bits -1)*2^(binaryOffset-M_bits);
    minVal = 2^(binaryOffset-(2^N_bits-1));
    %set_param(gcb,'MaskDisplay',"disp(sprintf('Programmable Look-up Table\nMemory Used = %d samples and coeffs\nClock Rate Needed = %d Hz', FIR_Uprate*2, Max_Rate)); port_label('input',1,'data'); port_label('input',2,'valid'); port_label('input',3,'Wr_Data'); port_label('input',4,'Wr_Addr'); port_label('input',5,'Wr_En'); port_label('output',1,'data'); port_label('output',2,'valid'); port_label('output',3,'RW_Dout');")

    %%%%%%%%%% check and identify error %%%%%%%%%%%
    % Define a set of test cases for the lookup table with log spaced points
    xTest = logspace(log10(minVal), log10(maxVal), 2^(RAM_SIZE+2));
    xTemp = xIn;
    xIn = xTest;
    % identify the values of the function at xTest
    yTest = eval(db_table_fn);

    % move lookup table input values back to xIn
    xIn = xTemp;

    % Find lookup addresses for each point in xTest
    % Effectively assumes the highest input value, then decreases address until test input is greater than associated table input at that address
    addrTest = zeros(1,length(xTest));
    for it = 1:length(xTest)
        addrTest(it) = 2^RAM_SIZE;
        while(xTest(it) < xIn(addrTest(it)) && addrTest(it) ~= 1)   % find the address associated with an input value closest to and below xTest
            addrTest(it) = addrTest(it) - 1;
        end
        if(addrTest(it)==0)
            addrTest(it) = 1;
        end
    end

    % Check for any possible out of bounds errors (handled similarly in hardware)
    addrTest(addrTest == 2^RAM_SIZE) = 2^RAM_SIZE -1;

    % Get values for linear interpolation of xIn
    xLow  = xIn(addrTest);
    xHigh = xIn(addrTest+1);

    % apply point-slope formula to preform linear interpolation for the table readout
    yLow  = tableInit(addrTest);
    yHigh = tableInit(addrTest+1);
    slope  = (yHigh-yLow) ./ (xHigh - xLow);
    yInter = slope.*(xTest-xLow)+yLow;
    
    % percent error: obt-exp / exp
    %errorFloor = (yTest-yLow)./yTest;  % w/out linear interpolation
    errorInter = (yTest-yInter)./yTest; % w/ linear interpolation
    maxErr = max(abs(errorInter));
    %check while loop condition
    if(100*maxErr <= abs(errorParam))
        repeatFlag = false;
    else

        if(100*maxErr > 8*errorParam)
            M_bits = M_bits+3;
        elseif(100*maxErr > 4*errorParam)
            M_bits = M_bits+2;
        else
            M_bits = M_bits+1;
        end
    end
end

%% Attack and Decay DP-RAM Parameters
%--Attack Coefficients
%-Initialize the attack coefficient arrays: 1 coefficient per band
attack_c1_a_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
attack_c2_a_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
attack_c1_r_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
attack_c2_r_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);

for j = 1:num_bands
    if j == 1
        attack_attack_tau  = 0.005; % Defined in the Open MHA Plug in documnetation
    else
        attack_attack_tau  = attack_attack_tau /2; % Reduce the time constant by half for each consecutive band 
    end
    attack_release_tau = attack_attack_tau; % Set the release time constant equal to the attack time constant - Lines 450-451 of mha_filter.cpp
    
    [attack_c1_a_array(j,1), attack_c2_a_array(j,1)] = o1_lp_coeffs(attack_attack_tau, fs, sim_type, ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);  % Compute the attack coefficients - Lines 589-599 of mha_filter.cpp
    [attack_c1_r_array(j,1), attack_c2_r_array(j,1)] = o1_lp_coeffs(attack_release_tau, fs, sim_type, ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec); % Compute the release coefficients - Lines 589-599 of mha_filter.cpp
end
%--Decay Coefficients
%-Initialize the decay coefficient arrays: 1 coefficient per band
decay_c1_a_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
decay_c2_a_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
decay_c1_r_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);
decay_c2_r_array = fi(zeros(num_bands,1), ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);

decay_attack_tau  = 0; % Line 507 of mha_filter.cpp
for j = 1:num_bands        
    if j == 1
        decay_release_tau = 0.060; % Defined in the Open MHA Plug in documnetation
    else
        decay_release_tau = decay_release_tau / 2; % Reduce the time constant by half for each consecutive band 
    end

    [decay_c1_a_array(j,1), decay_c2_a_array(j,1)] = o1_lp_coeffs(decay_attack_tau, fs, sim_type, ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec);  % Compute the attack coefficients - Lines 589-599 of mha_filter.cpp
    [decay_c1_r_array(j,1), decay_c2_r_array(j,1)] = o1_lp_coeffs(decay_release_tau, fs, sim_type, ad_coeff_fp_sign, ad_coeff_fp_size, ad_coeff_fp_dec); % Compute the release coefficients - Lines 589-599 of mha_filter.cpp
end

%--Dual Port RAM Coefficient Array
ad_coeffs = zeros(2^coeff_size,1);
z = 1;
for i = 1:2:2*num_bands-1
    ad_coeffs(i,1)   = attack_c1_a_array(z);
    ad_coeffs(i+1,1) = decay_c1_r_array(z);
    z = z+1;
end

attack_decay_data_default_value = 1048576;

%% Attack and Decay Delay Block Paramters
buf_a = ones(num_bands,1) .* 65; % Initial Condition of the Attack Filter Delay Block
buf_d = ones(num_bands,1) .* 65; % Initial Condition of the Delay Filter Delay Block

%% Gain Table Parameters
% Pre-lookup table values
input_levels_db = zeros(prelookup_table_size,1);
for i = 1:prelookup_table_size
    input_levels_db(i) = dB_min + (i-1)*dB_step;
end
% Gain Tables
mins  = dB_gain_low*ones(1,num_bands);  % Maximum audio input level .......................................... dB
maxes = dB_gain_high*ones(1,num_bands); % Minimum audio input level .......................................... dB

vy = calculateGainArray(mins, maxes, input_levels_db);
vy = [vy zeros(1,256-length(vy))];
numgainentries = length(vy);
RAM_size = ceil(log2(numgainentries));

RAM_addresses = 2^RAM_size;

% Gain Value to prevent Dual Port Ram Write
gain_table_default_data = 16711680;

%% Dual-Port Gain Application Parameters
gainapp_dp_memory = log2(num_bands) + 1;

gain_delay = 6;
accum_delay = max(band_sizes);
system_delay = gain_delay + accum_delay;
accum_delay_memory = ceil(log2(accum_delay));
system_delay_memory = ceil(log2(system_delay));
delay_memory_size =2^system_delay_memory;
accum_delay_memory_size = 2^accum_delay_memory;
