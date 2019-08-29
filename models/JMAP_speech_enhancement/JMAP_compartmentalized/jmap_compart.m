% function [xfinal, tfinal] = jmap_compart(x,Srate,beta)
[x, Srate] = audioread('flat_earth.wav');
beta = 3;
%%Implements Proposed JMAP based Speech Enhancement with post
%%processing to reduce musical noise
% Inputs:  x     - Noisy Speech
%          Srate - Sampling Frequency
%          beta  - Tradeoff parameter
%
% Outputs: xfinal - Processed Speech Signal
%          tfinal - Corresponding Time Vector of xfinal
%
% cJMAP Speech Enhancement

%  04/04/17.
%  Created by
%   Chandan K A Reddy
%	Nikhil Shankar
% 	Ram Charan Chandra Shekar
%  Modified by
%   Justin Patrick Williams


% 	Copyright © 2017
%	Statistical Signal Processing Laboratory, University Of Texas @ Dallas.
% 	All rights reserved.
% -------------------------------------------- %
% INITIALIZE VARIABLES 
% -------------------------------------------- %
len = 128;                          % Frame size in samples
PERC = 75;                          % window overlap in percent of frame size
len1 = floor(len*PERC/100);         % PERC% Length of Input Window
len2 = len-len1;                    % (1 - PERC) Length of Input Window

win = hanning(len);                 % Defining the Window
win = win*len2/sum(win);            % Normalized Window Input

Nframes = floor((length(x) - len)/len2);    % Num of frames - Signal Input
xfinal = zeros(length(x),1);                % Final Output Initialization
Xk_prev = zeros(len, 1);
k = 1;                                      % Frame Indexing Variable
% Statistical Variables
aa = 0.98;
eta = 0.15;
ksi_min = 10^(-25/10); 
count = 0;                                  % Counter Variable 
% ---------------------------------------------------------------------- %
% Noise Magnitude Calculations (Assumption: beginning frames are silent
% ---------------------------------------------------------------------- %
nFFT = len;                         % Number of FFT points
noise_pow  = zeros(nFFT,1);         % Noise Power Initialization

% ------------------------------------------------------------ %
% Initial Noise Power Estimation 
% ------------------------------------------------------------ %
noiseVariance = JMAP_noiseCalc(x, win, len, nFFT);                      

% ----------------------------------------------------------------------- %
% Begin Frame-Based Signal Processing
% ----------------------------------------------------------------------- %
for n = 1:Nframes
H = zeros(nFFT,1);
    % Function call, Calculates frame magnitude and posteriori SNR
    [frameMag, postSNR, frameInputFFT] = JMAP_frameResults(x, noiseVariance, win, nFFT, len, k);
    
    % Function call, Calculates ksi and hw
    [ksi, hw] = JMAP_hw_ksi(n, aa, beta, postSNR, Xk_prev, noiseVariance);
    
log_sigma_k = postSNR.* ksi./ (1+ ksi)- log(1+ ksi); 
vad_decision = sum( log_sigma_k)/nFFT;

% In case vad_decision > eta, need to use input variables for
% noiseVariance_out

if (vad_decision < eta) % noise on
    noisePow_out = noise_pow + noiseVariance;
    count_out = count+1;
end
noiseVariance_out = noisePow_out./count_out;
% ----------------------------------------------------------- %
%   Musical Noise Suppression
% ----------------------------------------------------------- %
    % Function call, Calculates FIR Filter Coefficients, N
    N = JMAP_firCoeffCalc(ensig, frameMag);
    
    % Function call, Calculates endSignal and Xk_prev
    [ensig, Xk_prev] = JMAP_filter(N, hw, frameMag, nFFT);

% -------------------------------------------------------- %
%   Inverse FFT current frame, take the real portion           
% -------------------------------------------------------- %

    sim_sigOut = ensig .* exp(i*angle(frameInputFFT));

    xi_w = ifft( sim_sigOut,nFFT);
    xi_w = real(xi_w);  

    xfinal(k:k + len-1) = xfinal(k:k + len-1) + xi_w;   % Overlap and Add

    k=k+len2;           % Increment k by (1 - PERC) window size
end 
tfinal = (1:length(xfinal))' / Srate; % Calculate Corresponding time vector

% end