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
% rsigma = .5;    % Pole shifting constant (set as constant for testing)
taumax = 0.003; % Max time constant (given as bmTaumax in C source code, set to 0.003 for testing, the value of bmTaumax for cf = 1000)
[sigma0, ipw, ipb, rpa, pzero, order_of_zero, fs_bilinear, CF, phase_init, C1initphase, preal, pimag, order_of_pole] = calc_c1_coefficients_parameters(cf, tdres, taumax);
[norm_gainc1] = c1_chirp_parameter(preal, pimag, pzero, order_of_pole, order_of_zero, CF);
