
%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\ohc_nlf_result.wav'];
%ohc_nlf_result

mp.sim_prompts = 1;
mp.sim_verify = 1;
mp.simDuration = 5;
mp.nSamples = config.system.sampleClockFrequency * mp.simDuration;

%% ANM Settings
cf = 1000;    % Characteristic frequency of specific neuron
Fs = 48e3;    % Sampling frequency
tdres = 1/Fs; % Binsize in seconds
nrep = 100;   % Number of repititions for peri-stimulus time histogram

% Human frequency shift corresponding to 1.2 mm 
bmplace = (35/2.1) * log10(1.0 + cf / 165.4); % Calculate the location on basilar membrane from CF 
centerfreq = 165.4*(10^((bmplace+1.2)/(35/2.1))-1.0); % shift the center freq

%% OHC Calculate Tau for C1

TWOPI = 6.28318530717959;

cohc = 1; % Input to IHC model


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

mp.integerDelayAddrSize = ceil(log2(floor(mp.maxDelay))) + 2;
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