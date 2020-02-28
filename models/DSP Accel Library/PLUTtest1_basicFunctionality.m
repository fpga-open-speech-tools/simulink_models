%% Testing and Verification script for Log-Spaced Programmable Look-Up Table (PLUT)
% PLUTtest1_basicFunctionality.m
% This script is built for the testingPLUT.slx model.
% It tests and verifies the following functionality: 
%  - Sizing of Table for an initial given accuracy and function
%  - Initialization of memory
%  - Addressing scheme of log-spaced inputs 
%  - Linear Interpolation
%  - Accuracy of results 
% Reprogramming during runtime will be in a second script, PLUTtest2_reprogramming.m 

% Mask Parameters of PLUT block:


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Before Running Simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run this section of code (ctrl + Enter) before running the simulation on testingPLUT.slx 
% Define Simulation variables
x_in = 0:0.001:3;					% Input data range, note it includes 0 and goes beyond the upper "expected input" bound
ts = 1/48000; 						% sample time 
tt = 0:length(x_in)-1;				
tt = tt.*ts;						% Note: Division tends to cause strange errors in simulation. Always use fixed-step time ts for consistent results.

% Setting up time series sets for Simulink inputs 
simin_Data_In = [tt',x_in'];		
simin_Table_Wr_Data = [tt',zeros(length(x_in),1)];	% no reprogramming the table during this test. Set these 3 to 0s
simin_Table_Wr_Addr = [tt',zeros(length(x_in),1)];
simin_Wr_En = [tt',zeros(length(x_in),1)];
stop_time = tt(end);

% Now run the simulation, ensure fixed step time and ending time of stop_time 

%%%%%%%%%%%%%%%%%%%%%%%%
%% After Running
%%%%%%%%%%%%%%%%%%%%%%%%

% Pull information out of the simulation workspace and set it up for graphs and analysis 

output = out.simout.Data(:);
outputIdeal = sqrt(x_in);
address = addr.Data(:);
address(1:3000) = address(2:3001); % Simulation addresses take 1 sample of time to pipeline. This shifts them to line up with their respective inputs 
figure(3); plot(x_in,address);
title("Read addresses as a function of input (Time Corrected)");
xlabel("Input");
ylabel("Read Address");

output(1:2998) = output(4:3001); % Simulation output takes 3 samples of time to pipeline. This shifts them to line up with their respective inputs 
figure(2); plot(x_in,output, x_in,outputIdeal);
title("Output Data over Input, sqrt Function (Time Corrected)");
xlabel("Input");
ylabel("Read Address");
legend("Table Output", "Ideal Output");

% Since expected inputs are bound between 2^-15 and 1, only consider the accuracy of points within that range 
% allowed_in = (x_in <= 1) && (x_in >= 2^-15);
above = x_in >= 2^-15;
below = x_in <= 1;
allowed_in = above & below;

% identify addresses, outputs, and inputs associated with the expected input range 
valid_addr = address(allowed_in);
valid_out = output(allowed_in);
valid_out_ideal = outputIdeal(allowed_in);
valid_x_in = x_in(allowed_in);

% Identify error of those valid outputs 
err = (valid_out_ideal - valid_out')./valid_out_ideal;
max_err = max(err) % not ;'d to allow printout 
figure(4); semilogx(valid_x_in, 100*err);
title("Output Error as a function of Input");
xlabel("Input");
ylabel("Output Error %");