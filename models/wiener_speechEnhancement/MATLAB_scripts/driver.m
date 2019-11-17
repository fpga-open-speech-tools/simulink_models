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

%% Driver
wins = [2e-3 1.5e-3 1e-3 0.5e-3];
sn   = zeros(4, length(noisyAudio));

for j = 1:4
    sn(j,:) = adaptiveWienerFilt(noisyAudio, Fs, wins(j));
end
%% Plot signals with respect to different windows
t = t';
figure;
subplot(411);
plot(t, sn(1,:))
xlabel('Time');
title('Filtered Signal - Win == 2ms');

subplot(412);
plot(t, sn(2,:))
xlabel('Time');
title('Filtered Signal - Win == 1.5ms');

subplot(413);
plot(t, sn(3,:))
xlabel('Time');
title('Filtered Signal - Win == 1ms');

subplot(414);
plot(t, sn(4,:))
xlabel('Time');
title('Filtered Signal - Win == 0.5ms');