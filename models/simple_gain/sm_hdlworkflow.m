%--------------------------------------------------------------------------
% HDL Workflow Script
% Generated with MATLAB 9.6 (R2019a) at 16:46:30 on 05/09/2019
% This script was generated using the following parameter values:
%     Filename  : '/mnt/data/NIH/simulink_models/models/simple_gain/hdlworkflow.m'
%     Overwrite : true
%     Comments  : true
%     Headers   : true
%     DUT       : 'SG/SG_DataPlane'
% To view changes after modifying the workflow, run the following command:
% >> hWC.export('DUT','SG/SG_DataPlane');
%--------------------------------------------------------------------------

%% Load the Model
model = mp.model_abbreviation;
dataplane_name = [model '_DataPlane'];
load_system(model);

%% Model HDL Parameters
%% Set Model 'SG' HDL parameters
hdlset_param('SG', 'CriticalPathEstimation', 'off');
hdlset_param('SG', 'GenerateHDLTestBench', 'off');
hdlset_param('SG','HDLCodingStandardCustomizations',hdlcodingstd.IndustryCustomizations());
hdlset_param('SG', 'HDLGenerateWebview', 'on');
hdlset_param('SG', 'HDLSubsystem', 'SG/SG_DataPlane');
hdlset_param('SG', 'OptimizationReport', 'on');
hdlset_param('SG', 'ResourceReport', 'on');
hdlset_param('SG', 'SynthesisTool', 'Altera QUARTUS II');
hdlset_param('SG', 'SynthesisToolChipFamily', 'Cyclone V');
hdlset_param('SG', 'SynthesisToolDeviceName', '5CSEBA6U23I7');
hdlset_param('SG', 'SynthesisToolPackageName', '');
hdlset_param('SG', 'SynthesisToolSpeedValue', '');
hdlset_param('SG', 'UseRisingEdge', 'on');

% XXX: Matlab refuses to put the code anywhere except hdlsrc, no matter
%      what directory I put here... >:(
hdlset_param('SG', 'TargetDirectory', './hdlsrc');

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
hWC = hdlcoder.WorkflowConfig('SynthesisTool','Altera QUARTUS II','TargetWorkflow','Generic ASIC/FPGA');

% Specify the top level project directory
hWC.ProjectFolder = '.';

% Set Workflow tasks to run
hWC.RunTaskGenerateRTLCodeAndTestbench = true;
hWC.RunTaskVerifyWithHDLCosimulation = false;
hWC.RunTaskCreateProject = false;
hWC.RunTaskPerformLogicSynthesis = false;
hWC.RunTaskPerformMapping = false;
hWC.RunTaskPerformPlaceAndRoute = false;
hWC.RunTaskAnnotateModelWithSynthesisResult = false;

% Set properties related to 'RunTaskGenerateRTLCodeAndTestbench' Task
hWC.GenerateRTLCode = true;
hWC.GenerateTestbench = false;
hWC.GenerateValidationModel = false;

% Set properties related to 'RunTaskCreateProject' Task
hWC.Objective = hdlcoder.Objective.None;
hWC.AdditionalProjectCreationTclFiles = '';

% Set properties related to 'RunTaskPerformMapping' Task
hWC.SkipPreRouteTimingAnalysis = false;

% Set properties related to 'RunTaskPerformPlaceAndRoute' Task
hWC.IgnorePlaceAndRouteErrors = false;

% Set properties related to 'RunTaskAnnotateModelWithSynthesisResult' Task
hWC.CriticalPathSource = 'pre-route';
hWC.CriticalPathNumber =  1;
hWC.ShowAllPaths = false;
hWC.ShowDelayData = false;
hWC.ShowUniquePaths = false;
hWC.ShowEndsOnly = false;

% Validate the Workflow Configuration Object
hWC.validate;

%% Run the workflow
hdlcoder.runWorkflow('SG/SG_DataPlane', hWC);
