%% Justin Williams
%  Flat Earth Inc.
%  Wiener FIlter Implementation
clc; clear; close all;
%% Import speech signal
[cleanAudio, Fs] = audioread('sp03.wav');
cleanAudio = resample(cleanAudio, 3*Fs, Fs);
Fs = 3*Fs;
%% Add noise
stddev = 0.1/6; % this makes it so the noise is approximately between [-0.05, 0.05]
noise = randn(size(cleanAudio))*stddev;
noisyAudio = cleanAudio + noise;
Ts = 1/Fs;
t = 0 : Ts : Ts * length(noisyAudio);
t = t(1:length(t)-1)';


%% Adaptive Wiener

% Initial Window
sn  = zeros(length(noisyAudio), 1);  % Filtered Audio Output
M   = 1/2*16e-3/Ts; % 16 ms window 
msn = 2*M + 1;   % Num samples in short segment
% Grab a window, estimate stats
msWin    = noisyAudio(1:M);
segMean  = mean(msWin);     % Local mean of stationary noisyAudio
sigma_x  = std(msWin);      % Local STD of stationary noisyAudio
%sigpow   = sigma_x^2;       % Signal Noise Power Estimate 
sigma_x2 = 1/msn .* (sum((msWin-segMean).^2));
if (sigma_x2 > sigma_x)
    sigma_s2 = sigma_x2 - sigpow;
else 
    sigma_s2 = 0;
end 
cnt = 1; 
for n = (M + 1) : length(noisyAudio)
    if cnt == 1
        sn(n) = segMean + sigma_s2/(sigma_s2 + sigma_x)*(noisyAudio(n) - segMean);
        cnt = 0;
    else 
        % Update window stats
        if (n+M)>(length(noisyAudio))
            msWin = noisyAudio((n-M):end);
        else
            msWin = noisyAudio((n-M):(n+M));
        end 
        segMean = mean(msWin);
        sigma_x = std(msWin);
        %sigpow  = sigma_x^2;
        sigma_x2 = 1 / msn * (sum((msWin - segMean).^2));
        if sigma_x2 > sigma_x
            sigma_s2 = sigma_x2 - sigma_x;
        else 
            sigma_s2 = 0;
        end
        % Clean up Speech
        sn(n) = segMean + sigma_s2/(sigma_s2 + sigma_x)*(noisyAudio(n) - segMean);

    end
    
end

%% Plot Results

figure(1);
subplot(311);
plot(t, cleanAudio, '--k', 'LineWidth', 0.5);
xlabel('time [sec]');
title('Clean Audio Speech Signal');
subplot(312);
plot(t, noisyAudio, '--k', 'LineWidth', 0.5);
xlabel('Time [sec]');
title('Noisy Speech');
subplot(313);
plot(t, sn, '--k', 'LineWidth', 0.5);
xlabel('time [sec]');
title('Filtered Audio Signal');

%% Spectrograms
figure(2);
% subplot(211);
% spectrogram(cleanAudio, 'yaxis');
% title('Frequency Content - Clean Audio');
subplot(211);
plot(t, sn, '--k', 'LineWidth', 0.5);
xlabel('time [sec]');
title('Filtered Audio Signal');
subplot(212);
spectrogram(sn,256,240,256,Fs,'yaxis')
ylim([0 10]); 
title('Frequency Content - Sn');
colormap winter;

%% HPF LPF FIlter
flag = 'scale';  % Sampling Flag

% LPF
% ------------
N1    = 128;      % Order
Fc1   = 10000;    % Cutoff Frequency

% Create the window vector for the design algorithm.
win1 = hann(N1+1);

% Calculate the coefficients using the FIR1 function.
b1  = fir1(N1, Fc1/(Fs/2), 'low', win1, flag);
Hd1 = dfilt.dffir(b1);

% HPF 
% ------------
N2    = 1024;     % Order
Fc2   = 100;      % Cutoff Frequency

% Create the window vector for the design algorithm.
win2 = hann(N2+1);

% Calculate the coefficients using the FIR1 function.
b2  = fir1(N2, Fc2/(Fs/2), 'high', win2, flag);
Hd2 = dfilt.dffir(b2);

% Filter sn
snLow = filter(b1, 1, sn);
snHi  = filter(b2, 1, sn);
snNew = snLow + snHi;

figure;
subplot(211);
plot(t, sn, '--k', 'LineWidth', 0.5);
xlabel('time [sec]');
title('Filtere Signal (Wiener Output)');

subplot(212);
plot(t, snNew, '--k', 'LineWidth', 0.5);
xlabel('time [sec]');
title('Filtered Signal (Wiener + Bandpass)');

figure;
spectrogram(snNew,256,240,256,Fs,'yaxis')
% ylim([0 10]); 
title('Frequency Content - Sn');
colormap winter;
