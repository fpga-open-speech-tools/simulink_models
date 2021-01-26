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
% Ross K. Snider, Tyler Davis
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Verify that the test data got encoded, passed through the model, and
% decoded correctly.  The input (modified by gain) and output values should be identical.

audioInputLeft  = testSignal.audio(:,1);
audioOutputLeft = createEcho(audioInputLeft,wetDryRatio,feedbackGain,echoDuration);

audioInputRight  = testSignal.audio(:,2);
audioOutputRight = createEcho(audioInputRight,wetDryRatio,feedbackGain,echoDuration);

figure(1)
subplot(2,1,1)
hold on
plot(audioInputLeft); 
plot(dataOut.Data(:,1))
plot(audioOutputLeft,'--');
hold off;
title(['Delay = ' num2str(mp.register{2}.value) '  Enable = ' num2str(mp.register{1}.value) '  Decay = ' num2str(mp.register{3}.value)  '  Wet/Dry Mix = ' num2str(mp.register{4}.value)])
legend('Input Audio','Simulink Simulation','Direct Calculation')

subplot(2,1,2)
hold on
plot(audioInputRight);
plot(dataOut.Data(:,2))
plot(audioOutputRight,'--');
hold off
title(['Delay = ' num2str(mp.register{2}.value) '  Enable = ' num2str(mp.register{1}.value) '  Decay = ' num2str(mp.register{3}.value)  '  Wet/Dry Mix = ' num2str(mp.register{4}.value)])
legend('Input Audio','Simulink Simulation','Direct Calculation')

% original_audio = [mp.test_signal.left(:) mp.test_signal.right(:)];
% processed_audio = [mp.left_data_out(:) mp.right_data_out(:)];
% soundsc(original_audio, mp.Fs);
% pause(mp.test_signal.duration*1.1);
% soundsc(processed_audio, mp.Fs);
