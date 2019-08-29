classdef (ConstructOnLoad,StrictDefaults) BlackBox < matlab.System   
% hdl.BlackBox implementation generates a black-box interface for a user
% defined System object. That is, the generated HDL code includes only the
% input/output port definitions for the System object. In this way, you can
% use a System object in your code to generate an interface to existing
% manually written HDL code. The black-box interface generated for
% System objects is similar to the interface generated for functions, but
% without generation of clock signals.
        
%#codegen 
%#ok<*EMCLS>
%#ok<*EMCA>


%   Copyright 2013-2017 The MathWorks, Inc.

% BlackBox    
    properties (Nontunable)
        AddClockEnablePort = 'on';
        AddClockPort = 'on';
        AddResetPort = 'on';
        AllowDistributedPipelining = 'off';
        ClockEnableInputPort ='clk_enable';
        ClockInputPort = 'clk';
        EntityName = '';
        %GenericList = '';
        ImplementationLatency = -1;
        InlineConfigurations = 'on';
        InputPipeline = 0;
        OutputPipeline = 0;
        ResetInputPort = 'reset';
        VHDLArchitectureName='rtl';  
        VHDLComponentLibrary='work';
        NumInputs = 1;
        NumOutputs = 1;

    end % properties (Nontunable)
    
    properties (Constant, Hidden, Transient)
        AddClockPortSet= matlab.system.StringSet({'on','off'});
        AddClockEnablePortSet = matlab.system.StringSet({'on','off'});
        AddResetPortSet = matlab.system.StringSet({'on','off'});
        InlineConfigurationsSet = matlab.system.StringSet({'on','off'});
        AllowDistributedPipeliningSet = matlab.system.StringSet({'on','off'});
    end % properties (Constant, Hidden, Transient)
    

    methods (Abstract, Access=protected)      
        
        varargout = stepImpl(obj, varargin)
            % Implement System algorithm.
            
    end
        
   methods
       % Constructor
        function obj = BlackBox(varargin)
            
        %if nargin > 0
        %        [varargin{:}] = convertStringsToChars(varargin{:});
        %    end
            
            % Support name-value pair arguments
            setProperties(obj,nargin,varargin{:});
        end
        
        % Set methods for properties
        function propertiesNameValuePairs = getBlackboxProperties(obj)
            propertiesNames = properties(class(obj));
            for i=1:1:length(propertiesNames)
                propertiesNameValuePairs{2*i-1}=propertiesNames{i};
                propertiesNameValuePairs{2*i}= obj.get(propertiesNames{i});
            end
        end
        
        function obj = set.ClockEnableInputPort(obj,value)   
            validateattributes(value, {'char','string'}, {},'hdl.BlackBox','ClockEnableInputPort');
            obj.ClockEnableInputPort = convertStringsToChars(value);
        end

        function obj = set.ClockInputPort(obj,value)
            validateattributes(value, {'char','string'}, {},'hdl.BlackBox','ClockInputPort');
            obj.ClockInputPort = convertStringsToChars(value);
        end

        function obj = set.EntityName(obj,value)
            validateattributes(value, {'char','string'}, {},'hdl.BlackBox','EntityName');
            obj.EntityName = convertStringsToChars(value);
        end      
        
        function obj = set.ImplementationLatency(obj,value)
            validateattributes(value, {'numeric'}, {'integer'},'hdl.BlackBox','ImplementationLatency');
            obj.ImplementationLatency = value;
        end
        
        function obj = set.InputPipeline(obj,value)
            validateattributes(value, {'numeric'}, {'nonnegative','integer'},'hdl.BlackBox','InputPipeline');
            obj.InputPipeline = value;
        end
        
        function obj = set.NumInputs(obj,value)
            validateattributes(value, {'numeric'}, {'nonnegative','integer'},'hdl.BlackBox','NumInputs');
            obj.NumInputs = value;
        end
        
        function obj = set.NumOutputs(obj,value)
            validateattributes(value, {'numeric'}, {'nonnegative','integer'},'hdl.BlackBox','NumOutputs');
            obj.NumOutputs = value;
        end 
        
        function obj = set.OutputPipeline(obj,value)
            validateattributes(value, {'numeric'}, {'nonnegative','integer'},'hdl.BlackBox','OutputPipeline');
            obj.OutputPipeline = value;
        end 
        
        function obj = set.ResetInputPort(obj,value)
            validateattributes(value, {'char','string'}, {},'hdl.BlackBox','ResetInputPort');
            obj.ResetInputPort = convertStringsToChars(value);
        end 

        function obj = set.VHDLArchitectureName(obj,value)
            validateattributes(value, {'char','string'}, {},'hdl.BlackBox','VHDLArchitectureName');
            obj.VHDLArchitectureName = convertStringsToChars(value);
        end 
        
        function obj = set.VHDLComponentLibrary(obj,value)
            validateattributes(value, {'char','string'}, {},'hdl.BlackBox','VHDLComponentLibrary');
            obj.VHDLComponentLibrary = convertStringsToChars(value);
        end 
                   
   end
   
    methods (Access=protected)
        % Disp method
        function displayScalarObject(obj)
           hdlblackboxPropsNames = properties('hdl.BlackBox');
           allPropsNames = properties(obj);
           allPropsNamesPadded = obj.rightPad(allPropsNames);
           hdlblackboxPropIndices = ismember(allPropsNames,hdlblackboxPropsNames);
           derivedClassPropsNames = {allPropsNames{~hdlblackboxPropIndices}}; %#ok<*CCAT1>
           derivedClassPropsNamesPadded = {allPropsNamesPadded{~hdlblackboxPropIndices}};
           hdlblackboxPropsNamesPadded = obj.rightPad(hdlblackboxPropsNames);
           
           disp([class(obj) ' Properties'])
           disp(' ')

           for i=1:length(derivedClassPropsNames)
              if isa(obj.(hdlblackboxPropsNames{i}), 'numeric')
                disp([derivedClassPropsNamesPadded{i} ' : ' num2str(obj.(derivedClassPropsNames{i}))]); 
              else
                disp([derivedClassPropsNamesPadded{i} ' : ' obj.(derivedClassPropsNames{i})]);
              end 
           end
           
           
           disp(' ')
           disp(' ')
           
           disp('hdlblackbox Properties')
           disp(' ')
           
           for i=1:length(hdlblackboxPropsNames)
              if isa(obj.(hdlblackboxPropsNames{i}), 'numeric')
                disp([hdlblackboxPropsNamesPadded{i} ' : ' num2str(obj.(hdlblackboxPropsNames{i}))]); 
              else
                disp([hdlblackboxPropsNamesPadded{i} ' : ' obj.(hdlblackboxPropsNames{i})]);
              end
           end
           
        end
        
        function modes = getExecutionSemanticsImpl(obj) %#ok<MANU>
            % supported semantics
            modes = {'Classic', 'Synchronous'};
        end % getExecutionSemanticsImpl
        
    end
   
    methods (Access=private)
        % helper function for padding properties in the display
        function paddedList = rightPad(~,strList)
            paddedList = cell(1, length(strList));         
            maxLength=0;
            for i=1:length(strList)
                if length(strList{i}) > maxLength
                    maxLength = length(strList{i});
                end
            end
            
            offset = 2;
            for ii = 1:length(strList)
                str = strList{ii};
                paddedList{ii} = [repmat(' ', 1, (maxLength - length(str)) + offset) str];
            end
        end
    end
       
    methods (Access=protected, Sealed)
        function N = getNumInputsImpl(obj)
            % Specify number of System inputs
            N = obj.NumInputs; % Because stepImpl has one argument beyond obj
        end
        
        function N = getNumOutputsImpl(obj)
            % Specify number of System outputs
            N = obj.NumOutputs; % Because stepImpl has one output
        end

    end
    
end


% LocalWords:  rtl Nontunable hdlblackbox
