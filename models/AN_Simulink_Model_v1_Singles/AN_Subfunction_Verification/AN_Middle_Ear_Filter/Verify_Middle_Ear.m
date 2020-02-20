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
% Verify_Middle_Ear
% 06/26/2019

%% NOTES

% The following script is designed as the stop function script for the
% Middle Ear Filter Simulink model. 

%% CALL MATLAB FUNCTION

% Call Middle_Ear MATLAB function with RxSignal input, found in the
% workspace from the Middle Ear Filter Model init script
mearout = (Middle_Ear(RxSignal,Fs,tdres))';

%% COMPARISON PLOT

figure()
subplot(2,1,1)
plot(mearout);
title('Middle Ear Filter Output - Source Code')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.mearoutdouble)
title('Middle Ear Filter Output - Simulink Model Double Precision')
xlabel('Sample Number');


% *** Figure added for test/verification of double to single precision
% *** Added by Matthew Blunt 02/13/2020
figure()
subplot(2,1,1)
plot(out.mearoutdouble);
title('Simulink Middle Ear Filter Output - Double Precision')
xlabel('Sample Number');
subplot(2,1,2)
plot(out.mearout)
title('Simulink Middle Ear Filter Output - Single Precision')
xlabel('Sample Number');

%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink Double model outputs
% *** Modified for new output vector names Matthew Blunt 02/13/2020
modelerror = norm(mearout-out.mearoutdouble(1:end-1));

% Compares output vectors of Simulink single precision to double precision
% outputs
% *** Added by Matthew Blunt 02/13/2020
conversionerror = norm(out.mearout-out.mearoutdouble);

% Display Model Error in Simulink Diagnostics menu
disp('Model error = ')
disp(modelerror)

% Display Conversion Error in Simulink Diagnostics menu
% *** Added by Matthew Blunt 02/13/2020
disp('Conversion error = ')
disp(conversionerror)

% end of script

