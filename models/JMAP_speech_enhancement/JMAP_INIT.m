% JMAP Simulink Model Initialization Fcn
%
%
% This function is called to declare variables and their required memory
% allocation for the Simulink Speech Enhancement model.

% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Justin P Williams
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com
% clc; clear;
Fs = 48000;
Ts = 1/Fs;

[x, Fs_in] = audioread('flat_earth.wav');
% x = x/max(x);                         % Normalizes Input Signal between -1 and 1
%x  = awgn(x, 45);                     % Introduces white guassian noise w/ SNR of 45%
t = (1:length(x))'/Fs_in;
global beta;
global FFT_size;
beta = 2;
FFT_size = 64;
FFT_size_half = FFT_size/2;
FFT_frame_shift = FFT_size/4;  % should be a power of two (to easily replace mode operator that is not HDL compatible)
FFT_frame_shift_Nbits = log2(FFT_frame_shift);

DPRAM1_size = FFT_size*2;  % number of words
DPRAM1_address_size = log2(DPRAM1_size);

SysRate_Upsample_Factor = 32;
SysRate_Dwnsample_Factor = (SysRate_Upsample_Factor*Fs)/FFT_size;


Wbits = 32;    %fixdt(1,Wbits,Fbits)
Fbits = 28;

% Calculate Estimated Noise before Simulink Model
% [noise_mu, noise_mu2] = noiseCalc(x, FFT_size);
% noise_stat = [1:128, noise_mu, noise_mu2];
noiseVarianceInit = JMAP_noiseCalc(x);%, hanning(FFT_size), FFT_size, FFT_size);
x2 = resample(x, 48000, 16000);
noiseVarianceTest = JMAP_noiseCalc(x2);%, hanning(FFT_size), FFT_size, FFT_size);


sp = [t, x];
stopTime = t(length(t));   % ModSel Run Time
stopTimeTst = 0.15;


%% Constant Declarations:
aa  = 0.98.*ones(FFT_size, 1);
eta = 0.15.*ones(FFT_size, 1);
count = 0;
ksiMin = 0.0032*ones(FFT_size, 1);

frameMag_initCond = abs(fft(sp(1:FFT_size), FFT_size))';

% Calculate Initial KSI Frame
fFrame = fft(x, FFT_size);
fMag   = abs(fFrame);
fPow   = fMag.^2;
pSNR   = min(fPow./noiseVarianceInit, 40);
ksiInit= aa + (1-aa).*max(pSNR - 1, 0);