%--------------------------------------------------------------------------
% HDL Workflow Script
% Generated with MATLAB 9.6 (R2019a) at 13:44:46 on 20/06/2019
% This script was generated using the following parameter values:
%     Filename  : 'E:\git\nih_simulinklib\simple_gain\hdlworkflow.m'
%     Overwrite : true
%     Comments  : true
%     Headers   : true
%     DUT       : [model '/DataPlane'
% To view changes after modifying the workflow, run the following command:
% >> hWC.export('DUT',[model '/DataPlane');
%--------------------------------------------------------------------------


%% Load the Model
model = mp.model_abbreviation;
load_system(model);

%% Restore the Model to default HDL parameters
%hdlrestoreparams([model '/DataPlane');

%% Model HDL Parameters
%% Set Model model HDL parameters
hdlset_param(model, 'CriticalPathEstimation', 'on');
hdlset_param(model, 'HDLGenerateWebview', 'on');
hdlset_param(model, 'HDLSubsystem', [model '/DataPlane']);
hdlset_param(model, 'OptimizationReport', 'on');
hdlset_param(model, 'ResourceReport', 'on');
hdlset_param(model, 'SynthesisTool', 'Altera QUARTUS II');
hdlset_param(model, 'SynthesisToolChipFamily', 'Cyclone V');
hdlset_param(model, 'SynthesisToolDeviceName', '5CSXFC6D6F31C8');
hdlset_param(model, 'SynthesisToolPackageName', '');
hdlset_param(model, 'SynthesisToolSpeedValue', '');
hdlset_param(model, 'TargetDirectory', 'hdl_prj\hdlsrc');
hdlset_param(model, 'TargetPlatform', 'Generic Altera Platform');
hdlset_param(model, 'Workflow', 'IP Core Generation');

% Set SubSystem HDL parameters
hdlset_param([model '/DataPlane'], 'IPCoreName', 'DataPlane');
hdlset_param([model '/DataPlane'], 'ProcessorFPGASynchronization', 'Free running');

% Set Inport HDL parameters
hdlset_param([model '/DataPlane/avalon_sink_valid'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/avalon_sink_valid'], 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param([model '/DataPlane/avalon_sink_data'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/avalon_sink_data'], 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param([model '/DataPlane/avalon_sink_channel'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/avalon_sink_channel'], 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param([model '/DataPlane/avalon_sink_error'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/avalon_sink_error'], 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param([model '/DataPlane/register_control_left_gain'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/register_control_left_gain'], 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param([model '/DataPlane/register_control_right_gain'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/register_control_right_gain'], 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param([model '/DataPlane/Avalon Data Processing/Sink_Data'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/Avalon Data Processing/Sink_Data'], 'IOInterfaceMapping', '');

% Set Inport HDL parameters
hdlset_param([model '/DataPlane/Avalon Data Processing/Sink_Channel'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/Avalon Data Processing/Sink_Channel'], 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param([model '/DataPlane/Avalon Data Processing/Source_Data'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/Avalon Data Processing/Source_Data'], 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param([model '/DataPlane/Avalon Data Processing/Source_Channel'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/Avalon Data Processing/Source_Channel'], 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param([model '/DataPlane/avalon_source_valid'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/avalon_source_valid'], 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param([model '/DataPlane/avalon_source_data'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/avalon_source_data'], 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param([model '/DataPlane/avalon_source_channel'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/avalon_source_channel'], 'IOInterfaceMapping', '');

% Set Outport HDL parameters
hdlset_param([model '/DataPlane/avalon_source_error'], 'IOInterface', 'External Port');
hdlset_param([model '/DataPlane/avalon_source_error'], 'IOInterfaceMapping', '');


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
hdlcoder.runWorkflow([model '/DataPlane'], hWC);
