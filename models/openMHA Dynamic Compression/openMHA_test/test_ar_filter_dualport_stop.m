% Matthew Blunt
% openMHA Test Attack-Release Filter w/ DP Memory Stop Script
% 10/05/2020

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

adj_timevector = ((1:1:(length(Lst))/2)./fs)';
adj_Lst = Lst(1:2:end-1);
adj_out = out.Lin(1:2:end-1);
figure()
plot(adj_timevector, adj_Lst,'b');
hold on;
plot(adj_timevector,adj_out,'r');
hold off;
legend('Input Level','Adjusted Input Level','Location','northwest');
title('Attack-Release Filter Input Level Adjustment');
xlabel('Time [seconds]');
ylabel('Sound Level [dB SPL]');
ylim([50,95]);

adj_timevector2 = ((1:1:(length(Lst))/2)./fs)';
adj_Lst2 = Lst(2:2:end);
adj_out2 = out.Lin(2:2:end);
figure()
plot(adj_timevector2, adj_Lst2,'b');
hold on;
plot(adj_timevector2,adj_out2,'r');
hold off;
legend('Input Level','Adjusted Input Level','Location','northwest');
title('Attack-Release Filter Input Level Adjustment');
xlabel('Time [seconds]');
ylabel('Sound Level [dB SPL]');
ylim([50,95]);

%% Compare Results

% Error calculations


