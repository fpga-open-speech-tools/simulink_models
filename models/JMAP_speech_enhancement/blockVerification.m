%% Block Verification Script
% The purpose of this script is to test the outputs of the CPU based
% algorithm and compare this against the results of the
% Parallel-Computation based Simulink model.

%% Constant Initialization
nSamp = 6;
FFT_size  = 64;
Fs = 48000;
Ts = 1/Fs;

t = 0 : Ts : 63*Ts;
t = t';
framePow = rand([nSamp, FFT_size]);
framePow = framePow';
noiseVariance = rand([nSamp, FFT_size]);
noiseVariance = noiseVariance';
framePow = [t, framePow];
noiseVariance = [t, noiseVariance];
%% PostSNR Block
postSNR = min(framePow./noiseVariance,40);  % posteriori SNR