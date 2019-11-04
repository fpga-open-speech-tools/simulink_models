%% Adaptive Wiener Filter Implementation
%  Author: Justin Williams
%  Flat Earth Inc.
%  NIH Speech Enhancement Demo Research

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear all; close all;
%% Import Speech Signal and Variable Declarations
[cleanAudio, Fs] = audioread('sp03.wav');
% Fs = 16 kHz, resample to 48 kHz
cleanAudio = resample(cleanAudio, 3*Fs, Fs);
Fs = 3*Fs;

% Add noise
stddev = 0.1/6; % this makes it so the noise is approximately between [-0.05, 0.05]
noise = randn(size(cleanAudio))*stddev;
noisyAudio = cleanAudio + noise;
Ts = 1/Fs;
t = 0 : Ts : Ts * length(noisyAudio);
t = t(1:length(t)-1)';

% Plot Signal & Spectrogram
figure;
subplot(211);
plot(t, noisyAudio, '--k', 'LineWidth', 0.25);
title('Noisy Audio -- Speech Signal');
xlabel('Time [sec]');

subplot(212);
spectrogram(noisyAudio,256,240,256,Fs,'yaxis')
ylim([0, 10]); % Limit to 10 kHz (no speech above that)