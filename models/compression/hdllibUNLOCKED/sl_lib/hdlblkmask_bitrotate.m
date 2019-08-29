function blkname = hdlblkmask_bitrotate
% Mask dynamic dialog function for BitRotate block

%   Copyright 2007-2011 The MathWorks, Inc.
%     

% Cache handle to block
blk = gcbh;   

% Get mode value
mode = get_param(blk, 'mode');
numN = get_param(blk, 'N');

% define the name that will appear on the mask
isBlkInLibrary = strcmp(get_param(bdroot(blk),'BlockDiagramType'),'library');
if isBlkInLibrary
  blkname = 'Rotate';
else
  blkname = [mode,'\nLength : ',numN];
end


