


fft_out = fft(double(HA_left_data_out'));   % assuming chirp input....


figure(20)

m = 20*log10(abs(fft_out));
m = m - max(m);
N=length(m);
N2 = N/2;
fm=1:N2;
fm=fm/N2 * 24000;
h=plot(fm/1000,m(1:N2),'b'); set(h,'LineWidth',3); hold on


xlabel('Frequency (kHz)')
ylabel('dB')
title('Frequency Response of Simulink Hearing Aid Model')
set(gca, 'FontSize', 50)

axis([0 5 -50 0])

%figure(21)

% % electrical test path (for comparison)
% load E:\FE\Phase1_Milestones_Update_2017_June\Pictures\V2_FreqResponse_AllOn_1d0_1d0_1d0_1d0_1d0_ElectrialTest.mat
% m2 = 20*log10(abs(fftdata));
% m2 = m2 - max(m2);
% h=plot(f/1000,m2,'r'); set(h,'LineWidth',3);
% 


% acoustic test path (for comparison)
% load E:\FE\Phase1_Milestones_Update_2017_June\Pictures\V2_FreqResponse_AllOn_0d5_0d9_1d1_1d0_10d0.mat
% m3 = 20*log10(abs(fftdata));
% m3 = m3 - max(m3);
% h=plot(f/1000,m3,'g'); set(h,'LineWidth',3);
