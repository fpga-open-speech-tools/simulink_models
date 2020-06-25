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
% AN_Set_Model_Parameters
% 08/02/2019

%% NOTES

% The following list of parameters are the highest level inputs to the AN
% Simulink Model. Editing these parameters will have an effect on other
% model parameters, calculated both in 'AN_Get_Model_Parameters.m' and the
% Simulink Model itself

%% DECLARING PARAMETERS

% characteristic frequency of the neuron 
% (must be between 125 Hz and 20000 Hz)
cf = 1000; 

% sampling rate
Fs = 48e3;

% histogram binsize in seconds, defined as 1/sampling rate
tdres = 1/Fs;

% number of repititions for the peri-stimulus time histogram
% (must always be 1 for Simulink Model)
nrep = 1; 

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


%% MODEL VERIFICATION FLAG

% Along with the Simulink Model, there are a group of functions which
% replicate the functionality of the AN model source code from which the
% Simulink model is based. If the user wishes to run these functions after
% the model in order to view various comparison plots and error
% calculations, they can set the following model verification flag to true.
% This will run the necessary functions in the AN_StopFcn_Callback.m script
% after the Simulink model runs, resulting in verification plots and error
% calculations displayed in the Simulink diagnostics menu.

% NOTE: If the flag is set to true, A MATLAB compatible C/C++ compiler is 
% required to create the mex wrappers for the C functions used in the 
% verification process. See the readme.txt file or open the model 
% instructions in the Simulink model for more information on downloading a 
% C/C++ compiler.

% Set to 'true' if model verification is desired
verificationflag = false;


% End of AN_Set_Model_Parameters
