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
if isfield(mp, 'sim_prompts') == 0
    sm_run_me_first;
end

%% Set Audio Data Sample Rate
mp.Fs = 48000;    % sample rate frequency of AD1939 codec in Hz
mp.Ts = 1/mp.Fs;  % sample period

%% Set the FPGA system clock frequency (frequency of the FPGA fabric)
% The frequency should be an integer multiple of the Mclk frequency (12.288 MHz)
if mp.fastsim_flag == 0
    mp.Fs_system = 49152000;        % System clock frequency in Hz of Avalon Interface  Mclk*4 = 12.288MHz*4=49152000
else
    mp.Fs_system = mp.Fs * mp.fastsim_Fs_system_N;          % Note: For faster development runs (faster sim times), reduce the number of system clocks between samples.  mp.fastsim_Fs_system_N is set in sm_run_me_first.m
end
mp.Ts_system = 1/mp.Fs_system;         % System clock period
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

%% Configure target system
mp.target_system = "de10";

%% place variables into workspace directly (debug)
% Avalon_Source_Data    = SG.Avalon_Source_Data;    % place into workspace directly so that the "From Workspace" blocks can read from these variables
% Avalon_Source_Valid   = SG.Avalon_Source_Valid;    
% Avalon_Source_Channel = SG.Avalon_Source_Channel;  
% Avalon_Source_Error   = SG.Avalon_Source_Error;    
% Ts_system = SG.Ts_system;
% W_bits = SG.W_bits;
% F_bits = SG.F_bits;
TABLE_SEL_BYPASS_ENABLE = 0; % 1 means the compression blocks will output 0s until Register_Addr is greater than 4, meaning the tables are not being programmed.
% this will be refactored as a top-level bypass of the system's output while the RAMs or pFIRs are being programmed.
% NOTE: in it's current iteration, this prevents us from writing to RAMs during runtime.
sm_compression_init;

FIR_0_Size = (ceil(log2(length(calib_bpfs(2:calib_bpfs(1,1)+1 ,1)'))));
FIR_0_Uprate = 2^FIR_0_Size;
B_k_0_init = zeros(1,FIR_0_Uprate);
B_k_0_init(1:calib_bpfs(1,1)) = calib_bpfs(2:calib_bpfs(1,1)+1 ,1)';

FIR_1_Size = (ceil(log2(length(calib_bpfs(2:calib_bpfs(1,2)+1 ,2)'))));
FIR_1_Uprate = 2^FIR_0_Size;
B_k_1_init = zeros(1,FIR_0_Uprate);
B_k_1_init(1:calib_bpfs(1,2)) = calib_bpfs(2:calib_bpfs(1,2)+1 ,2)';

FIR_2_Size = (ceil(log2(length(calib_bpfs(2:calib_bpfs(1,3)+1 ,3)'))));
FIR_2_Uprate = 2^FIR_0_Size;
B_k_2_init = zeros(1,FIR_0_Uprate);
B_k_2_init(1:calib_bpfs(1,3)) = calib_bpfs(2:calib_bpfs(1,3)+1 ,3)';

FIR_3_Size = (ceil(log2(length(calib_bpfs(2:calib_bpfs(1,4)+1 ,4)'))));
FIR_3_Uprate = 2^FIR_0_Size;
B_k_3_init = zeros(1,FIR_0_Uprate);
B_k_3_init(1:calib_bpfs(1,4)) = calib_bpfs(2:calib_bpfs(1,4)+1 ,4)';

FIR_4_Size = (ceil(log2(length(calib_bpfs(2:calib_bpfs(1,5)+1 ,5)'))));
FIR_4_Uprate = 2^FIR_0_Size;
B_k_4_init = zeros(1,FIR_0_Uprate);
B_k_4_init(1:calib_bpfs(1,5)) = calib_bpfs(2:calib_bpfs(1,5)+1 ,5)';

FIR_5_Size = (ceil(log2(length(ig_eq))));
FIR_5_Uprate = 2^FIR_0_Size;
B_k_5_init = zeros(1,FIR_0_Uprate);
B_k_5_init(1:length(ig_eq)) = ig_eq;
