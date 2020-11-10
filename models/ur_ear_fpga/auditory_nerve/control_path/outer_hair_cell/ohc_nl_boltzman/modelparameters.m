
%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\cp_wideband_gammatone_filter.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

%% OHC Nonlinear Boltzman Parameters
ohcasym = 7.0; % Ratio of positive Max to negative Max
[shift, s1, s0, x1, x0] = ohc_nl_boltzman_parameters(ohcasym);