function [blkname, portLabels] = hdlblkmask_bitconcat
% Mask dynamic dialog function for BitConcat block

%   Copyright 2007-2011 The MathWorks, Inc.
%     

% Cache handle to block
blk = gcbh;   

% Set portLabels
numInputs = str2double(get_param(blk, 'numInputs'));
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

% define the name that will appear on the mask
blkname = 'Concat';
