TWOPI= 6.28318530717959;

%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result_subset.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

%% CP Wideband Gammatone Filter Parameters
wbgain = 40.766; % Wideband gain (set to constant for testing, determined for cf = 1000 from the gain_groupdelay function)
wborder = 3;     % Wideband filter order
tauwb = 0.003;   % Wideband time constant (set to constant for testing, determined for cf = 1000 from model feedback path)
TauWBMax = 0.000163019356301846;
% Human frequency shift corresponding to 1.2 mm 
bmplace = (35/2.1) * log10(1.0 + cf / 165.4);         % Calculate the location on basilar membrane from CF 
centerfreq = 165.4*(10^((bmplace+1.2)/(35/2.1))-1.0); % shift the center freq 
delta_phase = -TWOPI*centerfreq*tdres;                % Filter phase shift parameter
cordiciterationswb = 52;                              % Number of cordic iterations for cos + jsin complex representation in Simulink