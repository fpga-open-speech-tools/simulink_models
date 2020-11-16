load rsigma.mat
TWOPI = 6.28318530717959;
%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;
mp.nSamples = length(double(squeeze(rsigma_sim_in.Data)));

%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram
species = 2;  % Human
order   = 3;  % Line 248 of model_IHC_BEZ2018.c

% Impairment constants
cohc = 1; 
cihc = 1; 

%% Filter Path Parameters
[taumax, taumin]              = Get_tauwb(cf, species, order);  % Line 242 
[bmTaumax, bmTaumin, ratiobm] = Get_taubm(cf, species, taumax); % Line 246
bmTaubm  = cohc*(bmTaumax-bmTaumin)+bmTaumin;                   % Line 247
fcohcc2  = bmTaumax/bmTaubm;                                    % Line 248

% C1 Chirp Filter Parameters
[sigma0, ipw, ipb, rpa, pzero, order_of_zero, fs_bilinear, CF, phase_init, C1initphase, preal, pimag, order_of_pole] = calc_c1_coefficients_parameters(cf, tdres, bmTaumax);
[norm_gainc1] = c1_chirp_parameter(preal, pimag, pzero, order_of_pole, order_of_zero, CF);

% C2 Filter Parameters
[C2coeffs, norm_gainc2] = C2Coefficients(tdres, cf, bmTaumax, 1/ratiobm); % Calculating IIR Biquad Coefficients by calling C2Coefficients MATLAB function

% Inner Hair Cell Parameters
Fc_ihc    = 3000;  % Constant In Function Call: Line 358
gain_ihc  = 1.0;   % Constant In Function Call: Line 358 
order_ihc = 7;     % Constant In Function Call: Line 358
[corner, strength, ihcasym_c1, slope_c1, ihcasym_c2, slope_c2, IHCLPcoeffs] = inner_hair_cell_parameters(tdres, Fc_ihc, gain_ihc);