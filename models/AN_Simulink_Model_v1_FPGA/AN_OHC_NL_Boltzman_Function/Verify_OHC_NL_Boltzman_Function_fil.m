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
% Verify_OHC_NL_Boltzman_Function_fil
% 04/15/2020

% *** Verify Script for Stage 2 of Test/Verification Process
% *** Added to file set by Matthew Blunt 04/15/2020

%% NOTES:

% The following script is designed to compare results from the Single
% Precision Subsystem to the FPGA-in-the-Loop Subsystem. (Stage 2
% Test/Verification)


%% COMPARISON PLOT

% Comparison Plot for Single Precision Simulink and FPGA-in-the-Loop Results 

figure()
subplot(2,1,1)
plot(out.ohcnonlinout(175:end));
title('OHC Nonlinear Boltzman Function Output - Simulink Single Precision')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ohcnonlinoutfpga(175:end))
title('OHC Nonlinear Bolztman Function Output - FPGA-in-the-Loop')
xlabel('Sample Number');


%% ERROR CALCULATION

% Performs various error calculations for Simulink Single Precision and
% FPGA-in-the-Loop Outputs (references user-created function calcerror.m)
[avgpercerror,maxpercerror,normerror,percerror] = calcerror(out.ohcnonlinout(175:end), out.ohcnonlinoutfpga(175:end));

% Adding more detailed title to function generated Error Distribution Plot
title('Percent Error Distribution (Stage 2) - OHC NL Boltzman Function');

% Display in Simulink Diagnostics menu
disp('OHC NL Boltzman Function Average Percent Error =');
disp(avgpercerror);

% Display in Simulink Diagnostics menu
disp('OHC NL Boltzman Function Maximum Percent Error =');
disp(maxpercerror);

% Display in Simulink Diagnostics menu
disp('OHC NL Boltzman Function Euclidean Norm Error =');
disp(normerror);

% end of script



