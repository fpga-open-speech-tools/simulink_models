
%% Autogen parameters
mp.testFile    = [mp.test_signals_path filesep 'acoustic.wav'];

mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 1;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;

%% Attack Filter Parameters
fs = 48000;
tau_a = 0.010; 

% Attack Filter Coefficients
c1_a = exp( -1.0/(tau_a * fs) );
c2_a = 1.0 - c1_a;