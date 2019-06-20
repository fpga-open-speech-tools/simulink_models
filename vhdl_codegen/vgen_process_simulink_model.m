% vgen_process_simulink_model
%
% This script parses the simulink model and extracts the interface signals
% and puts this information in a JSON file.
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


%% Parse the Simulink Model (currently opened model) 
% to get the Avalon signals and control registers
try
    avalon = vgen_get_simulink_block_interfaces(model_params);
catch
    % Terminate the compile mode if an error occurs while the model
    % has been placed in compile mode. Otherwise the model will be frozen
    % and you can't quit Matlab
    disp('   ***************************************************************************');
    disp('   Error occurred in function vgen_get_simulink_block_interfaces(model_params)');
    disp('   ***************************************************************************');
    cmd = [bdroot,'([],[],[],''term'');'];
    eval(cmd)
end

%% save the specified clock frequencies
avalon.clocks.sample_frequency_Hz   = model_params.Fs;
avalon.clocks.sample_period_seconds = model_params.Ts;
avalon.clocks.system_frequency_Hz   = model_params.Fs_system;
avalon.clocks.system_period_seconds = model_params.Ts_system;

%% save the device info
avalon.model_name           = model_params.model_name;
avalon.model_abbreviation   = model_params.model_abbreviation;
avalon.linux_device_name    = model_params.linux_device_name;
avalon.linux_device_version = model_params.linux_device_version;

%% Save the avalon structure to a json file and a .mat file
writejson(avalon, [avalon.entity,'.json'])
save([model_params.model_abbreviation '_avalon'], 'avalon')

%% Generate the VHDL code
model_params.sim_prompts = 0;    % turn off the simulation prompts and the stop callbacks when running HDL workflow (otherwise this runs at each HDL workflow step)
eval([model_params.model_abbreviation '_hdlworkflow'])

