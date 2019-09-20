function noiseVariance = JMAP_noiseCalc(x, win, len, nFFT)
%%This function is designed to calculate an initial noise estimate within a
%%frame of a speech signal. 
% Inputs:
%    x - Input speech sample
%  win - Pre-defined window
%  len - Frame size in samples
% nFFT - Number of FFT Points
%
% Outputs:
%   noiseVariance - statistical variance of the noise within the first 6
%   frames of a window
%
% Author: 
%  Justin Williams

% Copyright Flat Earth Inc

j = 1;   % Indexing Variable
noise_mean = zeros(nFFT, 1);

for k = 1:6
    noise_mean = noise_mean+abs(fft(win.*x(j:j+len-1),nFFT));
    j = j + len;
end
noise_mean    = noise_mean/length(k);
noiseVariance = noise_mean.^2;
end