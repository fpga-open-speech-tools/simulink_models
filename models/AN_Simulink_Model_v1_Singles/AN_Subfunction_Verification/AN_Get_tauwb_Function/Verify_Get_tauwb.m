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
% Verify_Get_tauwb
% 06/27/2019

%% NOTES

% The following script is designed to isolate and test the get tauwb
% function found in the model_IHC_BEZ2018.c file in order to verify
% MATLAB script functionality

%% GET TAUWB FUNCTION PARAMETERS

% Sampling period for 48kHz sampling rate
tdres = 1/48000;

% Set species to human for testing
species = 2;

% declared a constant in source code (no explanation given)
order = 3;

% characteristic frequency of specific neuron, chosen arbitrarily for
% testing (but must be greater than 125 - see model_IHC_BEZ2018)
cf = 1000; 

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex Get_tauwb_mex.c

%% CALL C FUNCTION

[taumax, taumin] = Get_tauwb_mex(cf,species,order);
    
%% CALL MATLAB FUNCTION

[taumaxmat, tauminmat] = Get_tauwb(cf,species);

%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
tauwbmodelerror1 = norm(taumax-taumaxmat);
tauwbmodelerror2 = norm(taumin-tauminmat);

% Display in Simulink Diagnostics menu
disp('taumax Error =');
disp(tauwbmodelerror1);
disp('taumin Error =');
disp(tauwbmodelerror2);

% end of script


