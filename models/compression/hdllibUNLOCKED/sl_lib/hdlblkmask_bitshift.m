function blkname = hdlblkmask_bitshift
% Mask dynamic dialog function for BitShift block

%   Copyright 2007-2011 The MathWorks, Inc.
%     

% Cache handle to block
blk = gcbh;   

% Get mode value
mode = get_param(blk, 'mode');
numN = get_param(blk, 'N');
switch mode
    case 'Shift Left Logical'
        modeString = 'Shift Left\nLogical';
    case 'Shift Right Logical'
        modeString = 'Shift Right\n Logical';        
    case 'Shift Right Arithmetic'
        modeString = 'Shift Right\n Arithmetic';        
    otherwise
        modeString = 'Shift';        
end

% define the name that will appear on the mask
isBlkInLibrary = strcmp(get_param(bdroot(blk),'BlockDiagramType'),'library');
if isBlkInLibrary
  blkname = 'Shift';
else
  blkname = [modeString, '\nLength : ', numN];
end
