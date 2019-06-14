%--------------------------------------------------------------------------
% Description:  Matlab script that converts the Simple Gain Simulink Model
%               to VHDL.  This script was initially created by manually
%               running the HDL Workflow Advisor on the DataPlane block
%               and then exporting to this script.  The script was then 
%               modified (see lines that have the % LineMod comments)
%--------------------------------------------------------------------------
% Author:       Ross K. Snider
% Company:      Flat Earth Inc
%               985 Technology Blvd
%               Bozeman, MT 59718
%               support@flatearthinc.com
% Create Date:  June 12, 2019
% Tool Version: MATLAB R2019a
% Revision:     1.0
% License:      MIT License (see license at end of code)
%--------------------------------------------------------------------------
%------------- BEGIN CODE --------------


%--------------------------------------------------------------------------
% HDL Workflow Script
% Generated with MATLAB 9.6 (R2019a) at 12:03:13 on 13/06/2019
% This script was generated using the following parameter values:
%     Filename  : 'E:\NIH\Simulink\Simple_Gain\hdlworkflow.m'
%     Overwrite : true
%     Comments  : true
%     Headers   : true
%     DUT       : 'SG/DataPlane'
% To view changes after modifying the workflow, run the following command:
% >> hWC.export('DUT','SG/DataPlane');
%--------------------------------------------------------------------------

%% Load the Model
load_system('SG');

%% Restore the Model to default HDL parameters
%hdlrestoreparams('SG/DataPlane');

%% Model HDL Parameters
%% Set Model 'SG' HDL parameters
hdlset_param('SG', 'CriticalPathEstimation', 'on');
hdlset_param('SG', 'HDLGenerateWebview', 'on');
hdlset_param('SG', 'HDLSubsystem', 'SG/DataPlane');
hdlset_param('SG', 'OptimizationReport', 'on');
hdlset_param('SG', 'ResourceReport', 'on');
hdlset_param('SG', 'SynthesisTool', 'Altera QUARTUS II');
hdlset_param('SG', 'SynthesisToolChipFamily', 'Cyclone V');
hdlset_param('SG', 'SynthesisToolDeviceName', '5CSXFC6D6F31C8');
hdlset_param('SG', 'SynthesisToolPackageName', '');
hdlset_param('SG', 'SynthesisToolSpeedValue', '');
hdlset_param('SG', 'TargetDirectory', [model_path '\' avalon.model_name '_' 'hdl_prj\hdlsrc']);  % LineMod
hdlset_param('SG', 'TargetPlatform', 'Generic Altera Platform');
hdlset_param('SG', 'Workflow', 'IP Core Generation');

% Set SubSystem HDL parameters
hdlset_param('SG/DataPlane', 'IPCoreName', 'DataPlane');
hdlset_param('SG/DataPlane', 'ProcessorFPGASynchronization', 'Free running');

% Set Inport HDL parameters
hdlset_param('SG/DataPlane/Avalon_Sink_Valid', 'IOInterface', 'External Port');
hdlset_param('SG/DataPlane/Avalon_Sink_Valid', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/DataPlane/Avalon_Sink_Data', 'IOInterface', 'External Port');
hdlset_param('SG/DataPlane/Avalon_Sink_Data', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/DataPlane/Avalon_Sink_Channel', 'IOInterface', 'External Port');
hdlset_param('SG/DataPlane/Avalon_Sink_Channel', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/DataPlane/Avalon_Sink_Error', 'IOInterface', 'External Port');
hdlset_param('SG/DataPlane/Avalon_Sink_Error', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/DataPlane/Register_Control_Left_Gain', 'IOInterface', 'External Port');
hdlset_param('SG/DataPlane/Register_Control_Left_Gain', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/DataPlane/Register_Control_Right_Gain', 'IOInterface', 'External Port');
hdlset_param('SG/DataPlane/Register_Control_Right_Gain', 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param('SG/DataPlane/Avalon_Source_Valid', 'IOInterface', 'External Port');
hdlset_param('SG/DataPlane/Avalon_Source_Valid', 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param('SG/DataPlane/Avalon_Source_Data', 'IOInterface', 'External Port');
hdlset_param('SG/DataPlane/Avalon_Source_Data', 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param('SG/DataPlane/Avalon_Source_Channel', 'IOInterface', 'External Port');
hdlset_param('SG/DataPlane/Avalon_Source_Channel', 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param('SG/DataPlane/Avalon_Source_Error', 'IOInterface', 'External Port');
hdlset_param('SG/DataPlane/Avalon_Source_Error', 'IOInterfaceMapping', '');


%% Workflow Configuration Settings
% Construct the Workflow Configuration Object with default settings
hWC = hdlcoder.WorkflowConfig('SynthesisTool','Altera QUARTUS II','TargetWorkflow','IP Core Generation');

% Specify the top level project directory
hWC.ProjectFolder = [avalon.model_name '_' 'hdl_prj'];   % LineMod
hWC.ReferenceDesignToolVersion = '';
hWC.IgnoreToolVersionMismatch = false;

% Set Workflow tasks to run
hWC.RunTaskGenerateRTLCodeAndIPCore = true;
hWC.RunTaskCreateProject = false;
hWC.RunTaskGenerateSoftwareInterfaceModel = false;
hWC.RunTaskBuildFPGABitstream = false;
hWC.RunTaskProgramTargetDevice = false;

% Set properties related to 'RunTaskGenerateRTLCodeAndIPCore' Task
hWC.IPCoreRepository = '';
hWC.GenerateIPCoreReport = true;

% Set properties related to 'RunTaskCreateProject' Task
hWC.Objective = hdlcoder.Objective.None;
hWC.AdditionalProjectCreationTclFiles = '';

% Set properties related to 'RunTaskGenerateSoftwareInterfaceModel' Task
hWC.OperatingSystem = '';

% Set properties related to 'RunTaskBuildFPGABitstream' Task
hWC.RunExternalBuild = false;
hWC.TclFileForSynthesisBuild = hdlcoder.BuildOption.Default;
hWC.CustomBuildTclFile = '';

% Set properties related to 'RunTaskProgramTargetDevice' Task
hWC.ProgrammingMethod = hdlcoder.ProgrammingMethod.JTAG;

% Validate the Workflow Configuration Object
hWC.validate;

%% Run the workflow
hdlcoder.runWorkflow('SG/DataPlane', hWC);

%--------------------------------------------------------------------------
%------------- END OF CODE --------------
%--------------------------------------------------------------------------
% MIT License
% Copyright (c) 2019 Flat Earth Inc
%
%Permission is hereby granted, free of charge, to any person obtaining a copy
%of this software and associated documentation files (the "Software"), to deal
%in the Software without restriction, including without limitation the rights
%to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%copies of the Software, and to permit persons to whom the Software is
%furnished to do so, subject to the following conditions:
%
%The above copyright notice and this permission notice shall be included in all
%copies or substantial portions of the Software.
%
%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%SOFTWARE.
%--------------------------------------------------------------------------

