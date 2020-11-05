function band_sizes = calculate_band_sizes(ef, num_bins, binwidth, num_bands)

% Calculates the size of each frequency band according the band edge
% frequencies, the total number of frequency bins coming from the FFT,
% the frequency bin width, and the number of frequency bands.

for bin = 1:num_bins
    bin_freq(bin) = (bin-1)*binwidth;
end

for i = 1:num_bands
    band_sizes(1,i) = sum(bin_freq>ef(i) & bin_freq<=ef(i+1));
end

band_sizes(1) = band_sizes(1) + 1;

% Error Checks

if length(band_sizes) ~= num_bands
    error('Band Size Vector does not equal Number of Bands');
end

if sum(band_sizes == 0) > 0
    error('There is a band containing no frequency bins. Band size must be increased of FFT length increased.');
end

