% Matthew Blunt
% openMHA Test Concatenated DC Model Init Script
% 10/09/20

% Created to test full dynamic compression model functionality from dB
% conversion to gaintable

clear all;

%% Declare Sampling Rate

fs = 48000;

%% Declare Data Type

Wbits = 40;    %fixdt(1,Wbits,Fbits)
Fbits = 32;

%% Declare FFT Parameters

FFTsize = 256;
num_bins = FFTsize/2 + 1;
freq = linspace(0,24000,129);
binwidth = (fs/2)/(FFTsize/2);

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

%% Declare Freq Band Information

% *** 2 Band Test Info *** %
num_bands = 2;

% *** 8 Band Test Info *** %
% num_bands = 8;

%% Declare Attack and Release Time Constants for Each Frequency Band

% Different time constants are chosen for easy difference in testing

% Base time constants
tau_a = 0.020; % seconds
tau_r = 0.100; % seconds

% Calculating vector easily via multiples of base constants
tau_as = tau_a.*[1:1:num_bands]';
tau_rs = tau_r.*[1:1:num_bands]';

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

% Declaring Gain Vectors for each Frequency Band in dB
fb1_gains = gtdata;
fb2_gains = gtdata;
% fb3_gains = gtdata;
% fb4_gains = gtdata;
% fb5_gains = gtdata;
% fb6_gains = gtdata;
% fb7_gains = gtdata;
% fb8_gains = gtdata;

% Concatenate dB Gain Vectors into Single Table
gt_db = [fb1_gains fb2_gains];

% Map dB gains to Linear Factors
gt = 10.^(gt_db./20);

% Transposing Table to Simulate DP Memory Table
dp_gt = gt';

% Sizing DP Table to match Address Port Width of RAM Block
numgainentries = table_length*num_bands;
RAM_size = 8;
% RAM_size = ceil(log2(numgainentries));   % number of bits
RAM_addresses = 2^RAM_size;
vy = dp_gt;
for i = length(dp_gt)+1:RAM_addresses
    vy(i,1) = 0;
end

%% Declare Input Signal

% Data Input Signal (Input Level Lst [dB])
Lst = [ 55.*ones(25000*num_bands,1); 90.*ones(25000*num_bands,1); 55.*ones(25000*num_bands,1); 90.*ones(25000*num_bands,1); 55.*ones(25000*num_bands,1); ];

% Data Input Signal (Input Level level_in [Pa^2])
level_in = (10.^(Lst./10))./2500000000;

%% Declare Control Signals

% Band Number State Controller Signal
for i = 1:num_bands:length(Lst)
    band_num(i) = 1;
    band_num(i+1) = 2;
%     band_num(i+2) = 3;
%     ...
end

% Attack-Release Write Enable Signal
write_en_ar = zeros(length(Lst),1);

% Attack Coefficient Write Data Signal
write_data_a = zeros(length(Lst),1);

% Release Coefficient Write Data Signal
write_data_r = zeros(length(Lst),1);

% Attack Coefficient Write Address Signal
write_addr_a = zeros(length(Lst),1);

% Release Coefficient Write Address Signal
write_addr_r = ones(length(Lst),1);

% Gain Table Write Enable Signal
write_en_vy = zeros(length(Lst),1);

% Gain Table Write Low Gain Data Signal
write_data_vy_low = zeros(length(Lst),1);

% Gain Table Write High Gain Data Signal
write_data_vy_high = zeros(length(Lst),1);

% Gain Table Write Low Gain Address Signal
write_addr_vy_low = zeros(length(Lst),1);

% Gain Table Write High Gain Address Signal
write_addr_vy_high = ones(length(Lst),1);


%% Declare Stop Time

stop_time = length(Lst) - 1;
