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


% write output
% audiowrite('room_reverb.wav', y, Fs);

w = 32;
f = 28;

h = imp_cave(:,1); % impulse response

% define fixed point
Fm = fimath('RoundingMethod','Floor',...
        'OverflowAction','Wrap',...
        'ProductMode','SpecifyPrecision',...
        'ProductWordLength',w,...
        'ProductFractionLength',f,...
        'SumMode','SpecifyPrecision',...
        'SumWordLength',w,...
        'SumFractionLength',f);


disp('c compile');
tic
argsIn = {x,h};
fiaccel conv_fixedpt... % function
    -args argsIn... % number and argumanets in
    -nargout 1 % number of outputs
toc

disp('Convolution w/ FFT');
tic
y = fconv(x,h);
toc

disp('Convolution w/o fixed points');
tic 
y_conv = conv(x,h);
toc

disp('Convolution w fixed points and c');
tic
y_fi = conv_fixedpt_mex(x, h); 
toc


%% do not do unless you have a lot of time
% tic
% disp('Convolution w fixed points');
% tic
% y_fi_slow = conv(fi(x, 1, w, f, Fm) , fi(h, 1, w, f, Fm)); 
% toc