
%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'noisySpeech.wav'];

% TODO: use booleans instead of 0 and 1
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 1;
mp.nSamples = mp.Fs * mp.simDuration;


%% Gain parameters

gain_dt = mp.register{2}.dataType;

%% Flanger parameters

% 10 ms window
mp.windowSize = 10e-3 * mp.Fs;

% define the exponential moving average weight to be roughly equivalent to
% a simple moving average of length mp.windowSize
% https://en.wikipedia.org/wiki/Moving_average#Relationship_between_SMA_and_EMA
mp.exponentialMovingAverageWeight = fi(2/(mp.windowSize + 1), 0, 32, 31);

mp.nco_dither_bits = 4;
mp.nco_max_ms = 10; %ms
mp.nco_max = ceil(mp.nco_max_ms * 1e-3 * mp.Fs);
mp.nco_min_ms = 0.5; %ms
mp.nco_min = ceil(mp.nco_min_ms * 1e-3 * mp.Fs);
mp.nco_offset = ceil((mp.nco_max + mp.nco_min)/2);
mp.nco_amplitude = ceil((mp.nco_max - mp.nco_min)/2);
mp.nco_quantizer_bits = 12;
rate_min =  0.1;
mp.nco_accumulator_bits = ceil(log2(mp.Fs/rate_min));

% Set parameters for the delay line
mp.delay_max = mp.nco_max;
mp.dpram_addr_size = ceil(log2(mp.delay_max));


%% Echo parameters
mp.max_delay = mp.Fs*1/2;   % max delay in samples, i.e. mp.Fs = 1 second max delay
delay_dpram_addr_size = ceil(log2(mp.max_delay));