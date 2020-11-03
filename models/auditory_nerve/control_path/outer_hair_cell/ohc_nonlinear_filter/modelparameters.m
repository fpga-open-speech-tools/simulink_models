
%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\ohc_lpf_result.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

%% OHC Nonlinear Filter
ohcasym = 7.0;  % Ratio of positive Max to negative Max
% Max and min time constants (input as bmTaumax and bmTaumin in source code, chosen as outputs for cf = 1000 Hz from Get_taubm)
taumax = 0.003;
taumin = 4.6310e-04;

[s0_nl, minR] = ohc_nonlinear_filter_parameters(ohcasym, taumax, taumin);

