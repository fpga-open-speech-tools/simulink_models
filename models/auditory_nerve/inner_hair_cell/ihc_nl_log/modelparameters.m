
%% Autogen parameters
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;


%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

% Impairment constants
cohc = 1;     % outer hair cell impairment constant ( from 0 to 1 )
cihc = 1;     % inner hair cell impairment constant ( from 0 to 1 )


%% IHC Nonlinear Log Function Parameters
corner    = 80; 
strength  = (20.0e6)/(10^(corner/20));

% % C1 Chirp Filter
% mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\c1_chirp_filter_out.wav'];
% ihcasym     = 3.0; % Ratio of positive Max to negative Max
% slope       = 0.1; % Hard-coded as 0.1 for the output of the C1 filter

% C2 Wideband Filter
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\c2_wbf_out.wav'];
ihcasym     = 1.0; % Ratio of positive Max to negative Max
slope       = 0.2; % Hard-coded as 0.1 for the output of the C1 filter