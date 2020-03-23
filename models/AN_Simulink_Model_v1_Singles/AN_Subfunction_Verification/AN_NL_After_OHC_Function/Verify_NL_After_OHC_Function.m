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
% Verify_NL_After_OHC_Function
% 06/27/2019

%% NOTES

% The following script is designed to isolate and test the get NL after 
% OHC function found in the model_IHC_BEZ2018.c file in order to 
% verify Simulink model functionality

%% COMPILE MEX WRAPPER

% Compiles MEX wrapper so C function can be called from MATLAB
mex NLafterohc.c

%% CALL C FUNCTION

for n = 0:length(RxSignal)-1
    tmptauc1(n+1,1) = NLafterohc(RxSignal(n+1,1), taumin, taumax, ohcasym);
end


%% COMPARISON PLOT

% *** Changed NL After OHC Simulink output name after update
% *** By Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(tmptauc1);
title('NL After OHC Function Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.tmptauc1double)
title('NL After OHC Function Output - Simulink Model')
xlabel('Sample Number');

% *** Comparison Plot for Double and Single Precision Simulink Results
% *** Added by Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(tmptauc1);
title('NL After OHC Function Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.tmptauc1)
title('NL After OHC Function Output - Simulink Model')
xlabel('Sample Number');


%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink Double Precision model outputs
% *** Changed output names after update by Matthew Blunt 03/03/2020
nlaohcmodelerror = norm(tmptauc1(1:end)-out.tmptauc1double(1:end-1));

% Compares output vectors of Simulink Double and Single Precision Outputs
% *** Added by Matthew Blunt 03/03/2020
nlaohcconversionerror = norm(tmptauc1(1:end)-out.tmptauc1double(1:end-1));

% Display in Simulink Diagnostics menu
disp('NL After OHC Function Model Error =');
disp(nlaohcmodelerror);

% Display in Simulink Diagnostics menu
% *** Added by Matthew Blunt 03/03/2020
disp('NL After OHC Function Conversion Error =');
disp(nlaohcconversionerror);

% end of script

