function [sn] = adaptiveWienerFilt(noisyAudio, windowSize)
%%Adaptive Wiener Filter
% Author: Justin Williams
% Under:  Flat Earth Inc
% NIH Speech Enhancement Research
%
%%This function imeplements an adaptive wiener filter that attenuates white
%%noise by using sample-based statistical approximation. It uses a
%%look-behind window to keep track of statistical variance and means to
%%estimate the SNR(?) and filters the signal sample-by-sample.
%
% Inputs:
%           noisyAudio  - Noisy speech signal
%           windowSize  - Size of Window [0 20] ms
% Outputs:
%           sn          - Filtered Output Signal
[~, Fs] = audioread('sp03.wav');

% Init Sound File
Ts = 1 / Fs;
t  = 0 : Ts : length(noisyAudio)*Ts;
t  = t(1:(end-1))';
sn = zeros(length(noisyAudio),1 );
winSize = windowSize / Ts;
lkBehindWin = zeros(1, winSize);        % Init look-behind-window

% Plot Signal & Spectrogram
figure;
subplot(211);
plot(t, noisyAudio, '--k', 'LineWidth', 0.25);
title('Noisy Audio -- Speech Signal');
xlabel('Time [sec]');

subplot(212);
spectrogram(noisyAudio,256,240,256,Fs,'yaxis')
ylim([0, 10]); % Limit to 10 kHz (no speech above that)

% begin Filter Process
for n = 1:length(noisyAudio)
    if n <= winSize
        lkWinMean   = mean(lkBehindWin);
        lkWinSTD    = std(lkBehindWin);
        winNoisePow = 1 / winSize * (sum((lkBehindWin - lkWinMean).^2));
        
        % Filter Based on Non-full lkBehindWin
        if winNoisePow > lkWinSTD
            winNoise = winNoisePow - lkWinSTD;
        else
            winNoise = 0;
        end
        
        sn(n) = lkWinMean + winNoise / (winNoise + lkWinSTD) *  ... 
                (noisyAudio(n) - lkWinMean);
    else
        curWin      = lkBehindWin((n - winSize):(n + winSize));
        lkWinMean   = mean(curWin);
        lkWinSTD    = std(curWin);
        winNoisePow = 1 / winSize * (sum((curWin - lkWinMean).^2));
        if winNoisePow > lkWinSTD
            winNoise = winNoisePow - lkWinSTD;
        else 
            winNoise = 0;
        end
        
        % Filter Signal
        sn(n) = lkWinMean + winNoise / (winNoise + lkWinSTD) *  ... 
                (noisyAudio(n) - lkWinMean);
        
        
    end
end




% % Initial Window
% sn  = zeros(length(noisyAudio), 1);  % Filtered Audio Output
% M   = 1/2*16e-3/Ts; % 16 ms window 
% msn = 2*M + 1;   % Num samples in short segment
% % Grab a window, estimate stats
% msWin    = noisyAudio(1:M);
% segMean  = mean(msWin);     % Local mean of stationary noisyAudio
% sigma_x  = std(msWin);      % Local STD of stationary noisyAudio
% %sigpow   = sigma_x^2;       % Signal Noise Power Estimate 
% sigma_x2 = 1/msn .* (sum((msWin-segMean).^2));
% if (sigma_x2 > sigma_x)
%     sigma_s2 = sigma_x2 - sigpow;
% else 
%     sigma_s2 = 0;
% end 
% cnt = 1; 
% for n = (M + 1) : length(noisyAudio)
%     if cnt == 1
%         sn(n) = segMean + sigma_s2/(sigma_s2 + sigma_x)*(noisyAudio(n) - segMean);
%         cnt = 0;
%     else 
%         % Update window stats
%         if (n+M)>(length(noisyAudio))
%             msWin = noisyAudio((n-M):end);
%         else
%             msWin = noisyAudio((n-M):(n+M));
%         end 
%         segMean = mean(msWin);
%         sigma_x = std(msWin);
%         %sigpow  = sigma_x^2;
%         sigma_x2 = 1 / msn * (sum((msWin - segMean).^2));
%         if sigma_x2 > sigma_x
%             sigma_s2 = sigma_x2 - sigma_x;
%         else 
%             sigma_s2 = 0;
%         end
%         % Clean up Speech
%         sn(n) = segMean + sigma_s2/(sigma_s2 + sigma_x)*(noisyAudio(n) - segMean);
% 
%     end
%     
% end


end