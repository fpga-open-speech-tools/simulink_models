function avalon1 = vgen_get_simulink_block_interfaces()
% Note: The model simulation needs to be run first before this function
% is called since there are workspace variables that need to be set
% in the initiallization callback function

%--------------------------------------------------------------------------
% Put the model in compile mode  needed to get the CompiledPortDataTypes
% https://www.mathworks.com/matlabcentral/answers/8679-how-to-get-the-port-types-and-dimensions-for-a-block
%--------------------------------------------------------------------------
modelName = bdroot;  % get model name
disp(['Placing the model in compile mode.'])
disp(['     If for some reason an error occurs, you will need to manually terminate the compile mode'])
disp(['     by executing the command: eval([<modelName>,''([],[],[],''''term'''');'']);  % terminate the compile mode'])
eval([modelName,'([],[],[],''compile'');']);  % put in compile mode

avalon1.model_name = modelName;
%----------------------------------
% Get Avalon Streaming Sink Info
%----------------------------------
avalon_sink_signals = find_system('SearchDepth','2','regexp','on','BlockType','Inport','BlockDialogParams','Avalon_Sink*');
if (isempty(avalon_sink_signals)==0) % The avalon streaming sink exists
    avalon1.avalon_sink_flag = 1;
    Na = length(avalon_sink_signals);
    index = 1;
    for i=1:Na
        signal_name = avalon_sink_signals{i};
        ind = strfind(signal_name,'gm_');  % if the signal name contains gm_ we will ignore it (generated model stuff)
        if sum(size(ind)) == 0 % signal name doesn't contain 'gm_' so process it
            h = getSimulinkBlockHandle(signal_name);  % get block handle
            if index==1 % get parent name, which will be the entity name
                parent = get_param(h,'Parent');  % get parent name with path
                split = strsplit(parent,'/');    % split string into parts separated by '/'
                avalon1.entity = split{end};     % get the last string
            end
            p=get_param(h,'CompiledPortDataTypes');
            avalon1.avalon_sink.signal{index}.name        = get(h,'PortName');
            avalon1.avalon_sink.signal{index}.data_type   = p.Outport{1};
            index = index + 1;
        end
    end
else
    avalon1.avalon_sink_flag = 0;  % No avalon streaming sink interface
    avalon1.avalon_sink = [];
end


%----------------------------------
% Get Avalon Streaming Source Info
%----------------------------------
avalon_source_signals = find_system('SearchDepth','2','regexp','on','BlockType','Outport','BlockDialogParams','Avalon_Source*');
if (isempty(avalon_source_signals)==0) % The avalon streaming source exists
    avalon1.avalon_source_flag = 1;
    Na = length(avalon_source_signals);
    index = 1;
    for i=1:Na
        signal_name = avalon_source_signals{i};
        ind = strfind(signal_name,'gm_');  % if the signal name contains gm_ we will ignore it (generated model stuff)
        if sum(size(ind)) == 0 % signal name doesn't contain 'gm_' so process it
            h = getSimulinkBlockHandle(signal_name);  % get block handle
            p=get_param(h,'CompiledPortDataTypes');
            avalon1.avalon_source.signal{index}.name      = get(h,'PortName');
            avalon1.avalon_source.signal{index}.data_type = p.Inport{1};
            index = index + 1;
        end
    end
else
    avalon1.avalon_source_flag = 0;  % No avalon streaming source interface
    avalon1.avalon_source = [];
end


%----------------------------------
% Get Avalon Memory Mapping Info
% Registers that Linux will interact with
%----------------------------------
register_names = find_system('SearchDepth','2','regexp','on','BlockType','Inport','BlockDialogParams','Register_Control*');
if (isempty(register_names)==0) % The avalon memory mapped interface exists
    avalon1.avalon_memorymapped_flag = 1;
    Na = length(register_names);
    index = 1;
    for i=1:Na
        register_name = register_names{i};
        ind = strfind(register_name,'gm_');  % if the register name contains gm_ we will ignore it (generated model stuff)
        if sum(size(ind)) == 0 % register name doesn't contain 'gm_' so process it
            h = getSimulinkBlockHandle(register_name);  % get block handle
            p=get_param(h,'CompiledPortDataTypes');
            register_name = get(h,'PortName');
            avalon1.avalon_memorymapped.register{index}.name      = register_name;
            avalon1.avalon_memorymapped.register{index}.data_type = p.Outport{1};
            avalon1.avalon_memorymapped.register{index}.reg_num   = index;
            default_value = evalin('base',[register_name]);  % get value in the 'base' workspace variable
            avalon1.avalon_memorymapped.register{index}.default_value = default_value;
            index = index + 1;
        end
    end
else
    avalon1.avalon_memorymapped_flag = 0;  % No avalon streaming sink interface
    avalon1.avalon_memorymapped = [];
end

%----------------------------------
% Get Exported Input Signals Info
%----------------------------------
conduit_names = find_system('SearchDepth','2','regexp','on','BlockType','Inport','BlockDialogParams','Export*');
if (isempty(conduit_names)==0)
    avalon1.conduit_input_flag = 1;
    Na = length(conduit_names);
    index = 1;
    for i=1:Na
        conduit_name = conduit_names{i};
        ind = strfind(conduit_name,'gm_');  % if the conduit name contains gm_ we will ignore it (generated model stuff)
        if sum(size(ind)) == 0 % conduit name doesn't contain 'gm_' so process it
            h = getSimulinkBlockHandle(conduit_name);  % get block handle
            p=get_param(h,'CompiledPortDataTypes');
            avalon1.conduit_input.signal{index}.name      = get(h,'PortName');
            avalon1.conduit_input.signal{index}.data_type = p.Outport{1};
            index = index + 1;
        end
    end
else
    avalon1.conduit_input_flag = 0;
    avalon1.conduit_input = [];
end

%----------------------------------
% Get Exported Output Signals Info
%----------------------------------
conduit_names = find_system('SearchDepth','2','regexp','on','BlockType','Outport','BlockDialogParams','Export*');
if (isempty(conduit_names)==0)
    avalon1.conduit_output_flag = 1;
    Na = length(conduit_names);
    index = 1;
    for i=1:Na
        conduit_name = conduit_names{i};
        ind = strfind(conduit_name,'gm_');  % if the conduit name contains gm_ we will ignore it (generated model stuff)
        if sum(size(ind)) == 0 % conduit name doesn't contain 'gm_' so process it
            h = getSimulinkBlockHandle(conduit_name);  % get block handle
            p=get_param(h,'CompiledPortDataTypes');
            avalon1.conduit_output.signal{index}.name      = get(h,'PortName');
            avalon1.conduit_output.signal{index}.data_type = p.Inport{1};
            index = index + 1;
        end
    end
else
    avalon1.conduit_output_flag = 0;
    avalon1.conduit_output = [];
end


% Other compiled port information:
% CompiledPortWidths: [1x1 struct]
%  CompiledPortDimensions: [1x1 struct]
%  CompiledPortDataTypes: [1x1 struct]
%  CompiledPortComplexSignals: [1x1 struct]
%  CompiledPortFrameData: [1x1 struct]
%https://www.mathworks.com/matlabcentral/answers/8679-how-to-get-the-port-types-and-dimensions-for-a-block
%get(gcbh)  % get block parameters when block is selected


%------------------------------------------------
% Turn off the compile mode 
% Otherwise you won't be able to modify the model
% If you can't modify, you may need to call
% the function below multiple times (a terminate call is needed for each compile call)
% because the termination has been deferred
%------------------------------------------------
eval([modelName,'([],[],[],''term'');']);  % terminate the compile mode


%avalon1
