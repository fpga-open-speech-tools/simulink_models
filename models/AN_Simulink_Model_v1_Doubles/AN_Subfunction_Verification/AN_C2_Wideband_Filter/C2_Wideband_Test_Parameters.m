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
% C2_Wideband_Test_Parameters
% 06/27/2019

% clear all;
% close all;

%% NOTES

% The following script is designed as an init script for the C2 Wideband
% Filter Simulink model. It sets the parameters for both the 
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

%% C2 WIDEBAND FILTER PARAMETERS

% Calculated Constants

% time constant determined with another function (chosen as the output of
% Get_taubm for cf = 1000 Hz)
taumaxc2 = 0.0030;

% parameter calculated as 1/ratiobm in model_IHC_BEZ2018.c (arbitrary for
% initial test)
fcohcc2 = 1;

% Calculating IIR Biquad Coefficients by calling C2Coefficients
% MATLAB function
[C2coeffs, norm_gainc2] = C2Coefficients( tdres, cf, taumaxc2, fcohcc2 );


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
