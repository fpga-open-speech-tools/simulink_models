% Test Filters for Simulink pFIR
%
% Author:  Justin P Williams
% Company: Flat Earth Inc.
% Date:    1/19/2020
% 

% This script is targeting the design of sample HPF and LPF FIR filters
% that can be used in a testing scenario using the designed programmable
% FIR filter created by E. Bailey Galacci and I. The intent is to start
% with using the static FIR filter, then load in several filters into
% memory and switch between batches of coefficients stored in memory. 

clc; close all; clear;

%% Global Variable Declaration
W_bits = 32;            % Word length
F_bits = 16;            % Fractional length
Fs     = 48000;
Ts     = 1/Fs;
t      = 0 : Ts : 2;    % Signal duration

%% HPF Filter Design
% This section designs a 512-order FIR filter with cutoff frequency of 140
% Hz. The filter coefficients are then represented using an unsigned
% fixed-point number system. 

hpFilt = designfilt('highpassfir', ...
                        'FilterOrder', 511, ...
                        'CutoffFrequency', 140, ... 
                        'SampleRate', Fs, ...
                        'DesignMethod', 'window', 'Window', 'hamming', ...
                        'ScalePassband', false);
hpFiltFi = ufi(hpFilt.Coefficients, W_bits, F_bits);
%% LPF Filter Design
% This section designs a 128-order FIR filter with cutoff frequency of 140
% Hz. The filter coefficients are then represented using an unsigned
% fixed-point number system.

lpFilt = designfilt('lowpassfir', ...                           % Response type
                       'FilterOrder',511, ...                   % Filter order
                       'PassbandFrequency',130, ...             % Frequency constraints
                       'StopbandFrequency',180, ...
                       'DesignMethod','ls', ...                 % Design method
                       'PassbandWeight',1, ...                  % Design method options
                       'StopbandWeight',2, ...
                       'SampleRate',Fs);                        % Sample rate
lpFiltFi = ufi(lpFilt.Coefficients, W_bits, F_bits);

%% Test Chirp Signal
%  This section lays out the chirp signal. The chirp signal was decided to
%  be between 80 - 180 Hz, where 80 Hz is representative of a male with a
%  "low-pitched" voice and 180 Hz is representative of a female with a
%  "high-pitched" voice. 

% Chirp signal, frequency ranging between 80 to 180 Hz.
y  = chirp(t, 80, 2, 180);
figure;
subplot(211);
plot(t,y); xlabel('Time [sec]'); title('Speech Signal Chirp');

subplot(212);
spectrogram(y,8192,7800,8192,Fs, 'yaxis');   % Display the spectrogram.
ylim([0 0.3]); 
title('Speech Signal Chirp Spectrogram');
print('speech_chirp_signal', '-dpng');

% --------------------------------------------------------

% HPF Filtered Chirp Signal
y_hpf = filter(hpFilt.Coefficients, ones(1, 1), y);
figure;
subplot(211);
plot(t, y_hpf); xlabel('Time [sec]'); ylabel('Magnitude'); title('Filtered Speech Chirp');

subplot(212);
spectrogram(y_hpf,8192,7800,8192,Fs, 'yaxis');
ylim([0 0.3]); 
title('HPF Filtered Speech Signal Chirp Spectrogram');
print('hpfFilt_speech_chirp_signal', '-dpng');

% --------------------------------------------------------

% LPF Filtered Chirp Signal
y_lpf = filter(lpFilt.Coefficients, ones(1, 1), y);
figure; 
subplot(211);
plot(t, y_lpf); xlabel('Time [sec]'); ylabel('Magnitude'); title('Filtered Speech Chirp');

subplot(212);
spectrogram(y_lpf,8192,7800,8192,Fs, 'yaxis');
ylim([0 0.3]);  
title('LPF Filtered Speech Signal Chirp Spectrogram');
print('lpfFilt_speech_chirp_signal', '-dpng');


