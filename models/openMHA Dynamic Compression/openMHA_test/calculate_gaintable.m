
%% Gain Table Calculation

% Model Parameters
num_bands = 8;

% Table Minimum Value
gtmin = 0; 

% Table Step Size
gtstep = 3; 

% Table Data [dB]
gtdata = [0 15 25 32 34 36 38 40 39.25 38.5 37.75 37 36.25 35.5 34.75 34 33.25 32.5 31.75 31 28 25 22 19 16 13 10 7 4 1 -2 -2]';
table_length = length(gtdata);

% Reference Input Levels
for i = 1:length(gtdata)
    input_levels_db(i,1) = gtmin + (i-1)*gtstep;
end

% Converting Table Data to Linear Factors
vy = 10.^(gtdata./20);

% Calculating necessary memory size in hardware
numgainentries = table_length*num_bands;
RAM_size = ceil(log2(numgainentries));
RAM_addresses = 2^RAM_size;

% Filling Gain Table for Each Band
% (Assuming the same gains for each band - will change according to
% audiogram)
for i = 1:num_bands-1
    vy(32*i+1:32*(i+1),1) = vy(1:32,1);
end

% Padding Gain Table with zeros if necessary to fill memory
for i = length(vy)+1:RAM_addresses
    vy(i,1) = 0;
end

% Plotting Gain Function (Linear Gain Factors)
figure()
plot(input_levels_db, vy(1:32,1));
title('Dynamic Compression Gain Function - Linear Factor Gains');
xlabel('Input Level [dB]');
ylabel('Gain [factor]');

% Plotting Gain Function (dB Gains)
figure()
plot(input_levels_db, gtdata);
title('Dynamic Compression Gain Function - dB Gains');
xlabel('Input Level [dB]');
ylabel('Gain [dB]');

% Plotting I/O Function
figure()
plot(input_levels_db, input_levels_db);
hold on;
plot(input_levels_db, gtdata(1:32,1) + input_levels_db(1:32,1));
legend('Unadjusted Output Level','Adjusted Output Level','Location','northwest');
title('Dynamic Compression I/O Function');
xlabel('Input Level [dB]');
ylabel('Output Level [dB]');

