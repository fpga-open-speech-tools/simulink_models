


p1=6255;
p2=6280;

p1 = 1
p2 = 15000

figure  %  FFT Data
plot(debug(p1:p2,1),'b'); hold on
plot(debug(p1:p2,1),'b.'); 
plot(debug(p1:p2,3),'g')
plot(debug(p1:p2,3),'g.')
title('FFT Data')


figure  % Weights
plot(debug(p1:p2,2),'b'); hold on
plot(debug(p1:p2,2),'b.'); 
plot(debug(p1:p2,3),'g')
plot(debug(p1:p2,3),'g.')
title('FFT Filter Weights')

figure  % Results
plot(debug(p1:p2,4),'b'); hold on
plot(debug(p1:p2,4),'b.'); 
plot(debug(p1:p2,3),'g')
plot(debug(p1:p2,3),'g.')
title('FFT Result')

figure  % FFT Data & Weights & Results
plot(debug(p1:p2,1),'b'); hold on
plot(debug(p1:p2,1),'b.'); 
plot(debug(p1:p2,3),'g')
plot(debug(p1:p2,3),'g.')
plot(debug(p1:p2,2),'r'); hold on
plot(debug(p1:p2,2),'r.'); 
plot(debug(p1:p2,3)*0.8,'g')
plot(debug(p1:p2,3)*0.8,'g.')
plot(debug(p1:p2,4),'g'); hold on
plot(debug(p1:p2,4),'g.'); 
title('All')
