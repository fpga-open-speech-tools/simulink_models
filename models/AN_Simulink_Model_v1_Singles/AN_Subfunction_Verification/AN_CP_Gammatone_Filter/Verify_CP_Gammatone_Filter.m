% Copyright 2020 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt & Hezekiah Austin
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

% Auditory Nerve Simulink Model Code
% Verify_CP_Gammatone_Filter
% 06/27/2019

%% NOTES

% The following script is designed to isolate and test the WbGammaTone
% function found in the model_IHC_BEZ2018.c file in order to verify
% Simulink model functionality

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex WbGammaTone.c complex.c

%% CALL C FUNCTION

for n = 0:length(RxSignal)-1
    wbout(n+1,1) = WbGammaTone(RxSignal(n+1,1),tdres,centerfreq,n,tauwb,wbgain,wborder);
end

%% COMPARISON PLOT

% Comparsion plotting of the Original C Source Code vs Simulink Doubles Model
% *** Modified for new vector names by Hezekiah Austin 03/03/2020
figure()
subplot(2,1,1)
plot(wbout);
title('CP Wideband Gammatone Filter Output - C Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.wbout_doubles)
title('CP Wideband Gammatone Filter Output - Simulink Doubles')
xlabel('Sample Number');

% Comparsion plotting of the Simulink Singles Model vs Simulink Doubles Model
% *** Added for test/verification by Hezekiah Austin 03/03/2020
figure()
subplot(2,1,1)
plot(out.wbout_doubles);
title('CP Wideband Gammatone Filter Output - Simulink Doubles')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.wbout)
title('CP Wideband Gammatone Filter Output - Simulink Singles')
xlabel('Sample Number');

%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
% *** Modified for the new vector names by Hezekiah Austin 03/03/2020
wbmodelerror = norm(wbout(1:end)-out.wbout_doubles(1:end-1));

% Compares output vectors of MATLAB and Simulink model outputs
% *** Added for test/verification of doubles to singles conversion by Hezekiah Austin 03/03/2020
wbconversionerror = norm(out.wbout_doubles(1:end-1)-out.wbout(1:end-1));

% Display in Simulink Diagnostics menu
disp('CP Wideband Gammatone Model Error =');
disp(wbmodelerror);

% Display in Simulink Diagnostics menu
disp('CP Wideband Gammatone Conversion Error =');
disp(wbconversionerror);

%% DEBUGGING ERROR CALCULATIONS
% *** Created for temporary use by Matthew Blunt 03/04/2020

% Compares vectors for double and single wbphase values
% *** Added for debugging by Matthew Blunt 03/04/2020
wbphaseerror = norm(out.wbphasedouble-out.wbphase);

% Compares vectors for double and single complex phase values
% *** Added for debugging by Matthew blunt 03/04/2020
cphaseerror = norm(out.cphasedouble-out.cphase);

% Compares vectors for double and single filter outputs
% *** Added for debugging by Matthew Blunt 03/04/2020
filtouterror = norm(out.filtoutdouble-out.filtout);

% Display in Simulink Diagnostics menu
disp('Wb Phase Error =');
disp(wbphaseerror);

% Display in Simulink Diagnostics menu
disp('Complex Phase Error =');
disp(cphaseerror);

% Display in Simulink Diagnostics menu
disp('Filter Output Error =');
disp(filtouterror);


% end of script
