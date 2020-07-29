% std_modelparameters.m
%
% This file sets the mp struct to have model parameters defined on it.
% First it parses model.json, then reads modelparameters.m, and finally
% computes additional fields from the previous settings.
%
% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Dylan Wickham
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com
%% Read the config 
config_path = [modelPath filesep 'model.json'];
config = jsondecode(fileread(config_path));

mp.modelName = config.devices(1).name;

%% Set Audio Data
if isfield(config.system, "sampleClockFrequency")
    mp.Fs = config.system.sampleClockFrequency; 
else
    mp.Fs = 48000;
end

if isfield(config.system, "numberOfChannels")
    mp.nChannels = config.system.numberOfChannels;
else
    mp.nChannels = 2;
end
% Set the data type for audio signal
mp.signed = config.system.inputDataType.signed;
mp.W_bits = config.system.inputDataType.wordLength;  % Word length
mp.F_bits = config.system.inputDataType.fractionLength;  % Number of fractional bits in word

%% Configure target system
if isfield(config.system, "target")
    mp.target_system = config.system.target; 
else
    mp.target_system = "audiomini";
end

%% Parse registers
mp.register = parseregisters(config);

modelparameters

%% Computed parameters
% Set sample period for audio source
mp.Ts = 1/mp.Fs; 

%Set the FPGA system clock frequency (frequency of the FPGA fabric)
% The system clock frequency should be an integer multiple of the Audio codec AD1939 Mclk frequency (12.288 MHz)

if isfield(mp, "fastsim_flag") == 0 || mp.fastsim_flag == 0
    if isfield(config.system, "systemClockFrequency")
        mp.Fs_system = config.system.systemClockFrequency;        % System clock frequency in Hz of Avalon Interface  Mclk*8 = 12.288MHz*8=98304000
    else
        mp.Fs_system = 98304000;
    end
else
    mp.Fs_system = mp.Fs * mp.fastsim_Fs_system_N;          % Note: For faster development runs (faster sim times), reduce the number of system clocks between samples.  mp.fastsim_Fs_system_N is set in sm_run_me_first.m
end
mp.Ts_system = 1/mp.Fs_system;         % System clock period
mp.rate_change = mp.Fs_system/mp.Fs;   % how much faster the system clock is to the sample clock


%% Helper functions
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
    nRegs = numel(device.registers);
    regs = cell(nRegs);
    for idx=1:nRegs
        reg = device.registers(idx);
        tempReg.name = reg.name;
        tempReg.value = reg.defaultValue;

        if reg.dataType.type == "boolean"
            tempReg.dataType = fixdt('boolean');
        else
            tempReg.dataType = fixdt(reg.dataType.signed, ...
                reg.dataType.wordLength, reg.dataType.fractionLength);
        end
        tempReg.timeseries = timeseries(tempReg.value, 0);
        
        regs{idx} = tempReg; 
    end
end