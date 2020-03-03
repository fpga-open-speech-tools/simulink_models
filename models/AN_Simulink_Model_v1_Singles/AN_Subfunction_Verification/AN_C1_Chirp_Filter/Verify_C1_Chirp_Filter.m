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

% *** Changed C1 filter Simulink output name after update
% *** By Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(C1filterout);
title('C1 Chirp Filter Output - C Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.C1filteroutdouble)
title('C1 Chirp Filter Output - Simulink Model')
xlabel('Sample Number');

% *** Comparison Plot for Double and Single Precision Simulink Results
% *** Added by Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(out.C1filteroutdouble);
title('C1 Chirp Filter Output - Double Precision Simulink')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.C1filterout)
title('C1 Chirp Filter Output - Single Precision Simulink')
xlabel('Sample Number');


%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink Double Precision model outputs
% *** Changed output names after update by Matthew Blunt 03/03/2020
C1modelerror = norm(C1filterout(1:end)-out.C1filteroutdouble(1:end-1));

% Compares output vectors of Simulink Double and Single Precision Outputs
% *** Added by Matthew Blunt 03/03/2020
C1conversionerror = norm(out.C1filteroutdouble(1:end)-out.C1filterout(1:end));

% Display in Simulink Diagnostics menu
disp('C1 Chirp Filter Model Error =');
disp(C1modelerror);

% Display in Simulink Diagnostics menu
% *** Added by Matthew Blunt 03/03/2020
disp('C1 Chirp Filter Conversion Error =');
disp(C1conversionerror);

% end of script
