% sm_callback_init
%
% This scripts initializes the model variables and parameters. The script 
% runs before the simulation starts.  This is called in the InitFcn callback 
% found in Model Explorer.
%
% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

%% Make sure that sm_run_me_first has actually been run first.
% if not, run it first since it sets up paths and toolchains
if isfield(mp,'sim_prompts') == 0
    cd ..
    sm_run_me_first;
end

%% Set Audio Data Sample Rate
mp.Fs = 48000;    % sample rate frequency of AD1939 codec in Hz
mp.Ts = 1/mp.Fs;  % sample period

%% Set the FPGA system clock frequency (frequency of the FPGA fabric)
% The system clock frequency should be an integer multiple of the Audio codec AD1939 Mclk frequency (12.288 MHz)
if mp.fastsim_flag == 0
    mp.Fs_system = 98304000;        % System clock frequency in Hz of Avalon Interface  Mclk*8 = 12.288MHz*8=98304000
else
    mp.Fs_system = mp.Fs * mp.fastsim_Fs_system_N;          % Note: For faster development runs (faster sim times), reduce the number of system clocks between samples.  mp.fastsim_Fs_system_N is set in sm_run_me_first.m
end
mp.Ts_system   = 1/mp.Fs_system;         % System clock period
mp.rate_change = mp.Fs_system/mp.Fs;   % how much faster the system clock is to the sample clock

%% Set the data type for audio signal (left and right channels) in data plane
mp.W_bits = 32;  % Word length
mp.F_bits = 28;  % Number of fractional bits in word

%% Create the control signals
mp = sm_init_control_signals(mp);  % create the control signals

%% Create test signals for the left and right channels
mp = sm_init_test_signals(mp);  % create the test signals that will go through the model
stop_time = mp.test_signal.duration;  % simulation time is based on the number of audio samples to go through the model
if mp.sim_prompts == 1  % Note: sim_prompts is set in Run_me_first.m and is set to zero when hdl code generation is run
    Nsamples_avalon = mp.test_signal.Nsamples * mp.rate_change;
    disp(['Simulation time has been set to ' num2str(stop_time) ' seconds'])
    disp(['    Processing ' num2str(Nsamples_avalon) ' Avalon streaming samples.'])
    disp(['          To reduce simulation time for development iterations,'])
    disp(['          reduce the system clock variable Fs_system (current set to ' num2str(mp.Fs_system)  ')'])
    disp(['          and/or reduce the test signal length (current set to ' num2str(mp.test_signal.duration)  ' sec = ' num2str(mp.test_signal.Nsamples)  ' samples)'])
end

%% Put the test signals into the Avalon Streaming Bus format
% i.e. put the test signals into the data-channel-valid protocol
mp = sm_init_avalon_signals(mp);  % create the avalon streaming signals 

%% Add Filter Signals
% i.e. Add any filter coefficient files to use in the FIR Filter block
load('test_filters.mat');
load('LPF_PB1000_SB1300.mat');
load('HPF_SB1400_PB1700.mat');
mp.LPF = b_k_LPF;
mp.HPF = b_k_HPF;
mp.LPF_1000 = LPF_PB1000_SB1300;
mp.HPF_1400 = HPF_SB1400_PB1700;

% Convention:
% mp.FILTER_IDENTIFIER = [COEFFICIENT_VECTOR]
% % Redefine Table input signals, as well as Data_In and the time vector 
% Table_Wr_Data = [zeros(1,length(dataIn)), newTableData, zeros(1,length(dataIn))];
% tt = 0:length(Table_Wr_Data)-1;
% tt = tt.*ts;
% Data_In = [dataIn, zeros(1,length(newTableData)), dataIn];
% Table_Wr_Addr = [zeros(1,length(dataIn)), 0:length(newTableData)-1, zeros(1,length(dataIn))];
% Wr_En = [zeros(1,length(dataIn)), ones(1,length(newTableData)), zeros(1,length(dataIn))];
% 
% simin_Data_In = [tt',Data_In'];
% simin_Table_Wr_Data = [tt',Table_Wr_Data'];
% simin_Table_Wr_Addr = [tt',Table_Wr_Addr'];
% simin_Wr_En = [tt',Wr_En'];
% stop_time = tt(end);

% dataIn = input signal
% zeros  = time to 

%% Psuedo Code
% Preload FIR -> Filter Test Signal -> Load new FIR -> Filter Test Signal
% AGAIN -> DONE

%% UNCOMMENT TO REPROGRAM 
% Make an address signal
% RW_Addr = [zeros(1, length(mp.Avalon_Source_Data.time(:))), ...
%            0:length(HPF_SB1400_PB1700)-1, ... 
%            zeros(1, length(mp.Avalon_Source_Data.time(:))) ];
% % Make a filter data signal
% Wr_Data = [zeros(1, length(mp.Avalon_Source_Data.time(:))), ...
%            HPF_SB1400_PB1700, ... 
%            zeros(1, length(mp.Avalon_Source_Data.time(:))) ];
% % Make an enable signal for writing
% Wr_En   = [zeros(1, length(mp.Avalon_Source_Data.time(:))), ...
%            ones(1, length(HPF_SB1400_PB1700)), ... 
%            zeros(1, length(mp.Avalon_Source_Data.time(:))) ];
% % Modify Register Control signals
% tt = 0:length(Wr_En)-1; 
% tt = tt'.*mp.Ts_system;
% mp.register(1).timeseries = [tt, ones(length(tt), 1)];
% mp.register(2).timeseries = [tt, Wr_Data'];
% mp.register(3).timeseries = [tt, RW_Addr'];
% mp.register(4).timeseries = [tt, Wr_En'];
% 
% % Modify Input Control signals 
% mp.Avalon_Source_Data     = [tt, [mp.Avalon_Source_Data.data(:) ;... 
%                                   zeros(length(HPF_SB1400_PB1700), 1) ;...
%                                   mp.Avalon_Source_Data.data(:) ] ];
% 
% mp.Avalon_Source_Valid    = [tt, [mp.Avalon_Source_Valid.data(:) ;... 
%                                   zeros(length(HPF_SB1400_PB1700), 1) ;...
%                                   mp.Avalon_Source_Valid.data(:) ] ];
%                               
% mp.Avalon_Source_Channel  = [tt, [mp.Avalon_Source_Channel.data(:) ;... 
%                                   zeros(length(HPF_SB1400_PB1700), 1) ;...
%                                   mp.Avalon_Source_Channel.data(:) ] ];
%                               
% mp.Avalon_Source_Error    = [tt, [mp.Avalon_Source_Error.data(:) ;... 
%                                   zeros(length(HPF_SB1400_PB1700), 1) ;...
%                                   mp.Avalon_Source_Error.data(:) ] ];
% 
% stop_time = tt(end);