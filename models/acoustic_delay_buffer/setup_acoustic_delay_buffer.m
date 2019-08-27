%% acoustic_delay_buffer_param - DSPBA Design Parameters Start
clear acoustic_delay_buffer_param; 

%% System Parameters
acoustic_delay_buffer_param.ChanCount   = 16;                                                  % How many data channels
acoustic_delay_buffer_param.ClockRate   = 98.304;                                              % The system clock rate in MHz
acoustic_delay_buffer_param.SampleRate  = 48e-3*16;            % The data rate per channel in MSps (mega-samples per second)
acoustic_delay_buffer_param.ClockMargin = 0.0;                                                 % Adjust the pipelining effort

%% Data Type Specification
acoustic_delay_buffer_param.input_word_length      = 32;         % Input data: bit width
acoustic_delay_buffer_param.input_fraction_length  = 28;         % Input data: fraction width

acoustic_delay_buffer_param.output_word_length     = 32;         % Output data: bit width
acoustic_delay_buffer_param.output_fraction_length = 28;         % Output data: fraction width

acoustic_delay_buffer_param.signed = 1;

%% Simulation Parameters
acoustic_delay_buffer_param.SampleTime  = acoustic_delay_buffer_param.ClockRate/acoustic_delay_buffer_param.SampleRate;                    % One unit in Simulink simulation is one clock cycle 
acoustic_delay_buffer_param.ClockCycle  = 1;
acoustic_delay_buffer_param.endTime     = 10000;                 % How many simulation clock cycles

%% Derived Parameters 
acoustic_delay_buffer_param.Period          = acoustic_delay_buffer_param.ClockRate / acoustic_delay_buffer_param.SampleRate;           % Clock cycles between consecutive data samples for a particular channel
acoustic_delay_buffer_param.ChanWireCount   = ceil(acoustic_delay_buffer_param.ChanCount/acoustic_delay_buffer_param.Period);           % How many wires are needed to support the specified number of channels?
acoustic_delay_buffer_param.ChanCycleCount  = ceil(acoustic_delay_buffer_param.ChanCount/acoustic_delay_buffer_param.ChanWireCount);    % Range of the channel signal

%% Stimulus setup
% get the range of possible fixed-point values
acoustic_delay_buffer_param.input_range = range(fi(0,acoustic_delay_buffer_param.signed, acoustic_delay_buffer_param.input_word_length, acoustic_delay_buffer_param.input_fraction_length));
% generate normally distributed data
acoustic_delay_buffer_param.input_data = double(acoustic_delay_buffer_param.input_range(1)) + ...
    (double(acoustic_delay_buffer_param.input_range(2))-double(acoustic_delay_buffer_param.input_range(1))).*rand(100,1);
% resample the data at the system clock rate; this allows the sampling rate
% of the stimulus blocks to all be the same
acoustic_delay_buffer_param.input_data = repelem(acoustic_delay_buffer_param.input_data, ...
    acoustic_delay_buffer_param.SampleTime);
acoustic_delay_buffer_param.chan_stim = repelem(0:acoustic_delay_buffer_param.ChanCount-1, ...
    acoustic_delay_buffer_param.SampleTime);

%% Dual port ram parameters
acoustic_delay_buffer_param.buffer_size = 4096; % this gives us a max source distance of 96.028 feet
acoustic_delay_buffer_param.addr_size = log2(acoustic_delay_buffer_param.buffer_size);

%% DSPBA Design Parameters End
