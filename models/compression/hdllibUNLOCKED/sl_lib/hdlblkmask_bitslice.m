function blkname = hdlblkmask_bitslice
% Mask dynamic dialog function for BitSlice block

%   Copyright 2007-2011 The MathWorks, Inc.
%     

% Cache handle to block
blk = gcbh;   

% Get mode value
lindex = get_param(blk, 'lidx');
rindex = get_param(blk, 'ridx');

% define the name that will appear on the mask
isBlkInLibrary = strcmp(get_param(bdroot(blk),'BlockDiagramType'),'library');
if isBlkInLibrary
  blkname = 'Slice';
else
  blkname = ['Slice\n(', lindex, ' downto ', rindex, ')'];
end
