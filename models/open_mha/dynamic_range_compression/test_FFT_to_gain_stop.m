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
plot(out.Lin(6:300:end));
hold on;
plot(out.adjusted_gain(72:300:end));
plot(Lst1);
hold off;
title('Input Levels - Frequency Band 1');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 2 Results
figure()
plot(out.Lin(7:300:end));
hold on;
plot(out.adjusted_gain(74:300:end));
plot(Lst2);
hold off;
title('Input Levels - Frequency Band 2');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 3 Results
figure()
plot(out.Lin(9:300:end));
hold on;
plot(out.adjusted_gain(75:300:end));
plot(Lst1);
hold off;
title('Input Levels - Frequency Band 3');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 4 Results
figure()
plot(out.Lin(10:300:end));
hold on;
plot(out.adjusted_gain(77:300:end));
plot(Lst2);
hold off;
title('Input Levels - Frequency Band 4');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 5 Results
figure()
plot(out.Lin(15:300:end));
hold on;
plot(out.adjusted_gain(78:300:end));
plot(Lst1);
hold off;
title('Input Levels - Frequency Band 5');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 6 Results
figure()
plot(out.Lin(26:300:end));
hold on;
plot(out.adjusted_gain(83:300:end));
plot(Lst2);
hold off;
title('Input Levels - Frequency Band 6');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 7 Results
figure()
plot(out.Lin(69:300:end));
hold on;
plot(out.adjusted_gain(94:300:end));
plot(Lst1);
hold off;
title('Input Levels - Frequency Band 7');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

% Band 8 Results
figure()
plot(out.Lin(132:300:end));
hold on;
plot(out.adjusted_gain(137:300:end));
plot(Lst2);
hold off;
title('Input Levels - Frequency Band 8');
xlabel('Sample Number');
ylabel('Sound Level [dB]');

%% Compare Results

% Error calculations

