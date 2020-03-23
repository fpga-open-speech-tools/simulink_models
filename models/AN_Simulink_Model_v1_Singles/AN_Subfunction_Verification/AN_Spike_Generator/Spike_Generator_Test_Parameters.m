% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

% Auditory Nerve Simulink Model Code
% Spike_Generator_Test_Parameters
% 07/31/2019

% clear all;
% close all;

%% NOTES

% This MATLAB script is designed to provide the initial test paramters and
% test signal in order to test the functionality of the
% Spike Generator Simulink model.

% NOTE: The input signal for the model is set to an example Synapse output
% signal, saved from MATLAB. This is necessary to replicate the type of
% input the spike generator would see.


%% DOUBLE PRECISION OVERALL MODEL INPUTS
% *** Name changed by Matthew Blunt 03/03/2020

% sampling rate
Fs = 48e3;

% histogram binsize in seconds, defined as 1/sampling rate
tdres = 1/Fs;

% Absolute refractory period
tabs   = 0.6e-3; 

% Baseline mean relative refractory period
trel   = 0.6e-3; 

%% SINGLE PRECISION OVERALL MODEL INPUTS
% *** Added by Matthew Blunt 03/03/2020

% sampling rate
SFs = single(48e3);

% histogram binsize in seconds, defined as 1/sampling rate
Stdres = single(1/Fs);

% Absolute refractory period
Stabs   = single(0.6e-3); 

% Baseline mean relative refractory period
Strel   = single(0.6e-3); 

%% TEST SIGNAL

% Declare input signals
load('AN_test_synout');

% Assign to variable used in model
% *** Renamed double precision input by Matthew Blunt 03/03/2020
synoutdouble = synout;

% Assign to variable used in model
% *** Changed to single precision input by Matthew Blunt 03/03/2020
synout = single(synout);

% Get uniformly distributed random number vector
% *** Updated double precision input name by Matthew Blunt 03/03/2020
randNumsdouble = rand(size(synout));

% *** Added single precision input by Matthew Blunt 03/03/2020
randNums = single(randNumsdouble);

% Calculate Simulink simulation test time
testtime = (length(synout)-1)/Fs;

%% DOUBLE PRECISION PARAMETER INITIALIZATION

% Original spike generation input parameters
spont = 100;
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


%% SINGLE PRECISION PARAMETER INITIALIZATION
% *** Added by Matthew Blunt 03/03/2020

% Original spike generation input parameters
Sspont = 100;
SnSites = 4;
St_rd_rest = 14.0e-3;
St_rd_jump = 0.4e-3;
St_rd_init = t_rd_rest + 0.02e-3*spont - t_rd_jump;
Stau = 60e-3;

% Calculate model parameter values

% Initialized elapsed_times, one for each synaptic docking site
Selapsed_time1 = single(elapsed_time1);
Selapsed_time2 = single(elapsed_time2);
Selapsed_time3 = single(elapsed_time3);
Selapsed_time4 = single(elapsed_time4);

% Initialized input sensing sums, one for each synaptic docking site
SXsum1 = single(0);
SXsum2 = single(0);
SXsum3 = single(0);
SXsum4 = single(0);

% Initialized threshold values, one for each synaptic docking site
SunitRateInterval1 = single(unitRateInterval1);
SunitRateInterval2 = single(unitRateInterval2);
SunitRateInterval3 = single(unitRateInterval3);
SunitRateInterval4 = single(unitRateInterval4);

% Initialized redocking time, one for each synaptic docking site
SoneSiteRedock1 = single(oneSiteRedock1);
SoneSiteRedock2 = single(oneSiteRedock2);
SoneSiteRedock3 = single(oneSiteRedock3);
SoneSiteRedock4 = single(oneSiteRedock4);

% Initialized refractory period
STref = single(Tref);

% Initialized refractory time
Srefractory_time = single(0);

% Initialized spike time
Ssptime = single(0);

% Initialized spike count
SspCount = single(0);

% Initialized redocking periods
Sprevious_redocking_period = single(t_rd_init);
Scurrent_redocking_period = single(previous_redocking_period);

% Initialized redocking period output vector
Strd_vector = single(current_redocking_period);

% end of script