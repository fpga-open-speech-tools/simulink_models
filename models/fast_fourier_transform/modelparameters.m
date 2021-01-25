%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'acoustic.wav'];

% TODO: use booleans instead of 0 and 1
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 0.5;
% mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;
mp.nSamples = 2048;

mp.useAvalonInterface = false;

mp.W_bits = 24;
mp.F_bits = 23;

%% Model parameters 
mp.FFT_size = 256;
% XXX: an unsigned int of mp.FFT_size_Nbits only goes up to mp.FFT_size - 1; not sure if that's intended or a bug 
mp.FFT_size_Nbits = log2(mp.FFT_size);
mp.FFT_size_half = mp.FFT_size/2;
mp.FFT_frame_shift = mp.FFT_size/4;  % Changiing this from a divide by four implies substantial architectural changes
mp.FFT_frame_shift_Nbits = log2(mp.FFT_frame_shift);

mp.DPRAM1_size = mp.FFT_size*2;  % number of words
mp.DPRAM1_address_size = log2(mp.DPRAM1_size);

mp.SysRate_Upsample_Factor = mp.FFT_size/mp.FFT_frame_shift * 8 * 4;  % How much faster the fast clock must be to complete a FFT within the time of FFT_frame_shift number of samples
