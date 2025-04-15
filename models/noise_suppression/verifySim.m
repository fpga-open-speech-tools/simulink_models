% mp = sm_stop_verify(mp)
%
% Matlab function that verifies the model output 

% Inputs:
%   mp
%
% Outputs:
%   mp

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
original_audio = AudioSource.fromFile([mp.test_signals_path filesep 'sp03.wav'], mp.Fs, mp.nSamples, mp.audio_dt);
noiseVariance = mp.register{2}.timeseries.Data(1);
% Calculate the MATLAB Results
left_channel_matlab  = adaptiveWienerFilt(testSignal.audio(:,1), mp.windowSize, noiseVariance);
right_channel_matlab = adaptiveWienerFilt(testSignal.audio(:,2), mp.windowSize, noiseVariance);

% Compute the SNR Metrics for the Left Channel
original_audio = original_audio.audio;
simulink_audio_left = double(dataOut.Data(1:mp.nSamples,1));
snr_simulink_left   = snr(original_audio, simulink_audio_left - original_audio);
disp(['SNR Left Channel Simulink: ' num2str(snr_simulink_left)])
snr_matlab_left = snr(original_audio, left_channel_matlab - original_audio);
disp(['SNR Left Channel MATLAB: ' num2str(snr_matlab_left)])

% Windowed SNR
[segmental_snr_simulink_left, snr_simulink_mean_left] = segmentalSnr(simulink_audio_left, original_audio, mp.windowSize);
disp(['SNR Left Channel Simulink Mean: ' num2str(snr_simulink_mean_left)])
[segmental_snr_matlab_left, snr_matlab_mean_left] = segmentalSnr(left_channel_matlab, original_audio, mp.windowSize);
disp(['SNR Left Channel MATLAB Mean: ' num2str(snr_matlab_mean_left)])
disp(' ');


% Compute the SNR Metrics for the Right Channel
simulink_audio_right = double(dataOut.Data(1:mp.nSamples,1));
snr_simulink_right   = snr(original_audio, simulink_audio_right - original_audio);
disp(['SNR Right Channel Simulink: ' num2str(snr_simulink_right)])
snr_matlab_right = snr(original_audio, right_channel_matlab - original_audio);
disp(['SNR Right Channel MATLAB: ' num2str(snr_matlab_right)])

% Windowed SNR
[segmental_snr_simulink_right, snr_simulink_mean_right] = segmentalSnr(simulink_audio_right, original_audio, mp.windowSize);
disp(['SNR Right Channel Simulink Mean: ' num2str(snr_simulink_mean_right)])
[segmental_snr_matlab_right, snr_matlab_mean_right] = segmentalSnr(right_channel_matlab, original_audio, mp.windowSize);
disp(['SNR Right Channel MATLAB Mean: ' num2str(snr_matlab_mean_right)])

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
plot(segmental_snr_simulink_left)
hold on
plot(segmental_snr_matlab_left, '--')
title('SNR over the Window Size')
legend('Simulink', 'MATLAB')

% Right Channel
figure
subplot(4,1,1)
plot(original_audio)
title('Right Channel Original Input')

subplot(4,1,2)
plot(testSignal.audio(:,2));
title('Right Channel Noisy Input')

subplot(4,1,3)
plot(dataOut.Data(:,2))
hold on
plot(right_channel_matlab,'--')
title('Right Channel Filtered Results')
legend('Simulink', 'MATLAB')

subplot(4,1,4)
plot(segmental_snr_simulink_right)
hold on
plot(segmental_snr_matlab_right, '--')
title('SNR over the Window Size')
legend('Simulink', 'MATLAB')