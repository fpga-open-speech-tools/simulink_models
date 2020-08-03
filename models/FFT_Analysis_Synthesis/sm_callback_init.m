%% Set the fastsim flag
% Value	Meaning
% 0	    Full Simulation.  Target (Fast) System Clock.  Entire audio signal.  Caution!!  You are likely to run out of memory and the Simulation time will take forever.
% 1	    Developer’s Mode*.  Slow System Clock.  Entire audio signal.  Typical setting for development. This is to reduce the simulation time on the entire signal.  Typical system clock is 2x or 4x of the audio signal sample rate.
% 2	    Fast Developer’s Mode.  Slow System Clock.  Truncated audio signal.  This is to further reduce the simulation time.  The audio signal is truncated, but can be longer than what is set for the HDL Coder Mode.
% 3	    HDL Coder Mode*.  Target (Fast) System Clock.  Truncated audio signal.  HDL Coder will run a simulation, which needs to be at the Target System Clock.  The audio signal needs to be truncated for a reasonable fast simulation time.  The simulation is assumed to be correct at this point.
mp.fastsim_flag = 3;

%% Set Audio Data Sample Rate
mp.Fs = 48000;    % sample rate frequency of AD1939 codec in Hz
mp.Ts = 1/mp.Fs;  % sample period

%% Set FFT size
mp.FFT_size = 128;
mp.FFT_size_Nbits = log2(mp.FFT_size);
mp.FFT_size_half = mp.FFT_size/2;
mp.FFT_frame_shift = mp.FFT_size/4;  % Changiing this from a divide by four implies substantial architectural changes
mp.FFT_frame_shift_Nbits = log2(mp.FFT_frame_shift);

mp.DPRAM1_size = mp.FFT_size*2;  % number of words
mp.DPRAM1_address_size = log2(mp.DPRAM1_size);

mp.SysRate_Upsample_Factor = mp.FFT_size/mp.FFT_frame_shift * 8 * 4;  % How much faster the fast clock must be to complete a FFT within the time of FFT_frame_shift number of samples


%% Set the FPGA system clock frequency (frequency of the FPGA fabric)
% The system clock frequency should be an integer multiple of the Audio codec AD1939 Mclk frequency (12.288 MHz)
switch mp.fastsim_flag  % set system clock and audio length based on simulation mode
    case 0
        mp.Fs_system = 98304000;        % System clock frequency in Hz of Avalon Interface  Mclk*8 = 12.288MHz*8=98304000
        mp.Naudio_samples = -1;         % -1 = no truncation
    case 1
        mp.Fs_system = mp.Fs * 2;       % slow system clock
        mp.Naudio_samples = -1;         % -1 = no truncation
    case 2
        mp.Fs_system = mp.Fs * 2;       % slow system clock
        mp.Naudio_samples = mp.Fs;      % audio truncated to 1 second
    case 3
        mp.Fs_system = mp.Fs;        % System clock frequency in Hz of Avalon Interface  Mclk*8 = 12.288MHz*8=98304000
        mp.Naudio_samples = mp.Fs/1000;   % audio truncated to 100 milliseconds
end
mp.Ts_system = 1/mp.Fs_system;         % System clock period

%% Set the data type for audio signal (left and right channels) in data plane
mp.W_bits = 24;  % Word length
mp.F_bits = 23;  % Number of fractional bits in word

%% Setup the FFT filters (lookup tables)
mp = sm_init_FFT_filters(mp);

%% Create test signals for the left and right channels
mp = sm_init_test_signals(mp);  % create the test signals that will go through the model
stop_time = mp.test_signal.duration;
%% Put the test signals into the Avalon Streaming Bus format
% i.e. put the test signals into the data-channel-valid protocol
mp = sm_init_avalon_signals(mp);  % create the avalon streaming signals 

%% Create the control signals
mp = sm_init_control_signals(mp);

