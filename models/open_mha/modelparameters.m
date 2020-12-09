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
mp.simDuration = 1; %.001;
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
X_high      = 93;            % Declare maximum dB output suitable for Gain Table  

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
FFTsize  = 256;
num_bins = FFTsize/2 + 1;
freq     = linspace(0,24000,129);
binwidth = (audio_fs/2)/(FFTsize/2);

%% Calculate Freq Band State Controller Parameters
band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);
band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands);
mirrored_band_edges = calculate_mirrored_band_edges(band_sizes, FFTsize, num_bins, num_bands);
band_edges = [band_edges mirrored_band_edges];

%% Look Up Table Parameters
look_up_table_size = 1024;
dB_low             = 0;
dB_high            = 96;
table_index_low    = dB2lin(dB_low,1);
table_index_high   = dB2lin(dB_high,1);

% Look Up Table Indexing 
table_indexing     = logspace(log10(table_index_low), log10(table_index_high), look_up_table_size); % Line 164 of mha_signal.hh
table_indexing_fp  = fi(table_indexing,0,40,38);
% Look Up Table dB Values
table_init         = linspace(dB_low, dB_high, look_up_table_size)';
table_init_fp      = fi(table_init,in_fp_sign,in_fp_size,in_fp_dec);

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
gain_table_min_input  = 0;
gain_table_input_step = 3;
gain_table_max_input  = 93;
input_levels_db       = gain_table_min_input:gain_table_input_step:gain_table_max_input;
table_length          = size(input_levels_db,2);

audio_dB_level_min = 0;
audio_dB_level_max = 96;
mins               = audio_dB_level_min*ones(1,num_bands); % Maximum audio input level .......................................... dB
maxes              = audio_dB_level_max*ones(1,num_bands); % Minimum audio input level .......................................... dB
boost              = 0;                                    % Amount to boost the minimum level to be heard comfortably .......... dB

vy = calculateGainArray(mins, boost, maxes, input_levels_db);

numgainentries = length(vy);

RAM_size = ceil(log2(numgainentries));

RAM_addresses = 2^RAM_size;

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
