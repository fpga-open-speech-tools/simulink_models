
%

%   Copyright 2013-2014 The MathWorks, Inc.

classdef hdlblkmask_deserializer1D
    %HDLBLKMASK_1DDESERIALIZER 
    properties
    end
    
    methods (Static = true)
        function ratio_callback(blk)
            maskStr = get_param(blk,'MaskValues');
            set_param([blk, '/rateTrans'], 'OutPortSampleTimeMultiple',...
                                  sprintf('%s + %s', maskStr{1}, maskStr{2}));
            set_param([blk, '/rateTrans1'], 'OutPortSampleTimeMultiple',...
                                  sprintf('%s + %s', maskStr{1}, maskStr{2}));
        end
        
        function initialCondition_callback(blk)
            maskStr = get_param(blk,'MaskValues');
            value = eval(maskStr{3});
            set_param([blk, '/Delay'], 'InitialCondition',...
                    sprintf('%s', maskStr{3}));
            if(coder.isenum(value))
                initValue = int32(value);
                set_param([blk, '/HDL1DDs'], 'InitialCondition',...
                    sprintf('%d', initValue));
            else
                set_param([blk, '/HDL1DDs'], 'InitialCondition',...
                    sprintf('%s', maskStr{3}));
            end
        end
        
        function InDataDimensions_callback(blk)
            maskStr = get_param(blk,'MaskValues');
            set_param([blk, '/S'], 'PortDimensions',...
                                  sprintf('%s', maskStr{7}));
        end
        
        function InSampleTime_callback(blk)
            maskStr = get_param(blk,'MaskValues');
            set_param([blk, '/S'], 'SampleTime',...
                sprintf('%s', maskStr{8}));
        end
        
        function InSignalType_callback(blk)
            maskStr = get_param(blk,'MaskValues');
            set_param([blk, '/S'], 'SignalType',...
                sprintf('%s', maskStr{9}));
        end
        
        function mask_init(blk)
            PortName = 'ValidOut';
            TerminatorName = 'Terminator';
            PortPath = [blk '/' PortName];
            TerminatorPath = [blk '/' TerminatorName];

            validOut = get_param(blk, 'validOut');

            if strcmpi(validOut, 'on')

                % When mask is set to ON, add port if it is not already there
                if isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
                        'SearchDepth',1,'Name',PortName))

                    % Get terminator blk position, then delete it
                    PortPosition = get_param(TerminatorPath, 'Position');
                    delete_block(TerminatorPath);

                    % Get port number offset, and add port
                    add_block('built-in/Outport', PortPath, 'Port', '2', ...
                        'Position', PortPosition, 'OutDataTypeStr', 'boolean', 'PortDimensions', '1');
                end

                % When mask is set to OFF, add terminator block if it is not already there
            elseif isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
                    'SearchDepth',1,'Name',TerminatorName))

                % Get port position, then delete it
                PortPosition = get_param(PortPath, 'Position');
                delete_block(PortPath);

                % Add terminator block
                add_block('built-in/Terminator', TerminatorPath, 'Position', PortPosition);
            end
           
            PortName = 'StartIn';
            TerminatorName = 'const_startIn';
            PortPath = [blk '/' PortName];
            TerminatorPath = [blk '/' TerminatorName];

            startIn = get_param(blk, 'startIn');
            
            if strcmpi(startIn, 'on')

                % When mask is set to ON, add port if it is not already there
                if isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
                        'SearchDepth',1,'Name',PortName))

                    % Get terminator blk position, then delete it
                    PortPosition = get_param(TerminatorPath, 'Position');
                    delete_block(TerminatorPath);

                    % Get port number offset, and add port
                    add_block('built-in/Inport', PortPath, 'Port', '2', ...
                         'Position', PortPosition, 'OutDataTypeStr', 'boolean', 'PortDimensions', '1');
                end
               
                % When mask is set to OFF, add terminator block if it is not already there
            elseif isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
                    'SearchDepth',1,'Name',TerminatorName))

                % Get port position, then delete it
                PortPosition = get_param(PortPath, 'Position');
                delete_block(PortPath);

                % Add constant block
                add_block('built-in/Constant', TerminatorPath, 'Value', '1', ...
                       'Position', PortPosition, 'OutDataTypeStr', 'boolean');
            end
            
            
            PortName = 'ValidIn';
            TerminatorName = 'const_validIn';
            PortPath = [blk '/' PortName];
            TerminatorPath = [blk '/' TerminatorName];

            validIn = get_param(blk, 'validIn');
            
            if strcmpi(validIn, 'on')

                % When mask is set to ON, add port if it is not already there
                if isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
                        'SearchDepth',1,'Name',PortName))

                    % Get terminator blk position, then delete it
                    PortPosition = get_param(TerminatorPath, 'Position');
                    delete_block(TerminatorPath);

                    % Get port number offset, and add port
                    add_block('built-in/Inport', PortPath, 'Port', '3', ...
                         'Position', PortPosition, 'OutDataTypeStr', 'boolean', 'PortDimensions', '1');
                end
                
                if strcmpi(startIn, 'on')
                    set_param(PortPath, 'Port', '3');
                else
                    set_param(PortPath, 'Port', '2');
                end
               
                % When mask is set to OFF, add terminator block if it is not already there
            elseif isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
                    'SearchDepth',1,'Name',TerminatorName))

                % Get port position, then delete it
                PortPosition = get_param(PortPath, 'Position');
                delete_block(PortPath);

                % Add constant block
                add_block('built-in/Constant', TerminatorPath, 'Value', '1', ...
                       'Position', PortPosition, 'OutDataTypeStr', 'boolean');
            end
            
            
        end
    end
    
    
end

% LocalWords:  DDESERIALIZER DDs
