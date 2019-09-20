
%%
for n = 1:nSamp
   figure(n)
   stem(1:FFT_size, HPF_Model(n,:), '.');
   hold on;
   stem(1:FFT_size, HPF_Sim(n,:), '*');
   hold off;
   xlabel('Samples');
   title(['Frame ', num2str(n), ' - HPFScript vs HPFModel']);
   legend('HPFScript', 'HPFModel');
end
%% error testing

error = abs(HPF_Sim(1:6, 1:FFT_size)-HPF_Model(1:6, 1:FFT_size))./HPF_Model(1:6, 1:FFT_size);