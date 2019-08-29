function xfinal = JMAP_Postfilt_SE_v3(x,beta)
%%Implements Proposed JMAP based Speech Enhancement with post
%%processing to reduce musical noise
% Inputs:  x     - Noisy Speech
%          beta  - Tradeoff parameter (Determines algo effectiveness, but
%                                      introduces additional latency)
%
% Outputs: xfinal - Processed Speech Signal
%
% cJMAP Speech Enhancement

%  04/04/17.
%  Created by
%   Chandan K A Reddy
%	Nikhil Shankar
% 	Ram Charan Chandra Shekar
%
%  June 2019
%  Modified by
%   Justin Patrick Williams
%
% 	Copyright © 2017
%	Statistical Signal Processing Laboratory, University Of Texas @ Dallas.
% 	All rights reserved.

% -------------------------------------------- %
% INITIALIZE VARIABLES 
% -------------------------------------------- %
len = 64;                           % Frame size in samples
PERC = 75;                          % window overlap in percent of frame size
len1 = floor(len*PERC/100);         
len2 = len-len1;                    

win = hanning(len);                 
win = win*len2/sum(win);            % Normalized Window Input

Nframes = floor((length(x) - len)/len2);    
xfinal = zeros(length(x),1);                

% Statistical Variables
aa = 0.98;
eta = 0.15;
ksi_min = 10^(-25/10); 
count = 0;   

% ---------------------------------------------------------------------- %
% Noise Magnitude Calculations (Assumption: beginning frames are silent)
% ---------------------------------------------------------------------- %
nFFT = len;                         
j = 1;
noise_mean = zeros(nFFT,1);         
noise_pow  = zeros(nFFT,1);         

for k = 1:6
    noise_mean = noise_mean+abs(fft(win.*x(j:j+len-1),nFFT));
    j = j + len;
end
noise_mean    = noise_mean/length(k);
noiseVariance = noise_mean.^2;                                                  

% ----------------------------------------------------------------------- %
% Begin Frame-Based Signal Processing
% ----------------------------------------------------------------------- %
k = 1;                                      % Frame Indexing Variable
for n = 1:Nframes
H = zeros(3,1);
    frameInput=win.*x(k:k+len-1);
%-------------------------------------------- %
%   FFT Input Frame
%-------------------------------------------- %
    frameInputFFT = fft(frameInput,nFFT);
    frameMag = abs(frameInputFFT); % compute the magnitude
    framePow = frameMag.^2; % Compute power

    postSNR = min(framePow./noiseVariance,40);  
    
    if n==1 % If first frame, initialize ksi & endSignal
        ksi = aa+(1-aa)*max(postSNR-1,0);
        endFrameSig = frameMag;
    else
        ksi = aa*Xk_prev./noiseVariance + (1-aa)*max(postSNR-1,0);     
        % decision-direct estimate of a priori SNR
        ksi = max(ksi_min,ksi);  % limit ksi to -25 dB
    end

    log_sigma_k = postSNR.* ksi./ (1+ ksi)- log(1+ ksi); 
    
% ------------------------------------------------------ %
%   VAD: Voice Activity Detector
% ------------------------------------------------------ %
    
    vad_decision = sum( log_sigma_k)/nFFT;    
    if (vad_decision < eta) % noise on
        noise_pow = noise_pow + noiseVariance;
        count = count+1;
    end
    noiseVariance = noise_pow./count;
    hw = (ksi+sqrt(ksi.^2+(1+ksi).*ksi./postSNR))./(2*(beta+ksi));   

% ----------------------------------------------------------- %
%   Musical Noise Suppression
% ----------------------------------------------------------- %
    PR = sum(abs(endFrameSig.^2))/(sum(abs(frameMag.^2))+eps);
    
    if(PR>=0.4)
        PRT = 1;
    else
        PRT = PR;
    end
    
    if(PRT == 1)
        N=1;
    else
        N = 2*round((1-PRT/0.4))+1;
    end
    
    H(1:N) = 1/N;                               % FIR Filter Coefficients
    HPF = conv(H,abs(hw));                      % FIR Filter
    endFrameSig = frameMag.*HPF(1:length(frameMag));  % Filtering endSignal
    
    Xk_prev = endFrameSig.^2;  % postSNR estimation reused for next frame 

% -------------------------------------------------------- %
%   Inverse FFT current frame, take the real portion           
% -------------------------------------------------------- %
    xi_w = ifft( endFrameSig .* exp(i*angle(frameInputFFT)),nFFT);
    xi_w = real(xi_w);  

    xfinal(k:k + len-1) = xfinal(k:k + len-1) + xi_w;   % Overlap and Add

    k=k+len2;           % Increment k by (1 - PERC) window size
end 
end