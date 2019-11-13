function [sn] = adaptiveWienerFilt(noisyAudio, Fs, windowSize)
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
%           Fs          - Sample rate
%           windowSize  - Size of Window [0 5] ms
% Outputs:
%           sn          - Filtered Output Signal

Ts = 1 / Fs;
sn = zeros(length(noisyAudio),1 );
winSize = round(windowSize / Ts);
win = zeros(winSize,1);        % Init look-behind-window

for n = 1:length(noisyAudio)
    
    if n <= winSize
        win(n)    = noisyAudio(n);
        [winMean, winSTD, winNoise] = wienStats(win);
    elseif (n > winSize & n <= (length(noisyAudio) - winSize))
        win     = noisyAudio((n-winSize/2):(n+winSize/2 - 1));
        [winMean, winSTD, winNoise] = wienStats(win);
    else
        win     = noisyAudio((n):end);
        [winMean, winSTD, winNoise] = wienStats(win);
    end
    % Filter Signal
    sn(n) = winMean + winNoise / (winNoise + winSTD) *  ... 
        (noisyAudio(n) - winMean);
    
    % Account for any nans / divide by zeros
    if (sn(n) == nan)
        sn(n) = 0;
    end
end

                
%% Calculate Stats 
    function [winMean, winSTD, winNoise] = wienStats(win)
    %%This function calculates the statistics of the current window within a
    %%function, including the mean, standard deviation, and noise power.
    winMean = mean(win);
    winSTD  = std(win);
    winNoisePow = 1 / length(win) * sum((win - winMean)).^2;
        if winNoisePow > winSTD
            winNoise = winNoisePow - winSTD;
        else 
            winNoise = 0;
        end % end if
    end % end fcn


end