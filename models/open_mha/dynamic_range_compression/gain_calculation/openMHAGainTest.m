close all
clear
clc

%% Define some parameters
mins     = [ 0 50 44 35 57 70 20 15 ];
maxes    = [ 35 85 93 50 60 90 30 60 ];

inputRef = 4e-10; % Defined in the Gain Calculation dB Lookup Table reference model
inputdB  = 0:3:93;

% Compute the input level for comparison
inputLev = 10.^(inputdB/10)*inputRef;

%% Compute the gains
gainArray = calculateGainArray(mins, maxes, inputdB);

%% Plot the data
figure
subplot(211)
plot(gainArray)
ylabel('All Linear Gains')

subplot(212)
hold on
plot(10*log10(gainArray(1:length(inputLev))) + inputdB)
plot(10*log10(gainArray(1:length(inputLev)).*inputLev/inputRef),'--')
hold off
legend('Gain + dB Input','Full Multiplication');
ylabel('Signal Level [ dB ]')




















