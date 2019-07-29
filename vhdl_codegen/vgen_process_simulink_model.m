% vgen_process_simulink_model
%
% This script parses the simulink model and extracts the interface signals
% and puts this information in a JSON file.

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
% We parse the model to get the Avalon signals and control registers we need for the Avalon vhdl wrapper
try
    mp.fastsim_flag = 0;  % turn off fast sim so that the model runs at the system clock rate
    avalon = vgen_get_simulink_block_interfaces(mp);
catch
    % Terminate the compile mode if an error occurs while the model
    % has been placed in compile mode. Otherwise the model will be frozen
    % and you can't quit Matlab
    disp('   ***************************************************************************');
    disp('   Error occurred in function vgen_get_simulink_block_interfaces(mp)');
    disp('   ***************************************************************************');
    cmd = [bdroot,'([],[],[],''term'');'];
    eval(cmd)
end

%% save the specified clock frequencies
avalon.clocks.sample_frequency_Hz   = mp.Fs;
avalon.clocks.sample_period_seconds = mp.Ts;
avalon.clocks.system_frequency_Hz   = mp.Fs_system;
avalon.clocks.system_period_seconds = mp.Ts_system;

%% save the device info
avalon.model_name           = mp.model_name;
avalon.model_abbreviation   = mp.model_abbreviation;
avalon.linux_device_name    = mp.linux_device_name;
avalon.linux_device_version = mp.linux_device_version;

% rename the entity by adding model abbreviation before DataPlane
avalon.entity  = [mp.model_abbreviation '_' avalon.entity];

%% Save the avalon structure to a json file and a .mat file
writejson(avalon, [avalon.entity,'.json'])
save([avalon.entity '_avalon'], 'avalon')

%% Generate the Simulink model VHDL code
mp.sim_prompts = 0;    % turn off the simulation prompts and the stop callbacks when running HDL workflow (otherwise this runs at each HDL workflow step)
sm_hdlworkflow         % run the workflow script

%% Generate the Avalon VHDL wrapper for the VHDL code generated by the HDL Coder
infile = [avalon.entity '.json'];
vhdl_source_path = [mp.model_path '\hdl_prj\ipcore\DataPlane_v1_0\hdl\'];
outfile = [vhdl_source_path avalon.entity, '.vhd'];
vgenAvalonWrapper(infile, outfile, false, false);

%% Generate the .tcl script to be used by Platform Designer in Quartus
infile = [avalon.entity '.json'];
tcl_source_path = [mp.model_path '\hdl_prj\ipcore\DataPlane_v1_0\'];
outfile = [tcl_source_path avalon.entity, '_avalon_hw.tcl'];  % Note: platform designer only adds components if they have the _hw.tcl suffix
vgenTcl(infile, outfile);







