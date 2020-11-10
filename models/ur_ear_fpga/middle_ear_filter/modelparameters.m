
%% Autogen parameters
mp.testFile    = [mp.test_signals_path filesep 'auditory_nerve\m06ae.wav'];

mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 5;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

% Impairment constants
cohc = 1; % outer hair cell impairment constant ( from 0 to 1 )
cihc = 1; % inner hair cell impairment constant ( from 0 to 1 )

%% Middle Ear Filter Parameters
[MEcoeffs, MEscale] = middle_ear_filter_parameter(tdres);