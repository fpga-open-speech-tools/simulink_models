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
% Verify_Get_taubm
% 06/27/2019

%% NOTES

% The following script is designed to isolate and test the get taubm
% function found in the model_IHC_BEZ2018.c file in order to verify
% MATLAB script functionality

%% TAUBM FUNCTION PARAMETERS

% Sampling period for 48kHz sampling rate
tdres = 1/48000;

% Set species to human for testing
species = 2;

% Declare maximum tau value
taumax = 0.0021;

% characteristic frequency of specific neuron, chosen arbitrarily for
% testing (but must be greater than 125 - see model_IHC_BEZ2018)
cf = 1000; 

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex Get_taubm_mex.c

%% CALL C FUNCTION

[bmTaumax, bmTaumin, ratio] = Get_taubm_mex(cf,species,taumax);
    
%% CALL MATLAB FUNCTION

[bmTaumaxmat, bmTauminmat, ratiomat] = Get_taubm(cf,species,taumax);

%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
tauwbmodelerror1 = norm(bmTaumax-bmTaumaxmat);
tauwbmodelerror2 = norm(bmTaumin-bmTauminmat);
tauwbmodelerror3 = norm(ratio-ratiomat);

% Display in Simulink Diagnostics menu
disp('taumax Error =');
disp(tauwbmodelerror1);
disp('taumin Error =');
disp(tauwbmodelerror2);
disp('ratio Error =');
disp(tauwbmodelerror3);


% end of script


