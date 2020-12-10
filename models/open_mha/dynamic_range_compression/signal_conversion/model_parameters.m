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

%% Initialize
addpath(genpath('band_controller'));         % Frequency Band State Controller
addpath(genpath('intensity'));               % Intensity Conversion
addpath(genpath('dB_lookup_table'));         % pa2 to dB Look Up Table
addpath(genpath('..\referenced_functions')); % Frost Library

load('fft_simulation.mat')
%% Simulation Parameters
stop_time = fft_valid_sim.Time(end);
debug = false;
% Simulation Type - Either 'double' or 'fxpt'
sim_type = 'fxpt';                  

% Data Input/Feedback Fixed Point Paramters
in_fp_size = 40; % Word Size
in_fp_dec  = 32; % Fractional Bits
in_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Define the Input Data Types
if(strcmp(sim_type,'double'))
    input_type    = 'double';
elseif(strcmp(sim_type,'fxpt'))
    input_type    = fixdt(in_fp_sign,in_fp_size,in_fp_dec);
end

%% Open MHA Parameters
coeff_size  = 8;             % Coefficient Address Size
num_bands   = 8;             % Number of Frequency Bands
band_number = 1:1:num_bands; % Create an array of band numbers
num_coeff   = 2;             % Number of C1 Coefficients required by the Attack and Decay Filter
ef          = [0 250 500 750 1000 2000 4000 12000 24000];
dB_low      = 0;
dB_high     = 93;
dB_step     = 3;
X_high      = dB_high-dB_step;            % Declare maximum dB output suitable for Gain Table  

%% Sampling Frequencies
audio_fs           = 48e3;                          % Audio Sampling Rate from the AD1939
fft_up_sample_rate = 128;                           % FFT Up Sample Rate
fs                 = audio_fs * fft_up_sample_rate; % Samplig Frequency

%% Declare FFT Parameters
FFTsize = 256;
num_bins = FFTsize/2 + 1;
freq = linspace(0,24000,129);
binwidth = (audio_fs/2)/(FFTsize/2);

%% Declare Freq Band Information
num_bands = 8;
ef = [0 250 500 750 1000 2000 4000 12000 24000];

% Calculate Freq Band State Controller Parameters
band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);
band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands);
mirrored_band_edges = calculate_mirrored_band_edges(band_sizes, FFTsize, num_bins, num_bands);
band_edges = [band_edges mirrored_band_edges];

%% Look Up Table Parameters
look_up_table_size = 1024;
table_index_low    = dB2lin(dB_low,1);
table_index_high   = dB2lin(dB_high,1);

% Look Up Table Indexing 
table_indexing     = logspace(log10(table_index_low), log10(table_index_high), look_up_table_size); % Line 164 of mha_signal.hh
table_indexing_fp  = fi(table_indexing,0,40,38);
% Look Up Table dB Values
table_init         = linspace(dB_low, dB_high, look_up_table_size)';
table_init_fp      = fi(table_init,in_fp_sign,in_fp_size,in_fp_dec);

maxInput = 1;
binaryOffset = ceil(log2(maxInput)); % used for binary tricks, as well as identifying input range
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