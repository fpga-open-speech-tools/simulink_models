function band_edges = calculate_band_edges(ef, num_bins, binwidth, num_bands)

% Calculates the index (bin number) of each frequency band edge according 
% to the band edge frequencies, the total number of frequency bins coming 
% from the FFT, the frequency bin width, and the number of frequency bands.

for bin = 1:num_bins
    bin_freq(bin) = (bin-1)*binwidth;
end

band_edges(1,1:32) = 0;

for i = 1:num_bands-1
    band_edges(1,i) = sum(bin_freq<=ef(i+1));
end

band_edges(1,num_bands) = num_bins;

% Error Checks

if length(band_edges) ~= 32
    error('Band Edge Vector does not equal Maximum Number of Bands plus one');
end


