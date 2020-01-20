% Test Filters for Simulink pFIR
%
% Author:  Justin P Williams
% Company: Flat Earth Inc.
% Date:    1/19/2020
% 
clc; close all; clear;
%% HPF Filter Design
%hpFilt = designfilt('highpassfir', ...          % Response type
%       'FilterOrder', 128, ...
%       'StopbandFrequency',85, ...             % Frequency constraints
%       'PassbandFrequency',180, ...
%       'StopbandAttenuation',30, ...            % Magnitude constraints
%       'PassbandRipple',4, ...
%       'DesignMethod','kaiserwin', ...          % Design method
%       'ScalePassband',false, ...               % Design method options
%       'SampleRate',48000);                     % Sample rate
hpFilt = designfilt('highpassfir', ...
                    'FilterOrder', 511, ...
                    'CutoffFrequency', 140, ... 
                    'SampleRate', 48000, ...
                    'DesignMethod', 'window', 'Window', 'hamming', ...
                    'ScalePassband', false);
% fvtool(hpFilt)
% xlim([0 0.6]);
% title('HPF Speech Filter');

%% LPF Filter Design
lpFilt = designfilt('lowpassfir', ...           % Response type
       'FilterOrder',511, ...                    % Filter order
       'PassbandFrequency',130, ...             % Frequency constraints
       'StopbandFrequency',180, ...
       'DesignMethod','ls', ...                 % Design method
       'PassbandWeight',1, ...                  % Design method options
       'StopbandWeight',2, ...
       'SampleRate',48000);                     % Sample rate
% fvtool(lpFilt)
% xlim([0 0.6]);
% title('LPF Speech Filter');

%% Test Chirp Signal
Fs = 48000;
Ts = 1 / Fs;

t  = 0 : Ts : 2 - Ts;

y  = chirp(t, 80, 2, 180);        % Chirp signal, frequency ranging between 80 to 180 Hz.
figure;
subplot(211);
plot(t,y); xlabel('Time [sec]'); title('Speech Signal Chirp');
subplot(212);
spectrogram(y,256,200,256,48000);   % Display the spectrogram.
xlim([0 0.5]); title('Speech Signal Chirp Spectrogram');
print('speech_chirp_signal', '-dpng');

% Filter Chirp Signal
y_hpf = filter(hpFilt.Coefficients, ones(1, 512), y);
figure;
subplot(211);
plot(t, y_hpf); xlabel('Time [sec]'); ylabel('Magnitude'); title('Filtered Speech Chirp');

subplot(212);
spectrogram(y_hpf,256,200,256,48000);   % Display the spectrogram.
xlim([0 0.5]); title('Filtered Speech Signal Chirp Spectrogram');
print('hpfFilt_speech_chirp_signal', '-dpng');


