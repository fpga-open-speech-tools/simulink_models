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

figure()
subplot(2,1,1)
plot(ohcnonlinout);
title('OHC NL Boltzman Function Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.ohcnonlinout)
title('OHC NL Boltzman Function Output - Simulink Model')
xlabel('Sample Number');


%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
ohcnlmodelerror = norm(ohcnonlinout(1:end)-out.ohcnonlinout(1:end-1));

% Display in Simulink Diagnostics menu
disp('OHC NL Boltzman Function Model Error =');
disp(ohcnlmodelerror);

% end of script



