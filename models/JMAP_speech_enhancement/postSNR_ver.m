FFT_size = 64;
nSamp = 6;
Fs = 48000;
Ts = 1/Fs;

t = 0 : Ts : (FFT_size - 1)*Ts;
[x, Fsi] = audioread('flat_earth.wav');
x = resample(x, Fs, Fsi); %48000Hz / 16000Hz Upsample Rate

framePower = abs(fft(x, FFT_size))^2;

len = FFT_size;                           % Frame size in samples
PERC = 75;                          % window overlap in percent of frame size
len1 = floor(len*PERC/100);         
len2 = len-len1;                    
win = hanning(len);                 
win = win*len2/sum(win);            % Normalized Window Input
j = 1;
noise_mean = zeros(nFFT,1);         
for k = 1:6
    noise_mean = noise_mean+abs(fft(win.*x(j:j+len-1),len));
    j = j + len;
end
noise_mean    = noise_mean/length(k);
noiseVariance = noise_mean.^2;
