
function [XX,f]= fft_compute(x,Fs)
L=length(x);

if nargin==1 
    Fs=16000;
end

nfft =(2^nextpower2(L)); % Next power of 2 from length of y
X = fft(x,nfft)/L;
f = Fs/2*linspace(0,1,nfft/2+1);

XX=20*log10(2*abs(X(1:nfft/2+1)));
%XX=(2*abs(X(1:nfft/2+1)));

plot(f,XX);
end