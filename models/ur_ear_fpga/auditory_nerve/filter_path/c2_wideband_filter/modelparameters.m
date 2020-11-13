
%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram
species = 2;
order   = 3;  % Line 248 of model_IHC_BEZ2018.c
% Impairment constants
cohc  = 1;    % outer hair cell impairment constant ( from 0 to 1 )
cihc  = 1;    % inner hair cell impairment constant ( from 0 to 1 )

%% C2 Filter Parameters
[taumax, taumin]              = Get_tauwb(cf, species, order);
[bmTaumax, bmTaumin, ratiobm] = Get_taubm(cf, species, taumax);

bmTaubm  = cohc*(bmTaumax-bmTaumin)+bmTaumin;
fcohcc2  = bmTaumax/bmTaubm;      
[C2coeffs, norm_gainc2] = C2Coefficients(tdres, cf, bmTaumax, 1/ratiobm); % Calculating IIR Biquad Coefficients by calling C2Coefficients MATLAB function
