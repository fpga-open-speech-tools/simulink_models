% configureModel.m
%
% This file sets the mp struct to have model parameters defined on it.
% First it parses model.json, then reads modelparameters.m, and finally
% computes additional fields from the previous settings.

% Copyright 2020 Audio Logic
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
configPath = [modelPath filesep 'model.json'];
config = jsondecode(fileread(configPath));

mp.modelName = config.devices(1).name;
mp.useAvalonInterface = lower(config.system.processing) == "channel";
%% Set Audio Data

mp.Fs = config.system.sampleClockFrequency; 

% Set the data type for audio signal
mp.signed = config.system.audioIn.signed;
mp.W_bits = config.system.audioIn.wordLength;  % Word length
mp.F_bits = config.system.audioIn.fractionLength;  % Number of fractional bits in word
mp.nChannels = config.system.audioIn.numberOfChannels;
mp.nOutChannels = config.system.audioOut.numberOfChannels;

%% Parse registers
mp.register = parseregisters(config);

run([mp.modelPath filesep 'modelparameters.m'])

%% Computed parameters
% Set undefined configuration parameters
if isfield(mp, "nSamples") == 0
   mp.nSamples = -1; % This is interpreted as the full audio file is to be used
end

if isfield(mp, "sim_prompts") == 0
   mp.sim_prompts = 0; 
end
if isfield(mp, "sim_verify") == 0
   mp.sim_verify = 0; 
end

if isfield(mp, "testFile") == 0
   mp.testFile = [mp.test_signals_path filesep 'Urban_Light_HedaMusic_Creative_Commons.mp3']; 
end

% Configure target system
if isfield(config.system, "target") == 0 || config.system.target == "audiomini"
    mp.target = Hardware.AudioMini;
elseif config.system.target == "reflex"
    mp.target = Hardware.Reflex;
else
    mp.target = Hardware.AudioBlade;
end

% Set sample period for audio source
mp.Ts = 1/mp.Fs; 

%Set the FPGA system clock frequency (frequency of the FPGA fabric)
% The system clock frequency should be an integer multiple of the Audio codec AD1939 Mclk frequency (12.288 MHz)
mp.Fs_system = config.system.systemClockFrequency;        % System clock frequency in Hz of Avalon Interface  Mclk*8 = 12.288MHz*8=98304000

mp.Ts_system = 1 / mp.Fs_system;
mp.Ts_sim = 1/(mp.Fs * mp.nChannels);         % System clock period
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

        if isfield(reg.dataType, "type") && reg.dataType.type == "boolean"
            tempReg.dataType = fixdt('boolean');
        else
            tempReg.dataType = fixdt(reg.dataType.signed, ...
                reg.dataType.wordLength, reg.dataType.fractionLength);
        end
        tempReg.timeseries = timeseries(tempReg.value, 0);
        
        regs{idx} = tempReg; 
    end
end