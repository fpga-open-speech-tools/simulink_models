% Matthew Blunt
% openMHA dB Input Signal Unit Conversion Script
% 10/19/2020

% Created to quickly calculate linear factors and FFT data values
% according to a desired dB level and number of bins in the band

function [Pa2val,FFTval] = dB2lin(dBval,num_bins)

% Calculating Pascal-squared intensity value according to dB input
Pa2val = (10.^(dBval./10))./2500000000;

% Calculating FFT value according to Pascal-squared value.
% Note that this case assumes that each bin contains the same intensity,
% and that the real and imaginary components of the FFT data are equal
FFTval = (sqrt((Pa2val/2)./(num_bins*2)));
