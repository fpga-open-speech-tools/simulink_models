TWOPI= 6.28318530717959; 

%% Autogen parameters
mp.testFile  = [mp.test_signals_path filesep 'auditory_nerve\ihc_nl_log_c1.wav'];

mp.testFile2 = [mp.test_signals_path filesep 'auditory_nerve\ihc_nl_log_c2.wav'];
testSignal2 = AudioSource.fromFile(mp.testFile2, mp.Fs, mp.nSamples);
avalonSource2 = testSignal2.toAvalonSource();
mp.avalonSim2 = avalonSource2.astimeseries();
mp.Avalon_Source_Data2     = mp.avalonSim.data;

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
cohc = 1; 
cihc = 1; 
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