
%

%   Copyright 2013 The MathWorks, Inc.

classdef hdlblkmask_serializer1D
    %HDLBLKMASK_1DSERIALIZER 
    properties
    end
    
    methods (Static = true)
        function ratio_callback(blk)
            maskStr = get_param(blk,'MaskValues');
            set_param([blk, '/rateTrans'], 'OutPortSampleTimeMultiple',...
                                  sprintf('1/(%s + %s)', maskStr{1}, maskStr{2}));
            set_param([blk, '/rateTrans1'], 'OutPortSampleTimeMultiple',...
                                  sprintf('1/(%s + %s)', maskStr{1}, maskStr{2}));
        end
        
        function InDataDimensions_callback(blk)
            maskStr = get_param(blk,'MaskValues');
            set_param([blk, '/P'], 'PortDimensions',...
                                  sprintf('%s', maskStr{6}));
        end
        
        function InSampleTime_callback(blk)
            maskStr = get_param(blk,'MaskValues');
            set_param([blk, '/P'], 'SampleTime',...
                                  sprintf('%s', maskStr{7}));
        end
        
        function InSignalType_callback(blk)
            maskStr = get_param(blk,'MaskValues');
            set_param([blk, '/P'], 'SignalType',...
                sprintf('%s', maskStr{8}));
        end
        
        function mask_init(blk)
            mdlName = bdroot(blk);
            solverMode = get_param(mdlName, 'Solvermode');
            if (~strcmp(mdlName, 'hdlsllib')) && (~strcmp(solverMode, 'SingleTasking'))
                warning(message('hdlsllib:hdlsllib:singletaskingSolverSetting', blk));
            end            
            
            PortName = 'StartOut';
            TerminatorName = 'Terminator';
            PortPath = [blk '/' PortName];
            TerminatorPath = [blk '/' TerminatorName];

            startOut = get_param(blk, 'startOut');

            if strcmpi(startOut, 'on')

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
            
            
            PortName = 'ValidOut';
            TerminatorName = 'Terminator1';
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
                    add_block('built-in/Outport', PortPath, 'Port', '3', ...
                         'Position', PortPosition, 'OutDataTypeStr', 'boolean', 'PortDimensions', '1');
                end
                
                if strcmpi(startOut, 'on')
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

                % Add terminator block
                add_block('built-in/Terminator', TerminatorPath, 'Position', PortPosition);
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
            
            
        end
    end
    
end

% LocalWords:  DSERIALIZER
