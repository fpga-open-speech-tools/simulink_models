% Matthew Blunt
% openMHA Test Concatenated DC Model Stop Script
% 10/09/20

% Created to test full dynamic compression model functionality from FFT
% data to gain table

%% Calculating Theoretical Results


%% Plotting Resulting I/O Characteristics

timevector = ((1:1:length(Lst))./fs)';

% Plotting Frequency Band 2 Attack-Release Filter Output
figure()
plot(timevector(1:end/2),Lst(1:2:end-1),'b');
hold on;
plot(timevector(1:end/2),out.Lin(1:2:end-1),'r');
hold off;
legend('Input Level','Adjusted Input Level','Location','northwest');
title('Attack-Release Filter Input Level Adjustment - Freq. Band 2');
xlabel('Time [seconds]');
ylabel('Sound Level [dB SPL]');
ylim([50,95]);

% Plotting Frequency Band 1 Attack-Release Filter Output
figure()
plot(timevector(1:end/2),Lst(2:2:end),'b');
hold on;
plot(timevector(1:end/2),out.Lin(2:2:end),'r');
hold off;
legend('Input Level','Adjusted Input Level','Location','northwest');
title('Attack-Release Filter Input Level Adjustment - Freq. Band 1');
xlabel('Time [seconds]');
ylabel('Sound Level [dB SPL]');
ylim([50,95]);


% Plotting Frequency Band 2 Gain
figure()
plot(timevector(1:end/2),out.gain(2:2:end),'b');
hold on;
plot(timevector(1:end/2),out.adjusted_gain(2:2:end),'r');
hold off;
legend('Gain (Original Input Level)','Gain (Adjusted Input Level)','Location','northwest');
title('Gain Comparison Plot with and without Attack-Release Filter - Freq. Band 2');
xlabel('Time [seconds');
ylabel('Gain [dB]');

% Plotting Frequency Band 1 Gain
figure()
plot(timevector(1:end/2),out.gain(1:2:end-1),'b');
hold on;
plot(timevector(1:end/2),out.adjusted_gain(1:2:end-1),'r');
hold off;
legend('Gain (Original Input Level)','Gain (Adjusted Input Level)','Location','northwest');
title('Gain Comparison Plot with and without Attack-Release Filter - Freq. Band 1');
xlabel('Time [seconds');
ylabel('Gain [dB]');

%% Compare Results

% Error calculations
