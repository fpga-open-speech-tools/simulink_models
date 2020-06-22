%% Adaptive Wiener Filter Implementation
%  Author: Justin Williams
%  Flat Earth Inc.
%  NIH Speech Enhancement Demo Research

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clc; clear all; close all;
%% Import Speech Signal and Variable Declarations
[originalAudio, Fs] = audioread('sp03.wav');
% Fs = 16 kHz, resample to 48 kHz
originalAudio = resample(originalAudio, 3*Fs, Fs);
Fs = 3*Fs;

% Ensure that the signal is an integer multiple of the sampling period
newLength = ceil(length(originalAudio)/Fs) * Fs;
cleanAudio = zeros(newLength, 1);
cleanAudio(1:length(originalAudio)) = originalAudio;

% Add noise
stddev = 0.3/6;
noiseVariance = stddev^2; 
noise = randn(size(cleanAudio))*stddev;
noisyAudio = cleanAudio + noise;
Ts = 1/Fs;
t = 0 : Ts : Ts * length(noisyAudio);
t = t(1:length(t)-1)';

snrOriginal = snr(cleanAudio, noisyAudio - cleanAudio);

%% Driver
wins = [20e-3 15e-3 10e-3 5e-3 2e-3];
sn   = zeros(length(cleanAudio), length(wins));
snrEstimatedSignal = zeros(length(wins), 1);
segmentalSnrEstimatedSignal = zeros(length(wins), 1);


for j = 1:length(wins)
    sn(:, j) = adaptiveWienerFilt(noisyAudio, Fs, wins(j), noiseVariance);
    snrEstimatedSignal(j) = snr(cleanAudio, sn(:, j) - cleanAudio);
    segmentalSnrEstimatedSignal(j) = segmentalSnr(sn(:,j), cleanAudio, 15e-3*Fs);
end
%% Plot signals with respect to different windows
% t = t';
% figure;
% subplot(411);
% plot(t, sn(1,:))
% xlabel('Time');
% title(['Filtered Signal - Win == ', num2str(wins(1)), ' seconds']);
% 
% subplot(412);
% plot(t, sn(2,:))
% xlabel('Time');
% title(['Filtered Signal - Win == ', num2str(wins(2)), ' seconds']);
% 
% subplot(413);
% plot(t, sn(3,:))
% xlabel('Time');
% title(['Filtered Signal - Win == ', num2str(wins(3)), ' seconds']);
% 
% subplot(414);
% plot(t, sn(4,:))
% xlabel('Time');
% title(['Filtered Signal - Win == ', num2str(wins(4)), ' seconds']);