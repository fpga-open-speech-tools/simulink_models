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
h = imp_cave(:,1); % impulse response

tic
for i = 32:-1:10
    width = i
    frac = width - 8;
    name = ['cave_reverb_w_' int2str(i) '.wav'] % name of the file
    Fm = fimath('RoundingMethod','Floor',...
        'OverflowAction','Wrap',...
        'ProductMode','SpecifyPrecision',...
        'ProductWordLength',width,...
        'ProductFractionLength',frac,...
        'SumMode','SpecifyPrecision',...
        'SumWordLength',width,...
        'SumFractionLength',frac);
    
    x_fi = fi(x, 1, width, frac, Fm);
    h_fi = fi(h, 1, width, frac, Fm);

    argsIn = {x_fi, h_fi};
    fiaccel  fi_conv... % function
            -args argsIn... % number and argumanets in
            -nargout 1  % number of outputs
        
    y_fi = fi_conv_mex(x_fi, h_fi);
    y = double(y_fi);
    y = y ./ max(abs(y));
    audiowrite(name, y, Fs);
end
toc
