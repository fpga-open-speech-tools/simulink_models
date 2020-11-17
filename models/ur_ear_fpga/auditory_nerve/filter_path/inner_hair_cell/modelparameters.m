%% Autogen parameters
mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 5;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;

mp.testFile            = [mp.test_signals_path filesep 'auditory_nerve\c1_chirp_filter_out.wav'];
mp.testFile2           = [mp.test_signals_path filesep 'auditory_nerve\c2_wbf_out.wav'];
testSignal2            = AudioSource.fromFile(mp.testFile2, mp.Fs, mp.nSamples);
avalonSource2          = testSignal2.toAvalonSource();
mp.avalonSim2          = avalonSource2.astimeseries();
mp.Avalon_Source_Data2 = mp.avalonSim2.data;

%% ANM Settings
cf      = 5000; % Characteristic frequency of specific neuron
Fs      = 48e3; % Sampling frequency
tdres   = 1/Fs; % Binsize in seconds
nrep    = 100;  % Number of repititions for peri-stimulus time histogram
species = 2;    % Human
order   = 3;    % Line 248 of model_IHC_BEZ2018.c

% Impairment constants
cohc  = 1;    % outer hair cell impairment constant ( from 0 to 1 )
cihc  = 1;    % inner hair cell impairment constant ( from 0 to 1 )
%% Inner Hair Cell Parameters
Fc_ihc    = 3000;  % Hardcoded In Function Call: Line 358
gain_ihc  = 1.0;   % Hardcoded In Function Call: Line 358 
order_ihc = 7;     % Hardcoded In Function Call: Line 358
[corner, strength, ihcasym_c1, slope_c1, ihcasym_c2, slope_c2, IHCLPcoeffs] = inner_hair_cell_parameters(tdres, Fc_ihc, gain_ihc);