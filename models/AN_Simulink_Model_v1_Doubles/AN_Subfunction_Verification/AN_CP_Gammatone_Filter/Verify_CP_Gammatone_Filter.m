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
% openspeech@flatearthinc.com

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

figure()
subplot(2,1,1)
plot(wbout);
title('CP Wideband Gammatone Filter Output - C Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.wbout)
title('CP Wideband Gammatone Filter Output - Simulink Model')
xlabel('Sample Number');

%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
wbmodelerror = norm(wbout(1:end)-out.wbout(1:end-1));

% Display in Simulink Diagnostics menu
disp('CP Wideband Gammatone Model Error =');
disp(wbmodelerror);

% end of script
