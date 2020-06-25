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
% support@flatearthinc.com

% Auditory Nerve Simulink Model Code
% Synapse_Test_Parameters
% 07/24/2019

% clear all;
% close all;

%% NOTES

% The following script is designed as an init script for the Synapse
% Simulink model. It sets the parameters for the 
% Simulink model and provides the test signal.

% NOTE: The input signal for the model is set to an example IHC output
% signal, saved from MATLAB. This is necessary to replicate the type of
% input the synapse model and spike generator would see.

%% AN MODEL INPUTS

% Characteristic frequency of specific neuron, chosen arbitrarily for
% testing (but must be greater than 125 - see model_IHC_BEZ2018)
cf = 1000;

% Sampling frequency
Fs = 48e3;

% Binsize in seconds
tdres = 1/Fs;

% Number of repititions for peri-stimulus time histogram
nrep = 100; 

% Impairment constants
cohc = 1; 
cihc = 1; 

% Species (1 for cat, 2 or 3 for human)
species = 2;

% Absolute refractory period
tabs   = 0.6e-3; 

% Baseline mean relative refractory period
trel   = 0.6e-3; 

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

% Declare input signals
load('AN_test_ihcout');
RxSignal = ihcout;

% Get uniformly distributed random number vector
randNums = rand(size(RxSignal));

% Calculate Simulink simulation test time
testtime = (length(RxSignal)-1)/Fs;


%% RANDOMLY GENERATED NOISE SIGNAL

% Find input signal length for testing
totalstim = length(RxSignal);

% Declare ffGn parameters

% Set to variable ffGn type (1)
noiseType = 1;

% Set Hurst index to the value hard-coded in C source code
Hinput = 0.9;

% Set mean of noise
spont = 100;

% Call fast fractional gaussian noise function
noise = ffGn(totalstim, tdres, Hinput, noiseType, spont);

