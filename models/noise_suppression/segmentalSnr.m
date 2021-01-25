function [snrs,r] = segmentalSnr(noisySignal, cleanSignal, windowLength)
noisySegments = reshape(noisySignal, windowLength, []).';
cleanSegments = reshape(cleanSignal, windowLength, []).';

snrs = zeros(size(noisySegments,1), 1);
for i = 1:size(noisySegments,1)
    snrs(i) = snr(cleanSegments(i,:), noisySegments(i,:) - cleanSegments(i,:));
    if isinf(snrs(i))
        snrs(i) = nan;
    end
end
snrs = abs(snrs);
r = mean(snrs, 'omitnan');
