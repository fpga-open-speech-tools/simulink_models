%#codegen
function y = cast_to_fi(u)
% convert input integer to an equivalent fi

%   Copyright 2008-2010 The MathWorks, Inc.
eml.allowpcode('plain');

if isinteger(u)
    y = fi(u, 'DataTypeOverride', 'Off');
elseif islogical(u)
    y = convertBool2Ufix1(u);
else
    y = u;
end


function y = convertBool2Ufix1(u)

y = fi(zeros(size(u)), 0, 1, 0, 'DataTypeOverride', 'Off');
for ii=1:length(u)
    if u(ii)
        y(ii) = fi(1, 0, 1, 0, 'DataTypeOverride', 'Off');
    else
        y(ii) = fi(0, 0, 1, 0, 'DataTypeOverride', 'Off');
    end
end
