% mp = sm_stop_verify(mp)
%
% Matlab function that verifies the model output 

% Inputs:
%   mp, which is the model data structure that holds the model parameters
%
% Outputs:
%   mp, the model data structure that now contains the left/right channel
%   data, which is in the following format:
%          mp.left_data_out         - The processed left channel data
%          mp.left_time_out         - time of left channel data
%          mp.right_data_out        - The processed right channel data
%          mp.right_time_out        - time of right channel data
%
% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Verify that the test data got encoded, passed through the model, and
% decoded correctly.  The input (modified by gain) and output values should be identical.
close all;

left_channel_matlab = testSignal.audio(:,1) * mp.register{2}.value;
right_channel_matlab = testSignal.audio(:,2) * mp.register{2}.value;

left_error_max  = max(abs(left_channel_matlab - mp.dataOut(1, :)'));
disp(['Left Channel Max Error: ' num2str(left_error_max)]);
right_error_max = max(abs(right_channel_matlab - mp.dataOut(2, :)'));
disp(['Right Channel Max Error: ' num2str(right_error_max)]);

%% Plot the Results
figure
subplot(2,1,1)
plot(testSignal.audio(:,1)); 
title('Left Channel - Input')

subplot(2,1,2)
plot(mp.dataOut(1, :))
hold on
plot(left_channel_matlab,'--')
title(['Left Channel - Gain: ' num2str(mp.register{2}.value)])
legend('Simulink', 'MATLAB')

figure
subplot(2,1,1)
plot(testSignal.audio(:,2)); 
title('Right Channel - Input')

subplot(2,1,2)
plot(mp.dataOut(2, :))
hold on
plot(right_channel_matlab,'--')
title(['Right Channel - Gain: ' num2str(mp.register{2}.value)])
legend('Simulink', 'MATLAB')

