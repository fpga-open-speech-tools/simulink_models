% Matthew Blunt
% openMHA Test Dual Port Init Script
% 08/13/2020

% Created to test dual rate dual port memory functionality during 
% openMHA implementation

%% Initialize Dual Port Memory Gain Table

tableInit = zeros(256,1);
tableInit(1:26) = 0:2:50;

%% Declare Input Signals

% Simulated Gain Table Addresses
vy_address_low = zeros(75,1);
vy_address_high = zeros(75,1);
vy_address_low(1:25) = 0:24;
vy_address_high(1:25) = 1:25;
vy_address_low(26:38) = 0:2:24;
vy_address_low(39:50) = 0:2:22;
vy_address_high(26:37) = 1:2:23;
vy_address_high(38) = 23;
vy_address_high(39:50) = 1:2:23;
vy_address_low(51:75) = vy_address_low(1:25);
vy_address_high(51:75) = vy_address_high(1:25);

% Simulated Control Signal indicating Write from ARM CPU
vy_write_en = zeros(75,1);
vy_write_en(26:50) = 1;

% Simulated New Gain Table Values coming from ARM CPU
vy_new_gain_low = zeros(75,1);
vy_new_gain_high = zeros(75,1);
vy_new_gain_low(26:38) = 0:2:24;
vy_new_gain_high(26:37) = 1:2:23;
vy_new_gain_high(38) = 23;
vy_new_gain_low(39:50) = 0:2:22;
vy_new_gain_high(39:50) = 1:2:23;


%% Declare Stop Time

stop_time = length(vy_address_low) - 1;
