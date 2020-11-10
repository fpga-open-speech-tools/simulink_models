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

% Impairment constants
cohc = 1; 
cihc = 1; 

%% C1 Chirp Filter Parameters
taumaxc1 = 0.003; % Max time constant (given as bmTaumax in C source code, set to 0.003 for testing, the value of bmTaumax for cf = 1000)
[sigma0, ipw, ipb, rpa, pzero, order_of_zero, fs_bilinear, CF, phase_init, C1initphase, preal, pimag, order_of_pole] = calc_c1_coefficients_parameters(cf, tdres, taumaxc1);
[norm_gainc1] = c1_chirp_parameter(preal, pimag, pzero, order_of_pole, order_of_zero, CF);


%% C2 Wideband Filter Parameters
taumaxc2 = 0.0030; % time constant determined with another function (chosen as the output of Get_taubm for cf = 1000 Hz)     
fcohcc2 = 1;       % parameter calculated as 1/ratiobm in model_IHC_BEZ2018.c (arbitrary for initial test)
[C2coeffs, norm_gainc2] = C2Coefficients( tdres, cf, taumaxc2, fcohcc2); % Calculating IIR Biquad Coefficients by calling C2Coefficients MATLAB function


%% Inner Hair Cell Parameters
Fcihc    = 3000;
gainihc  = 1.0;
orderihc = 7;
[corner, strength, ihcasym_c1, slope_c1, ihcasym_c2, slope_c2, IHCLPcoeffs] = inner_hair_cell_parameters(tdres, Fcihc, gainihc);