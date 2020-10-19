% Matthew Blunt
% openMHA Test Attack-Release Filter Stop Script
% 09/23/2020

% Created to test attack-release filter functionality during 
% openMHA implementation in order to ensure proper architecture design in
% Simulink according to attack and release time standards


%% Calculating Theoretical Results


%% Plotting Resulting I/O Characteristics

timevector = ((1:1:length(Lst))./fs)';

figure()
plot(timevector,Lst,'b');
hold on;
plot(timevector,out.Lin,'r');
hold off;
legend('Input Level','Adjusted Input Level','Location','northwest');
title('Attack-Release Filter Input Level Adjustment');
xlabel('Time [seconds]');
ylabel('Sound Level [dB SPL]');
ylim([50,95]);

%% Compare Results

% Error calculations


