function [sn, meansVect] = adaptiveWienerFilt(noisyAudio, Fs, windowSize, noiseVariance)
%%Adaptive Wiener Filter
% Author: Justin Williams
% Under:  Audio Logic
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
meansVect = zeros(winSize, 1);
for n = 1:length(noisyAudio)
    
    if n <= winSize
        win(n)    = noisyAudio(n);
        [signalAvg, signalVariance] = wienStats(win, noiseVariance);
    elseif (n > winSize && n <= (length(noisyAudio) - winSize))
        win     = noisyAudio(n - winSize + 1 : n);
        [signalAvg, signalVariance] = wienStats(win, noiseVariance);
    else
        win     = noisyAudio((n):end);
        [signalAvg, signalVariance] = wienStats(win, noiseVariance);
    end
    
    % Filter Signal
    sn(n) = signalAvg ... 
        + (signalVariance / (noiseVariance + signalVariance)) * (noisyAudio(n) - signalAvg);
    
    meansVect(n) = signalAvg;
    
    % Account for any nans / divide by zeros
    if (isnan(sn(n)))
        sn(n) = 0;
    end
end
                
%% Calculate Stats 
function [signalAvg, signalVariance] = wienStats(win, noiseVariance)
%%This function calculates the statistics of the current window within a
%%function, including the mean, standard deviation, and noise power.
signalAvg = mean(win);
windowVariance = var(win);
    if windowVariance > noiseVariance
        signalVariance = windowVariance - noiseVariance;
    else 
        signalVariance = 0;
    end
end
end