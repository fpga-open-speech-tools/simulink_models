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
% NL_Before_PLA_Test_Parameters
% 07/09/2019

%clear all;
%close all;

%% NOTES

% The following script is designed as an init script for the NL Before
% PLA Simulink model. It sets the parameters for both the 
% Simulink model and the comparison MATLAB function. In addition, it 
% provides the test signal, set to a frequency sweep from 125 Hz to 20000 
% Hz in 4 seconds, sampled at 48 kHz.


%% AN MODEL INPUTS

% Overall AN model inputs

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

%% NL BEFORE PLA FUNCTION PARAMETERS

% Spontaneous firing rate of neurons, as set in testANmodel_BEZ2018.m source code
spont = 100;

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


%% TEST SIGNAL

% Test signal set to chirp signal moving linearly over time from 125 Hz to
% 20000 Hz, sampled at 48 kHz.

% read in chirp signal
[tone,fs] = audioread('AN_test_tone.wav');

% Assign to variable used in model
RxSignal = tone;

% Find test time, which is set in model
testtime = length(RxSignal)/Fs

% end of script

% read in chirp signal
%[tone,fs] = audioread('AN_test_tone.wav');

% Assign to variable used in model
%RxSignal = tone;
%tone1 = zeros(48000,1);
%t = 0:1/48000:1;
%tone2 = (1*sin(2*pi*cf*t))';
%RxSignal = [tone1' tone2' tone1']';
% RxSignal = ihcout;

% Find test time, which is set in model
% testtime = length(RxSignal)/Fs

% end of script

