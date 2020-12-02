% Matthew Blunt
% openMHA FFT Input Signal Unit Conversion Script
% 10/19/2020

% Created to quickly calculate linear factors and dB values
% according to an FFT data real/imaginary value and number of bins in 
% the band

function [Pa2val,dBval] = lin2dB(FFTval,num_bins)

% Calculating Pascal-squared intensity value according to dB input
Pa2val = num_bins.*2.*(FFTval).^2;

% Multiplying Pascal-squared intensity by 2 to account for mirrored
% frequencies
Pa2val = 2*Pa2val;

% Calculating FFT value according to Pascal-squared value.
% Note that this case assumes that each bin contains the same intensity,
% and that the real and imaginary components of the FFT data are equal
dBval = 10.*log10(2500000000.*Pa2val);