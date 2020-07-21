% pathSetupWindows Setup required paths for Simulink development
%
% This file is used to define and setup all paths required for Simulink development.
% Users need to add their FPGA Open Speech Tools root folder where all of the 
% git repositories are. They also need to add the path to their Quartus installation.

% Copyright 2020 Flat Earth Inc, Montana State University
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross Snider, Trevor Vannoy, Dylan Wickham
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

%% Setup Matlab/Simulink paths
% These paths are required for developing simulink models and autogenerating code.
% It is intended that users put the FPGA Open Speech Tools repositories
% all in the same root folder (gitPath).

% TODO: change struct field names to match coding style; this struct
%       is used all over the place, so this will require some global refactoring
autogenConfig = getconfig();
autogenRootDir = autogenConfig.root;
mp.model_path = '';
%mp.model_path           = [gitPath filesep 'simulink_models' filesep 'models' filesep mp.model_name];
mp.test_signals_path    = [autogenRootDir filesep 'simulink_models' filesep 'test_signals'];
mp.ipcore_codegen_path  = [autogenRootDir filesep 'simulink_codegen' filesep 'ipcore'];
mp.driver_codegen_path  = [autogenRootDir filesep 'simulink_codegen' filesep 'device_drivers'];
mp.ui_codegen_path      = [autogenRootDir filesep 'simulink_codegen' filesep 'ui'];
mp.dtogen_path          = [autogenRootDir filesep 'utils' filesep  'device_tree_overlays'];
mp.codegen_path         = [autogenRootDir filesep 'simulink_codegen' ];


%% Quartus Setup
mp.quartus_path = autogenConfig.quartus;

%% Setup Python paths
if count(py.sys.path,mp.ipcore_codegen_path) == 0
    insert(py.sys.path,int32(0),mp.ipcore_codegen_path);
end
if count(py.sys.path,mp.driver_codegen_path) == 0
    insert(py.sys.path,int32(0),mp.driver_codegen_path);
end
if count(py.sys.path,mp.dtogen_path) == 0
    insert(py.sys.path,int32(0),mp.dtogen_path);
end

%% Add the paths to the current Matlab session
addpath(mp.model_path)
addpath(mp.driver_codegen_path)
addpath(mp.ipcore_codegen_path)
addpath(mp.ui_codegen_path)
addpath(mp.test_signals_path)
addpath(mp.codegen_path)
hdlsetuptoolpath('ToolName', 'Altera Quartus II', 'ToolPath', mp.quartus_path);

%% Print out the paths
disp(['------------------------------------------------'])
disp(['Setting up the the following path parameters'])
disp(['Local GitHub repository path = ' autogenRootDir])
disp(['Simulink model path          = ' mp.model_path])
disp(['Test signals path            = ' mp.test_signals_path])
disp(['VHDL Codegen path            = ' mp.ipcore_codegen_path])
disp(['Driver Codegen path          = ' mp.driver_codegen_path])
disp(['UI Codegen path              = ' mp.ui_codegen_path])
disp(['Quartus path                 = ' mp.quartus_path])
disp(['------------------------------------------------'])


function config = getconfig()
% Get the autogen configuration from path.json or automatically
    config_dir = erase(mfilename('fullpath'), mfilename); 
    config_path = config_dir + "path.json";
    
    if isfile(config_path)
        config = jsondecode(fileread(config_path));
        if isfolder(config.root) == 0
            error("The given root path " + config.root + " was not found on your system.")
        end
        if isfolder(config.quartus) == 0
           error("The given quartus path " + config.quartus + " was not found on your system.") 
        end
    else
        root_dir = config_dir + ".." +  filesep + ".." + filesep;
        [~, values] = fileattrib(root_dir);
        root_dir = values.Name;
        config.root = root_dir;
        if ispc
            quartus_root = strcat(getenv("QUARTUS_ROOTDIR"),filesep);
            bin = "bin64";
        else
            % QUARTUS_ROOTDIR is not defined on Linux installations by default
            qsys_root = getenv("QSYS_ROOTDIR");
            temp = regexp(qsys_root, "sopc_builder", 'split');
            quartus_root = temp{1};
            bin = "bin";
        end
        if isempty(quartus_root)
           error("Quartus was not found in your system environment variables.\n" ...
               + "Ensure Quartus environment variables are set or use path.json to configure Quartus path.") 
        end
        config.quartus = char(quartus_root + bin + filesep);
    end
end