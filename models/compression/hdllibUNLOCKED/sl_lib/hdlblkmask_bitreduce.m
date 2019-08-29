function blkname = hdlblkmask_bitreduce
% Mask dynamic dialog function for BitReduce block

%   Copyright 2007-2011 The MathWorks, Inc.
%     

% Cache handle to block
blk = gcbh;   

% Get mode value
mode = get_param(blk, 'mode');

% define the name that will appear on the mask
isBlkInLibrary = strcmp(get_param(bdroot(blk),'BlockDiagramType'),'library');
if isBlkInLibrary
  blkname = 'Reduce';
else
  blkname = ['Bit Reduce\n(', mode, ')'];
end