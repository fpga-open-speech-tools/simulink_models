%--------------------------------------------------------------------------
% HDL Workflow Script
% Generated with MATLAB 9.6 (R2019a) at 16:46:30 on 05/09/2019
% This script was generated using the following parameter values:
%     Filename  : '/mnt/data/NIH/simulink_models/models/simple_gain/hdlworkflow.m'
%     Overwrite : true
%     Comments  : true
%     Headers   : true
%     DUT       : [model '\' dataplane_name]
% To view changes after modifying the workflow, run the following command:
% >> hWC.export('DUT',[model '\' dataplane_name]);
%--------------------------------------------------------------------------

%% Load the Model
model = mp.model_abbreviation;
dataplane_name = 'dataplane';
load_system(model);

%% Model HDL Parameters
hdlset_param(model, ...
    'DateComment', 'off', ...
    'ModulePrefix', [model '_'], ...
    'CriticalPathEstimation', 'off', ...
    'GenerateHDLTestBench', 'off', ...
    'HDLCodingStandardCustomizations',hdlcodingstd.IndustryCustomizations(), ...
    'HDLGenerateWebview', 'on', ...
    'HDLSubsystem', [model '/' dataplane_name], ...
    'OptimizationReport', 'on', ...
    'ResourceReport', 'on', ...
    'SynthesisTool', 'Altera QUARTUS II', ...
    'SynthesisToolChipFamily', 'Cyclone V', ...
    'SynthesisToolDeviceName', '5CSEBA6U23I7', ...
    'SynthesisToolPackageName', '', ...
    'SynthesisToolSpeedValue', '', ...
    'UseRisingEdge', 'on', ...
    'TargetDirectory', 'hdlsrc', ...
    'TargetFrequency', mp.Fs_system);

%% Workflow Configuration Settings
% Construct the Workflow Configuration Object with default settings
hWC = hdlcoder.WorkflowConfig('SynthesisTool','Altera QUARTUS II','TargetWorkflow','Generic ASIC/FPGA');

% Specify the top level project directory
hWC.ProjectFolder = mp.model_path;

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
hdlcoder.runWorkflow([model '/' dataplane_name], hWC);
