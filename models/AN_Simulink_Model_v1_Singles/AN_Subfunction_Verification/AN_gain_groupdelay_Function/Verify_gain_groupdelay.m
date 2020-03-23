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
% Verify_gain_groupdelay
% 06/27/2019

%% NOTES

% The following script is designed to isolate and test the gain_groupdelay
% function found in the model_IHC_BEZ2018.c file in order to verify
% MATLAB script functionality

%% GAIN GROUP DELAY FUNCTION PARAMETERS

% Binsize, or sampling period
tdres = 1/48000;

% Time constant determined with another function, thus arbitrary for test
tau = 1;

% Characteristic frequency of specific neuron, chosen arbitrarily for
% testing (but must be greater than 125 - see model_IHC_BEZ2018)
cf = 1000; 

% Human frequency shift corresponding to 1.2 mm 
bmplace = (35/2.1) * log10(1.0 + cf / 165.4); % Calculate the location on basilar membrane from CF 
centerfreq = 165.4*(10^((bmplace+1.2)/(35/2.1))-1.0); % shift the center freq 

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex gain_groupdelay_mex.c

%% CALL C FUNCTION

[wb_gain,grdelay] = gain_groupdelay_mex(tdres,centerfreq,cf,tau);
grdelay = floor(grdelay);
    
%% CALL MATLAB FUNCTION (DOUBLE PRECISION)
% *** Title changed by Matthew Blunt 03/03/2020

% *** Output Variable names changed by Matthew Blunt 03/03/2020
[wb_gainmatdouble,grdelaymatdouble] = gain_groupdelay(tdres,centerfreq,cf,tau);


%% CALL MATLAB FUNCTION (SINGLE PRECISION)
% *** Added by Matthew Blunt 03/03/2020

% *** Single precision computation added by Matthew Blunt 03/03/2020
[wb_gainmat,grdelaymat] = gain_groupdelay(single(tdres),single(centerfreq),single(cf),single(tau));


%% CALCULATE ERROR

% Compares output vectors of MATLAB and Simulink model outputs
% *** Edited to reflect variable name changes by Matthew Blunt 03/03/2020
ggdmodelerror1 = norm(wb_gainmatdouble-wb_gain);
ggdmodelerror2 = norm(grdelay-grdelaymatdouble);

% Compares output vectors of Double and Single Precision Simulink outputs
% *** Added by Matthew Blunt 03/03/2020
ggdconversionerror1 = norm(wb_gainmatdouble-wb_gainmat);
ggdconversionerror2 = norm(grdelaymat-grdelaymatdouble);

% Display Model Error in Simulink Diagnostics menu
disp('Model Gain Error =');
disp(ggdmodelerror1);
disp('Model Group Delay Error =');
disp(ggdmodelerror2);

% Display Conversion Error in Simulink Diagnostics menu
% *** Added by Matthew Blunt 03/03/2020
disp('Conversion Gain Error =');
disp(ggdconversionerror1);
disp('Conversion Group Delay Error =');
disp(ggdconversionerror2);

% end of script



