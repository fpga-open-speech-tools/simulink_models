%% Load Constants
% Model Constants
FFT_size = 64;
nSamp = 6;
Fs = 48000;
Ts = 1/Fs;

t = 0 : Ts : (nSamp - 1)*Ts;
t = t';

% Model Inputs
mn = 0.001;
mx = 0.98;
hw = (mx - mn).*rand(6, 64) + mn;

N  = [1 1 3 3 3 3];

% Concatenate with t
hwSim = [t, hw];
NSim  = [t, N'];

%% Result Verification
firC = [  1,   0,   0;
          1,   0,   0;
        1/3, 1/3, 1/3;
        1/3, 1/3, 1/3;
        1/3, 1/3, 1/3;
        1/3, 1/3, 1/3];
HPF_Model = -1*ones(nSamp+2, FFT_size);
k     = 1;       % FFT Index Counter
fCnt  = 1;       % Frame Index Counter
delay = 1;       % Delay Counter

for n = 1:nSamp+2
   if n == 1 
       HPF_Model(n,:) = zeros(1, FFT_size);
   elseif n == 2
       disp('n == 2');
       HPF_Model(n,:) = zeros(1, FFT_size);
   else 
       l = n - 2;
       fFilt = conv(firC(l, 1:3), abs(hw(l,:)));
       fFilt(65:66) = [];
       HPF_Model(n,:) = fFilt;   
   end
    
   
end



        
















