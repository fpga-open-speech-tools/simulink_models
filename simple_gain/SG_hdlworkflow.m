%--------------------------------------------------------------------------
% HDL Workflow Script
% Generated with MATLAB 9.6 (R2019a) at 13:44:46 on 20/06/2019
% This script was generated using the following parameter values:
%     Filename  : 'E:\git\nih_simulinklib\simple_gain\hdlworkflow.m'
%     Overwrite : true
%     Comments  : true
%     Headers   : true
%     DUT       : 'SG/SG_DataPlane'
% To view changes after modifying the workflow, run the following command:
% >> hWC.export('DUT','SG/SG_DataPlane');
%--------------------------------------------------------------------------

%% Load the Model
load_system('SG');

%% Restore the Model to default HDL parameters
%hdlrestoreparams('SG/SG_DataPlane');

%% Model HDL Parameters
%% Set Model 'SG' HDL parameters
hdlset_param('SG', 'CriticalPathEstimation', 'on');
hdlset_param('SG', 'HDLGenerateWebview', 'on');
hdlset_param('SG', 'HDLSubsystem', 'SG/SG_DataPlane');
hdlset_param('SG', 'OptimizationReport', 'on');
hdlset_param('SG', 'ResourceReport', 'on');
hdlset_param('SG', 'SynthesisTool', 'Altera QUARTUS II');
hdlset_param('SG', 'SynthesisToolChipFamily', 'Cyclone V');
hdlset_param('SG', 'SynthesisToolDeviceName', '5CSXFC6D6F31C8');
hdlset_param('SG', 'SynthesisToolPackageName', '');
hdlset_param('SG', 'SynthesisToolSpeedValue', '');
hdlset_param('SG', 'TargetDirectory', 'hdl_prj\hdlsrc');
hdlset_param('SG', 'TargetPlatform', 'Generic Altera Platform');
hdlset_param('SG', 'Workflow', 'IP Core Generation');

% Set SubSystem HDL parameters
hdlset_param('SG/SG_DataPlane', 'IPCoreName', 'SG_DataPlane');
hdlset_param('SG/SG_DataPlane', 'ProcessorFPGASynchronization', 'Free running');

% Set Inport HDL parameters
hdlset_param('SG/SG_DataPlane/avalon_sink_valid', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/avalon_sink_valid', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/SG_DataPlane/avalon_sink_data', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/avalon_sink_data', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/SG_DataPlane/avalon_sink_channel', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/avalon_sink_channel', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/SG_DataPlane/avalon_sink_error', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/avalon_sink_error', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/SG_DataPlane/register_control_left_gain', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/register_control_left_gain', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/SG_DataPlane/register_control_right_gain', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/register_control_right_gain', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/SG_DataPlane/Avalon Data Processing/Sink_Data', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/Avalon Data Processing/Sink_Data', 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param('SG/SG_DataPlane/Avalon Data Processing/Sink_Channel', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/Avalon Data Processing/Sink_Channel', 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param('SG/SG_DataPlane/Avalon Data Processing/Source_Data', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/Avalon Data Processing/Source_Data', 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param('SG/SG_DataPlane/Avalon Data Processing/Source_Channel', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/Avalon Data Processing/Source_Channel', 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param('SG/SG_DataPlane/avalon_source_valid', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/avalon_source_valid', 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param('SG/SG_DataPlane/avalon_source_data', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/avalon_source_data', 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param('SG/SG_DataPlane/avalon_source_channel', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/avalon_source_channel', 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param('SG/SG_DataPlane/avalon_source_error', 'IOInterface', 'External Port');
hdlset_param('SG/SG_DataPlane/avalon_source_error', 'IOInterfaceMapping', '');


%% Workflow Configuration Settings
% Construct the Workflow Configuration Object with default settings
hWC = hdlcoder.WorkflowConfig('SynthesisTool','Altera QUARTUS II','TargetWorkflow','IP Core Generation');

% Specify the top level project directory
hWC.ProjectFolder = 'hdl_prj';
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
hdlcoder.runWorkflow('SG/SG_DataPlane', hWC);
