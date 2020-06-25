% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

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
 
figure()
subplot(2,1,1)
plot(powerLawIn);
title('Nonlinear Function Before PLA Output - MATLAB Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.powerLawIn(1:end-1))
title('Nonlinear Function Before PLA Output - Simulink Model')
xlabel('Sample Number');


%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
NLBPLAmodelerror = norm((powerLawIn(1:end))'-out.powerLawIn(1:end-1));

% Display in Simulink Diagnostics menu
disp('NL Before PLA Model Error =');
disp(NLBPLAmodelerror);

% end of script
