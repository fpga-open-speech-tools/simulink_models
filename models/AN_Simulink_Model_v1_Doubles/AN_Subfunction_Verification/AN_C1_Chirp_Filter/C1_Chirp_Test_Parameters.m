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
% C1_Chirp_Test_Parameters
% 06/27/2019

% clear all;
% close all;

%% NOTES

% The following script is designed as an init script for the C1 Chirp
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

%% C1 CHIRP FILTER PARAMETERS

% Pole shifting constant (set as constant for testing)
rsigma = 1;

% Max time constant (given as bmTaumax in C source code, set to 0.003 for 
% testing, the value of bmTaumax for cf = 1000)
taumax = 0.003;

% Calculate the constant parameters for the C1 filter, including initial
% pole/zero locations, shifting constants, and gain constants

% Setup locations of poles and zeros
sigma0 = 1/taumax;
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

