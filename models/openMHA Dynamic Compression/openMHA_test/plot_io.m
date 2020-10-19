% Matthew Blunt
% openMHA Dynamic Compression I/O Plot Test Script
% 08/12/2020

%------------------------------------------------------------------------%
% The following script is designed to quickly plot the Dynamic Compression
% I/O Characteristic given the gain table parameters. Note that the script
% should be run with the current MATLAB directory set to the following:

%                   Documents/openMHA-master/mfiles                      %

%------------------------------------------------------------------------%

gtmin = 16;
gtstep = 4;
gtdata = [37 40 39 38 37 36 35 34 33 32 31 30 26 22 18 14 10 6 2 -2 -2];
for i = 1:length(gtdata)
    input_levels_db(i) = gtmin + (i-1)*gtstep;
end
output_levels_db = dc_plot_io(gtmin, gtstep, gtdata, input_levels_db);
hold on;
plot(input_levels_db,input_levels_db);
hold off;

% Converting input levels from dB SPL to Squared Pascal
io = 4*10^-10;  % reference sound intensity
input_levels = io.*10.^(input_levels_db./10);

% Converting gain values from dB to linear factors
gtdata_map = 10.^(gtdata./20);

% Plotting new I/O Characteristic
figure()
plot(input_levels,gtdata_map);
xlabel('Input Levels [Pa^2]');
ylabel('Gain');


