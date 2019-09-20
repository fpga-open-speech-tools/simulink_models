%% dummy_beamformer_param - DSPBA Design Parameters Start
clear dummy_beamformer_param; 

%% System Parameters
dummy_beamformer_param.ChanCount   = 16;                                                  % How many data channels
dummy_beamformer_param.ClockRate   = 98.304;                                              % The system clock rate in MHz
dummy_beamformer_param.SampleRate  = 48e-3*16;            % The data rate per channel in MSps (mega-samples per second)
dummy_beamformer_param.ClockMargin = 0.0;         

%% Data Type Specification
dummy_beamformer_param.input_word_length      = 32;         % Input data: bit width
dummy_beamformer_param.input_fraction_length  = 28;         % Input data: fraction width

dummy_beamformer_param.output_word_length     = 32;         % Output data: bit width
dummy_beamformer_param.output_fraction_length = 28;         % Output data: fraction width

dummy_beamformer_param.signed = 1;


%% Stimulus setup
dummy_beamformer_param.input_range = range(fi(0,dummy_beamformer_param.signed, 24, 24));

dummy_beamformer_param.input_data = double(dummy_beamformer_param.input_range(1)) + ...
    (double(dummy_beamformer_param.input_range(2))-double(dummy_beamformer_param.input_range(1))).*rand(100,1);
dummy_beamformer_param.input_data = repelem(dummy_beamformer_param.input_data, 128);
dummy_beamformer_param.chan_stim = repelem(0:dummy_beamformer_param.ChanCount-1, 128);


%% Simulation Parameters
dummy_beamformer_param.SampleTime  = dummy_beamformer_param.ClockRate/dummy_beamformer_param.SampleRate;                    % One unit in Simulink simulation is one clock cycle 
dummy_beamformer_param.ClockCycle  = 1;
dummy_beamformer_param.endTime     = 5000;                 % How many simulation clock cycles


%% Derived Parameters 
dummy_beamformer_param.Period          = dummy_beamformer_param.ClockRate / dummy_beamformer_param.SampleRate;           % Clock cycles between consecutive data samples for a particular channel
dummy_beamformer_param.ChanWireCount   = ceil(dummy_beamformer_param.ChanCount/dummy_beamformer_param.Period);           % How many wires are needed to support the specified number of channels?
dummy_beamformer_param.ChanCycleCount  = ceil(dummy_beamformer_param.ChanCount/dummy_beamformer_param.ChanWireCount);    % Range of the channel signal
dummy_beamformer_param.ChanWidth = ceil(log2(dummy_beamformer_param.ChanCount));

%% DSPBA Design Parameters End
