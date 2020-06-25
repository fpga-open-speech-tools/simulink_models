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
% OHC_IHC_Model_Parameters
% 07/31/2019

%% NOTES

% The following list of parameters are the highest level inputs to the AN
% Simulink Model. Editing these parameters will have an effect on other
% model parameters, calculated both in 'OHC_IHC_Get_Parameters.m' and the
% Simulink Model itself

%% DECLARING PARAMETERS

% characteristic frequency of the neuron
cf = 1000; 

% sampling rate
Fs = 48e3;

% histogram binsize in seconds, defined as 1/sampling rate
tdres = 1/Fs;

% number of repititions for the peri-stimulus time histogram
nrep = 100; 

% outer hair cell impairment constant ( from 0 to 1 )
cohc = 1; 

% inner hair cell impairment constant ( from 0 to 1 )
cihc = 1;

% species associated with model ( 1 for cat, 2 or 3 for human )
species = 2;

% Absolute refractory period
tabs   = 0.6e-3; 

% Baseline mean relative refractory period
trel   = 0.6e-3; 

% End of script
