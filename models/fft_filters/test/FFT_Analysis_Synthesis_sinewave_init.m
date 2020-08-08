clear all
close all

%----------------------------------------------------------------------------
% Set sample rate
%----------------------------------------------------------------------------
Fs = 48000;
Ts = 1/Fs;

%----------------------------------------------------------------------------
% Set FFT size
%----------------------------------------------------------------------------
FFT_size = 16;
FFT_size_Nbits = log2(FFT_size);
FFT_size_half = FFT_size/2;
FFT_frame_shift = FFT_size/4;  % Changiing this from a divide by four implies substantial architectural changes
FFT_frame_shift_Nbits = log2(FFT_frame_shift);

DPRAM1_size = FFT_size*2;  % number of words
DPRAM1_address_size = log2(DPRAM1_size);

SysRate_Upsample_Factor = FFT_size/FFT_frame_shift * 8 * 2;  % How much faster the fast clock must be to complete a FFT within the time of FFT_frame_shift number of samples

Wbits = 32;    %fixdt(1,Wbits,Fbits)
Fbits = 28;


%----------------------------------------------------------------------------
% Create Input Signals
%----------------------------------------------------------------------------
% create impulse for latency measurement
y1 = zeros(FFT_size*4,1);
y1(FFT_size_half) = 1;
t1 = 0:FFT_size*4-1;
t1 = t1*Ts;
t1_offset = FFT_size*4*Ts;
% sine wave 
sine_freq = 3000;
t2 = 0:FFT_size*4-1;
t2 = t2*Ts;
t2 = t2 + t1_offset;
y2 = sin(2*pi*sine_freq*t2);
y = [y1; y2'];
t = [t1'; t2'];
signal_in = timeseries(y,t);


%----------------------------------------------------------------------------
% Set simulation time
%----------------------------------------------------------------------------
Nsamples = length(y);
stop_time = Nsamples * Ts;

%----------------------------------------------------------------------------
% Filter 1 - Low Pass
%----------------------------------------------------------------------------
low_pass_cutoff = 1000  % frequency in Hz
low_pass_index = round(low_pass_cutoff / Fs * FFT_size)  
fft_gains_1_real = zeros(FFT_size_half,1);  % start by zeroing array
fft_gains_1_real(2:low_pass_index)  = ones(low_pass_index-1,1);  % start at 2 since we want to zero DC offset
fft_gains_1_imag  = zeros(FFT_size_half,1);  % zero imaginary part

%----------------------------------------------------------------------------
% Filter 2 - Band Pass
%----------------------------------------------------------------------------
band_pass_cutoff_low  = 3000  % frequency in Hz
band_pass_cutoff_high = 5000  % frequency in Hz
band_pass_index_low  = round(band_pass_cutoff_low / Fs * FFT_size)  
band_pass_index_high = round(band_pass_cutoff_high / Fs * FFT_size)  
fft_gains_2_real = zeros(FFT_size_half,1);  % start by zeroing array
fft_gains_2_real(band_pass_index_low:band_pass_index_high)  = ones(band_pass_index_high-band_pass_index_low+1,1);  
fft_gains_2_imag  = zeros(FFT_size_half,1);  % zero imaginary part

%----------------------------------------------------------------------------
% Filter 3 - High Pass
%----------------------------------------------------------------------------
high_pass_cutoff = 7000  % frequency in Hz
high_pass_index = round(high_pass_cutoff / Fs * FFT_size)  
fft_gains_3_real = zeros(FFT_size_half,1);  % start by zeroing array
fft_gains_3_real(high_pass_index:end)  = ones(FFT_size_half - high_pass_index + 1, 1);  
fft_gains_3_imag  = zeros(FFT_size_half,1);  % zero imaginary part

%----------------------------------------------------------------------------
% Filter 4 - All Pass
%----------------------------------------------------------------------------
fft_gains_4_real = ones(FFT_size_half,1);  
fft_gains_4_real(1)  = 0;  %  zero DC offset
fft_gains_4_imag  = zeros(FFT_size_half,1);  % zero imaginary part

