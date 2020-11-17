
%% Autogen parameters
mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

% mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\c1_chirp_filter_out.wav'];
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\c2_wbf_out.wav'];

%% ANM Settings
cf = 5000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

% Impairment constants
cohc = 1;     % outer hair cell impairment constant ( from 0 to 1 )
cihc = 1;     % inner hair cell impairment constant ( from 0 to 1 )


%% IHC Nonlinear Log Function Parameters
% data_path = 'c1_chirp';
data_path = 'c2_wbf';
[corner, strength, ihcasym, slope, plot_title] = ihc_nl_log_parameter(data_path);

