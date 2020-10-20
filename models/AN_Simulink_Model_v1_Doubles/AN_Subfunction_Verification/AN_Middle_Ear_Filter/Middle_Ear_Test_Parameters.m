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
% Middle_Ear_Test_Parameters
% 06/26/2019

clear all;
close all;

%% NOTES

% The following script is designed as an init script for the Middle Ear
% Filter Simulink model. It sets the parameters for both the Simulink model
% and the comparison MATLAB function. In addition, it provides the test
% signal, set to a frequency sweep from 125 Hz to 20000 Hz in 4 seconds,
% sampled at 48 kHz.


%% AN MODEL INPUTS

% Overall AN model inputs

% Characteristic frequency
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

%% MIDDLE EAR FILTER PARAMETERS

% Various Constants:

% Declaring 2 pi constant
TWOPI= 6.28318530717959; 

% Prewarping frequency 1 kHz
fp = 1000;  

% Filter constant
C  = TWOPI*fp/tan(TWOPI/2*fp*tdres);

% ---------------------------------------------------------------------- %

% Filter Coefficients taken from AN model (Set as human for testing)

% 1st Second Order IIR Coefficients
m11=1/(C^2+5.9761e+003*C+2.5255e+007); 
m12=-2*C^2+2*2.5255e+007;
m13= C^2-5.9761e+003*C+2.5255e+007;
m14=C^2+5.6665e+003*C; 
m15=-2*C^2;
m16=C^2-5.6665e+003*C;

% 2nd Second Order IIR Coefficients
m21=1/(C^2+6.4255e+003*C+1.3975e+008); 
m22=-2*C^2+2*1.3975e+008;
m23=C^2-6.4255e+003*C+1.3975e+008;
m24=C^2+5.8934e+003*C+1.7926e+008; 
m25=-2*C^2+2*1.7926e+008;	
m26=C^2-5.8934e+003*C+1.7926e+008;

% 3rd Second Order IIR Coefficients
m32=-2*C^2+2*1.2700e+009;
m31=1/(C^2+2.4891e+004*C+1.2700e+009); 
m33=C^2-2.4891e+004*C+1.2700e+009;
m34=(3.1137e+003*C+6.9768e+008);    
m35=2*6.9768e+008;				
m36=-3.1137e+003*C+6.9768e+008; 

% Filter Scaling Factor
megainmax=2;

%% TEST SIGNAL

% read in chirp signal
[tone,fs] = audioread('AN_test_tone.wav');

% Assign to variable used in model
RxSignal = tone;

% Find test time, which is set in model
testtime = length(RxSignal)/Fs

% end of script

