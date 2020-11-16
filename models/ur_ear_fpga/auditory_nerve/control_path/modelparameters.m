TWOPI = 6.28318530717959;
%% Autogen parameters
mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 5;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;

mp.testFile    = [mp.test_signals_path filesep 'auditory_nerve\mef_result_subset.wav'];
%totalstim      = 20007;

%% ANM Settings
cf    = 1000; % Characteristic frequency of specific neuron
Fs    = 48e3; % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep  = 100;  % Number of repititions for peri-stimulus time histogram
species = 2;  % Human
order   = 3;  % Line 248 of model_IHC_BEZ2018.c

% Impairment constants
cohc  = 1;    % outer hair cell impairment constant ( from 0 to 1 )
cihc  = 1;    % inner hair cell impairment constant ( from 0 to 1 )

%% Control Path Parameters
% CP Wideband Gammatone Filter Parameters
% Human frequency shift corresponding to 1.2 mm 
bmplace     = (35/2.1) * log10(1.0 + cf / 165.4);      % Calculate the location on basilar membrane from CF 
centerfreq  = 165.4*(10^((bmplace+1.2)/(35/2.1))-1.0); % shift the center freq 
delta_phase = -TWOPI*centerfreq*tdres;                 % Filter phase shift parameter
cordiciterationswb = 52;                               % Number of cordic iterations for cos + jsin complex representation in Simulink

% Outer Hair Cell Parameters
ohcasym  = 7.0; % Ratio of positive Max to negative Max
Fcohc    = 600; % Hardcoded in model, line 320
gainohc  = 1.0; % Hardcoded in model, line 320
orderohc = 2;   % Hardcoded in model, line 320

[taumax, taumin] = Get_tauwb( cf, species, order);            % Line 242
[bmTaumax, bmTaumin, ratio] = Get_taubm(cf, species, taumax); % Line 246 
[shift, s1, s0, x1, x0, OHCLPcoeffs, s0_nl, minR] = outer_hair_cell_parameters(tdres, ohcasym, Fcohc, gainohc, bmTaumax, bmTaumin);

% OHC Calculate Tau for C1
taubm   = cohc*(taumax-taumin)+taumin;                        % Line 243
ratiowb = taumin/taumax;                                      % Line 244
bmTaubm  = cohc*(bmTaumax-bmTaumin)+bmTaumin;                 % Line 247
fcohc = bmTaumax/bmTaubm;                                     % Line 248

% Lines 250-253:
wborder  = 3;
TauWBMax = taumin+0.2*(taumax-taumin);
TauWBMin = TauWBMax/taumax*taumin;
% This is the initial value of tauwb, in future calculations tauc1 is used in place of bmTaubm
tauwb_i    = TauWBMax+(bmTaubm-bmTaumax)*(TauWBMax-TauWBMin)/(bmTaumax-bmTaumin);

% Delay constants
mp.maxDelay = 64; % Estimate of necessary buffer size to accomodate max delay; buffer size is a power of 2
mp.integerDelayAddrSize = ceil(log2(floor(mp.maxDelay)));
mp.integerDelayBufferSize = 2^mp.integerDelayAddrSize;

[wbgain_i, ~] = gain_groupdelay(tdres, centerfreq, cf, tauwb_i);
