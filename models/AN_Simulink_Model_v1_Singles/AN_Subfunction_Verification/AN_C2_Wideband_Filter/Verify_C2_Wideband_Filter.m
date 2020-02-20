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
% Verify_C2_Wideband_Filter
% 06/27/2019

%% NOTES

% The following script is designed to isolate and test the C2ChirpFilt
% function found in the model_IHC_BEZ2018.c file in order to verify
% Simulink model functionality

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex C2ChirpFilt.c complex.c

%% CALL C FUNCTION

for n = 0:length(RxSignal)-1
    C2filterout(n+1,1) = C2ChirpFilt(RxSignal(n+1,1),tdres,cf,n,taumaxc2,fcohcc2);
end

%% COMPARISON PLOT

figure()
subplot(2,1,1)
plot(C2filterout);
title('C2 Filter Output - C Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.C2filterout_doubles)
title('C2 Filter Output - Simulink Model Double Precision')
xlabel('Sample Number');

figure()
subplot(2,1,1)
plot(out.C2filterout_doubles);
title('C2 Filter Output - Simulink Model Double Precision')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.C2filterout)
title('C2 Filter Output - Simulink Model Single Precision')
xlabel('Sample Number');

%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink Double Precision Model outputs
% *** Modified for new output vector names by Hezekiah Austin 02/20/2020
C2modelerror = norm(C2filterout(1:end)-out.C2filterout_doubles(1:end-1));

% Compares output vectors of Simulink Single Precision and Double Precision Model outputs
% *** Added by Hezekiah Austin 02/20/2020
C2conversionerror = norm(out.C2filterout(1:end)-out.C2filterout_doubles(1:end));

% Display in Simulink Diagnostics menu
disp('C2 Wideband Filter Model Error =');
disp(C2modelerror);

% Display in Simulink Diagnostics menu
disp('C2 Wideband Filter Conversion Error =');
disp(C2conversionerror);

% end of script
