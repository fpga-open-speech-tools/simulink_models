% reverb_example.m
% Script to call implement Convolution Reverb
% read the sample waveform
% filename = 'acoustic.wav';

[x,Fs] = audioread('acoustic.wav'); 

% read the impulse response waveform
[imp_room, Fsimp] = audioread('impulse_room.wav');
[imp_box, Fsimp] = audioread('STRANGEBOX-2.wav');
[imp_cave, Fsimp] = audioread('DAMPED CAVE E001 M2S.wav');
[imp_hall, Fsimp] = audioread('BIG HALL E001 M2S.wav');
[imp_pipe, Fsimp] = audioread('PIPE & CARPET E001 M2S.wav');
tic
i = 32
name = ['room_reverb_w_' int2str(i) '.wav'] % name of the file

h = imp_room(:,1); % impulse response

% compile the c code
argsIn = {x, h};
fiaccel  conv_fixedpt_32... % function
        -args argsIn... % number and argumanets in
        -nargout 1  % number of outputs

% Convolution w fixed points and c
y_fi = conv_fixedpt_mex(x, h); 
    
% normalize and type cast
y = double(y_fi/max(abs(y_fi)));
    audiowrite(name, y, Fs);
  
i = 28    
name = ['room_reverb_w_' int2str(i) '.wav'] % name of the file

% compile the c code
argsIn = {x, h};
fiaccel  conv_fixedpt_28... % function
        -args argsIn... % number and argumanets in
        -nargout 1  % number of outputs

% Convolution w fixed points and c
y_fi = conv_fixedpt_mex(x, h); 
    
% normalize and type cast
y = double(y_fi/max(abs(y_fi)));
    audiowrite(name, y, Fs);
    
i = 24    
name = ['room_reverb_w_' int2str(i) '.wav'] % name of the file

% compile the c code
argsIn = {x, h};
fiaccel  conv_fixedpt_24... % function
        -args argsIn... % number and argumanets in
        -nargout 1  % number of outputs

% Convolution w fixed points and c
y_fi = conv_fixedpt_mex(x, h); 
    
% normalize and type cast
y = double(y_fi/max(abs(y_fi)));
    audiowrite(name, y, Fs);

i = 20    
name = ['room_reverb_w_' int2str(i) '.wav'] % name of the file

% compile the c code
argsIn = {x, h};
fiaccel  conv_fixedpt_20... % function
        -args argsIn... % number and argumanets in
        -nargout 1  % number of outputs

% Convolution w fixed points and c
y_fi = conv_fixedpt_mex(x, h); 
    
% normalize and type cast
y = double(y_fi/max(abs(y_fi)));
    audiowrite(name, y, Fs);
    
i = 16   
name = ['room_reverb_w_' int2str(i) '.wav'] % name of the file

% compile the c code
argsIn = {x, h};
fiaccel  conv_fixedpt_16... % function
        -args argsIn... % number and argumanets in
        -nargout 1  % number of outputs

% Convolution w fixed points and c
y_fi = conv_fixedpt_mex(x, h); 
    
% normalize and type cast
y = double(y_fi/max(abs(y_fi)));
    audiowrite(name, y, Fs);

i = 12
name = ['room_reverb_w_' int2str(i) '.wav'] % name of the file

% compile the c code
argsIn = {x, h};
fiaccel  conv_fixedpt_12... % function
        -args argsIn... % number and argumanets in
        -nargout 1  % number of outputs

% Convolution w fixed points and c
y_fi = conv_fixedpt_mex(x, h); 
    
% normalize and type cast
y = double(y_fi/max(abs(y_fi)));
    audiowrite(name, y, Fs);

i = 8   
name = ['room_reverb_w_0' int2str(i) '.wav'] % name of the file

% compile the c code
argsIn = {x, h};
fiaccel  conv_fixedpt_08... % function
        -args argsIn... % number and argumanets in
        -nargout 1  % number of outputs

% Convolution w fixed points and c
y_fi = conv_fixedpt_mex(x, h); 
    
% normalize and type cast
y = double(y_fi/max(abs(y_fi)));
    audiowrite(name, y, Fs);


    
toc

%% do not do unless you have a lot of time
% tic
% disp('Convolution w fixed points');
% tic
% y_fi_slow = conv(fi(x, 1, w, f, Fm) , fi(h, 1, w, f, Fm)); 
% toc