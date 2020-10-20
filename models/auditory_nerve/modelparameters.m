
%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'm06ae.wav'];

% TODO: use booleans instead of 0 and 1
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

