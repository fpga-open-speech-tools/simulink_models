function hdlblkmask_deserializer(tapdelay_based)
% hdlblkmask_deserializer

%   Copyright 2009-2014 The MathWorks, Inc.

if nargin < 1
    tapdelay_based = false;
end

outputLen    = hdlslResolve('outputLen', gcb);
% check whether outputLen is 1
if outputLen <= 1
    error(message('hdlsllib:hdlsllib:SerVectorSize', 'Deserializer', get_param( gcb, 'Name' )));
end



if ~tapdelay_based
    serialFactor = hdlslResolve('serialFactor', gcb);
    
% check whether mod(outputLen, serialFactor) == 0
if mod(outputLen, serialFactor) ~= 0
    error(message('hdlsllib:hdlsllib:InvalidFactor', get_param( gcb, 'Name' )));
end

end



end % [EOF]


