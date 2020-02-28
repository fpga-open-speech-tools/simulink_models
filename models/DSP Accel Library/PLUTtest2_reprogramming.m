%% Testing and Verification script for Log-Spaced Programmable Look-Up Table (PLUT)
% PLUTtest2_reprogramming.m
% This script is built for the testingPLUT.slx model.
% It tests and verifies the following functionality: 
%  - Sizing of Table for an initial given accuracy and function
%  - Initialization of memory
%  - Addressing scheme of log-spaced inputs 
%  - Linear Interpolation
%  - Accuracy of results 
%  - Reprogramming during runtime 

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

% It is possible to identify these parameters by looking under the mask. Check the init script of the mask for more details
% With the mask values as defined in the comment above, the variables below are correct.
maxInput = 1;
M_bits = 4; N_bits = 4;
d = ceil(log2(maxInput));

% Define X_in, the inputs used to find table output values 
X_in = zeros(1, 2^(M_bits+N_bits));
addr = 1;

for NShifts = 2^N_bits-1:-1:0
    for M = 0:2^M_bits - 1
        X_in(addr) = 2^(d-NShifts) + M*2^(d-NShifts-M_bits);
        addr = addr+1;
    end
end

% Find new table values, Y_out 
Y_out = tanh(X_in); 

% Redefine Table input signals, as well as Data_In and the time vector 
Table_Wr_Data = [zeros(1,length(x_in)), Y_out, zeros(1,length(x_in))];
tt = 0:length(Table_Wr_Data)-1;
tt = tt.*ts;
Data_In = [x_in, zeros(1,length(Y_out)), x_in];
Table_Wr_Addr = [zeros(1,length(x_in)), 0:length(Y_out)-1, zeros(1,length(x_in))];
Wr_En = [zeros(1,length(x_in)), ones(1,length(Y_out)), zeros(1,length(x_in))];

simin_Data_In = [tt',Data_In'];
simin_Table_Wr_Data = [tt',Table_Wr_Data'];
simin_Table_Wr_Addr = [tt',Table_Wr_Addr'];
simin_Wr_En = [tt',Wr_En'];
stop_time = tt(end);

% Now run the simulation, ensure fixed step time and ending time of stop_time 

%%%%%%%%%%%%%%%%%%%%%%%%
%% After Running
%%%%%%%%%%%%%%%%%%%%%%%%

% Pull information out of the simulation workspace and set it up for graphs and analysis 

output = out.simout.Data(:);
outputIdeal = sqrt(x_in);
outputIdeal2 = tanh(x_in);
address = addr.Data(:);
address(1:end-1) = address(2:end); % Simulation addresses take 1 sample of time to pipeline. This shifts them to line up with their respective inputs 
figure(3); plot(x_in,address);
title("Read addresses as a function of input (Time Corrected)");
xlabel("Input");
ylabel("Read Address");

% Note that output will look strange when the input is not within the specified bounds, especially when there is a large non-fractional word size. 

output(1:end-3) = output(4:end); % Simulation output takes 3 samples of time to pipeline. This shifts them to line up with their respective inputs 
% Plot first function compared to its expected output 
figure(2); plot(x_in,output(<subset 1>), x_in,outputIdeal); 
title("Output Data over Input, sqrt Function (Time Corrected)");
xlabel("Input");
ylabel("Read Address");
legend("Table Output", "Ideal Output");

% Plot second function compared to its expected output 
figure(2); plot(x_in,output(<subset 2>), x_in,outputIdeal2); % Plot first function compared to its expected output 
title("Output Data over Input, sqrt Function (Time Corrected)");
xlabel("Input");
ylabel("Read Address");
legend("Table Output", "Ideal Output");

% NOTE: Error is not guaranteed to be within the same accuracy after reprogramming the table. 
% identify addresses, outputs, and inputs associated with the expected input range 
valid_addr = address(allowed_in);
valid_out = output(allowed_in);
valid_out_ideal = outputIdeal(allowed_in);
valid_x_in = x_in(allowed_in);

% Identify error of those valid outputs, note the inputs and outputs must be split into two graphs since the input set is the same. 
err = (valid_out_ideal - valid_out')./valid_out_ideal;
max_err = max(err) % not ;'d to allow printout 
figure(4); semilogx(valid_x_in, 100*err);
title("Output Error as a function of Input");
xlabel("Input");
ylabel("Output Error %");