%--------------------------------------------------------------------------
% Description:  Matlab script to initialize Model variables and parameters
%               The script runs before the simulation starts (InitFcn
%               callback found in Model Explorer)
%--------------------------------------------------------------------------
% Author:       Ross K. Snider
% Company:      Flat Earth Inc
%               985 Technology Blvd
%               Bozeman, MT 59718
%               support@flatearthinc.com
% Create Date:  June 7, 2019
% Tool Version: MATLAB R2019a
% Revision:     1.0
% License:      MIT License (see license at end of code)
%--------------------------------------------------------------------------
%------------- BEGIN CODE --------------
%--------------------------------------------------------------------------
% Data Sample Rate
%--------------------------------------------------------------------------
Fs = 48000; % sample rate frequency of AD1939 codec in Hz
Ts = 1/Fs;  % sample period

%--------------------------------------------------------------------------
% System clock frequency (frequency of FPGA fabric)
% The frequency should be an integer multiple of the Mclk frequency (12.288 MHz)
%--------------------------------------------------------------------------
Fs_system = 49152000;      % System clock frequency in Hz of Avalon Interface  Mclk*4 = 12.288MHz*4=49152000
%Fs_system = Fs*4;         % Note: For faster development runs (faster sim times), reduce the number of system clocks between samples
Ts_system = 1/Fs_system;   % System clock period

rate_change = Fs_system/Fs;   % how much faster the system clock is to the sample clock

%--------------------------------------------------------------------------
% Sample data type in data plane
%--------------------------------------------------------------------------
W_bits = 32;  % Word length
F_bits = 28;  % Number of fractional bits in word

%--------------------------------------------------------------------------
% Create the control signals
%--------------------------------------------------------------------------
Register_Control_Left_Gain  = 1.0;
Register_Control_Right_Gain = 0.5;
% put the control signals into a timeseries format
Register_Control_Left_Gain_ts  = timeseries(Register_Control_Left_Gain,0);  % timeseries(datavals,timevals);
Register_Control_Right_Gain_ts = timeseries(Register_Control_Right_Gain,0);  % timeseries(datavals,timevals);

%--------------------------------------------------------------------------
% Create test signals for left and right channels
%--------------------------------------------------------------------------
Duration = 1;  % duration in seconds
Nsamples = round(Duration*Fs);
sample_times = [0 1:(Nsamples-1)]*Ts;
left_data_in  = cos(2*pi*2000*sample_times);
right_data_in = cos(2*pi*3000*sample_times);

stop_time = Nsamples*Ts;  % simulation time
disp(['Simulation time will be ' num2str(stop_time) ' seconds'])
disp(['    To reduce simulation time for development iterations,'])
disp(['    temporarily reduce the system clock variable Fs_system'])

%-------------------------------------------------------------------------
% Create the Avalon Streaming Signals, i.e. put the test signals into the 
% data-channel-valid protocol
%-------------------------------------------------------------------------
datavals_data    = zeros(1,Nsamples);   % preallocate arrays
datavals_valid   = zeros(1,Nsamples); 
datavals_channel = zeros(1,Nsamples); 
datavals_error   = zeros(1,Nsamples); 
dataval_index = 1;
for sample_index = 1:Nsamples
    %----------------------------
    % left channel
    %----------------------------
    datavals_data(dataval_index)     = left_data_in(sample_index); 
    datavals_valid(dataval_index)    = 1; 
    datavals_channel(dataval_index)  = 0;   % channel 0 = left
    datavals_error(dataval_index)    = 0;  
    dataval_index                    = dataval_index + 1;
    %----------------------------
    % right channel
    %----------------------------
    datavals_data(dataval_index)     = right_data_in(sample_index); 
    datavals_valid(dataval_index)    = 1; 
    datavals_channel(dataval_index)  = 1;  % channel 1 = right
    datavals_error(dataval_index)    = 0;  
    dataval_index                    = dataval_index + 1;
    %---------------------------------------------
    % fill in the invalid data slots with zeros
    %---------------------------------------------
    for k=1:(rate_change-2)
        datavals_data(dataval_index)    = 0; 
        datavals_valid(dataval_index)   = 0; 
        datavals_channel(dataval_index) = 3;  % channel 3 = no data
        datavals_error(dataval_index)   = 0;  
        dataval_index                   = dataval_index + 1;
    end
end

%--------------------------------------------------------------------------
% Convert to time series objects that can be read from "From Workspace"
% blocks
%--------------------------------------------------------------------------
Ndatavals = length(datavals_data);  % get number of data points
timevals  =  [0 1:(Ndatavals-1)]*Ts_system;  % get associated times
Avalon_Source_Data     = timeseries(datavals_data,timevals);
Avalon_Source_Valid    = timeseries(datavals_valid,timevals);
Avalon_Source_Channel  = timeseries(datavals_channel,timevals);
Avalon_Source_Error    = timeseries(datavals_error,timevals);

%--------------------------------------------------------------------------
%------------- END OF CODE --------------
%--------------------------------------------------------------------------
% MIT License
% Copyright (c) 2019 Flat Earth Inc
%
%Permission is hereby granted, free of charge, to any person obtaining a copy
%of this software and associated documentation files (the "Software"), to deal
%in the Software without restriction, including without limitation the rights
%to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%copies of the Software, and to permit persons to whom the Software is
%furnished to do so, subject to the following conditions:
%
%The above copyright notice and this permission notice shall be included in all
%copies or substantial portions of the Software.
%
%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%SOFTWARE.
%--------------------------------------------------------------------------
