TWOPI= 6.28318530717959; 

%% Autogen parameters
mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 5;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;

mp.testFile    = [mp.test_signals_path filesep 'auditory_nerve\m06ae.wav'];
totalstim      = 20007;

%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

% Impairment constants
cohc = 1; 
cihc = 1; 

%% Middle Ear Filter Parameters
mef_parameters;

%% C1 Chirp Filter Parameters
rsigma = .5;     % Pole shifting constant (set as constant for testing)
taumax = 0.003; % Max time constant (given as bmTaumax in C source code, set to 0.003 for testing, the value of bmTaumax for cf = 1000)

%--Calculate the constant parameters for the C1 filter, including initial pole/zero locations, shifting constants, and gain constants
% Setup locations of poles and zeros
sigma0 = 1/taumax;
ipw    = 1.01*cf*2*pi-50;
ipb    = 0.2343*2*pi*cf-1104;
rpa    = 10^(log10(cf)*0.9 + 0.55)+ 2000;
pzero  = 10^(log10(cf)*0.7+1.6)+500;
    
order_of_pole    = 10;             
half_order_pole  = order_of_pole/2;
order_of_zero    = half_order_pole;
    
fs_bilinear = 2*pi*cf/tan(2*pi*cf*tdres/2);
rzero       = -pzero;
CF          = 2*pi*cf;

preal = zeros(11,1);
pimag = zeros(11,1);

preal(1) = -sigma0;
preal(5) = preal(1) - rpa;
preal(3) = (preal(1) + preal(5))/2;
preal(7) = preal(1);
preal(9) = preal(5);
preal(2) = preal(1);
preal(4) = preal(3);
preal(6) = preal(5);
preal(8) = preal(2);
preal(10) = preal(6);

pimag(1) = ipw;
pimag(5) = pimag(1) - ipb;
pimag(3) = (pimag(1) + pimag(5))/2;
pimag(7) = pimag(1);
pimag(9) = pimag(5);
pimag(2) = -pimag(1);
pimag(4) = -pimag(3);
pimag(6) = -pimag(5);
pimag(8) = pimag(2);
pimag(10) = pimag(6);

% Calculate initial phase
C1initphase = 0.0;
for i = 1:half_order_pole
    C1initphase = C1initphase + atan(CF/(-rzero))-atan((CF-pimag(2*i-1))/(-preal(2*i-1)))-atan((CF+pimag(2*i-1))/(-preal(2*i-1)));
end

% Normalize the gain
C1gain_norm = 1.0;
for i = 1:order_of_pole
        C1gain_norm = C1gain_norm*((CF-pimag(i))^2 + (preal(i))^2);
end

norm_gainc1 = (sqrt(C1gain_norm))/((sqrt(CF^2+rzero^2))^order_of_zero);

%% C2 Wideband Filter
taumaxc2 = 0.0030; % time constant determined with another function (chosen as the output of Get_taubm for cf = 1000 Hz)     
fcohcc2 = 1;       % parameter calculated as 1/ratiobm in model_IHC_BEZ2018.c (arbitrary for initial test)
[C2coeffs, norm_gainc2] = C2Coefficients( tdres, cf, taumaxc2, fcohcc2); % Calculating IIR Biquad Coefficients by calling C2Coefficients MATLAB function

%% Inner Hair Cell Parameters
% IHC Nonlinear Log Function Parameters
corner    = 80; 
strength  = (20.0e6)/(10^(corner/20));

% C1 Chirp Filter
ihcasym_c1 = 3.0; % Ratio of positive Max to negative Max
slope_c1   = 0.1; % Hard-coded as 0.1 for the output of the C1 filter

% C2 Wideband Filter
ihcasym_c2 = 1.0; % Ratio of positive Max to negative Max
slope_c2   = 0.2; % Hard-coded as 0.2 for the output of the C2 filter

% IHC Lowpass Filter Parameters

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
            
%% Synapse Model
% Nonlinear PLA Filter Parameters
spont = 100; % Spontaneous firing rate of neurons, as set in testANmodel_BEZ2018.m source code

cfslope = (spont^0.19)*(10^-0.87);
cfconst = 0.1*(log10(spont))^2 + 0.56*log10(spont) - 0.84;
cfsat = 10^(cfslope*8965.5/1e3 + cfconst);
cf_factor = min(cfsat, 10^(cfslope*cf/1e3 + cfconst)) * 2.0;

multFac = max(2.95*max(1.0,1.5-spont/100), 4.3-0.2*cf/1e3);

% ---------------------------------------%
% NOTE: delaypoint may need to be changed due
%       to sampling rate change from 100 kHz 
%       to 48 kHz, not sure yet
% ---------------------------------------%
delaypoint = floor(7500/(cf/1e3));

%Power Law Adapter Parameters
% Random Noise
noiseType = 1; % Set to variable ffGn type (1)
Hinput = 0.9;  % Set Hurst index to the value hard-coded in C source code
spont = 100;   % Set mean of noise
% Call fast fractional gaussian noise function for Double Precision
randNums = single(ffGn(totalstim, tdres, Hinput, noiseType, spont));

% Parameters for Fast Power Law Adaptation Function
alpha1 = 1.5e-6*100e3; 
beta1 = 5e-4; 
    
% Parameters for Slow Power Law Adaptation Function
alpha2 = 1e-2*100e3; 
beta2 = 1e-1; 

% Initialized outputs of PLA
I1 = 0;
I2 = 0;

% Fast PLA 6th Order IIR Filter Approximation Coefficients
% First 2nd Order Stage
fast_b0_1 = 1;
fast_b1_1 = -0.994466986569624;
fast_b2_1 = 0.000000000002347;
fast_a0_1 = 1;
fast_a1_1 = -1.992127932802320;
fast_a2_1 = 0.992140616993846;
% Second 2nd Order Stage
fast_b0_2 = 1;
fast_b1_2 = -1.997855276593802;
fast_b2_2 = 0.997855827934345;
fast_a0_2 = 1;
fast_a1_2 = -1.999195329360981;
fast_a2_2 = 0.999195402928777;
% Third 2nd Order Stage
fast_b0_3 = 1;
fast_b1_3 = 0.798261718184977;
fast_b2_3 = 0.199131619874064;
fast_a0_3 = 1;
fast_a1_3 = 0.798261718183851;
fast_a2_3 = 0.199131619873480;
% Combine Coefficients into Matrix for Implementation in Simulink
fast_coeffs = [fast_b0_1*10^-3 fast_b1_1*10^-3 fast_b2_1*10^-3 fast_a0_1 fast_a1_1 fast_a2_1; fast_b0_2 fast_b1_2 fast_b2_2 fast_a0_2 fast_a1_2 fast_a2_2; fast_b0_3 fast_b1_3 fast_b2_3 fast_a0_3 fast_a1_3 fast_a2_3];

% Slow PLA 10th Order IIR Filter Approximation Coefficients
% First 2nd Order Stage
slow_b0_1 = 1;
slow_b1_1 = -0.173492003319319;
slow_b2_1 = 0.000000172983796;
slow_a0_1 = 1;
slow_a1_1 = -0.491115852967412;
slow_a2_1 =  0.055050209956838;
% Second 2nd Order Stage
slow_b0_2 = 1;
slow_b1_2 = -0.803462163297112;
slow_b2_2 = 0.154962026341513;
slow_a0_2 = 1;
slow_a1_2 = -1.084520302502860;
slow_a2_2 = 0.288760329320566;
% Third 2nd Order Stage
slow_b0_3 = 1;
slow_b1_3 = - 1.416084732997016;
slow_b2_3 = 0.496615555008723;
slow_a0_3 = 1;
slow_a1_3 = -1.588427084535629;
slow_a2_3 = 0.628138993662508;
% Fourth 2nd Order Stage
slow_b0_4= 1;
slow_b1_4 = -1.830362725074550;
slow_b2_4 = 0.836399964176882;
slow_a0_4 = 1;
slow_a1_4 = -1.886287488516458;
slow_a2_4 = 0.888972875389923;
% Fifth 2nd Order Stage
slow_b0_5 = 1;
slow_b1_5 = -1.983165053215032;
slow_b2_5 = 0.983193027347456;
slow_a0_5 = 1;
slow_a1_5 = -1.989549282714008;
slow_a2_5 = 0.989558985673023;
% Combine Coefficients into Matrix for Implementation in Simulink
slow_coeffs = [slow_b0_1*0.2 slow_b1_1*0.2 slow_b2_1*0.2 slow_a0_1 slow_a1_1 slow_a2_1; slow_b0_2 slow_b1_2 slow_b2_2 slow_a0_2 slow_a1_2 slow_a2_2; slow_b0_3 slow_b1_3 slow_b2_3 slow_a0_3 slow_a1_3 slow_a2_3; slow_b0_4 slow_b1_4 slow_b2_4 slow_a0_4 slow_a1_4 slow_a2_4; slow_b0_5 slow_b1_5 slow_b2_5 slow_a0_5 slow_a1_5 slow_a2_5];
