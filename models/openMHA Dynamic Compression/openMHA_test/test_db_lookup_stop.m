% Matthew Blunt
% openMHA Test dB Lookup Gain Stop Script
% 08/19/2020

% Created to test dB lookup and gain calculation functionality during 
% openMHA implementation in order to gather error data and optimize lookup
% table solution

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

% % Calculating addressing error
% 
% % Calculating gain error
% gain = gain(1:end-1)';
% out.gain = out.gain(2:end);
% zeros = find(gain == 0);
% gain(zeros) = [];
% out.gain(zeros) = [];
% gain_error = abs(out.gain - gain);
% perc_gain_error = 100.*(gain_error ./ gain);
% avg_perc_gain_error = (sum(perc_gain_error)/length(gain));
% disp('Average Percent Error: Gain = ');
% disp(avg_perc_gain_error);
% 
% % Calculating frac error
% zeros = find(frac == 0);
% frac(zeros) = [];
% out.frac(zeros) = [];
% frac_error = abs(out.frac - frac');
% perc_frac_error = 100.*(frac_error ./ frac');
% avg_perc_frac_error = (sum(perc_frac_error)/length(frac));
% disp('Average Percent Error: Frac = ');
% disp(avg_perc_frac_error);

