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
% Verify_NL_Before_PLA
% 07/09/2019

%% NOTES:

% The following script is designed to isolate and test the NL Before
% PLA calculation found in source code in order 
% to verify Simulink model functionality.


%% CALL MATLAB FUNCTION

totalstim = length(RxSignal);

powerLawIn = NLBeforePLA(RxSignal, totalstim, spont, cf);


%% COMPARISON PLOT

% *** Changed NL Before PLA Simulink output name after update
% *** By Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(powerLawIn);
title('Nonlinear Function Before PLA Output - MATLAB Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.powerLawIndouble(1:end-1))
title('Nonlinear Function Before PLA Output - Simulink Model')
xlabel('Sample Number');

% *** Comparison Plot for Double and Single Precision Simulink Results
% *** Added by Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(out.powerLawIndouble);
title('Nonlinear Function Before PLA Output - Simulink Double Precision')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.powerLawIn)
title('Nonlinear Function Before PLA Output - Simulink Single Precision')
xlabel('Sample Number');


%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink Double Precision model outputs
% *** Changed output names after update by Matthew Blunt 03/03/2020
NLBPLAmodelerror = norm((powerLawIn(1:end))'-out.powerLawIndouble(1:end-1));

% Compares output vectors of Simulink Double and Single Precision Outputs
% *** Added by Matthew Blunt 03/03/2020
NLBPLAconversionerror = norm((out.powerLawIndouble(1:end))-out.powerLawIn(1:end));

% Display in Simulink Diagnostics menu
disp('NL Before PLA Model Error =');
disp(NLBPLAmodelerror);

% Display in Simulink Diagnostics menu
% *** Added by Matthew Blunt 03/03/2020
disp('NL Before PLA Conversion Error =');
disp(NLBPLAconversionerror);

% end of script
