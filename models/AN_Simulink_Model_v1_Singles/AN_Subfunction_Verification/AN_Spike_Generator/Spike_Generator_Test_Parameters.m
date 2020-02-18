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


%% OVERALL MODEL INPUTS

% sampling rate
Fs = 48e3;

% histogram binsize in seconds, defined as 1/sampling rate
tdres = 1/Fs;

% Absolute refractory period
tabs   = 0.6e-3; 

% Baseline mean relative refractory period
trel   = 0.6e-3; 

%% TEST SIGNAL

% Declare input signals
load('AN_test_synout');

% Get uniformly distributed random number vector
randNums = rand(size(synout));

% Calculate Simulink simulation test time
testtime = (length(synout)-1)/Fs;

%% PARAMETER INITIALIZATION

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

% end of script