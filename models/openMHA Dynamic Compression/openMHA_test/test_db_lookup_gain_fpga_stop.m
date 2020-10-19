% Matthew Blunt
% openMHA Test dB Lookup Gain FPGA-in-the-Loop Stop Script
% 10/14/2020

% Created to test dB lookup and gain calculation functionality during 
% FPGA-in-the-Loop simulation

%% Loading Theoretical Results

load('reference.mat');

%% Calculating Theoretical Results

level_in_db = 10.*log10(2500000000.*level_in);

%% Plotting Resulting I/O Characteristics

figure()
semilogx(level_in(4:end),level_in_db(4:end),'b');
hold on;
plot(level_in(4:end),out.level_in_db(4:end),'r');
hold off;
legend('Expected Input Values','Lookup Table Input Values','Location','southeast');
xlabel('Input Level [Pa^2]');
ylabel('Input Level [dB]');
title('Dual-Port dB Lookup Table: Actual vs. Expected Results');


%% Compare Results

% Error calculations
level_in = level_in';
level_in_db = level_in_db';
diff = abs(out.level_in_db(4:end-4) - level_in_db(4:end-4));
percdiff = 100.*(diff./level_in_db(4:end-4));
[maxpercdiff mpdidx] = max(percdiff);
[maxdiff mdidx] = max(diff);
avgpercdiff = sum(percdiff)/length(percdiff);

% Display results
disp('Maximum Percent Difference = ');
disp(maxpercdiff);
disp('Maximum Difference = ');
disp(maxdiff);
disp('Average Percent Difference');
disp(avgpercdiff);

disp('Max Diff Input Value = ');
disp(level_in(mdidx+4));
disp('Max Perc Diff Input Value = ');
disp(level_in(mpdidx+4));

avgdiff = sum(diff)/length(diff);
bitprecision = log2(avgdiff)
guaranteedbits = log2(maxdiff);

% Calculating addressing error

% Calculating gain error
gain = gain(2:end-3);
out.gain = out.gain(5:end);
gain_error = abs(out.gain - gain);
perc_gain_error = 100.*(gain_error ./ gain);
avg_perc_gain_error = (sum(perc_gain_error)/length(gain));
disp('Average Percent Error: Gain = ');
disp(avg_perc_gain_error);

% Calculating frac error
frac = frac(2:end-3);
out.frac = out.frac(5:end);
zeros = find(frac == 0);
frac(zeros) = [];
out.frac(zeros) = [];
frac_error = abs(out.frac - frac);
perc_frac_error = 100.*(frac_error ./ frac);
avg_perc_frac_error = (sum(perc_frac_error)/length(frac));
disp('Average Percent Error: Frac = ');
disp(avg_perc_frac_error);

%% Plotting Theoretical vs. Experimental Gain

figure()
plot(level_in_db(1:end-4),gain,'b');
hold on;
plot(level_in_db(1:end-4),out.gain,'r');
hold off;
xlabel('Input Level [Pa^2]');
ylabel('Output Gain Factor');
title('Gain Table Output: Actual vs. Expected Results');
legend('Expected Gain Values','Lookup Table Gain Values','Location','southeast');

%% Plotting Experimental vs FPGA-in-the-Loop Gain

figure()
plot(out.gain,'b');
hold on;
plot(out.gain_fpga,'r');
hold off;