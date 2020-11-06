
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

%% Outer Hair Cell Parameters
ohcasym = 7.0; % Ratio of positive Max to negative Max

Fcohc = 600;
gainohc = 1.0;
orderohc = 2;
% Max and min time constants (input as bmTaumax and bmTaumin in source code, chosen as outputs for cf = 1000 Hz from Get_taubm)
bmTaumax = 0.003;
bmTaumin = 4.6310e-04;

[shift, s1, s0, x1, x0, OHCLPcoeffs, s0_nl, minR] = outer_hair_cell_parameters(tdres, ohcasym, Fcohc, gainohc, bmTaumax, bmTaumin);