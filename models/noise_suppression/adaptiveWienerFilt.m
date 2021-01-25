function [sn, means] = adaptiveWienerFilt(noisyAudio, windowSize, noiseVariance)
%% Adaptive Wiener Filter
% Author: Justin Williams, Trevor Vannoy
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
%           windowSize  - Size of Window in samples
% Outputs:
%           sn          - Filtered Output Signal
%% Calculations
sn = zeros(length(noisyAudio),1 );
means = zeros(ceil(length(noisyAudio)/windowSize), 1);
signalAvg = zeros(ceil(length(noisyAudio)/windowSize), 1);
signalVariance = zeros(ceil(length(noisyAudio)/windowSize), 1);
exponentialWeight = 2/(windowSize + 1);
for n = 1:length(noisyAudio)
    if n > 1
        signalAvg(n) = signalAvg(n-1) + exponentialWeight * (noisyAudio(n) - signalAvg(n-1));
        signalVariance(n) = (1 - exponentialWeight) * (signalVariance(n-1) + exponentialWeight * (noisyAudio(n) - signalAvg(n-1)).^2);
    else
        signalAvg(n) = noisyAudio(n);
    end
    
    % Filter Signal
    sn(n) = signalAvg(n) ... 
        + (signalVariance(n) / (noiseVariance + signalVariance(n))) * (noisyAudio(n) - signalAvg(n));
    
    
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