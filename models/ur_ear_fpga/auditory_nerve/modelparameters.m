TWOPI = 6.28318530717959;
%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result_subset.wav'];
% mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result.wav'];

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 10;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf    = 1000; % Characteristic frequency of specific neuron
Fs    = 48e3; % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep  = 100;  % Number of repititions for peri-stimulus time histogram

% Impairment constants
cohc  = 1;    % outer hair cell impairment constant ( from 0 to 1 )
cihc  = 1;    % inner hair cell impairment constant ( from 0 to 1 )
             

%% Control Path Parameters

% CP Wideband Gammatone Filter Parameters
% Human frequency shift corresponding to 1.2 mm 
bmplace = (35/2.1) * log10(1.0 + cf / 165.4);         % Calculate the location on basilar membrane from CF 
centerfreq = 165.4*(10^((bmplace+1.2)/(35/2.1))-1.0); % shift the center freq 
delta_phase = -TWOPI*centerfreq*tdres;                % Filter phase shift parameter
cordiciterationswb = 52;                              % Number of cordic iterations for cos + jsin complex representation in Simulink

% Outer Hair Cell Parameters
ohcasym  = 7.0; % Ratio of positive Max to negative Max
Fcohc    = 600; % Hardcoded in model, line 320
gainohc  = 1.0; % Hardcoded in model, line 320
orderohc = 2; % Hardcoded in model, line 320

bmTaumax = 0.003;      % Max time constant (given as bmTaumax in C source code -the value of bmTaumax for cf = 1000)
bmTaumin = 4.6310e-04; % Min time constant (given as bmTaumin in C source code - the value of bmTaumax for cf = 1000)
             
[shift, s1, s0, x1, x0, OHCLPcoeffs, s0_nl, minR] = outer_hair_cell_parameters(tdres, ohcasym, Fcohc, gainohc, bmTaumax, bmTaumin);

% OHC Calculate Tau for C1
gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0); % Defined in both Get_tauwb & Get_taubm
if(gain>60.0) 
    gain = 60.0;  
end
if(gain<15.0)
    gain = 15.0;
end

order = 3; % This is hardcoded as bmorder in C

ratio_tauwb  = 10^(-gain/(20.0*order)); % Ratio defined in Get_tauwb
Q10 = (cf/1000)^(0.3)*12.7*0.505+0.2085; % Defined Get_tauwb
bw = cf/Q10;
taumax = 2.0/(TWOPI*bw);
taumin = taumax*ratio_tauwb;

taubm   = cohc*(taumax-taumin)+taumin; % Line 243 of C code
ratiowb = taumin/taumax; % Line 244 of C code

bwfactor = 0.7; % Hardcoded in Get_taubm
factor   = 2.5; % Hardcoded in Get_taubm

ratio_taubm  = 10^(-gain/(20.0*factor)); % Ratio defined in Get_taubm

bmTaumax = taumax/bwfactor;
bmTaumin = bmTaumax*ratio_taubm;   

bmTaubm  = cohc*(bmTaumax-bmTaumin)+bmTaumin; % Line 247 of C code
fcohc = bmTaumax/bmTaubm; % Line 248

% Lines 250-253:
wborder  = 3;
TauWBMax = taumin+0.2*(taumax-taumin);
TauWBMin = TauWBMax/taumax*taumin;
% This is the initial value of tauwb, in future calculations tauc1 is used
% in place of bmTaubm
tauwb_i    = TauWBMax+(bmTaubm-bmTaumax)*(TauWBMax-TauWBMin)/(bmTaumax-bmTaumin);

% Delay constants

mp.maxDelay = 64; % Estimate of necessary buffer size
% buffer size to accomodate max delay; buffer size is a power of 2

mp.integerDelayAddrSize = ceil(log2(floor(mp.maxDelay)));
mp.integerDelayBufferSize = 2^mp.integerDelayAddrSize;

[wbgain_i, ~] = gain_groupdelay(tdres, centerfreq, cf, tauwb_i);
gain_groupdelay_func = @gain_groupdelay;


%% Filter Path Parameters
% C1 Chirp Filter Parameters
taumaxc1 = 0.003; % Max time constant (given as bmTaumax in C source code, set to 0.003 for testing, the value of bmTaumax for cf = 1000)
[sigma0, ipw, ipb, rpa, pzero, order_of_zero, fs_bilinear, CF, phase_init, C1initphase, preal, pimag, order_of_pole] = calc_c1_coefficients_parameters(cf, tdres, taumaxc1);
[norm_gainc1] = c1_chirp_parameter(preal, pimag, pzero, order_of_pole, order_of_zero, CF);


% C2 Wideband Filter Parameters
taumaxc2 = 0.0030; % time constant determined with another function (chosen as the output of Get_taubm for cf = 1000 Hz)     
fcohcc2 = 1;       % parameter calculated as 1/ratiobm in model_IHC_BEZ2018.c (arbitrary for initial test)
[C2coeffs, norm_gainc2] = C2Coefficients( tdres, cf, taumaxc2, fcohcc2); % Calculating IIR Biquad Coefficients by calling C2Coefficients MATLAB function


% Inner Hair Cell Parameters
Fcihc    = 3000;
gainihc  = 1.0;
orderihc = 7;
[corner, strength, ihcasym_c1, slope_c1, ihcasym_c2, slope_c2, IHCLPcoeffs] = inner_hair_cell_parameters(tdres, Fcihc, gainihc);