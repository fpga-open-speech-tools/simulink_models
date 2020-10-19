% Matthew Blunt
% openMHA Test Init Script
% 08/04/2020

% Created to test various functionality during openMHA implementation

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

%% Declare Input Signal

FFT_data_real = [ones(1,129) zeros(1,71) ones(1,129) zeros(1,71) ones(1,129)];
FFT_data_imag = [ones(1,129) zeros(1,71) ones(1,129) zeros(1,71) ones(1,129)];

%% Calculate Valid Signal

valid_data = zeros(size(FFT_data_real));
valid_data(find(FFT_data_real)) = 1;

%% Gain Table Parameters

table_length = 21;

fb1_gains = [];
fb2_gains = [];
fb3_gains = [];
fb4_gains = [];
fb5_gains = [];
fb6_gains = [];
fb7_gains = [];
fb8_gains = [];
fb9_gains = [];

% gt_step = 4;
% gt_min = 0;
