classdef HDLStatusEnum < Simulink.IntEnumType
% HDLStatusEnum Enumerated class example

% HDL supported enumerations may be derived from Simulink.IntEnumType or any
% supported integer type.
% HDL enumerated values must be monotonically increasing.

%   Copyright 2013 The MathWorks, Inc.

  enumeration
    Waiting(-1)
    Ready(1)
    Valid(4)
  end
end
