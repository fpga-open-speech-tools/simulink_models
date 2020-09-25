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

% *** Changed Simulink output name after update
% *** By Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(vihctmp);
title('IHC NL Logarithmic Function Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.vihctmpdouble)
title('IHC NL Logarithmic Function Output - Simulink Model')
xlabel('Sample Number');

% *** Comparison Plot for Double and Single Precision Simulink Results
% *** Added by Matthew Blunt 03/03/2020
figure()
subplot(2,1,1)
plot(out.vihctmpdouble);
title('IHC NL Logarithmic Function Output - Simulink Double Precision')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.vihctmp)
title('IHC NL Logarithmic Function Output - Simulink Single Precision')
xlabel('Sample Number');


%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink Double Precision model outputs
% *** Changed output names after update by Matthew Blunt 03/03/2020
ihcnlmodelerror = norm(vihctmp(1:end)-out.vihctmpdouble(1:end-1));

% Compares output vectors of Simulink Double and Single Precision Outputs
% *** Added by Matthew Blunt 03/03/2020
ihcnlconversionerror = norm(out.vihctmpdouble(1:end)-out.vihctmp(1:end));

% Display in Simulink Diagnostics menu
disp('IHC NL Logarithmic Function Model Error =');
disp(ihcnlmodelerror);

% Display in Simulink Diagnostics menu
% *** Added by Matthew Blunt 03/03/2020
disp('IHC NL Logarithmic Function Conversion Error =');
disp(ihcnlconversionerror);

% end of script