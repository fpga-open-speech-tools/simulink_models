% pathSetup Setup required paths for FPGA Open Speech Tools code
%
% This file is used to define and setup all paths required for development.
% Users can define their root directory that contains all repos and their
% Quartus directory in path.json (as demonstrated in example_path.json)
% if desired. If path.json doesn't exist, the root and Quartus paths will
% be found automatically.

% Copyright 2020 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross Snider, Trevor Vannoy, Dylan Wickham
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Setup Matlab/Simulink paths

% TODO: change struct field names to match coding style; this struct
%       is used all over the place, so this will require some global refactoring
autogenConfig = getconfig();
autogenRootDir = autogenConfig.root;
mp.test_signals_path    = [autogenRootDir filesep 'simulink_models' filesep 'test_signals'];
mp.ipcore_codegen_path  = [autogenRootDir filesep 'simulink_codegen' filesep 'ipcore'];
mp.driver_codegen_path  = [autogenRootDir filesep 'simulink_codegen' filesep 'device_drivers'];
mp.dtogen_path          = [autogenRootDir filesep 'simulink_codegen' filesep  'device_tree_overlays'];
mp.codegen_path         = [autogenRootDir filesep 'simulink_codegen'];

%% Quartus Setup
mp.quartus_path = autogenConfig.quartus;

%% Add the paths to the current Matlab session
addpath(mp.driver_codegen_path)
addpath(mp.ipcore_codegen_path)
addpath(mp.dtogen_path)
addpath(mp.test_signals_path)
addpath(mp.codegen_path)
config_dir = erase(mfilename('fullpath'), mfilename); 
addpath(config_dir + "../autogen")
hdlsetuptoolpath('ToolName', 'Altera Quartus II', 'ToolPath', mp.quartus_path);

%% Print out the paths
disp(['------------------------------------------------'])
disp(['Setting up the the following path parameters'])
disp(['Local GitHub repository path = ' autogenRootDir])
disp(['Test signals path            = ' mp.test_signals_path])
disp(['VHDL Codegen path            = ' mp.ipcore_codegen_path])
disp(['Driver Codegen path          = ' mp.driver_codegen_path])
disp(['Dtogen path                  = ' mp.dtogen_path])
disp(['Quartus path                 = ' mp.quartus_path])
disp(['------------------------------------------------'])


function config = getconfig()
% Get the autogen configuration from path.json or automatically
    configDir = erase(mfilename('fullpath'), mfilename); 
    configPath = configDir + "path.json";
    
    if isfile(configPath)
        config = jsondecode(fileread(configPath));
        if isfolder(config.root) == 0
            error("The given root path " + config.root + " was not found on your system.")
        end
        if isfolder(config.quartus) == 0
           error("The given quartus path " + config.quartus + " was not found on your system.") 
        end
    else        
        % The root directory is by convention always two directories up from here,
        % as all of our repositories live in the same root directory
        root_dir = configDir + ".." +  filesep + ".." + filesep;
        [~, values] = fileattrib(root_dir);
        root_dir = values.Name;
        config.root = root_dir;
        
        % Find the Quartus path based on environment variables
        % QUARTUS_ROOTDIR_OVERRIDE takes precedence over other environment
        % variables because users can use that environment variable to set
        % the default Quartus install when multiple versions are installed. 
        % QUARTUS_ROOTDIR is not defined on Linux installations by default, so
        % we check QSYS_ROOTDIR as a last resort because that is always defined.
        if getenv("QUARTUS_ROOTDIR_OVERRIDE")
            quartusRoot = strcat(getenv("QUARTUS_ROOTDIR_OVERRIDE"),filesep);
        elseif getenv("QUARTUS_ROOTDIR")
            quartusRoot = strcat(getenv("QUARTUS_ROOTDIR"),filesep);
        else
            qsysRoot = getenv("QSYS_ROOTDIR");
            temp = regexp(qsysRoot, "sopc_builder", 'split');
            quartusRoot = temp{1};
        end
        
        if isempty(quartusRoot)
           error("Quartus was not found in your system environment variables.\n" ...
               + "Ensure Quartus environment variables are set or use path.json to configure your Quartus path.") 
        end 
        
        if ispc
            bin = "bin64";
        else
            bin = "bin";
        end
        
        config.quartus = char(quartusRoot + bin + filesep);
    end
end
