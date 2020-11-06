TWOPI = 6.28318530717959;
%% Autogen parameters
mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 5;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;

mp.testFile    = [mp.test_signals_path filesep 'auditory_nerve\m06ae.wav'];
totalstim      = 20007;

%% ANM Settings
cf    = 1000; % Characteristic frequency of specific neuron
Fs    = 48e3; % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep  = 100;  % Number of repititions for peri-stimulus time histogram

% Impairment constants
cohc  = 1;    % outer hair cell impairment constant ( from 0 to 1 )
cihc  = 1;    % inner hair cell impairment constant ( from 0 to 1 )

%% Audiotry Nerve Model Parameters
% Middle Ear Filter Parameters
fp = 1e3;     % Prewarping frequency of 1kHz

% Outer Hair Cell Parameters
ohcasym  = 7.0; % Ratio of positive Max to negative Max
Fcohc    = 600;
gainohc  = 1.0;
orderohc = 2;

% C1 Chirp Filter Parameters
rsigma = .5;         % Pole shifting constant (set as constant for testing)
bmTaumax = 0.003;      % Max time constant (given as bmTaumax in C source code -the value of bmTaumax for cf = 1000)
bmTaumin = 4.6310e-04; % Min time constant (given as bmTaumin in C source code - the value of bmTaumax for cf = 1000)

% C2 Wideband Filter
taumaxc2 = 0.0030;   % time constant determined with another function (chosen as the output of Get_taubm for cf = 1000 Hz)     
fcohcc2  = 1;        % parameter calculated as 1/ratiobm in model_IHC_BEZ2018.c (arbitrary for initial test)

% Inner Hair Cell Parameters
Fcihc    = 3000;
gainihc  = 1.0;
orderihc = 7;

[MEcoeffs, MEscale, shift, s1, s0, x1, x0, OHCLPcoeffs, s0_nl, minR, order_of_zero, fs_bilinear, CF, preal, pimag, C1initphase, norm_gainc1, C2coeffs, norm_gainc2, ...
        corner, strength, ihcasym_c1, slope_c1, ihcasym_c2, slope_c2, IHCLPcoeffs] = auditory_nerve_parameters(tdres, fp, ohcasym, Fcohc, gainohc, bmTaumax, bmTaumin, cf, taumaxc2, fcohcc2, Fcihc, gainihc);
             

%% Synapse Model
% Nonlinear PLA Filter Parameters
spont = 100; % Spontaneous firing rate of neurons, as set in testANmodel_BEZ2018.m source code

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

%Power Law Adapter Parameters
% Random Noise
noiseType = 1; % Set to variable ffGn type (1)
Hinput = 0.9;  % Set Hurst index to the value hard-coded in C source code
spont = 100;   % Set mean of noise
% Call fast fractional gaussian noise function for Double Precision
randNums = single(ffGn(totalstim, tdres, Hinput, noiseType, spont));

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


%% Control Path Parameters

% CP Wideband Gammatone Filter Parameters
% Human frequency shift corresponding to 1.2 mm 
bmplace = (35/2.1) * log10(1.0 + cf / 165.4);         % Calculate the location on basilar membrane from CF 
centerfreq = 165.4*(10^((bmplace+1.2)/(35/2.1))-1.0); % shift the center freq 
delta_phase = -TWOPI*centerfreq*tdres;                % Filter phase shift parameter
cordiciterationswb = 52;                              % Number of cordic iterations for cos + jsin complex representation in Simulink

% Outer Hair Cell Parameters
ohcasym  = 7.0; % Ratio of positive Max to negative Max
Fcohc    = 600;
gainohc  = 1.0;
orderohc = 2;

taumax = 0.003;      % Max time constant (given as bmTaumax in C source code -the value of bmTaumax for cf = 1000)
taumin = 4.6310e-04; % Min time constant (given as bmTaumin in C source code - the value of bmTaumax for cf = 1000)
             
[shift, s1, s0, x1, x0, OHCLPcoeffs, s0_nl, minR] = outer_hair_cell_parameters(tdres, ohcasym, Fcohc, gainohc, taumax, taumin);

%% OHC Calculate Tau for C1
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

%% Delay constants

mp.maxDelay = 1024; % Estimate of necessary buffer size
% buffer size to accomodate max delay; buffer size is a power of 2

mp.integerDelayAddrSize = ceil(log2(floor(mp.maxDelay)));
mp.integerDelayBufferSize = 2^mp.integerDelayAddrSize;

[wbgain_i, ~] = gain_groupdelay(tdres, centerfreq, cf, tauwb_i);
gain_groupdelay_func = @gain_groupdelay;

function [taumax, taumin] = Get_tauwb( cf, species, order)
  TWOPI = 6.28318530717959;
  if(species==1) 
      gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0); %/* for cat */
  end
  if(species>1) 
      gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3)+0.15)+1.0); %/* for human */
    %/*gain = 52/2*(tanh(2.2*log10(cf/1e3)+0.15)+1);*/ /* older values */
  end
  if(gain>60.0) 
      gain = 60.0;  
  end
  if(gain<15.0) 
      gain = 15.0;
  end
  ratio = 10^(-gain/(20.0*order));       %/* ratio of TauMin/TauMax according to the gain, order */
%   if (species==1) %/* cat Q10 values */
%     Q10 = pow(10,0.4708*log10(cf/1e3)+0.4664);
%   end
  if (species==2) %/* human Q10 values from Shera et al. (PNAS 2002) */
    Q10 = (cf/1000)^(0.3)*12.7*0.505+0.2085;
  end
  if (species==3) %/* human Q10 values from Glasberg & Moore (Hear. Res. 1990) */
    Q10 = cf/24.7/(4.37*(cf/1000)+1)*0.505+0.2085;
  end
  bw     = cf/Q10;
  taumax = 2.0/(TWOPI*bw);
  taumin   = taumax*ratio;
end

function [wb_gain, grdelay, x] = gain_groupdelay(tdres, centerfreq, cf, tau)
  TWOPI = 6.28318530717959;
  tmpcos = cos(TWOPI*(centerfreq-cf)*tdres);
  dtmp2 = tau*2.0/tdres;
  c1LP = (dtmp2-1)/(dtmp2+1);
  c2LP = 1.0/(dtmp2+1);
  tmp1 = 1+c1LP*c1LP-2*c1LP*tmpcos;
  tmp2 = 2*c2LP*c2LP*(1+tmpcos);
  
  wb_gain = (tmp1/tmp2)^( 1.0/2.0);
  
  grdelay = floor((0.5-(c1LP*c1LP-c1LP*tmpcos)/(1+c1LP*c1LP-2*c1LP*tmpcos)));
  x = grdelay;
end