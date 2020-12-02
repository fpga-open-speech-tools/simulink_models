% Matthew Blunt
% openMHA Test Concatenated DC Model Init Script
% 10/09/20

% Created to test full dynamic compression model functionality from FFT
% data to gain table

% clear all;

%% Add Subfolders to MATLAB Path

addpath(genpath('variable_delay'));
addpath(genpath('referenced_functions'));
addpath(genpath('gain_calculation'));

%% Declare Sampling Rate

fs = 48000;

%% Declare Data Type

Wbits = 40;    %fixdt(1,Wbits,Fbits)
Fbits = 32;

%% Simulation Type - Either 'double' or 'fxpt'
sim_type = 'fxpt';                  

% Data Input/Feedback Fixed Point Paramters
in_fp_size = 40; % Word Size
in_fp_dec  = 32; % Fractional Bits
in_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Attack and Decay Coefficient Fixed Point Paramters
ad_coeff_fp_size = 16; % Word Size
ad_coeff_fp_dec  = 16; % Fractional Bits
ad_coeff_fp_sign = 0;  % Unsigned = 0, Signed = 1

% Gain - Fixed Point Paramters
gain_coeff_fp_size = 16; % Word Size
gain_coeff_fp_dec  = 8;  % Fractional Bits
gain_coeff_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Define the Input Data Types
if(strcmp(sim_type,'double'))
    input_type      = 'double';
    ad_coeff_type   = 'double';
    gain_coeff_type = 'double';
elseif(strcmp(sim_type,'fxpt'))
    input_type      = fixdt(in_fp_sign,in_fp_size,in_fp_dec);
    ad_coeff_type   = fixdt(ad_coeff_fp_sign,ad_coeff_fp_size,ad_coeff_fp_dec);
    gain_coeff_type = fixdt(gain_coeff_fp_sign,gain_coeff_fp_size,gain_coeff_fp_dec);
end

%% Declare FFT Parameters

FFTsize = 256;
num_bins = FFTsize/2 + 1;
freq = linspace(0,24000,129);
binwidth = (fs/2)/(FFTsize/2);

%% Declare Freq Band Information

% *** 2 Band Test Info *** %
% num_bands = 2;
% ef = [0 11999 24000];

% *** 8 Band Test Info *** %
num_bands = 8;
ef = [0 250 500 750 1000 2000 4000 12000 24000];

% Calculate Freq Band State Controller Parameters
band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);
band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands);
mirrored_band_edges = calculate_mirrored_band_edges(band_sizes, FFTsize, num_bins, num_bands);
band_edges = [band_edges mirrored_band_edges];

%% Declare Attack and Release Time Constants

% Note that example attack and release time constants found in the openMHA 
% Dynamic Compression Plugin documentation are used for testing

tau_a = 0.020; % seconds
tau_r = 0.100; % seconds

%% Calculate Attack-Release Filter Coefficients

% Calculating filter coefficients as done in the source code C++ file
% mha_filter.cpp

% Attack Filter Coefficients
c1_a = exp( -1.0/(tau_a * fs) );
c2_a = 1.0 - c1_a;

% Release Filter Coefficients
c1_r = exp( -1.0/(tau_r * fs) );
c2_r = 1.0 - c1_r;



%% Declare Attack and Release Time Constants for Each Frequency Band

% Different time constants are chosen for easy difference in testing

% Base time constants
tau_a = 0.020; % seconds
tau_r = 0.100; % seconds

% Calculating vector easily via multiples of base constants
tau_as = tau_a.*[1:0.2:num_bands]';
tau_rs = tau_r.*[1:0.2:num_bands]';

z = 1;
for i = 1:2:2*num_bands-1
    ar_taus(i) = tau_as(z);
    ar_taus(i+1) = tau_rs(z);
    z = z+1;
end

%% Initialize Attack-Release Filter Coefficient Dual-Port Memory

% Declaring RAM port width
coeff_size = 8;

%% Calculate Attack-Release Filter Coefficients

% Calculating filter coefficients as done in the source code C++ file
% mha_filter.cpp

ar_coeffs = zeros(2^coeff_size,1);
ar_coeffs(1:2*num_bands) = exp( -1.0./(ar_taus(1:2*num_bands).*fs) );

%% Initialize Filter Buffer Values

buf_a = 65.*ones(num_bands,1);
buf_r = 65.*ones(num_bands,1);

%% Calculate New Attack-Release Filter Coefficients

% Created for testing of coefficient write functionality

% ar_coeffs_new = [...]';

%% dB Lookup Table Parameters

% Declare maximum dB output suitable for Gain Table
X_high = 93;

%% Gain Table Parameters

% gtmin = 0;
% gtstep = 4;
% gtdata = [0 20 31 34 37 40 39 38 37 36 35 34 33 32 31 30 26 22 18 14 10 6 2 -2 -2];
% table_length = length(gtdata);
% 
% figure()
% plot(gtstep.*(0:1:length(gtdata)-1),gtdata);
% hold on;

gtmin = 0;
gtstep = 3;
gtdata = [0 15 25 32 34 36 38 40 39.25 38.5 37.75 37 36.25 35.5 34.75 34 33.25 32.5 31.75 31 28 25 22 19 16 13 10 7 4 1 -2 -2];
table_length = length(gtdata);


% plot(gtstep.*(0:1:length(gtdata)-1),gtdata);
% hold off;

for i = 1:length(gtdata)
    input_levels_db(i) = gtmin + (i-1)*gtstep;
end

% Declaring Gain Vectors for each Frequency Band in dB and Concatenating
gt_db = [];
for i = 1:num_bands
    gt_db = [gt_db gtdata];
end

% Map dB gains to Linear Factors
gt = 10.^(gt_db./20);

% Transposing Table to Simulate DP Memory Table
dp_gt = gt';

% Sizing DP Table to match Address Port Width of RAM Block
numgainentries = table_length*num_bands;
RAM_size = ceil(log2(numgainentries));
% RAM_size = ceil(log2(numgainentries));   % number of bits
RAM_addresses = 2^RAM_size;
vy = dp_gt;
for i = length(dp_gt)+1:RAM_addresses
    vy(i,1) = 0;
end

%% Dual-Port Gain Application Parameters

gainapp_dp_memory = log2(num_bands) + 1;

%% Declare Input Signal

% % Data Input Signal (Input Level Lst [dB])
% Lst = [ 55.*ones(25000*num_bands,1); 90.*ones(25000*num_bands,1); 55.*ones(25000*num_bands,1); 90.*ones(25000*num_bands,1); 55.*ones(25000*num_bands,1); ];
% 
% % Data Input Signal (Input Level level_in [Pa^2])
% level_in = (10.^(Lst./10))./2500000000;

% Translate desired dB value and number of bins per band into symmetric FFT
% data
% *** % NOTE: Will need to change to adjust for number of bands and desired
% signal behavior
input_length = 15;

for i = 1:num_bands
   [Pa2val1(i),FFTval1(i)] = dB2lin(55,band_sizes(i));
   [Pa2val2(i),FFTval2(i)] = dB2lin(90,band_sizes(i));
end

i = 1;
FFT_data_real = [];
FFT_data_imag = [];
for i = 1:input_length/3
    FFT_data_real = [FFT_data_real FFTval1(1).*ones(1,band_sizes(1)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(8).*ones(1,band_sizes(8)) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
    FFT_data_imag = [FFT_data_imag FFTval1(1).*ones(1,band_sizes(1)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(8).*ones(1,band_sizes(8)) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
end

i = 1;
for i = 1:input_length/3
    FFT_data_real = [FFT_data_real FFTval2(1).*ones(1,band_sizes(1)) FFTval1(2).*ones(1,band_sizes(2)) FFTval2(3).*ones(1,band_sizes(3)) FFTval1(4).*ones(1,band_sizes(4)) FFTval2(5).*ones(1,band_sizes(5)) FFTval1(6).*ones(1,band_sizes(6)) FFTval2(7).*ones(1,band_sizes(7)) FFTval1(8).*ones(1,band_sizes(8)) FFTval1(8).*ones(1,band_sizes(8)-1) FFTval2(7).*ones(1,band_sizes(7)) FFTval1(6).*ones(1,band_sizes(6)) FFTval2(5).*ones(1,band_sizes(5)) FFTval1(4).*ones(1,band_sizes(4)) FFTval2(3).*ones(1,band_sizes(3)) FFTval1(2).*ones(1,band_sizes(2)) FFTval2(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
    FFT_data_imag = [FFT_data_imag FFTval2(1).*ones(1,band_sizes(1)) FFTval1(2).*ones(1,band_sizes(2)) FFTval2(3).*ones(1,band_sizes(3)) FFTval1(4).*ones(1,band_sizes(4)) FFTval2(5).*ones(1,band_sizes(5)) FFTval1(6).*ones(1,band_sizes(6)) FFTval2(7).*ones(1,band_sizes(7)) FFTval1(8).*ones(1,band_sizes(8)) FFTval1(8).*ones(1,band_sizes(8)-1) FFTval2(7).*ones(1,band_sizes(7)) FFTval1(6).*ones(1,band_sizes(6)) FFTval2(5).*ones(1,band_sizes(5)) FFTval1(4).*ones(1,band_sizes(4)) FFTval2(3).*ones(1,band_sizes(3)) FFTval1(2).*ones(1,band_sizes(2)) FFTval2(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
end

i = 1;
for i = 1:input_length/3
    FFT_data_real = [FFT_data_real FFTval1(1).*ones(1,band_sizes(1)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(8).*ones(1,band_sizes(8)) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
    FFT_data_imag = [FFT_data_imag FFTval1(1).*ones(1,band_sizes(1)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(8).*ones(1,band_sizes(8)) FFTval2(8).*ones(1,band_sizes(8)-1) FFTval1(7).*ones(1,band_sizes(7)) FFTval2(6).*ones(1,band_sizes(6)) FFTval1(5).*ones(1,band_sizes(5)) FFTval2(4).*ones(1,band_sizes(4)) FFTval1(3).*ones(1,band_sizes(3)) FFTval2(2).*ones(1,band_sizes(2)) FFTval1(1).*ones(1,band_sizes(1)-1) zeros(1,44)];
end

Lst1 = [55.*ones(1,input_length/3) 90.*ones(1,input_length/3) 55.*ones(1,input_length/3)];
Lst2 = [90.*ones(1,input_length/3) 55.*ones(1,input_length/3) 90.*ones(1,input_length/3)];


%% Calculate Valid Signal

valid_data = zeros(size(FFT_data_real));
valid_data(find(FFT_data_real)) = 1;

%% Declare Control Signals

% % Band Number State Controller Signal
% for i = 1:num_bands:length(Lst)
%     band_num(i) = 1;
%     band_num(i+1) = 2;
% %     band_num(i+2) = 3;
% %     ...
% end

% Attack-Release Write Enable Signal
write_en_ar = zeros(length(FFT_data_real),1);

% Attack-Release Coefficient Write Data Signal
write_data_ar = zeros(length(FFT_data_real),1);

% Attack-Release Coefficient Write Address Signal
write_addr_ar = zeros(length(FFT_data_real),1);

% Gain Table Write Enable Signal
write_en_vy = zeros(length(FFT_data_real),1);

% Gain Table Write Gain Data Signal
write_data_vy = zeros(length(FFT_data_real),1);

% Gain Table Write Gain Address Signal
write_addr_vy = zeros(length(FFT_data_real),1);

%% Declare Attack-Release Enabled Subsystem Rate Transition Multiplier

% Rate Transition Multiplying Factor to ensure that enabled subsystem
% completes all computations within the major time step
% enabled_rate_mult = 2;

%% Calculating Variable Signal Path Delay

% Calculating gain delay according to the following:
% dB Lookup table delay = 3
% AR Filter delay = 1
% Gain Table delay = 1
% Gain Application Controller delay = 1

% Maximum freq. band size = variable;

gain_delay = 6;
accum_delay = max(band_sizes);
system_delay = gain_delay + accum_delay;
accum_delay_memory = ceil(log2(accum_delay));
system_delay_memory = ceil(log2(system_delay));
delay_memory_size =2^system_delay_memory;
accum_delay_memory_size = 2^accum_delay_memory;


%% Declare Stop Time

% Why is this mp.Fs now instead of fs? Switched for model referencing.
stop_time = (length(FFT_data_real) - 1)/fs/2;
