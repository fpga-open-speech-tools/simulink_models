% reverb_convolution_eg.m
% Script to call implement Convolution Reverb
% read the sample waveform
%filename = 'acoustic.wav';
[x,Fs] = audioread('acoustic.wav'); 

% read the impulse response waveform
[imp_room, Fsimp] = audioread('impulse_room.wav');
[imp_box, Fsimp] = audioread('STRANGEBOX-2.wav');
[imp_cave, Fsimp] = audioread('DAMPED CAVE E001 M2S.wav');
[imp_hall, Fsimp] = audioread('BIG HALL E001 M2S.wav');
[imp_pipe, Fsimp] = audioread('PIPE & CARPET E001 M2S.wav');

% Do convolution with FFT
y = fconv(x,imp_room);

% write output
audiowrite('room_reverb.wav', y, Fs);


% box
y = fconv(x,imp_box);
audiowrite('box_reverb.wav', y, Fs);

% cave
y = fconv(x,imp_cave);
audiowrite('cave_reverb.wav', y, Fs);

% hall
y = fconv(x,imp_hall);
audiowrite('hall_reverb.wav', y, Fs);

% pipe 
y = fconv(x,imp_pipe);
audiowrite('pipe_reverb.wav', y, Fs);

