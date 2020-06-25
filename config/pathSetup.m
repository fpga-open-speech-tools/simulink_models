% pathSetupWindows Setup required paths for Simulink development
%
% This file is used to define and setup all paths required for Simulink development.
% Users need to add their FPGA Open Speech Tools root folder where all of the 
% git repositories are. They also need to add the path to their Quartus installation.

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

%% Git Repository Setup
% Add your git path to the cell array selection below so it will be found
% the next time you run Simulink.
% The first directory that Matlab finds that exists will be used.
localGitPath = {};
localGitPath{end + 1} = '/mnt/data/NIH';
localGitPath{end + 1} = 'C:\Users\bugsbunny\research\NIH';
localGitPath{end + 1} = 'V:\MSU\GitHub\';
localGitPath{end + 1} = 'C:\Users\wickh\Documents\NIH\';
validIndex = 0;
for index=1:length(localGitPath)
    if isfolder(localGitPath{index}) 
        validIndex = index;
    end
end
if validIndex > 0
    gitPath = localGitPath{validIndex};
else
    error('Local Git repository not found.  Please add your Git path to pathSetupWindows.m');
end

%% Setup Matlab/Simulink paths
% These paths are required for developing simulink models and autogenerating code.
% It is intended that users put the FPGA Open Speech Tools repositories
% all in the same root folder (gitPath).

% TODO: change struct field names to match coding style; this struct
%       is used all over the place, so this will require some global refactoring
mp.model_path           = [gitPath filesep 'simulink_models' filesep 'models' filesep mp.model_name];
mp.test_signals_path    = [gitPath filesep 'simulink_models' filesep 'test_signals'];
mp.ipcore_codegen_path  = [gitPath filesep 'simulink_codegen' filesep 'ipcore'];
mp.driver_codegen_path  = [gitPath filesep 'simulink_codegen' filesep 'device_drivers'];
mp.ui_codegen_path      = [gitPath filesep 'simulink_codegen' filesep 'ui'];
mp.dtogen_path          = [gitPath filesep 'utils' filesep  'device_tree_overlays'];
mp.codegen_path         = [gitPath filesep 'simulink_codegen' ];

%% Quartus Setup
% Add your Quartus path to the cell array selection below so it will be found
% the next time you run Simulink.
% The first directory that Matlab finds that exists will be used.
localQuartusPath = {};
localQuartusPath{end + 1} = 'C:\intelFPGA_lite\18.1\quartus\bin64';
localQuartusPath{end + 1} = 'D:\intelFPGA_lite\18.1\quartus\bin64';
localQuartusPath{end + 1} = 'C:\intelFPGA\18.0\quartus\bin64';
localQuartusPath{end + 1} = '/usr/local/intelFPGA/19.1/quartus/bin';
localQuartusPath{end + 1} = '/usr/local/intelFPGA_lite/18.0/quartus/bin';

validIndex = 0;
for index=1:length(localQuartusPath)
    if isfolder(localQuartusPath{index}) 
        validIndex = index;
    end
end
if validIndex > 0
    quartusPath = localQuartusPath{validIndex};
else
    error('Local Quartus install not found.  Please add your Quartus path to pathSetupWindows.m');
end
mp.quartus_path = quartusPath;

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
disp(['Local GitHub repository path = ' gitPath])
disp(['Simulink model path          = ' mp.model_path])
disp(['Test signals path            = ' mp.test_signals_path])
disp(['VHDL Codegen path            = ' mp.ipcore_codegen_path])
disp(['Driver Codegen path          = ' mp.driver_codegen_path])
disp(['UI Codegen path              = ' mp.ui_codegen_path])
disp(['Quartus path                 = ' mp.quartus_path])
disp(['------------------------------------------------'])