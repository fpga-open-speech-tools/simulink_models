% function [xfinal, tfinal] = JMAP_Postfilt_SE_OG(x,Srate,beta)
[x, Fsi] = audioread('flat_earth.wav');
beta = 2;
Srate = 48000;
x = resample(x, Srate, Fsi);
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
noiseVariance = noise_mean.^2;
noiseVarREEE = noiseVariance;

% ------------------------------------------------ %
% More variable initialization
% -------------------------------------------------%
Nframes = floor((length(x) - len)/len2);    % Num of frames - Signal Input
xfinal = zeros(length(x),1);                % Final Output Initialization
k = 1;                                      % Frame Indexing Variable
% Statistical Variables
aa = 0.98;
eta = 0.15;
ksi_min = 10^(-25/10); 
count = 0;                                  % Counter Variable                        

% ----------------------------------------------------------------------- %
% Initialize Variables For Model Comparison
% ----------------------------------------------------------------------- %

frameInputExport = zeros(Nframes, nFFT);
frameMagExport = zeros(Nframes, nFFT);
framePowExport = zeros(Nframes, nFFT);
postSNRExport  = zeros(Nframes, nFFT);
ensigExport    = zeros(Nframes, nFFT);
ksiExport      = zeros(Nframes, nFFT);
countExport    = zeros(Nframes, 1);
NExport        = zeros(Nframes, 1);
noiseVarExport = zeros(Nframes, nFFT);
noisePowExport = zeros(Nframes, nFFT);
hwExport       = zeros(Nframes, nFFT);
XkprevExport   = zeros(Nframes, nFFT);
sigOutExport   = zeros(Nframes, nFFT);
compOutExport  = zeros(Nframes, nFFT);


% ----------------------------------------------------------------------- %
% Begin Frame-Based Signal Processing
% ----------------------------------------------------------------------- %
for n = 1:Nframes
H = zeros(nFFT,1);
    frameInput=win.*x(k:k+len-1);
%-------------------------------------------- %
%   FFT Input Frame
%-------------------------------------------- %
    frameInputFFT = fft(frameInput,nFFT);
    frameInputExport(n,:) = frameInputFFT;      % Export to Data Comparison Model
    
    frameMag = abs(frameInputFFT); % compute the magnitude
    frameMagExport(n,:) = frameMag; % Export to Data Comparison Model
    
    framePow = frameMag.^2; % Compute power
    framePowExport(n,:) = framePow; % Export to Data Comparison Model
    
    postSNR = min(framePow./noiseVariance,40);  % posteriori SNR
    postSNRExport(n,:) = postSNR; % Export to Data Comparison Model
    
    if n==1 % If first frame, initialize ksi & endSignal
        ksi = aa+(1-aa)*max(postSNR-1,0);
        ensig = frameMag;
    else
        ksi = aa*Xk_prev./noiseVariance + (1-aa)*max(postSNR-1,0);     
        % decision-direct estimate of a priori SNR
        ksi = max(ksi_min,ksi);  % limit ksi to -25 dB
    end
    
    ksiExport(n,:) = ksi; % Export to Data Comparison Model

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
    hwExport(n,:) = hw;
    countExport(n) = count; % Export to Data Comparison Model
    noisePowExport(n,:) = noise_pow; % Export to Data Comparison Model
% ----------------------------------------------------------- %
%   Musical Noise Suppression
% ----------------------------------------------------------- %
    PR = sum(abs(ensig.^2))/(sum(abs(frameMag.^2))+eps);
    
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
    NExport(n) = N; % Export to Data Comparison Model
    H(1:N) = 1/N;                               % FIR Filter Coefficients
    HPF = conv(H,abs(hw));                      % FIR Filter Declaration
    ensig = frameMag.*HPF(1:length(frameMag));  % Filtering endSignal
    
    Xk_prev = ensig.^2;  % postSNR estimation reused for next frame 
    ensigExport(n,:) = ensig; % Export to Data Comparison Model
    XkprevExport(n,:) = Xk_prev; % Export to Data Comparison Model
% -------------------------------------------------------- %
%   Inverse FFT current frame, take the real portion           
% -------------------------------------------------------- %
    compOut = exp(i*angle(frameInputFFT));
    sigOut = ensig .* compOut;
    
    compOutExport(n,:) = compOut;
    sigOutExport(n,:) = sigOut;
    xi_w = ifft( ensig .* exp(i*angle(frameInputFFT)),nFFT);
    xi_w = real(xi_w);  

    xfinal(k:k + len-1) = xfinal(k:k + len-1) + xi_w;   % Overlap and Add

    k=k+len2;           % Increment k by (1 - PERC) window size
end 
tfinal = (1:length(xfinal))' / Srate; % Calculate Corresponding time vector
% NExport = NExport';
% end