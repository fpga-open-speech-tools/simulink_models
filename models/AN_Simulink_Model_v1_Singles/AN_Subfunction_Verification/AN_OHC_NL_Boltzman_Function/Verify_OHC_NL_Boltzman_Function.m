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
% Verify_OHC_NL_Boltzman_Function
% 06/26/2019

%% NOTES

% The following script is designed to isolate and test the get OHC NL
% Boltzman function found in the model_IHC_BEZ2018.c file in order to 
% verify Simulink model functionality

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex Boltzman.c

%% CALL C FUNCTION

for n = 0:length(RxSignal)-1
    ohcnonlinout(n+1,1) = Boltzman(RxSignal(n+1,1), ohcasym, s0, s1, x1);
end

%% COMPARISON PLOT

% *** Changed OHC NL Boltzman Simulink output name after update
% *** By Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(ohcnonlinout);
title('OHC NL Boltzman Function Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ohcnonlinoutdouble)
title('OHC NL Boltzman Function Output - Simulink Model')
xlabel('Sample Number');

% *** Comparison Plot for Double and Single Precision Simulink Results
% *** Added by Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(out.ohcnonlinoutdouble);
title('OHC NL Boltzman Function Output - Simulink Double Precision')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ohcnonlinout)
title('OHC NL Boltzman Function Output - Simulink Single Precision')
xlabel('Sample Number');


%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink Double Precision model outputs
% *** Changed output names after update by Matthew Blunt 03/03/2020
ohcnlmodelerror = norm(ohcnonlinout(1:end)-out.ohcnonlinout(1:end-1));

% Compares output vectors of Simulink Double and Single Precision Outputs
% *** Added by Matthew Blunt 03/03/2020
ohcnlconversionerror = norm(out.ohcnonlinoutdouble(1:end)-out.ohcnonlinout(1:end));

% Display in Simulink Diagnostics menu
disp('OHC NL Boltzman Function Model Error =');
disp(ohcnlmodelerror);

% Display in Simulink Diagnostics menu
% *** Added by Matthew Blunt 03/03/2020
disp('OHC NL Boltzman Function Conversion Error =');
disp(ohcnlconversionerror);

% end of script



