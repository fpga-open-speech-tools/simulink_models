% Copyright 2020 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Hezekiah Austin
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

% Auditory Nerve Simulink Model Code
% Verify_Biquad_Filter
% 03/05/2020

%% NOTES:

% The following script is designed to isolate and test the IhcLowPass
% function found in the model_IHC_BEZ2018.c file in order to verify
% Simulink model functionality

%% CLEARING ENVIROMENT

% Clearing the open figures from previous run.
close all;

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex IhcLowPass.c

%% CALL C FUNCTION

for n = 0:length(RxSignal)-1
    ihcout(n+1,1) = IhcLowPass(RxSignal(n+1,1),tdres,Fcihc,n,gainihc,orderihc);
end

%% COMPARISON PLOT

% *** Figure added for test/verification of Simulink Single Model to FPGA Single Model
% *** Added by Hezekiah Austin 03/05/2020
figure()
subplot(2,1,1)
plot(out.ihcout);
title('IHC LP Filter Output - Simulink Model Singles')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ihcout)
title('IHC LP Filter Output - FPGA Model Singles')
xlabel('Sample Number');

%% CALCULATE ERROR

% Compares output vectors of Simulink Singles Model and Simulink Doubles Model outputs
% ??? Unfinished *** Modified for new output vector names by Hezekiah Austin 03/03/2020
IHCimplimentationerror = norm(out.ihcout(1:end-1)-out.ihcout(1:end-1));

% Display in Simulink Diagnostics menu
% *** Created for implimentation (Simulink to FPGA) error by Hezekiah Austin 03/03/2020
disp('Biquad Filter Implimentation Error = ');
disp(IHCimplimentationerror);

% end of script

