%------------------------------------------------------
% System Setup
%------------------------------------------------------
Fs = 48000; % target sample rate frequency of AD1939 codec
Ts = 1/Fs;

Fs_system = 49152000;      % System clock frequency in Hz of Avalon Interface  Mclk*4 = 12.288MHz*4=49152000
%Fs_system = Fs*4;      % System clock frequency in Hz of Avalon Interface
Ts_system = 1/Fs_system;  % System clock period

rate_change = Fs_system/Fs;

W_bits = 32;
F_bits = 28;

%-------------------------------------------------------------------------
% Registers for Avalon Data Processing
%-------------------------------------------------------------------------
Register_Control_Left_Gain = 1;      
Register_Control_Left_Gain_Nbits = 32;   % 32 bits for Avalon data bus    
Register_Control_Right_Gain = 1;      
Register_Control_Right_Gain_Nbits = 32;   % 32 bits for Avalon data bus    

%-------------------------------------------------------------------------
% Registers for Signal Energy LED Driver
%-------------------------------------------------------------------------
Register_Control_reset_threshold_time = 200;       % time in milliseconds
Register_Control_Reset_Threshold = Register_Control_reset_threshold_time/1000 * Fs;  % reset time in number of samples
Register_Control_Reset_Nbits = 32;    % 32 bits for Avalon data bus      

Register_Control_LED_persistence_time = 50;       % time in milliseconds
Register_Control_LED_Persistence = Register_Control_LED_persistence_time/1000 * Fs;    % persistence time in number of samples
Register_Control_LED_Persistence_Nbits = 32;   % 32 bits for Avalon data bus    


%------------------------------------------------------------
% Create a test signals for left and right channels
%------------------------------------------------------------
Nsamples = Fs*1/32;
sample_times = [0 1:(Nsamples-1)]*Ts;
test_signal_left  = cos(2*pi*2000*sample_times);
test_signal_right = cos(2*pi*2000*sample_times);

stop_time = Nsamples*Ts;

%-------------------------------------------------------------------------
% Create the Avalon Streaming Signals (data-channel-valid)
%-------------------------------------------------------------------------
dataval_index = 1;
for sample_index = 1:Nsamples
    %----------------------------
    % left channel
    %----------------------------
    datavals_data(dataval_index)     = test_signal_left(sample_index); 
    datavals_valid(dataval_index)     = 1; 
    datavals_channel(dataval_index) = 0;   % channel 0 = left
    datavals_error(dataval_index)    = 0;  
    dataval_index = dataval_index + 1;
    %----------------------------
    % right channel
    %----------------------------
    datavals_data(dataval_index)     = test_signal_right(sample_index); 
    datavals_valid(dataval_index)     = 1; 
    datavals_channel(dataval_index) = 1;  % channel 1 = right
    datavals_error(dataval_index)     = 0;  
    dataval_index = dataval_index + 1;
    %----------------------------
    % fill in the invalid data slots with zeros
    %----------------------------
    for k=1:(rate_change-2)
        datavals_data(dataval_index)     = 0; 
        datavals_valid(dataval_index)     = 0; 
        datavals_channel(dataval_index) = 3;  % channel 3 = no data
        datavals_error(dataval_index)    = 0;  
        dataval_index = dataval_index + 1;
    end
end

Ndatavals = length(datavals_data);
timevals =  [0 1:(Ndatavals-1)]*Ts_system;

Avalon_Source_Data     = timeseries(datavals_data,timevals);
Avalon_Source_Valid     = timeseries(datavals_valid,timevals);
Avalon_Source_Channel = timeseries(datavals_channel,timevals);
Avalon_Source_Error      = timeseries(datavals_error,timevals);


