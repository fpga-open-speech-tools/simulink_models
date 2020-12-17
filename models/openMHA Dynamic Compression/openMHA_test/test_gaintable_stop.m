% Matthew Blunt
% openMHA Test Gaintable Stop Script
% 08/13/2020

% Created to test gaintable functionality during openMHA implementation

%% Calculating Theoretical Results

vy_address_low = [];
frac = [];
for i = 1:96/4
    vy_address_low = [vy_address_low i i i i];
    frac = [frac 0 0.25 0.5 0.75];
end
vy_address_low = [vy_address_low ones(1,4) write_addrA(101:228) vy_address_low];
vy_address_high = vy_address_low + 1;
frac = [frac zeros(1,132) frac];

gain(1:96) = gt(vy_address_low(1:96)) + frac(1:96).*(gt(vy_address_high(1:96)) - gt(vy_address_low(1:96)));
gain = [gain zeros(1,132)];
gain2 = newgt(vy_address_low(229:324)) + frac(229:324).*(newgt(vy_address_high(229:324)) - newgt(vy_address_low(229:324)));
gain = [gain gain2];

%% Plotting Resulting I/O Characteristic

% Converting gains to dB
gain_levels_db = 20.*log10(gain);

% Calculating output levels in dB
output_levels_db = level_in_filtered + gain_levels_db;

figure()
plot(level_in_filtered(1:96), output_levels_db(1:96), '-r');
hold on;
plot(input_levels_db,input_levels_db + gtdata, 'b');
hold off;


%% Compare Results

% Calculating frac error
zeros = find(frac == 0);
frac(zeros) = [];
out.frac(zeros) = [];
frac_error = abs(out.frac - frac');
perc_frac_error = 100.*(frac_error ./ frac');
avg_perc_frac_error = (sum(perc_frac_error)/length(frac));
disp('Average Percent Error: Frac = ');
disp(avg_perc_frac_error);

% Calculating gain error
gain = gain(1:end-1)';
out.gain = out.gain(2:end);
zeros = find(gain == 0);
gain(zeros) = [];
out.gain(zeros) = [];
gain_error = abs(out.gain - gain);
perc_gain_error = 100.*(gain_error ./ gain);
avg_perc_gain_error = (sum(perc_gain_error)/length(gain));
disp('Average Percent Error: Gain = ');
disp(avg_perc_gain_error);

figure()
plot(out.gain);
hold on;
plot(gain);
hold off;



