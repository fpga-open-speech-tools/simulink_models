
%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'noisySpeech.wav'];

% TODO: use booleans instead of 0 and 1
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 15;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

mp.useAvalonInterface = false;
    
%% Exponential moving average setup

% 10 ms window
mp.windowSize = 10e-3 * mp.Fs;

% define the exponential moving average weight to be roughly equivalent to
% a simple moving average of length mp.windowSize
% https://en.wikipedia.org/wiki/Moving_average#Relationship_between_SMA_and_EMA
mp.exponentialMovingAverageWeight = fi(2/(mp.windowSize + 1), 0, 32, 31);

