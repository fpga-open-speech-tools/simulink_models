close all
clear
clc

%% Define some constants
mindB = 75;
maxdB = 85;
boost = 6;

inputRef = 4e-10; % Defined in the Gain Calculation dB Lookup Table reference model

% Create an array of linear input audio values
linInput = logspace(1,9,1e3)*inputRef; % logspace(a,b,n) => n logarithmically spaced points from 10^a to 10^b
% linInput = linspace(1,9,1e3)*inputRef; % logspace(a,b,n) => n logarithmically spaced points from 10^a to 10^b

% Define the output dB gain array (0 dB == unity gain)
gdB = zeros(size(linInput));


%% Compute the input dB levels as well as the inverse function for a sanity check
indB = 10*log10(linInput/inputRef);
linOutput = 10.^(indB/10)*inputRef;

%% Plot the results
figure
plot(linInput,indB)
title('Linear Input vs Corresponding dB')

figure
hold on
plot(linInput)
plot(linOutput,'--')
hold off
legend('Input Values','Inverse Calculation Values')
title('Input vs the Inverse Conversion')

%% Define the piecewise functions
gdB(indB > maxdB) = maxdB - indB(indB > maxdB);
gdB(indB < mindB+boost) = mindB - indB(indB < mindB+boost) + boost;

%% Plot the piecewise gain function
figure
plot(indB,gdB);
title('dB Input vs Corresponding dB Gain')

%% Calculate the inverse function and multiply the input by the gain/attenuation value
gain = 10.^(gdB/10);
figure
plot(linInput,gain)
title('Linear Input vs Corresponding Linear Gain')

figure
plot(linInput,10*log10(linInput.*gain/inputRef))
title('Linear Input vs Corresponding Adjusted dB Level')

figure
hold on
plot(linInput)
plot(linInput.*gain,'--')
hold off
title('Linear Input vs Scaled Input')
legend('Input Values','Scaled Values')