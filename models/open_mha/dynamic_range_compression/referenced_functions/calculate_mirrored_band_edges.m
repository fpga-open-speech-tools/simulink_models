function mirrored_band_edges = calculate_mirrored_band_edges(band_sizes, FFTsize, num_bins, num_bands)

% Calculates the index (bin number) of each mirrored frequency band edge 
% according to the band sizes, the total number of frequency bins 
% coming from the FFT, and the number of frequency bands.

current_bin = num_bins-1;

for i = 1:num_bands-1
    if i == 1
        mirrored_band_edges(1,i) = current_bin + band_sizes(end+1-i) - 1;
        current_bin = current_bin + band_sizes(1,end+1-i) - 1;
    else
        mirrored_band_edges(1,i) = current_bin + band_sizes(end+1-i);
        current_bin = current_bin + band_sizes(1,end+1-i);
    end
end

mirrored_band_edges(1,num_bands) = FFTsize-1;
mirrored_band_edges = fliplr(mirrored_band_edges);
if num_bands < 32
    mirrored_band_edges(1,num_bands+1:32) = 0;
end

% Error Checks

if length(mirrored_band_edges) ~= 32
    error('Mirrored Band Edge Vector does not equal Maximum Number of Bands');
end
