function r = segmentalSnr(noisySignal, cleanSignal, windowLength)
noisySegments = reshape(noisySignal, windowLength, []).';
cleanSegments = reshape(cleanSignal, windowLength, []).';

snrs = zeros(length(noisySegments), 1);
for i = 1:length(noisySegments)
    snrs(i) = snr(cleanSegments(i,:), noisySegments(i,:) - cleanSegments(i,:));
    if isinf(snrs(i))
        snrs(i) = nan;
    end
end

r = mean(snrs, 'omitnan');
