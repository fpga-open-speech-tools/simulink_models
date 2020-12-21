
%% Autogen parameters
% mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\cp_wideband_gammatone_filter_delay.wav'];
mp.testFile = ['cp_wideband_gammatone_filter_delay.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf    = 1000; % Characteristic frequency of specific neuron
Fs    = 48e3; % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep  = 100;  % Number of repititions for peri-stimulus time histogram
species = 2;  % Human
order   = 3;  % Line 248 of model_IHC_BEZ2018.c

% Impairment constants
cohc  = 1;    % outer hair cell impairment constant ( from 0 to 1 )
cihc  = 1;    % inner hair cell impairment constant ( from 0 to 1 )

%% Outer Hair Cell Parameters
ohcasym  = 7.0; % Ratio of positive Max to negative Max
Fcohc    = 600; % Hardcoded in model, line 320
gainohc  = 1.0; % Hardcoded in model, line 320
orderohc = 2;   % Hardcoded in model, line 320

[taumax, taumin] = Get_tauwb( cf, species, order);            % Line 242
[bmTaumax, bmTaumin, ratio] = Get_taubm(cf, species, taumax); % Line 246 
[shift, s1, s0, x1, x0, OHCLPcoeffs, s0_nl, minR] = outer_hair_cell_parameters(tdres, ohcasym, Fcohc, gainohc, bmTaumax, bmTaumin);