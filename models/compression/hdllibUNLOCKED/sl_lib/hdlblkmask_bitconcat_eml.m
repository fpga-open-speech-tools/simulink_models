function [blkname, portLabels] = hdlblkmask_bitconcat_eml
% Mask dynamic dialog function for BitConcat block

%   Copyright 2007-2017 The MathWorks, Inc.
%     

% Cache handle to block
blk = gcbh;   

% Set portLabels
%numInputs = str2double(get_param(blk, 'numInputs'));
numInputs = hdlslResolve_local('numInputs', blk);

% define the name that will appear on the mask
blkname = 'Concat';

fullpath = getfullname(blk);
modelname = bdroot(fullpath);

if numInputs == 1
    portLabels(1).port = 1;
    portLabels(1).txt = '';
    portLabels(2).port = 1;
    portLabels(2).txt = '';    
else
    portLabels(1).port = 1;
    portLabels(1).txt = 'H';
    portLabels(2).port = numInputs;
    portLabels(2).txt = 'L';    
end

if strcmpi(modelname, 'hdlsllib')
    return;
end

obj = get_param(fullpath, 'Object');

if length(obj.PortHandles.Inport) == numInputs
    return;
end

% Collect the connectivity information and store in a map. This is done
% only for the input ports. Output port's connectivity is kept intact since
% there can be only 1 output port and that cannot be changed.
%
% Increasing number of inputs:
%     When number of inputs are increased from 2 to 4, 2 more inputs are
%     added to the 'Bit Concat' block. Previous connections are maintained
%     for 'H', 'H-1' bits. 'H-2' and 'L' inputs remain unconnected.
%     (Only H and L inputs are named. H-1, H-2 are mentioned for
%     understanding)
%
% Decreasing number of inputs:
%     When number of inputs are decreased from 4 to 2, 'H' and 'H-1' input
%     ports and their connectivity is retained. Ports 'H-2' and 'L' are
%     removed. Along with removal of these two ports, lines connected to
%     'H-2' and 'L' are also removed. However, after removal of these two
%     ports 'H-1' will be renamed as 'L'.
%     
%     Connectivity to multiple blocks:
%         If a line connected to  of Bit concat block at port 'L' was also
%         connected to an input port of a different block (add/1), this
%         would be a case of 1 driver multiple sinks. In such a case,
%         connection to 'add/1' is retained.
%
% Partial connectivity:
%     In case there are some intermediate ports which are unconnected, both
%     srcPortArr and dstPortArr will hold 'noconnectivity' for that port
%     number. This helps in restoring the connectivity appropriately.
%
portHan = get_param(blk, 'PortHandles');
inputPorts = portHan.Inport;

% Arrays srcPortArr and dstPortArr are used to store the connectivity. Map
% cannot be used since same line could be connected to two input ports. In
% such a case, information for one of the input ports will get lost.
[srcPortArr, dstPortArr] = removeConnectedLines(inputPorts);

blks = obj.Blocks;
lines = obj.Lines;

for ii=1:length(lines)
    delete_line(lines(ii).Handle);
end
for ii=1:length(blks)
    internalBlkName = [fullpath, '/', blks{ii}];
    % Do not remove output port inside the masked subsystem
    if ~strcmp (get_param(internalBlkName, 'BlockType'), 'Outport')
        delete_block(internalBlkName);
    end
end

ppos = [15    30    35    50];
bpos = [15    30    35    50];
add_block('built-in/Inport', [fullpath, '/u1', ], 'Position', ppos);
ppos = [ppos(1), ppos(2)+30, ppos(3), ppos(4)+30];
inp1 = 'u1';

load_system('hdlmdlgenlib');

if (numInputs == 1)
    bc = sprintf('bc%d', ii);
    bpos = [bpos(1)+60, bpos(2)+30, bpos(3)+60, bpos(4)+30];
    add_block('hdlmdlgenlib/Bit Concat1', [fullpath, '/' bc], 'Position', bpos);  
    add_line(fullpath, [inp1, '/1'], [bc, '/1']);
else        
    for ii=2:numInputs
        inp2 = sprintf('u%d', ii);
        add_block('built-in/Inport', [fullpath, '/', inp2], 'Position', ppos);
        bc = sprintf('bc%d', ii);
        bpos = [bpos(1)+60, bpos(2)+30, bpos(3)+60, bpos(4)+30];
        add_block('hdlmdlgenlib/Bit Concat2', [fullpath, '/' bc], 'Position', bpos);
        ppos = [ppos(1), ppos(2)+30, ppos(3), ppos(4)+30];
        
        add_line(fullpath, [inp1, '/1'], [bc, '/1']);
        add_line(fullpath, [inp2, '/1'], [bc, '/2']);
        
        inp1 = bc;
    end
end

% connect to outPort block inside masked subsystem
add_line(fullpath, [bc, '/1'], 'y/1');

% Reconnect all the ports of 'Bit Concat' block
dut = get_param(blk, 'Parent');
for ii = 1:numel(srcPortArr)
    if ii > numInputs
        break;
    end
    srcPort = srcPortArr(ii);
    srcPortStr = char(srcPort);
    if strcmp (srcPortStr, 'noconnectivity')
        continue;
    end    
    dstPort = char(dstPortArr(ii));
    add_line(dut, srcPortStr, dstPort, 'autorouting', 'on');
end

end

% Removes the lines connected to input ports
% If there are no lines connected, no impact.
% Before removing the lines connected to input ports, connectivity
% information is stored in two array srcPortArr and dstPortArr.
%
function [srcPortArr, dstPortArr] = removeConnectedLines(ports)
    totalPorts = numel(ports);
    srcPortArr = cell(totalPorts, 1);
    dstPortArr = cell(totalPorts, 1);

    for ii = 1: totalPorts
        port = ports(ii);
        line = get_param(port, 'Line');
        
        % No line connected. Store this information as well.
        srcPortStr = 'noconnectivity';
        dstPortStr = 'noconnectivity';
        if ishandle(line) 
            % Get the src port name
            srcPort = get_param(line, 'SrcPortHandle');
            srcPortParentName = get_param(srcPort, 'Parent');
            [~, name, ~] = fileparts(srcPortParentName);
            srcPortNum = get_param(srcPort, 'PortNumber');
            srcPortStr = [name '/' int2str(srcPortNum)];
        

            % Get the destination port name
            dstPort = get_param(line, 'dstPortHandle');
            dstPortParentName = get_param(dstPort, 'Parent');
            [~, name, ~] = fileparts(dstPortParentName);
            dstPortNum = get_param(dstPort, 'PortNumber');
            dstPortStr = [name '/' int2str(dstPortNum)];
            
            % Remove actual line
            delete_line(line);
        end

        % Store the information
        srcPortArr{ii} = srcPortStr;
        dstPortArr{ii} = dstPortStr;
    end
end

%--------------------------------------------------------------------------
function val = hdlslResolve_local(param, blk)
% Resolve and validate parameter value

val = hdlslResolve(param, blk);

if ~(isnumeric(val) && isreal(val) && isscalar(val))
    error(message('hdlsllib:hdlsllib:invalidcounterparam'));
end
end

% LocalWords:  hdlmdlgenlib bc autorouting invalidcounterparam noconnectivity
