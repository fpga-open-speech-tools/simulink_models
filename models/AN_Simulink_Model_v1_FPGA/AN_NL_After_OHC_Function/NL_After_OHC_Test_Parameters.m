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
% NL_After_OHC_Test_Parameters
% 06/27/2019

% clear all;
% close all;

%% NOTES

% The following script is designed as an init script for the NL After
% OHC Function Simulink model. It sets the parameters for both the 
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

%% NL AFTER OHC FUNCTION PARAMETERS

% Ratio of positive Max to negative Max
ohcasym = 7.0;

% Max and min time constants
% (input as bmTaumax and bmTaumin in source code, chosen as outputs for 
% cf = 1000 Hz from Get_taubm)
taumax = 0.003;
taumin = 4.6310e-04;

% Declared as constant in function
minR = 0.05;

% *** Adding precalculated values to avoid unnecessary computation and
% switch block architecture (All the following lines until Test Signal
% section)
% *** Added by Matthew Blunt 04/08/2020

R = taumin/taumax;

if R < minR
    minR = 0.5*R;
else
    minR = minR;
end

dc = (ohcasym-1)/(ohcasym+1.0)/2.0-minR;
R1 = R-minR;

% Denoted in C code: For new nonlinearity
s0 = -dc/log(R1/(1-minR));

% *** Note: These new variables are added to the Simulink model as constant
% blocks (single precision)

%% TEST SIGNAL

% Test signal set to chirp signal moving linearly over time from 125 Hz to
% 20000 Hz, sampled at 48 kHz.

% read in chirp signal
[tone,fs] = audioread('AN_test_tone.wav');

% Assign to variable used in model
% *** Changed to single precision input by Matthew Blunt 03/03/2020
RxSignal = single(tone);

% Assign to variable used in model
% *** Added double precision input by Matthew Blunt 03/03/2020
RxSignalDouble = tone;

% Find test time, which is set in model
testtime = length(RxSignal)/Fs

% end of script

