TWOPI= 6.28318530717959; 

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
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

% Impairment constants
cohc = 1; 
cihc = 1; 
%% IHC Nonlinear Log Function Parameters
corner    = 80; 
strength  = (20.0e6)/(10^(corner/20));

% C1 Chirp Filter
ihcasym_c1 = 3.0; % Ratio of positive Max to negative Max
slope_c1   = 0.1; % Hard-coded as 0.1 for the output of the C1 filter

% C2 Wideband Filter
ihcasym_c2 = 1.0; % Ratio of positive Max to negative Max
slope_c2   = 0.2; % Hard-coded as 0.2 for the output of the C2 filter

%% IHC Lowpass Filter Parameters

% Function Inputs:
Fcihc = 3000;
gainihc = 1.0;
orderihc = 7;

% Calculated Constants
C = 2.0/tdres;
c1LPihc = ( C - TWOPI*Fcihc ) / ( C + TWOPI*Fcihc );
c2LPihc = TWOPI*Fcihc / (TWOPI*Fcihc + C);

% Filter Coefficients Matrix
% Coefficients are order as follows
%       [b01 b11 b21 a01 a11 a21]
%       [b02 b12 b22 a02 a12 a22]
%               * * *
%       [b0m b1m b2m a0m a1m a2m]
% Added for the Direct Form implementation by Hezekiah Austin 03/10/2020
IHCLPcoeffs = [  gainihc*c2LPihc gainihc*c2LPihc 0 1 -c1LPihc 0;
                c2LPihc c2LPihc 0 1 -c1LPihc 0;
                c2LPihc c2LPihc 0 1 -c1LPihc 0;
                c2LPihc c2LPihc 0 1 -c1LPihc 0;
                c2LPihc c2LPihc 0 1 -c1LPihc 0;
                c2LPihc c2LPihc 0 1 -c1LPihc 0;
                c2LPihc c2LPihc 0 1 -c1LPihc 0];