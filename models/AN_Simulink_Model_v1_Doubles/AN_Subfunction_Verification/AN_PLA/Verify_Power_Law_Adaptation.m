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
 
figure()
subplot(2,1,1)
plot(synout);
title('Power Law Adaptation Approximation Output - MATLAB Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.synout(1:end-1))
title('Power Law Adaptation Approximation Output - Simulink Model')
xlabel('Sample Number');


%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
PLAmodelerror = norm(synout(1:end)-out.synout(1:end-1));

% Display in Simulink Diagnostics menu
disp('PLA Model Error =');
disp(PLAmodelerror);

% end of script
