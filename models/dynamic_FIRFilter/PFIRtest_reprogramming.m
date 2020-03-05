%% Testing and Verification script for Log-Spaced Programmable Look-Up Table (PLUT)
% PFIRtest_reprogramming.m
% This script is built for the testingPLUT.slx model.
% It tests and verifies the following functionality: 
%  - Sizing of Table for an initial given accuracy and function
%  - Initialization of memory
%  - Addressing scheme of log-spaced inputs 
%  - Linear Interpolation
%  - Accuracy of results 
%  - Reprogramming during runtime 

% Instructions for setting up the simulation given in "Testing of the PLUT Instructions.docx"


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Before Running Simulation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all;
% Run this section of code (ctrl + Enter) before running the simulation on testingPLUT.slx 
% Define Simulation variables
dataIn = 0:0.001:3;					% Input data range, note it includes 0 and goes beyond the upper "expected input" bound
ts = 1/48000; 						% sample time 
tt = 0:length(dataIn)-1;				
tt = tt.*ts;						% Note: Division tends to cause strange errors in simulation. Always use fixed-step time ts for consistent results.

% It is possible to identify these parameters by looking under the mask. Check the init script of the mask for more details
% With the mask values at default, the variables below are correct.
maxInput = 1;
M_bits = 3; N_bits = 4;
binaryOffset = ceil(log2(maxInput));

% Define xIn, the inputs used to find table output values
xIn = zeros(1, 2^(M_bits+N_bits));
addr = 1;

for NShifts = 2^N_bits-1:-1:0
    for M = 0:2^M_bits - 1
        xIn(addr) = 2^(binaryOffset-NShifts) + M*2^(binaryOffset-NShifts-M_bits);
        addr = addr+1;
    end
end

% Find new table values 
newTableData = tanh(xIn); 

% Redefine Table input signals, as well as Data_In and the time vector 
Table_Wr_Data = [zeros(1,length(dataIn)), newTableData, zeros(1,length(dataIn))];
tt = 0:length(Table_Wr_Data)-1;
tt = tt.*ts;
Data_In = [dataIn, zeros(1,length(newTableData)), dataIn];
Table_Wr_Addr = [zeros(1,length(dataIn)), 0:length(newTableData)-1, zeros(1,length(dataIn))];
Wr_En = [zeros(1,length(dataIn)), ones(1,length(newTableData)), zeros(1,length(dataIn))];

simin_Data_In = [tt',Data_In'];
simin_Table_Wr_Data = [tt',Table_Wr_Data'];
simin_Table_Wr_Addr = [tt',Table_Wr_Addr'];
simin_Wr_En = [tt',Wr_En'];
stop_time = tt(end);

% Now run the simulation, ensure fixed step time and ending time of stop_time 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% After Running Simulation %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pull information out of the simulation workspace and set it up for graphs and analysis 

output = out.Data_Out.Data(:);
outputIdeal = sqrt(dataIn);
outputIdeal2 = tanh(dataIn);

% Note that output will look strange when the input is not within the specified bounds, especially when there is a large non-fractional word size. 
outputDelay = 3;
output(1:end-3) = output(outputDelay+1:end); % Simulation output takes 3 samples of time to pipeline. This shifts them to line up with their respective inputs 

% Plot first function compared to its expected output 
figure(2); plot(dataIn,output(1:length(dataIn)), dataIn,outputIdeal); 
title("Output Data over Input, sqrt Function (Time Corrected)");
xlabel("Simulated Input");
ylabel("Simulated Output");
legend("Table Output", "Ideal Output");

% Plot second function compared to its expected output 
figure(3); plot(dataIn,output(length(dataIn)+length(newTableData)+1:end), dataIn,outputIdeal2); % grabbing the set after reprogramming is finished
title("Output Data over Input, tanh Function (Time Corrected)");
xlabel("Simulated Input");
ylabel("Simulated Output");
legend("Table Output", "Ideal Output");