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
%% Create the control signals
%mp = sm_init_control_signals(mp);  % create the control signals

%% Create test signals for the left and right channels

[modelPath,modelAbbreviation,~] = fileparts(which(bdroot));
mp.modelPath = char(modelPath);
mp.modelAbbreviation = char(modelAbbreviation);
onPath = contains(path, [modelPath, pathsep]);
if ~onPath
    addpath(modelPath)
end
std_modelparameters;

test_signal = sm_init_test_signals(mp);  % create the test signals that will go through the model
stop_time = test_signal.duration;  % simulation time is based on the number of audio samples to go through the model


%% Put the test signals into the Avalon Streaming Bus format
% i.e. put the test signals into the data-channel-valid protocol

avalonSource = test_signal.toAvalonSource();

mp.avalonSim = avalonSource.astimeseries(mp.Ts_system);

mp.Avalon_Source_Data     = mp.avalonSim.data;
mp.Avalon_Source_Valid    = mp.avalonSim.valid;
mp.Avalon_Source_Channel  = mp.avalonSim.channel;
mp.Avalon_Source_Error    = mp.avalonSim.error;
if mp.sim_prompts == 1  % Note: sim_prompts is set in Run_me_first.m and is set to zero when hdl code generation is run
    disp(['Simulation time has been set to ' num2str(stop_time) ' seconds'])
    disp(['    Processing ' num2str(avalonSource.nSamples) ' Avalon streaming samples.'])
    disp(['          To reduce simulation time for development iterations,'])
    disp(['          reduce the system clock variable Fs_system (current set to ' num2str(mp.Fs_system)  ')'])
    disp(['          and/or reduce the test signal length (current set to ' num2str(test_signal.duration)  ' sec = ' num2str(test_signal.nSamples)  ' samples)'])
end

clear avalonSource;
if ~onPath
    rmpath(modelPath)
end
