% Matthew Blunt
% openMHA Test Frequency Band State Controller, Gain Application Subsystem,
% and Variable Delay Circular Buffer Init Script
% 10/28/2020

% Created to test functionality of the MATLAB band state controller
% function block, dual-rate dual-port gain application subsystem, and
% signal path variable delay circular buffer during openMHA implementation

clear all;

%% Declare Data Type

Wbits = 32;    %fixdt(1,Wbits,Fbits)
Fbits = 28;

%% Declare Sampling Rate
fs = 48000;

%% Declare FFT Parameters

FFTsize = 256;
num_bins = FFTsize/2 + 1;
freq = linspace(0,24000,129);
binwidth = (fs/2)/(FFTsize/2);

%% Calculate Freq Band Information

% *** 2 Band Test Info *** %
num_bands = 8;
% ef = [0 12000 24000];

% *** 3 Band Test Info *** %
% num_bands = 3;
% ef = [0 6000 12000 24000];

% *** 9 Band Test Info *** %
% num_bands = 9;
% ef = [0 100 200 400 800 1600 3200 6400 12000 24000];

% *** 18 Band Test Info *** %
% num_bands = 18;
% ef = [0 200 400 600 800 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 12500 15000 20000 24000]

% band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands);
band_sizes = [5 8 12 16 16 20 24 28];
% band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands);
band_edges = zeros(1,32);
band_edges(1,1) = 4;
for i = 2:num_bands
   band_edges(1,i) = band_edges(1,i-1) + band_sizes(1,i);
end
mirrored_band_edges = calculate_mirrored_band_edges(band_sizes, FFTsize, num_bins, num_bands);
band_edges = [band_edges mirrored_band_edges];

%% Dual-Port Gain Application Parameters

gainapp_dp_memory = log2(num_bands) + 1;

%% Declare Signal Path Delay

system_delay = max(band_sizes);

system_delay_memory = ceil(log2(system_delay));
delay_memory_size =2^system_delay_memory;

%% Declare Input Signal

FFT_data_real = [1.*ones(1,5) 2.*ones(1,8) 3.*ones(1,12) 4.*ones(1,16) 5.*ones(1,16) 6.*ones(1,20) 7.*ones(1,24) 8.*ones(1,55) 7.*ones(1,24) 6.*ones(1,20) 5.*ones(1,16) 4.*ones(1,16) 3.*ones(1,12) 2.*ones(1,8) 1.*ones(1,4) zeros(1,144)];
FFT_data_imag = FFT_data_real;

%% Calculate Valid Signal

valid_data = zeros(size(FFT_data_real));
valid_data(find(FFT_data_real)) = 1;

%% Simulated Gain Siganl

gain = zeros(1,length(FFT_data_real));
gain(1,1:132) = [zeros(1,4) 1.*ones(1,8) 2.*ones(1,12) 3.*ones(1,16) 4.*ones(1,16) 5.*ones(1,20) 6.*ones(1,24) 7.*ones(1,28) 8.*ones(1,4) ];

%% Simulated Grab Accumulator Signal

grab_accumulator = zeros(1,length(FFT_data_real));
grab_accumulator = [zeros(1,4) 1 zeros(1,7) 1 zeros(1,11) 1 zeros(1,15) 1 zeros(1,15) 1 zeros(1,19) 1 zeros(1,23) 1 zeros(1,27) 1 zeros(1,3)];

%% Declare Stop Time

stop_time = length(FFT_data_real) -1;