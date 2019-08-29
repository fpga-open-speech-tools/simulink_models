function sysObjMap = hdlsysobjs
% map from System object to HDL implementation

%   Copyright 2011-2019 The MathWorks, Inc.

% This file is eval'ed, not executed. Do not count this for code coverage. Do
% not place an 'end' at the end of this file.
sysObjMap = containers.Map;

% mapping for new hdl.RAM which replaces hdlram
sysObjMap('hdl.RAM') = 'hdldefaults.RamSystem';
sysObjMap('hdl.MatrixMultiply') = 'hdldefaults.MatrixMultiplyStream';
sysObjMap('hdl.MatrixInverse') = 'hdldefaults.MatrixInverseStream';

sysObjMap('hdl.internal.PIRHDLFunctionObject') = 'hdldefaults.SinCosCordic';

% end

% LocalWords:  eval'ed hdlram hdldefaults PIRHDL
