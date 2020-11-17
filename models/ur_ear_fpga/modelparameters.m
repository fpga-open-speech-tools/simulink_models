TWOPI = 6.28318530717959;
%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\m06ae.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 10;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf    = 2500; % Characteristic frequency of specific neuron
Fs    = 48e3; % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep  = 100;  % Number of repititions for peri-stimulus time histogram
species = 2;  % Human
order   = 3;  % Line 248 of model_IHC_BEZ2018.c

% Impairment constants
cohc  = 1;    % outer hair cell impairment constant ( from 0 to 1 )
cihc  = 1;    % inner hair cell impairment constant ( from 0 to 1 )

%% Middle Ear Filter Parameters
[MEcoeffs, MEscale] = middle_ear_filter_parameter(tdres);

%% Control Path Parameters
% CP Wideband Gammatone Filter Parameters
% Human frequency shift corresponding to 1.2 mm 
bmplace     = (35/2.1) * log10(1.0 + cf / 165.4);      % Calculate the location on basilar membrane from CF 
centerfreq  = 165.4*(10^((bmplace+1.2)/(35/2.1))-1.0); % shift the center freq 
delta_phase = -TWOPI*centerfreq*tdres;                 % Filter phase shift parameter
cordiciterationswb = 52;                               % Number of cordic iterations for cos + jsin complex representation in Simulink

% OHC Calculate Tau for C1
[taumax, taumin]              = Get_tauwb(cf, species, order);     % Line 242 
taubm                         = cohc*(taumax-taumin)+taumin;       % Line 243
ratiowb                       = taumin/taumax;                     % Line 244
[bmTaumax, bmTaumin, ratiobm] = Get_taubm(cf, species, taumax);    % Line 246
bmTaubm                       = cohc*(bmTaumax-bmTaumin)+bmTaumin; % Line 247

% Outer Hair Cell Parameters
ohcasym  = 7.0; % Ratio of positive Max to negative Max
Fcohc    = 600; % Hardcoded in model, line 320
gainohc  = 1.0; % Hardcoded in model, line 320
orderohc = 2;   % Hardcoded in model, line 320
[shift, s1, s0, x1, x0, OHCLPcoeffs, s0_nl, minR] = outer_hair_cell_parameters(tdres, ohcasym, Fcohc, gainohc, bmTaumax, bmTaumin);

% Lines 250-253:
wborder  = 3;
TauWBMax = taumin+0.2*(taumax-taumin);
TauWBMin = TauWBMax/taumax*taumin;
% This is the initial value of tauwb, in future calculations tauc1 is used in place of bmTaubm
tauwb_i    = TauWBMax+(bmTaubm-bmTaumax)*(TauWBMax-TauWBMin)/(bmTaumax-bmTaumin);
[wbgain_i, ~] = gain_groupdelay(tdres, centerfreq, cf, tauwb_i);

% Delay constants
mp.maxDelay = 64; % Estimate of necessary buffer size to accomodate max delay; buffer size is a power of 2
mp.integerDelayAddrSize = ceil(log2(floor(mp.maxDelay)));
mp.integerDelayBufferSize = 2^mp.integerDelayAddrSize;

%% Filter Path Parameters
% C1 Chirp Filter Parameters
[sigma0, ipw, ipb, rpa, pzero, order_of_zero, fs_bilinear, CF, phase_init, C1initphase, preal, pimag, order_of_pole] = calc_c1_coefficients_parameters(cf, tdres, bmTaumax);
[norm_gainc1] = c1_chirp_parameter(preal, pimag, pzero, order_of_pole, order_of_zero, CF);

% C2 Filter Parameters
[C2coeffs, norm_gainc2] = C2Coefficients(tdres, cf, bmTaumax, 1/ratiobm); % Calculating IIR Biquad Coefficients by calling C2Coefficients MATLAB function

% Inner Hair Cell Parameters
Fc_ihc    = 3000;  % Hardcoded In Function Call: Line 358
gain_ihc  = 1.0;   % Hardcoded In Function Call: Line 358 
order_ihc = 7;     % Hardcoded In Function Call: Line 358
[corner, strength, ihcasym_c1, slope_c1, ihcasym_c2, slope_c2, IHCLPcoeffs] = inner_hair_cell_parameters(tdres, Fc_ihc, gain_ihc);