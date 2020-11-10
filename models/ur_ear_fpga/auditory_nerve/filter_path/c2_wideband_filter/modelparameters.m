
%% Autogen parameters

mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result_subset.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

taumaxc2 = 0.0030; % time constant determined with another function (chosen as the output of Get_taubm for cf = 1000 Hz)     
fcohcc2 = 1;       % parameter calculated as 1/ratiobm in model_IHC_BEZ2018.c (arbitrary for initial test)
[C2coeffs, norm_gainc2] = C2Coefficients( tdres, cf, taumaxc2, fcohcc2 ); % Calculating IIR Biquad Coefficients by calling C2Coefficients MATLAB function