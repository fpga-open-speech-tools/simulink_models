
%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'noisySpeech.wav'];

% TODO: use booleans instead of 0 and 1
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 15;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;


gain_dt = mp.getReg("gain").dataType;