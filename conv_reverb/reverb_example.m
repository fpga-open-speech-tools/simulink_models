% reverb_convolution_eg.m
% Script to call implement Convolution Reverb
% read the sample waveform
%filename = 'acoustic.wav';
[x,Fs] = audioread('acoustic.wav'); 

% read the impulse response waveform
%filename = 'impulse_room.wav'; 
[imp,Fsimp] = audioread('impulse_room.wav');

% Do convolution with FFT
y = fconv(x,imp);

% write output
audiowrite('out_IRreverb.wav', y, Fs)