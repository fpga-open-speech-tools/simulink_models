function [frameMag, postSNR, frameInputFFT] = JMAP_frameResults(x, noiseVariance, win, nFFT, len, k)
%%This function is designed to calculate each frame's magnitude and
%%posteriori SNR. 
%
% Inputs:
%    x -
%  win - 
% nFFT -
%  len -
%    k - 
% 
% Outputs
%    frameMag - The magnitude of each frame
%     postSNR - Posteriori SNR 
%

% Copyright Flat Earth Inc
% Author: Justin Williams

frameInput=win.*x(k:k+len-1);
%-------------------------------------------- %
%   FFT Input Frame
%-------------------------------------------- %
frameInputFFT = fft(frameInput,nFFT);
frameMag = abs(frameInputFFT); % compute the magnitude
framePow = frameMag.^2; % Compute power
    
postSNR = min(framePow./noiseVariance,40);  % posteriori SNR

end