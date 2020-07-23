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
% Verify_IHC_NL_Logarithmic_Function
% 06/26/2019

%% NOTES

% The following script is designed to isolate and test the get IHC NL
% Logarithmic function found in the model_IHC_BEZ2018.c file in order to 
% verify Simulink model functionality

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex NLogarithm.c complex.c

%% CALL C FUNCTION

for n = 0:length(RxSignal)-1
    vihctmp(n+1,1) = NLogarithm(RxSignal(n+1,1), slope, ihcasym, cf);
end

%% COMPARISON PLOT

figure()
subplot(2,1,1)
plot(vihctmp);
title('IHC NL Logarithmic Function Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.vihctmp)
title('IHC NL Logarithmic Function Output - Simulink Model')
xlabel('Sample Number');

%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
ihcnlmodelerror = norm(vihctmp(1:end)-out.vihctmp(1:end-1));

% Display in Simulink Diagnostics menu
disp('IHC NL Logarithmic Function Model Error =');
disp(ihcnlmodelerror);


% end of script