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
% AN_Simulink_Model_v1_fil
% 04/15/2020

% *** Verify Script for Stage 2 of Test/Verification Process
% *** Added to file set by Matthew Blunt 04/15/2020

%% NOTES:

% The following script is designed to compare results from the Single
% Precision Simulink AN Model to the FPGA-in-the-Loop AN Model. (Stage 2
% Test/Verification)


%% COMPARISON PLOT

% Comparison Plot for Single Precision Simulink and FPGA-in-the-Loop Results 

% Showing NaN

figure()
subplot(2,1,1)
plot(out.ihcout);
title('Inner Hair Cell Relative Membrane Potential (ihcout) - Simulink Model')
ylabel('Relative Potential [V]');
xlabel('Sample Number');
subplot(2,1,2)
plot(zeros(192001,1))
title('Inner Hair Cell Relative Membrane Potential (ihcout) - FPGA')
ylabel('Relative Potential [V]');
xlabel('Sample Number');


%% ERROR CALCULATION

% Performs various error calculations for Simulink Single Precision and
% FPGA-in-the-Loop Outputs (references user-created function calcerror.m)
[avgpercerror,maxpercerror,normerror] = calcerror(out.ihcout, out.ihcoutfpga);

% Adding more detailed title to function generated Error Distribution Plot
title('Percent Error Distribution - Auditory Nerve Model');

% Display in Simulink Diagnostics menu
disp('Average Percent Error =');
disp(avgpercerror);

% Display in Simulink Diagnostics menu
disp('Maximum Percent Error =');
disp(maxpercerror);

% Display in Simulink Diagnostics menu
disp('Euclidean Norm Error =');
disp(normerror);

% end of script

