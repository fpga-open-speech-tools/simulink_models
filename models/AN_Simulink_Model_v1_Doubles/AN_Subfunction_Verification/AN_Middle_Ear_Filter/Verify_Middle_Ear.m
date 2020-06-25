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
plot(out.mearout)
title('Middle Ear Filter Output - Simulink Model')
xlabel('Sample Number');

%% ERROR CALCULATION

% Compares output vectors of MATLAB and Simulink model outputs
modelerror = norm(mearout-out.mearout(1:end-1));

% Display in Simulink Diagnostics menu
disp('Model error = ')
disp(modelerror)

% end of script

