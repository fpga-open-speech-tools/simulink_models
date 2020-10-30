
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

%% OHC Low Pass Filter Parameters
TWOPI= 6.28318530717959; 
% Function Inputs:
Fcohc = 600;
gainohc = 1.0;
orderohc = 2;
% Calculated Constants
C = 2.0/tdres;
c1LPohc = ( C - TWOPI*Fcohc ) / ( C + TWOPI*Fcohc );
c2LPohc = TWOPI*Fcohc / (TWOPI*Fcohc + C);
OHCLPcoeffs = [gainohc*c2LPohc gainohc*c2LPohc 0 1 -c1LPohc 0; gainohc*c2LPohc gainohc*c2LPohc 0 1 -c1LPohc 0];

%% OHC Nonlinear Filter
minR = 0.05; % Declared as constant in function
% Max and min time constants (input as bmTaumax and bmTaumin in source code, chosen as outputs for cf = 1000 Hz from Get_taubm)
taumax = 0.003;
taumin = 4.6310e-04;

% *** Adding precalculated values to avoid unnecessary computation and
% switch block architecture (All the following lines until Test Signal
% section)
% *** Added by Matthew Blunt 04/08/2020

R = taumin/taumax;

if R < minR
    minR = 0.5*R;
else
    minR = minR;
end

dc = (ohcasym-1)/(ohcasym+1.0)/2.0-minR;
R1 = R-minR;

% Denoted in C code: For new nonlinearity
s0_nl = -dc/log(R1/(1-minR));