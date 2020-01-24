function [y]=fconv(x, h)
%FCONV Fast Convolution
%  [y] = FCONV(x, h) convolves x and h, and normalizes the output
%         to +-1.
%      x = input vector
%      h = input vector
%

Ly=length(x)+length(h)-1;  
Ly2=pow2(nextpow2(Ly));     % Find smallest power of 2 that is > Ly
X=fft(x, Ly2);              % Fast Fourier transform
H=fft(h, Ly2);              % Fast Fourier transform
Y=X.*H;                     % DO CONVOLUTION
y=real(ifft(Y, Ly2));       % Inverse fast Fourier transform
y=y(1:1:Ly);                % Take just the first N elements
y=y/max(abs(y));            % Normalize the output