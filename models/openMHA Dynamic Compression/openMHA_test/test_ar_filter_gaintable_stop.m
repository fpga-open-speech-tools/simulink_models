% Matthew Blunt
% openMHA Test Attack-Release Filter & Gaintable Stop Script
% 09/24/2020

% Created to test attack-release filter and gaintable functionality during 
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

figure()
plot(timevector,out.gain,'b');
hold on;
plot(timevector,out.adjusted_gain,'r');
hold off;
legend('Gain (Original Input Level)','Gain (Adjusted Input Level)','Location','northwest');
title('Gain Comparison Plot with and without Attack-Release Filter');
xlabel('Time [seconds');
ylabel('Gain [dB]');

%% Compare Results

% Error calculations
