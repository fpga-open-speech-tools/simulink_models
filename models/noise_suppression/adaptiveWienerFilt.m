function sn = adaptiveWienerFilt(noisyAudio, windowSize, noiseVariance)
%% Adaptive Wiener Filter
% Author: Justin Williams, Trevor Vannoy
% Under:  AudioLogic, Inc
%         Frost Examples
%
% This function imeplements an adaptive wiener filter that attenuates white
% noise by using sample-based statistical approximation. The implementation 
% is based off of https://link.springer.com/article/10.1007/s10772-013-9205-5)
%
% Inputs:
%           noisyAudio  - Noisy speech signal
%           Fs          - Sample rate
%           windowSize  - Size of Window in samples
% Outputs:
%           sn          - Filtered Output Signal
%% Calculations
sn = zeros(length(noisyAudio),1 );
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