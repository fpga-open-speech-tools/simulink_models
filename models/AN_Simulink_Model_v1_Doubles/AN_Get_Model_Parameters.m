% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

% Auditory Nerve Simulink Model Code
% AN_Get_Model_Parameters
% 08/02/2019

%% NOTES

% This MATLAB script calculates and declares the necessary parameters for
% the AN Simulink Model, many of which depend on the overall model input
% parameters declared in AN_Set_Model_Parameters

% Various functions are called in order to calculate various gains, time
% constants, delays, etc. All functions called will include a description
% which gives the basic functionality of that particular function.

% All parameters found will be added to the MATLAB workspace and referred
% to by the AN Simulink Model. Note that all parameters will be constant
% throughout the runtime of the model , and will not be able to be edited
% during the simulation. If you desire to change a parameter during the
% runtime of the AN Simulink Model, it will be necessary to edit the
% Simulink model and bring the parameter up through the block heirarchy
% such that it can be edited within the FPGA fabric during runtime.

% NOTE: To edit the test signal, scroll to near the bottom of the script.

%% CENTER FREQUENCY PARAMETERS

% Calculating the center frequency for the control-path wideband filter 
% from the location on the basilar membrane, based on Greenwood (JASA 1990)

% For cat
if species == 1
    
    % Cat frequency shift corresponding to 1.2 mm
    % Calculate location on basilar membrane according to cf
    bmplace = 11.9 * log10(0.80 + cf / 456.0);
    
    % Shift the center frequency
    centerfreq = 456.0*((10^((bmplace+1.2)/11.9)) - 0.80);
    
end

% For human
if species > 1
    
    % Human frequency shift corresponding to 1.2 mm
    % Calculate location on basilar membrane according to cf
    bmplace = (35/2.1) * log10(1.0 + cf / 165.4);
    
    % Shift the center frequency
    centerfreq = 165.4*(10^((bmplace+1.2)/(35/2.1)) - 1.0);
    
end

%% GAIN PARAMETER

% Calculating gain, which is the same for both cat and human models
gain = 52.0/2.0*(tanh(2.2*log10(cf/0.6e3) + 0.15) + 1.0);

% Setting gain limits
if gain > 60.0
    gain = 60.0;
end

if gain < 15.0
    gain = 15.0;
end

%% CONTROL PATH WIDEBAND GAMMATONE FILTER PARAMETERS

bmorder = 3;
[Taumax, Taumin] = Get_tauwb(cf, species);
taubm = cohc*(Taumax-Taumin) + Taumin;
ratiowb = Taumin/Taumax;

%% SIGNAL PATH C1 CHIRP FILTER PARAMETERS

[bmTaumax, bmTaumin, ratiobm] = Get_taubm(cf, species, Taumax);
bmTaubm = cohc*(bmTaumax-bmTaumin) + bmTaumin;
fcohc = bmTaumax/bmTaubm;

%% CONTROL PATH WIDEBAND GAMMATONE FILTER PARAMETERS

wborder = 3;
TauWBMax = Taumin + 0.2*(Taumax-Taumin);
TauWBMin = TauWBMax/Taumax*Taumin;
tauwb = TauWBMax + (bmTaubm-bmTaumax)*(TauWBMax-TauWBMin)/(bmTaumax-bmTaumin);

[wbgain, grdelay] = gain_groupdelay(tdres, centerfreq, cf, tauwb);
tmpgain = wbgain;
lasttmpgain = wbgain;

% Calculated Constants:
% (Calculated in C source code functions)
delta_phase = -2*pi*centerfreq*tdres;

% Simulink Specific Parameter:
% number of cordic iterations
cordiciterationswb = 52;

%% NONLINEAR OHC & IHC TRANSDUCTION FUNCTION PARAMETERS

ohcasym = 7.0;
ihcasym = 3.0;

%% MIDDLE EAR FILTER AND PREWARPING PARAMETERS

% Prewarping frequency of 1kHz
fp = 1e3;

C  = 2*pi*fp/tan(2*pi/2*fp*tdres);

% Middle Ear Filter Coefficients

% For cat
if species == 1
    
m11 = C/(C + 693.48); % 1st Second Order IIR Coefficients
m12 = (693.48 - C)/C;
m13 = 0.0;
m14 = 1.0;
m15 = -1.0;
m16 = 0.0;

m21 = 1/(C^2 + 11053*C + 1.165e8); % 2nd Second Order IIR Coefficients
m22 = -2*C^2 + 2.326e8;
m23 = C^2 - 11053*C + 1.163e8;
m24 = C^2 + 1356.3*C + 7.4417e8;
m25 = -2*C^2 + 14.8834e8;
m26 = C^2 - 1356.3*C + 7.4417e8;

m31 = 1/(C^2 + 4620*C + 909059944); % 3rd Second Order IIR Coefficients
m32 = -2*C^2 + 2*909059944;
m33 = C^2 - 4620*C + 909059944;
m34 = 5.7585e5*C + 7.1665e7;
m35 = 14.333e7;
m36 = 7.1665e7 - 5.7585e5*C;

megainmax = 41.1405;

end

% For human
if species > 1
   
m11=1/(C^2+5.9761e+003*C+2.5255e+007); % 1st Second Order IIR Coefficients
m12=-2*C^2+2*2.5255e+007;
m13= C^2-5.9761e+003*C+2.5255e+007;
m14=C^2+5.6665e+003*C; 
m15=-2*C^2;
m16=C^2-5.6665e+003*C;

m21=1/(C^2+6.4255e+003*C+1.3975e+008); % 2nd Second Order IIR Coefficients
m22=-2*C^2+2*1.3975e+008;
m23=C^2-6.4255e+003*C+1.3975e+008;
m24=C^2+5.8934e+003*C+1.7926e+008; 
m25=-2*C^2+2*1.7926e+008;	
m26=C^2-5.8934e+003*C+1.7926e+008;

m31=1/(C^2+2.4891e+004*C+1.2700e+009); % 3rd Second Order IIR Coefficients
m32=-2*C^2+2*1.2700e+009;
m33=C^2-2.4891e+004*C+1.2700e+009;
m34=(3.1137e+003*C+6.9768e+008);    
m35=2*6.9768e+008;				
m36=-3.1137e+003*C+6.9768e+008; 

megainmax = 2;
    
end

%% OHC LP FILTER PARAMETERS

% Function Inputs:
% (Hard-coded in C source code, but set as parameters for model)
Fcohc = 600;
gainohc = 1.0;
orderohc = 2;

% Calculated Constants:
% (Calculated in C source code functions)
Cohc = 2.0/tdres;
c1LPohc = ( Cohc - 2*pi*Fcohc ) / ( Cohc + 2*pi*Fcohc );
c2LPohc = 2*pi*Fcohc / (2*pi*Fcohc + Cohc);

%% OHC NL BOLTZMAN FUNCTION PARAMETERS

% Function Inputs:
% (Hard-coded in C source code, but set as parameters for model)
shift = 1.0/(1.0+ohcasym);
s1 = 5.0;
s0 = 12.0;
x1 = 5.0;
x0 = s0*log((1.0/shift-1)/(1+exp(x1/s1)));

%% NL AFTER OHC FUNCTION PARAMETERS

% Function Inputs:
% (Hard-coded in C source code, but set as parameters for model)
minR = 0.05;

%% IHC LP FILTER PARAMETERS

% Function Inputs:
% (Hard-coded in C source code, but set as parameters for model)
Fcihc = 3000;
gainihc = 1.0;
orderihc = 7;

% Calculated Constants:
Cihc = 2.0/tdres;
c1LPihc = ( Cihc - 2*pi*Fcihc ) / ( Cihc + 2*pi*Fcihc );
c2LPihc = 2*pi*Fcihc / (2*pi*Fcihc + Cihc);

%% IHC NL LOGARITHMIC FUNCTION PARAMETERS

% Function Inputs:
% (Hard-coded in C source code, but set as parameters for model)
C1slope = 0.1;
C2slope = 0.2;
corner = 80;
strength = (20.0e6)/(10^(corner/20));

%% C2 FILTER PARAMETERS

% Calculate C2 filter coefficients and normalizing gain by calling MATLAB
% function
[C2coeffs, norm_gainc2] = C2Coefficients( tdres, cf, bmTaumax, 1/ratiobm );

%% C1 FILTER PARAMETERS

% Calculate the constant parameters for the C1 filter, including initial
% pole/zero locations, shifting constants, and gain constants

% Setup locations of poles and zeros
sigma0 = 1/bmTaumax;
ipw    = 1.01*cf*2*pi-50;
ipb    = 0.2343*2*pi*cf-1104;
rpa    = 10^(log10(cf)*0.9 + 0.55)+ 2000;
pzero  = 10^(log10(cf)*0.7+1.6)+500;
    
order_of_pole    = 10;             
half_order_pole  = order_of_pole/2;
order_of_zero    = half_order_pole;
    
fs_bilinear = 2*pi*cf/tan(2*pi*cf*tdres/2);
rzero       = -pzero;
CF          = 2*pi*cf;

preal = zeros(11,1);
pimag = zeros(11,1);

preal(1) = -sigma0;
preal(5) = preal(1) - rpa;
preal(3) = (preal(1) + preal(5))/2;
preal(7) = preal(1);
preal(9) = preal(5);
preal(2) = preal(1);
preal(4) = preal(3);
preal(6) = preal(5);
preal(8) = preal(2);
preal(10) = preal(6);

pimag(1) = ipw;
pimag(5) = pimag(1) - ipb;
pimag(3) = (pimag(1) + pimag(5))/2;
pimag(7) = pimag(1);
pimag(9) = pimag(5);
pimag(2) = -pimag(1);
pimag(4) = -pimag(3);
pimag(6) = -pimag(5);
pimag(8) = pimag(2);
pimag(10) = pimag(6);

% Calculate initial phase
C1initphase = 0.0;
for i = 1:half_order_pole
    C1initphase = C1initphase + atan(CF/(-rzero))-atan((CF-pimag(2*i-1))/(-preal(2*i-1)))-atan((CF+pimag(2*i-1))/(-preal(2*i-1)));
end

% Normalize the gain
C1gain_norm = 1.0;
for i = 1:order_of_pole
        C1gain_norm = C1gain_norm*((CF-pimag(i))^2 + (preal(i))^2);
end

norm_gainc1 = (sqrt(C1gain_norm))/((sqrt(CF^2+rzero^2))^order_of_zero);


%% NL BEFORE PLA FUNCTION PARAMETERS

% Spontaneous firing rate of neurons, as set in testANmodel_BEZ2018.m source code
spont = 100;

cfslope = (spont^0.19)*(10^-0.87);
cfconst = 0.1*(log10(spont))^2 + 0.56*log10(spont) - 0.84;
cfsat = 10^(cfslope*8965.5/1e3 + cfconst);
cf_factor = min(cfsat, 10^(cfslope*cf/1e3 + cfconst)) * 2.0;

multFac = max(2.95*max(1.0,1.5-spont/100), 4.3-0.2*cf/1e3);

% ---------------------------------------%
% NOTE: Currently, delaypoint is not used.
% ---------------------------------------%

delaypoint = floor(7500/(cf/1e3));


%% POWER LAW FUNCTION PARAMETERS

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


slow_coeffs = [slow_b0_1*0.2 slow_b1_1*0.2 slow_b2_1*0.2 slow_a0_1 slow_a1_1 slow_a2_1; slow_b0_2 slow_b1_2 slow_b2_2 slow_a0_2 slow_a1_2 slow_a2_2; slow_b0_3 slow_b1_3 slow_b2_3 slow_a0_3 slow_a1_3 slow_a2_3; slow_b0_4 slow_b1_4 slow_b2_4 slow_a0_4 slow_a1_4 slow_a2_4; slow_b0_5 slow_b1_5 slow_b2_5 slow_a0_5 slow_a1_5 slow_a2_5];


%% SPIKE GENERATOR PARAMETERS

% Original spike generation input parameters
nSites = 4;
t_rd_rest = 14.0e-3;
t_rd_jump = 0.4e-3;
t_rd_init = t_rd_rest + 0.02e-3*spont - t_rd_jump;
tau = 60e-3;

% Calculate model parameter values

% Initialized elapsed_times, one for each synaptic docking site
elapsed_time1 = tdres * randi(floor(Fs * t_rd_init));
elapsed_time2 = tdres * randi(floor(Fs * t_rd_init));
elapsed_time3 = tdres * randi(floor(Fs * t_rd_init));
elapsed_time4 = tdres * randi(floor(Fs * t_rd_init));

% Initialized input sensing sums, one for each synaptic docking site
Xsum1 = 0;
Xsum2 = 0;
Xsum3 = 0;
Xsum4 = 0;

% Initialized threshold values, one for each synaptic docking site
unitRateInterval1 = -log(rand(1))/tdres;
unitRateInterval2 = -log(rand(1))/tdres;
unitRateInterval3 = -log(rand(1))/tdres;
unitRateInterval4 = -log(rand(1))/tdres;

% Initialized redocking time, one for each synaptic docking site
oneSiteRedock1 = -t_rd_init * log(rand(1));
oneSiteRedock2 = -t_rd_init * log(rand(1));
oneSiteRedock3 = -t_rd_init * log(rand(1));
oneSiteRedock4 = -t_rd_init * log(rand(1));

% Initialized refractory period
Tref = tabs - trel*log(rand(1));

% Initialized refractory time
refractory_time = 0;

% Initialized spike time
sptime = 0;

% Initialized spike count
spCount = 0;

% Initialized redocking periods
previous_redocking_period = t_rd_init;
current_redocking_period = previous_redocking_period;

% Initialized redocking period output vector
trd_vector = current_redocking_period;


%% TEST SIGNAL

% Closely Matching Source Code:

% stimulus parameters
stimdb = 60; % stimulus intensity in dB SPL
F0 = cf;     % stimulus frequency in Hz
T  = 50e-3;  % stimulus duration in seconds
rt = 2.5e-3; % rise/fall time in seconds
ondelay = 10e-3;

% PSTH parameters
psthbinwidth = 1e-4; % binwidth in seconds;
psthbins = round(psthbinwidth*Fs);  % number of psth bins per psth bin

t = 0:1/Fs:T-1/Fs; % time vector
mxpts = length(t);
irpts = rt*Fs;
onbin = round(ondelay*Fs);

pin = zeros(1,onbin+mxpts);

pin(onbin+1:onbin+mxpts) = sqrt(2)*20e-6*10^(stimdb/20)*sin(2*pi*F0*t); % unramped stimulus
pin(onbin+1:onbin+irpts)= pin(onbin+1:onbin+irpts).*(0:(irpts-1))/irpts;
pin(onbin+(mxpts-irpts):onbin+mxpts)=pin(onbin+(mxpts-irpts):onbin+mxpts).*(irpts:-1:0)/irpts;

% Assign to simulink input signal
RxSignal = zeros(1,10/3*length(pin));
RxSignal(1:length(pin)) = pin;

% Simulink simulation test time
testtime = length(RxSignal)/Fs;

%% RANDOMLY GENERATED NUMBER VECTOR AND NOISE SIGNAL

% Get random vector
randNums = rand(size(RxSignal));

% Find input signal length for testing
totalstim = length(RxSignal);

% Declare ffGn parameters

% Set to variable ffGn type (1)
noiseType = 1;

% Set Hurst index to the value hard-coded in C source code
Hinput = 0.9;

% Set mean of noise
spont = 100;

% Call fast fractional gaussian noise function for noise signal in Power
% Law Adaptation
noise = ffGn(totalstim, tdres, Hinput, noiseType, spont);


% end of script
