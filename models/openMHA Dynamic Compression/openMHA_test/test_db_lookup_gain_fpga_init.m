% Matthew Blunt
% openMHA Test dB Lookup Gain FPGA-in-the-Loop Init Script
% 10/14/2020

% Created to test dB lookup and gain calculation functionality during 
% FPGA-in-the-Loop simulation

clear all;

%% Declare Data Type

Wbits = 40;    %fixdt(1,Wbits,Fbits)
Fbits = 37;

%% Declare Sampling Rate
fs = 48000;

%% Declare FFT Parameters

FFTsize = 256;
num_bins = FFTsize/2 + 1;
freq = linspace(0,24000,129);
binwidth = (fs/2)/(FFTsize/2);

%% Calculate Freq Band Information

% *** 3 Band Test Info *** %
% num_bands = 3;
% ef = [0 6000 12000 24000];

% *** 9 Band Test Info *** %
num_bands = 9;
ef = [0 100 200 400 800 1600 3200 6400 12000 24000];

% *** 18 Band Test Info *** %
% num_bands = 18;
% ef = [0 200 400 600 800 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 12500 15000 20000 24000]

band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);
band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands);

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

%figure()
%plot(input_levels_db,input_levels_db + gtdata);

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

% % Editing Gain Table Data Type
% vy = cast(vy,fixdt(1,16,8));
vy = fi(vy,1,16,8);
%% Declare Input Signals

% Data Input Signal (Input Level level_in)
load('level_in.mat');

%% Declare Stop Time

stop_time = length(level_in) - 1;
