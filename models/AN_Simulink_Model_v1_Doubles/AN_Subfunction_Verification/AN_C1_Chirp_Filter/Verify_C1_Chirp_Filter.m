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
% Verify_C1_Chirp_Filter
% 06/27/2019

%% NOTES

% The following script is designed to isolate and test the C1ChirpFilt
% function found in the model_IHC_BEZ2018.c file in order to verify
% Simulink model functionality

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex C1ChirpFilt.c complex.c

%% CALL C FUNCTION

for n = 0:length(RxSignal)-1
    C1filterout(n+1,1) = C1ChirpFilt(RxSignal(n+1,1),tdres,cf,n,taumax,rsigma);
end

%% COMPARISON PLOT

figure()
subplot(2,1,1)
plot(C1filterout);
title('C1 Chirp Filter Output - C Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.C1filterout)
title('C1 Chirp Filter Output - Simulink Model')
xlabel('Sample Number');

%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
C1modelerror = norm(C1filterout(1:end)-out.C1filterout(1:end-1));

% Display in Simulink Diagnostics menu
disp('C1 Chirp Filter Model Error =');
disp(C1modelerror);

% end of script
