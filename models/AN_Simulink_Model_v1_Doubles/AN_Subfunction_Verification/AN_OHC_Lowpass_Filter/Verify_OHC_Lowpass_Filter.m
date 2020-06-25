% Copyright 2019 Audio Logic
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
% Verify_OHC_Lowpass_Filter
% 06/26/2019

%% NOTES:

% The following script is designed to isolate and test the OhcLowPass
% function found in the model_IHC_BEZ2018.c file in order to verify
% Simulink model functionality

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex OhcLowPass.c

%% CALL C FUNCTION

for n = 0:length(RxSignal)-1
    ohcout(n+1,1) = OhcLowPass(RxSignal(n+1,1),tdres,Fcohc,n,gainohc,orderohc);
end

%% COMPARISON PLOT

figure()
subplot(2,1,1)
plot(ohcout);
title('OHC LP Filter Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ohcout)
title('OHC LP Filter Output - Simulink Model')
xlabel('Sample Number');


%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
OHCmodelerror = norm(ohcout(1:end)-out.ohcout(1:end-1));

% Display in Simulink Diagnostics menu
disp('OHC Lowpass Model Error =');
disp(OHCmodelerror);

% end of script


