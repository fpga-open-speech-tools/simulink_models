% Matthew Blunt
% openMHA Test Attack-Release Filter & Gaintable Init Script
% 09/24/2020

% Created to test attack-release filter and gaintable functionality during 
% openMHA implementation in order to ensure proper architecture design in
% Simulink according to attack and release time standards

clear all;

%% Declare Sampling Rate

fs = 48000;

%% Declare Data Type

Wbits = 32;    %fixdt(1,Wbits,Fbits)
Fbits = 28;

%% Declare FFT Parameters

FFTsize = 256;
num_bins = FFTsize/2 + 1;
freq = linspace(0,24000,129);
binwidth = (fs/2)/(FFTsize/2);

%% Declare Attack and Release Time Constants

% Note that example attack and release time constants found in the openMHA 
% Dynamic Compression Plugin documentation are used for testing

tau_a = 0.020; % seconds
tau_r = 0.200; % seconds

%% Calculate Attack-Release Filter Coefficients

% Calculating filter coefficients as done in the source code C++ file
% mha_filter.cpp

% Attack Filter Coefficients
c1_a = exp( -1.0/(tau_a * fs) );
c2_a = 1.0 - c1_a;

% Release Filter Coefficients
c1_r = exp( -1.0/(tau_r * fs) );
c2_r = 1.0 - c1_r;

%% dB Lookup Table Parameters

% Declare maximum dB output suitable for Gain Table
X_high = 95;

%% Gain Table Parameters

gtmin = 0;
gtstep = 4;
gtdata = [0 20 31 34 37 40 39 38 37 36 35 34 33 32 31 30 26 22 18 14 10 6 2 -2 -2];
table_length = length(gtdata);
for i = 1:length(gtdata)
    input_levels_db(i) = gtmin + (i-1)*gtstep;
end

% Declaring Gain Vectors for each Frequency Band in dB
fb1_gains = gtdata;
fb2_gains = gtdata;
fb3_gains = gtdata;
fb4_gains = gtdata;
fb5_gains = gtdata;
fb6_gains = gtdata;
fb7_gains = gtdata;
fb8_gains = gtdata;
fb9_gains = gtdata;

% Concatenate dB Gain Vectors into Single Table
gt_db = [fb1_gains fb2_gains fb3_gains fb4_gains fb5_gains fb6_gains fb7_gains fb8_gains fb9_gains];

% Map dB gains to Linear Factors
gt = 10.^(gt_db./20);

% Transposing Table to Simulate DP Memory Table
dp_gt = gt';

% Sizing DP Table to match Address Port Width of RAM Block
RAM_size = 8;   % number of bits
RAM_addresses = 2^8;
vy = dp_gt;
for i = length(dp_gt)+1:RAM_addresses
    vy(i,1) = 0;
end

%% Declare Input Signal

% Data Input Signal (Input Level Lst)
Lst = [ 55.*ones(50000,1); 90.*ones(50000,1); 55.*ones(50000,1); 90.*ones(50000,1); 55.*ones(50000,1); ];

% Plotting Input Signal
% figure()
% plot(Lst);
% title('Input Level Test Signal');
% xlabel('Sample Number');
% ylabel('Input Level [dB SPL]');
% ylim([50,95]);

%% Declare Stop Time

stop_time = length(Lst) - 1;
