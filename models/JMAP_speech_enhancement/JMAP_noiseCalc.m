function noiseVariance2 = JMAP_noiseCalc(x)
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

% Copyright Audio Logic
len = 64;                          % Frame size in samples
PERC = 75;                          % window overlap in percent of frame size
len1 = floor(len*PERC/100);         % PERC% Length of Input Window
len2 = len-len1;                    % (1 - PERC) Length of Input Window

win = hanning(len);                 % Defining the Window
win = win*len2/sum(win);            % Normalized Window Input

% ---------------------------------------------------------------------- %
% Noise Magnitude Calculations (Assumption: beginning frames are silent
% ---------------------------------------------------------------------- %
nFFT = len;                         % Number of FFT points

j = 1;
noise_mean = zeros(nFFT,1);         % Noise Average Initialization
noise_pow  = zeros(nFFT,1);         % Noise Power Initialization

% ------------------------------------------------------------ %
% Initial Noise Power Estimation 
% ------------------------------------------------------------ %
for k = 1:6
    noise_mean = noise_mean+abs(fft(win.*x(j:j+len-1),nFFT));
    j = j + len;
end
noise_mean    = noise_mean/length(k);
noiseVariance2 = noise_mean.^2;
disp('reeee');


end