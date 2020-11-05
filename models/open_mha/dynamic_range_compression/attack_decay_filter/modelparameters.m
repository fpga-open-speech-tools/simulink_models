
%% Autogen parameters
mp.testFile    = [mp.test_signals_path filesep 'acoustic.wav'];

mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 1;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;

%% Attack Filter Parameters
fs = 48000;
tau_a = 0.010; 
tau_r = 0.015;

% Attack Lowpass Filter Coefficients - mha_filter.cpp
c1_a = exp( -1.0/(tau_a * fs) ); % Line 595
c2_a = 1.0 - c1_a;               % Line 598

% Release Lowpass Filter Coefficients - mha_filter.cpp
c1_r = exp( -1.0/(tau_r * fs) ); % Line 595
c2_r = 1.0 - c1_r;               % Line 598