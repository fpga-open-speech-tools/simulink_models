%% Justin Williams
%  Flat Earth Inc.
%  Wiener FIlter Implementation
clc; clear; close all;
%11;45
%% Import speech signal
[cleanAudio, Fs] = audioread('sp03.wav');

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
sigma_s2 = 0;
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

%% Questions for Trevor
% 1. I need to calculate ms(n) and sigma2s(n)
% 2. the "hats" denote a short segment signal calculation, what about the
% non-hats variables?
% 3. Unsure how to go from a short segment calculation to a
% sample-by-sample time-domain
% 4. Is it just a system that takes short_segment-by-short_segment and
% updates each sample within the individual shortsegment and then it
% recalculates everything?
%%%%%%%%%%%%%%%%%%%%%%
% The summations for the statistical estimators are looking behind a
% certain distance with the length of the user defined window. the current
% sample is then updated based on the estimated variables from the window
% as you move forward. The stationary signal has more to do with
% probability. I still don't get it. 
%
% White noise => Stationary
% Speech      => Non-stationary
%
% Short speech segments are assumed to be stationary 
% This is a model assumption for the wiener filter

