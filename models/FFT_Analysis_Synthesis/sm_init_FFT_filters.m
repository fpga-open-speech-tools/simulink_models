function mp = sm_init_FFT_filters(mp)

%----------------------------------------------------------------------------
% Filter 1 - Low Pass
%----------------------------------------------------------------------------
mp.low_pass_cutoff = 4000;  % frequency in Hz
mp.low_pass_index = ceil(mp.low_pass_cutoff / mp.Fs * mp.FFT_size) + 1;  % the +1 is to convert from the FFT bin array that is zero offset to a Matlab array that is 1 offset
mp.fft_gains_1_real = zeros(mp.FFT_size_half,1);  % start by zeroing array
mp.fft_gains_1_real(1:mp.low_pass_index)  = ones(mp.low_pass_index,1);
mp.fft_gains_1_imag  = zeros(mp.FFT_size_half,1);  % zero imaginary part
mp.latency_threshold1 = sum(mp.fft_gains_1_real)/mp.FFT_size;

%----------------------------------------------------------------------------
% Filter 2 - Band Pass
%----------------------------------------------------------------------------
mp.band_pass_cutoff_low  = 4000;  % frequency in Hz
mp.band_pass_cutoff_high = 8000;  % frequency in Hz
mp.band_pass_index_low  = floor(mp.band_pass_cutoff_low / mp.Fs * mp.FFT_size) + 1;  % Note: The FFT bin indexing assumes the first bin index number of zero.  Matlab starts arrays with index 1.  Thus we need to add get the right frequency bin.
mp.band_pass_index_high = ceil(mp.band_pass_cutoff_high / mp.Fs * mp.FFT_size)+ 1;
mp.fft_gains_2_real = zeros(mp.FFT_size_half,1);  % start by zeroing array
mp.fft_gains_2_real(mp.band_pass_index_low:mp.band_pass_index_high)  = ones(mp.band_pass_index_high-mp.band_pass_index_low+1,1);
mp.fft_gains_2_imag  = zeros(mp.FFT_size_half,1);  % zero imaginary part
mp.latency_threshold2 = sum(mp.fft_gains_2_real)/mp.FFT_size;

%----------------------------------------------------------------------------
% Filter 3 - High Pass
%----------------------------------------------------------------------------
mp.high_pass_cutoff = 8000;  % frequency in Hz
mp.high_pass_index = floor(mp.high_pass_cutoff / mp.Fs * mp.FFT_size) + 1;
mp.fft_gains_3_real = zeros(mp.FFT_size_half,1);  % start by zeroing array
mp.fft_gains_3_real(mp.high_pass_index:end)  = ones(mp.FFT_size_half - mp.high_pass_index + 1, 1);
mp.fft_gains_3_imag  = zeros(mp.FFT_size_half,1);  % zero imaginary part
mp.latency_threshold3 = sum(mp.fft_gains_3_real)/mp.FFT_size;

%----------------------------------------------------------------------------
% Filter 4 - All Pass
%----------------------------------------------------------------------------
mp.fft_gains_4_real = ones(mp.FFT_size_half,1);
mp.fft_gains_4_imag  = zeros(mp.FFT_size_half,1);  % zero imaginary part
mp.latency_threshold4 = sum(mp.fft_gains_4_real)/mp.FFT_size;


end

