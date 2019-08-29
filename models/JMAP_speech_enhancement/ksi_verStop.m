ksiError = abs(ksiOut(1:nSamp, 1:FFT_size) - ksi(1:nSamp, 1:FFT_size)) ./ ksi(1:nSamp, 1:FFT_size);
hwError  = abs(hwOut(1:nSamp, 1:FFT_size) - hw(1:nSamp, 1:FFT_size)) ./ hw(1:nSamp, 1:FFT_size);

maxKsiError = max(ksiError(:))*100
maxHWError  = max(hwError(:))*100

%% hw Verification
for n = 1:nSamp
   figure(n)
   stem(1:FFT_size, hw(n, 1:FFT_size), 'o');
   hold on;
   stem(1:FFT_size, hwOut(n, 1:FFT_size), '*');
   hold off;
   xlabel('Samples');
   title(['Frame: ', num2str(n), ' - hw(exact) vs hw(model)']);    
end