
%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'noisySpeech.wav'];

% TODO: use booleans instead of 0 and 1
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 1.5;
mp.nSamples = mp.Fs * mp.simDuration;

gain_dt = mp.register{2}.dataType;
