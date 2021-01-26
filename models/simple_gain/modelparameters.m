
%% Autogen parameters
mp.testFile    = [mp.test_signals_path filesep 'acoustic.wav'];
mp.sim_prompts = 1;
mp.sim_verify  = 0;
mp.simDuration = .05;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;

