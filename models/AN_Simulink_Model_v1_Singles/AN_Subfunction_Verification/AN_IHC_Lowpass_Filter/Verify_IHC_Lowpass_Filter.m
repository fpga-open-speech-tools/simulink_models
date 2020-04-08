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
% Verify_IHC_Lowpass_Filter
% 06/26/2019

%% NOTES:

% The following script is designed to isolate and test the IhcLowPass
% function found in the model_IHC_BEZ2018.c file in order to verify
% Simulink model functionality

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex IhcLowPass.c

%% CALL C FUNCTION

for n = 0:length(RxSignal)-1
    ihcout(n+1,1) = IhcLowPass(RxSignal(n+1,1),tdres,Fcihc,n,gainihc,orderihc);
end

%% COMPARISON PLOT

% Close all the figures from previous run
% *** Added by Hezekiah Austin 03/10/2020
close all;

% Comparision Plots for the Original C Code vs Simulink Doubles Model
% *** Modified for new vector names by Hezekiah Austin 03/03/2020
figure()
subplot(2,1,1)
plot(ihcout);
title('IHC LP Filter Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ihcout_doubles)
title('IHC LP Filter Output - Simulink Model Doubles')
xlabel('Sample Number');

% *** Figure added for test/verification of double to single precision
% *** Added by Hezekiah Austin 03/03/2020
figure()
subplot(2,1,1)
plot(out.ihcout_doubles);
title('IHC LP Filter Output - Simulink Model Doubles')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ihcout)
title('IHC LP Filter Output - Simulink Model Singles')
xlabel('Sample Number');

%% CALCULATE ERROR

% Compares output vectors of MATLAB and Simulink Doubles Model outputs
% *** Modified for new output vector names by Hezekiah Austin 03/03/2020
IHCmodelerror = norm(ihcout(1:end)-out.ihcout_doubles(1:end-1));

% Compares output vectors of Simulink Singles Model and Simulink Doubles Model outputs
% *** Modified for new output vector names by Hezekiah Austin 03/03/2020
IHCconversionerror = norm(out.ihcout(1:end-1)-out.ihcout_doubles(1:end-1));

% Compares output vectors of Singles Direct Form 1 and Doubles Biquad outputs
% *** Modified for new output vector names by Hezekiah Austin 03/10/2020
IHCdirecterror = norm(out.ihcout_doubles(1:end-1)-out.ihcout_filter(1:end-1));

% Compares output vectors of Simulink Singles Biquad Filter and Simulink
% Single Direct Form 1 Filter
% *** Modified for new output vector names by Hezekiah Austin 03/10/2020
IHCreplacementerror = norm(out.ihcout(1:end-1)-out.ihcout_filter(1:end-1));

% Compares output vectors of Simulink Singles Biquad Filter and Simulink
% Single Direct Form 1 Filter
% *** Modified for new output vector names by Hezekiah Austin 03/10/2020
IHCreplacementerror = norm(out.ihcout(1:end-1)-out.ihcout_filter(1:end-1));

% Display in Simulink Diagnostics menu
disp('IHC Lowpass Filter Model Error = ');
disp(IHCmodelerror);

% Display in Simulink Diagnostics menu
% *** Created for conversion (doubles to singles) error by Hezekiah Austin 03/03/2020
disp('IHC Lowpass Filter Conversion Error = ');
disp(IHCconversionerror);

% Display in Simulink Diagnostics menu

% *** Created for Filter Comparision (Doubles Biquads to Direct Form 1) error by Hezekiah Austin 03/10/2020
disp('IHC Lowpass Filter Doubles Biquad to Singles Direct Form Error = ');
disp(IHCdirecterror);

% Display in Simulink Diagnostics menu
% *** Created for Filter Comparision (Singles Biquads to Direct Form 1) error by Hezekiah Austin 03/10/2020
disp('IHC Lowpass Filter Replacement Error = ');
disp(IHCreplacementerror);

% *** Created for Filter Comparision (Biquads to Direct Form 1) error by Hezekiah Austin 03/10/2020
disp('IHC Lowpass Filter Filter Error = ');
disp(IHCfiltererror);

% end of script

