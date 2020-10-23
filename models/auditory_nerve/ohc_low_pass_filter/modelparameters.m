TWOPI= 6.28318530717959; 

%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\nl_boltzman_result.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

%% OHC Low Pass Filter Parameters
% Function Inputs:
Fcohc = 600;
gainohc = 1.0;
orderohc = 2;
% Calculated Constants
C = 2.0/tdres;
c1LPohc = ( C - TWOPI*Fcohc ) / ( C + TWOPI*Fcohc );
c2LPohc = TWOPI*Fcohc / (TWOPI*Fcohc + C);
OHCLPcoeffs = [gainohc*c2LPohc gainohc*c2LPohc 0 1 -c1LPohc 0; gainohc*c2LPohc gainohc*c2LPohc 0 1 -c1LPohc 0];