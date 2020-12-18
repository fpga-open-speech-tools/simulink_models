TWOPI = 6.28318530717959;
%% Add Subfolders to Path
addpath(genpath('auditory_nerve'))
addpath(genpath('middle_ear_filter'))
addpath(genpath('synapse_spike_generator_model'))
addpath(genpath('validation'))

%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\m06ae.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 10;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf      = 1000; % Characteristic frequency of specific neuron
Fs      = 16e3; % Sampling frequency
tdres   = 1/Fs; % Binsize in seconds
nrep    = 1;    % Number of repititions for peri-stimulus time histogram
species = 2;    % Human
order   = 3;    % Line 248 of model_IHC_BEZ2018.c

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

%% Delay Point: Lines 367 - 379
if(species == 1)
    delay = delay_cat(cf);
else
%     delay = delay_human(cf);
    delay = delay_cat(cf);
end
delay_point = max(0,ceil(delay/tdres)); % Line 374
    
%% Synapse and Spike Gen Parameters
% Synapse Parameters
dt = tdres; 
noiseType = 1;
implnt = 0;
spont = 100; % Spontaneous firing rate of neurons, as set in testANmodel_BEZ2018.m source code

% Nonlinear PLA Filter Parameters
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

% Power Law Adapter Parameters
% Random Noise
Hinput = 0.9;  % Set Hurst index to the value hard-coded in C source code
spont = 100;   % Set mean of noise
% Call fast fractional gaussian noise function for Double Precision
pla_rand_delay = 256;
pla_rand_nums  = single(ffGn(pla_rand_delay, tdres, Hinput, noiseType, spont));

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


% Spike Gen Parameters
spont = 100;
nSites = 4;
t_rd_rest = 14.0e-3;
t_rd_jump = 0.4e-3;
t_rd_init = t_rd_rest + 0.02e-3*spont - t_rd_jump;
tau = 60e-3;    

trel = 10e-3;
tabs = 10e-3;

elapsed_time = 0; % single(tdres * randi(floor(Fs * t_rd_init)));
% unitRateInterval = single(-log(rand(1))/tdres);
unitRateInterval = 87745;
% oneSiteRedock = single(-t_rd_init * log(rand(1)));
oneSiteRedock = single(t_rd_init/2);

% Accumulator Settings
integrationTime = 40e-3*Fs;
threshold       = 0.950;