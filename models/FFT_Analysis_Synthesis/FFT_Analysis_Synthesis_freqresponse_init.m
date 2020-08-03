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
FFT_size = 512;
FFT_size_Nbits = log2(FFT_size);
FFT_size_half = FFT_size/2;
FFT_frame_shift = FFT_size/4;  % Changiing this from a divide by four implies substantial architectural changes
FFT_frame_shift_Nbits = log2(FFT_frame_shift);

DPRAM1_size = FFT_size*2;  % number of words
DPRAM1_address_size = log2(DPRAM1_size);

SysRate_Upsample_Factor = FFT_size/FFT_frame_shift * 8 * 4;  % How much faster the fast clock must be to complete a FFT within the time of FFT_frame_shift number of samples

Wbits = 32;    %fixdt(1,Wbits,Fbits)
Fbits = 28;


%----------------------------------------------------------------------------
% Create Input Signals
%----------------------------------------------------------------------------
% create impulse for latency measurement
y1 = zeros(FFT_size*2,1);
y1(FFT_size_half) = 1;
t1 = 0:FFT_size*2-1;
t1 = t1*Ts;
t1_offset = FFT_size*2*Ts;
y3 = y1;


% create frequencies to test
t2 = 0:FFT_size-1;
t2 = t2*Ts;
t3 = t2 + t1_offset;
h = hanning(FFT_size);
freq_list = [];
for f = 0:500:24000
    freq_list = [freq_list f];
    y2 = sin(2*pi*f*t3)';
    y3 = [y3; y2.*h];  % apply hanning window
    t3 = t3 + FFT_size*Ts;
end
t = 0:length(y3)-1;
t = t*Ts;
signal_in = timeseries(y3,t);

%----------------------------------------------------------------------------
% Set simulation time
%----------------------------------------------------------------------------
Nsamples = length(y3)-1;
stop_time = Nsamples * Ts;


%----------------------------------------------------------------------------
% Set passthrough mode
%----------------------------------------------------------------------------
passthrough = 0;  
passthrough_in = timeseries(passthrough,0);

%----------------------------------------------------------------------------
% Set filter mode
%----------------------------------------------------------------------------
filter_select = 4;
filter_select_in = timeseries(filter_select,0);

%----------------------------------------------------------------------------
% Filter 1 - Low Pass
%----------------------------------------------------------------------------
low_pass_cutoff = 4000  % frequency in Hz
low_pass_index = ceil(low_pass_cutoff / Fs * FFT_size) + 1  % the +1 is to convert from the FFT bin array that is zero offset to a Matlab array that is 1 offset
fft_gains_1_real = zeros(FFT_size_half,1);  % start by zeroing array
fft_gains_1_real(1:low_pass_index)  = ones(low_pass_index,1);  
fft_gains_1_imag  = zeros(FFT_size_half,1);  % zero imaginary part
latency_threshold1 = sum(fft_gains_1_real)/FFT_size

%----------------------------------------------------------------------------
% Filter 2 - Band Pass
%----------------------------------------------------------------------------
%band_pass_cutoff_low  = 12000  % frequency in Hz
%band_pass_cutoff_high = 12000  % frequency in Hz
band_pass_cutoff_low  = 4000  % frequency in Hz
band_pass_cutoff_high = 8000  % frequency in Hz
band_pass_index_low  = floor(band_pass_cutoff_low / Fs * FFT_size) + 1  % Note: The FFT bin indexing assumes the first bin index number of zero.  Matlab starts arrays with index 1.  Thus we need to add get the right frequency bin. 
band_pass_index_high = ceil(band_pass_cutoff_high / Fs * FFT_size)+ 1  
fft_gains_2_real = zeros(FFT_size_half,1);  % start by zeroing array
fft_gains_2_real(band_pass_index_low:band_pass_index_high)  = ones(band_pass_index_high-band_pass_index_low+1,1);  
fft_gains_2_imag  = zeros(FFT_size_half,1);  % zero imaginary part
latency_threshold2 = sum(fft_gains_2_real)/FFT_size

%----------------------------------------------------------------------------
% Filter 3 - High Pass
%----------------------------------------------------------------------------
high_pass_cutoff = 8000  % frequency in Hz
high_pass_index = floor(high_pass_cutoff / Fs * FFT_size) + 1 
fft_gains_3_real = zeros(FFT_size_half,1);  % start by zeroing array
fft_gains_3_real(high_pass_index:end)  = ones(FFT_size_half - high_pass_index + 1, 1);  
fft_gains_3_imag  = zeros(FFT_size_half,1);  % zero imaginary part
latency_threshold3 = sum(fft_gains_3_real)/FFT_size

%----------------------------------------------------------------------------
% Filter 4 - All Pass
%----------------------------------------------------------------------------
fft_gains_4_real = ones(FFT_size_half,1);  
%fft_gains_4_real(1)  = 0;  %  zero DC offset
fft_gains_4_imag  = zeros(FFT_size_half,1);  % zero imaginary part
latency_threshold4 = sum(fft_gains_4_real)/FFT_size
