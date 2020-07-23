%%% Autogen 
%% Read the config
config_dir = erase(mfilename('fullpath'), mfilename); 
config_path = config_dir + "model.json";
config = jsondecode(fileread(config_path));

%% Set Audio Data
if isfield(config.system, "sampleClockFrequency")
    mp.Fs = config.system.sampleClockFrequency; 
else
    mp.Fs = 48000;
end
mp.Ts = 1/mp.Fs;  % sample period

if isfield(config.system, "numberOfChannels")
    mp.nChannels = config.system.numberOfChannels;
else
    mp.nChannels = 2;
end
% Set the data type for audio signal
mp.signed = config.system.inputDataType.signed;
mp.W_bits = config.system.inputDataType.wordLength;  % Word length
mp.F_bits = config.system.inputDataType.fractionLength;  % Number of fractional bits in word

%% Set the FPGA system clock frequency (frequency of the FPGA fabric)
% The system clock frequency should be an integer multiple of the Audio codec AD1939 Mclk frequency (12.288 MHz)
mp.fastsim_flag = 1;
mp.fastsim_Fs_system_N = 4;
if mp.fastsim_flag == 0
    mp.Fs_system = config.system.systemClockFrequency;        % System clock frequency in Hz of Avalon Interface  Mclk*8 = 12.288MHz*8=98304000
else
    mp.Fs_system = mp.Fs * mp.fastsim_Fs_system_N;          % Note: For faster development runs (faster sim times), reduce the number of system clocks between samples.  mp.fastsim_Fs_system_N is set in sm_run_me_first.m
end
mp.Ts_system = 1/mp.Fs_system;         % System clock period
mp.rate_change = mp.Fs_system/mp.Fs;   % how much faster the system clock is to the sample clock



%% Configure target system
if isfield(config.system, "target")
    mp.target_system = config.system.target; 
else
    mp.target_system = 48000;
end
mp.testFile = [mp.test_signals_path filesep 'Urban_Light_HedaMusic_Creative_Commons.mp3'];
mp.fastsim_Nsamples = 100000000000;
mp.sim_prompts = 0;

%% Set size of Dual Port Memory
mp.max_delay = mp.Fs*1/2;   % max delay in samples, i.e. mp.Fs = 1 second max delay
mp.dpram_addr_size = ceil(log2(mp.max_delay));
%% Parse registers
mp.register = parseregisters(config);
function regs = parseregisters(config)
    if size(config.devices) == 1
        regs = parsedeviceregisters(config.devices(1));
    else
        regs = {};
        for device = config.devices
           temp.regs = parsedeviceregisters(device);
           temp.name = device.name;
           regs{end + 1} = temp;
        end
    end
end
function regs = parsedeviceregisters(device)
    regs = {};
    for idx=1:numel(device.registers)
        reg = device.registers(idx);
        tempReg.name = reg.name;
        tempReg.value = reg.defaultValue;

        if reg.dataType.type == "boolean"
            tempReg.dataType = fixdt('boolean');
        else
            tempReg.dataType = fixdt(reg.dataType.signed, ...
                reg.dataType.totalBits, reg.dataType.fractionalBits);
        end
        tempReg.timeseries = timeseries(tempReg.value, 0);
        
        regs{end + 1} = tempReg; 
    end
end
    
%%% Not Autogen




%%% Autogen but simulink only
%mp.fastSim = 0;
%mp.simPrompts = 0;
% Test source is class and test file is path to file.
%mp.testSource = "";
%mp.testFile = [mp.test_signals_path filesep 'Urban_Light_HedaMusic_Creative_Commons.mp3'];