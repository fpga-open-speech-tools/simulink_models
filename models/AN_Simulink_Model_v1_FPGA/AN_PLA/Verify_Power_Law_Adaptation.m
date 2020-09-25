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
% Verify_Power_Law_Adaptation
% 07/24/2019

%% NOTES:

% The following script is designed to isolate and test the Power Law
% Adaptation approximation found in the model_IHC_BEZ2018.c file in order 
% to verify Simulink model functionality. Note the current implementation
% does not account for the resampling found in the Synapse function of the C
% source code.


%% CALL MATLAB FUNCTION

synout = PowerLaw(RxSignal, totalstim, randNums, Fs);


%% COMPARISON PLOT

% *** Changed PLA Simulink output name after update
% *** By Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(synout);
title('Power Law Adaptation Approximation Output - MATLAB Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.synoutdouble(1:end-1))
title('Power Law Adaptation Approximation Output - Simulink Model')
xlabel('Sample Number');

% *** Comparison Plot for Double and Single Precision Simulink Results
% *** Added by Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(out.synoutdouble);
title('Power Law Adaptation Approximation Output - Simulink Double Precision')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.synout)
title('Power Law Adaptation Approximation Output - Simulink Single Precision')
xlabel('Sample Number');


%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink Double Precision model outputs
% *** Changed output names after update by Matthew Blunt 03/03/2020
PLAmodelerror = norm(synout(1:end)-out.synoutdouble(1:end-1));

% Compares output vectors of Simulink Double and Single Precision Outputs
% *** Added by Matthew Blunt 03/03/2020
PLAconversionerror = norm(out.synoutdouble(1:end)-out.synout(1:end));

% Display in Simulink Diagnostics menu
disp('PLA Model Error =');
disp(PLAmodelerror);

% Display in Simulink Diagnostics menu
% *** Added by Matthew Blunt 03/03/2020
disp('PLA Conversion Error =');
disp(PLAconversionerror);

% Calculate Filter Error 
% *** Added by Matthew Blunt 03/10/2020
filtererror = norm(out.synout - out.synout1);

% Display Filter Error
% *** Added by Matthew Blunt 03/10/2020
disp('Filter Error = ')
disp(filtererror)

% Calculate New Structure Conversion Error 
% *** Added by Matthew Blunt 03/10/2020
newerror = norm(out.synout1 - out.synoutdouble);

% Display New Structure Conversion Error
% *** Added by Matthew Blunt 03/10/2020
disp('New Structure Conversion Error = ')
disp(newerror)

% end of script
