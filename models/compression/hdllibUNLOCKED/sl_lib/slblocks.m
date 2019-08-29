function blkStruct = slblocks
%SLBLOCKS Defines Simulink library block representation for HDL Coder supported blocks

% Copyright 2013 The MathWorks, Inc.

blkStruct.Name    = sprintf('HDL\nCoder');
blkStruct.OpenFcn = 'hdlsllib';
blkStruct.MaskInitialization = '';
blkStruct.MaskDisplay = 'disp(''HDL\nCoder'')';

% Define the library list for the Simulink Library browser.
% Return the name of the library model and the name for it

Browser(1).Library = 'hdlsllib';
Browser(1).Name    = 'HDL Coder';
Browser(1).IsFlat  = 0;

blkStruct.Browser = Browser;

% [EOF] slblocks.m
