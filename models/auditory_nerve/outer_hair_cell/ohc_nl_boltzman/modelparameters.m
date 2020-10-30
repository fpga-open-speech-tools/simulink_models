
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
% Function specific parameters
shift = 1.0/(1.0+ohcasym);
s1 = 5.0;
s0 = 12.0;
x1 = 5.0;
x0 = s0*log((1.0/shift-1)/(1+exp(x1/s1)));