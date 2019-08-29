function hdlblkmask_serializer
%

%   Copyright 2009-2014 The MathWorks, Inc.

inputLen     = hdlslResolve('inputLen', gcb);
serialFactor = hdlslResolve('serialFactor', gcb);
EnumInit     = hdlslResolve('EnumInit', gcb);

% check whether inputLen is 1
if inputLen <= 1
    error(message('hdlsllib:hdlsllib:SerVectorSize', 'Serializer', get_param( gcb, 'Name' )));
end

% check whether mod(inputLen, serialFactor) == 0
if mod(inputLen, serialFactor) ~= 0
    error(message('hdlsllib:hdlsllib:InvalidSerFactor', get_param( gcb, 'Name' )));
end

dvalidport_callback;

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dvalidport_callback
% switch between terminator block and Dvalid output port

blk = gcb;
PortName = 'Dvalid';
TerminatorName = 'Terminator';
PortPath = [blk '/' PortName];
TerminatorPath = [blk '/' TerminatorName];
dvalidPort = get_param(blk, 'dvalidport');

if strcmpi(dvalidPort, 'on')
    % When mask is set to ON, add port if it is not already there
    if isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
            'SearchDepth',1,'Name',PortName))
        
        % Get terminator blk position, then delete it
        PortPosition = get_param(TerminatorPath, 'Position');
        delete_block(TerminatorPath);
        
        % Get port number offset, and add port
        add_block('built-in/Outport', PortPath, 'Port', '2', ...
            'Position', PortPosition, 'OutDataTypeStr', 'boolean');
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

end % [EOF]

% LocalWords:  Ser
