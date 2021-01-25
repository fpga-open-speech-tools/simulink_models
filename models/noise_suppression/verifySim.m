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
% Connor Dack
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Verify the results of the Noise Suppresion Models
% Initialize
close all;
original_audio = AudioSource.fromFile([mp.test_signals_path filesep 'sp03.wav'], mp.Fs, mp.nSamples);
noiseVariance = mp.register{2}.timeseries.Data(1);
% Calculate the MATLAB Results
[left_channel_matlab, ~]  = adaptiveWienerFilt(testSignal.audio(:,1), mp.Fs, mp.windowSize, noiseVariance);
[right_channel_matlab, ~] = adaptiveWienerFilt(testSignal.audio(:,2), mp.Fs, mp.windowSize, noiseVariance);

% Compute the SNR Metrics for the Left Channel
original_audio = original_audio.audio;
simulink_audio = double(dataOut.Data(1:mp.nSamples,1));
snr_simulink   = snr(original_audio, simulink_audio - original_audio);
disp(['SNR Simulink: ' num2str(snr_simulink)])
snr_matlab = snr(original_audio, left_channel_matlab - original_audio);
disp(['SNR MATLAB: ' num2str(snr_matlab)])

% Windowed SNR
[segmental_snr_simulink, snr_simulink_mean] = segmentalSnr(simulink_audio, original_audio, mp.windowSize);
disp(['SNR Simulink Mean: ' num2str(snr_simulink_mean)])
[segmental_snr_matlab, snr_matlab_mean] = segmentalSnr(left_channel_matlab, original_audio, mp.windowSize);
disp(['SNR MATLAB Mean: ' num2str(snr_matlab_mean)])
%% Plot the Results
% Left Channel
figure
subplot(4,1,1)
plot(original_audio)
title('Left Channel Original Input')

subplot(4,1,2)
plot(testSignal.audio(:,1));
title('Left Channel Noisy Input')

subplot(4,1,3)
plot(dataOut.Data(:,1))
hold on
plot(left_channel_matlab, '--')
title('Left Channel Filtered Results')
legend('Simulink', 'MATLAB')

subplot(4,1,4)
plot(segmental_snr_simulink)
hold on
plot(segmental_snr_matlab, '--')
title('SNR over the Window Size')
legend('Simulink', 'MATLAB')

% Right Channel
figure
subplot(3,1,1)
plot(original_audio)
title('Right Channel Original Input')

subplot(3,1,2)
plot(testSignal.audio(:,2));
title('Right Channel Noisy Input')

subplot(3,1,3)
plot(dataOut.Data(:,2))
hold on
plot(right_channel_matlab,'--')
title('Right Channel Filtered Results')
legend('Simulink', 'MATLAB')
