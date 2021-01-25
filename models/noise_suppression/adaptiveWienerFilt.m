function [sn, means] = adaptiveWienerFilt(noisyAudio, Fs, windowSize, noiseVariance)
%% Adaptive Wiener Filter
% Author: Justin Williams
% Under:  AudioLogic, Inc
%         Frost Examples
%
% This function imeplements an adaptive wiener filter that attenuates white
% noise by using sample-based statistical approximation. It uses a
% look-behind window to keep track of statistical variance and means to
% estimate the SNR(?) and filters the signal sample-by-sample.
%
% Inputs:
%           noisyAudio  - Noisy speech signal
%           Fs          - Sample rate
%           windowSize  - Size of Window [0 5] ms
% Outputs:
%           sn          - Filtered Output Signal
%% Calculations
Ts = 1 / Fs;
sn = zeros(length(noisyAudio),1 );
win = zeros(windowSize,1);        % Init look-behind-window
means = zeros(ceil(length(noisyAudio)/windowSize), 1);
meansExponential = zeros(ceil(length(noisyAudio)/windowSize), 1);
varExponential = zeros(ceil(length(noisyAudio)/windowSize), 1);
exponentialWeight = 2/(windowSize + 1);
for n = 1:length(noisyAudio)
    
    if n <= windowSize
        win(n)    = noisyAudio(n);
        [signalAvg, signalVariance] = wienStats(win, noiseVariance);
    elseif (n > windowSize && n <= (length(noisyAudio) - windowSize))
        win     = noisyAudio(n - windowSize + 1 : n);
        [signalAvg, signalVariance] = wienStats(win, noiseVariance);
    else
        win     = noisyAudio((n):end);
        [signalAvg, signalVariance] = wienStats(win, noiseVariance);
    end
    
    if n > 1
        meansExponential(n) = meansExponential(n-1) + exponentialWeight * (noisyAudio(n) - meansExponential(n-1));
        varExponential(n) = (1 - exponentialWeight) * (varExponential(n-1) + exponentialWeight * (noisyAudio(n) - meansExponential(n-1)).^2);
    else
        meansExponential(n) = noisyAudio(n);
    end
    
    % Filter Signal
    sn(n) = signalAvg ... 
        + (signalVariance / (noiseVariance + signalVariance)) * (noisyAudio(n) - signalAvg);
    
    means(n) = signalAvg;
    vars(n) = signalVariance;
    
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