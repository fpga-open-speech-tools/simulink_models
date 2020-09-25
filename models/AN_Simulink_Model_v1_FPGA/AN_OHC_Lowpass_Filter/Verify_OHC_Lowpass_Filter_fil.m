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
% Verify_OHC_Lowpass_Filter_fil
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
plot(out.ohcout);
title('Outer Hair Cell Lowpass Filter Output - Simulink Single Precision')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ohcoutfpga)
title('Outer Hair Cell Lowpass Filter Output - FPGA-in-the-Loop')
xlabel('Sample Number');


%% ERROR CALCULATION

% Performs various error calculations for Simulink Single Precision and
% FPGA-in-the-Loop Outputs (references user-created function calcerror.m)
[avgpercerror,maxpercerror,normerror] = calcerror(out.ohcout1, out.ohcoutfpga);

% Adding more detailed title to function generated Error Distribution Plot
title('Percent Error Distribution (Stage 2) - OHC Lowpass Filter');

% Display in Simulink Diagnostics menu
disp('OHC LP Filter Average Percent Error =');
disp(avgpercerror);

% Display in Simulink Diagnostics menu
disp('OHC LP Filter Maximum Percent Error =');
disp(maxpercerror);

% Display in Simulink Diagnostics menu
disp('OHC LP Filter Euclidean Norm Error =');
disp(normerror);

% end of script


