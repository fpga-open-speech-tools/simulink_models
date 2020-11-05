% Matthew Blunt
% openMHA Test Concatenated DC Model Stop Script
% 10/09/20

% Created to test full dynamic compression model functionality from FFT
% data to gain table

%% Calculating Theoretical Results


%% Plotting Resulting I/O Characteristics

timevector = ((1:1:length(Lst1))./fs)';

% Band 1 Results
figure()
plot(out.Lin(70:300:end));
hold on;
plot(out.adjusted_gain(71:300:end));
plot(Lst1);
hold off;
title('Input Levels - Frequency Band 1');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 2 Results
figure()
plot(out.Lin(71:300:end));
hold on;
plot(out.adjusted_gain(73:300:end));
plot(Lst2);
hold off;
title('Input Levels - Frequency Band 2');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 3 Results
figure()
plot(out.Lin(72:300:end));
hold on;
plot(out.adjusted_gain(74:300:end));
plot(Lst1);
hold off;
title('Input Levels - Frequency Band 3');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 4 Results
figure()
plot(out.Lin(74:300:end));
hold on;
plot(out.adjusted_gain(76:300:end));
plot(Lst2);
hold off;
title('Input Levels - Frequency Band 4');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 5 Results
figure()
plot(out.Lin(75:300:end));
hold on;
plot(out.adjusted_gain(77:300:end));
plot(Lst1);
hold off;
title('Input Levels - Frequency Band 5');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 6 Results
figure()
plot(out.Lin(80:300:end));
hold on;
plot(out.adjusted_gain(82:300:end));
plot(Lst2);
hold off;
title('Input Levels - Frequency Band 6');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 7 Results
figure()
plot(out.Lin(91:300:end));
hold on;
plot(out.adjusted_gain(93:300:end));
plot(Lst1);
hold off;
title('Input Levels - Frequency Band 7');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 8 Results
figure()
plot(out.Lin(134:300:end));
hold on;
plot(out.adjusted_gain(136:300:end));
plot(Lst2);
hold off;
title('Input Levels - Frequency Band 8');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

%% Compare Results

% Error calculations

