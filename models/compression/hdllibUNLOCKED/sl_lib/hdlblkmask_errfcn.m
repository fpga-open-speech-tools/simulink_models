function [emsg] = hdlblkmask_errfcn(bh, errmsg)
% Error callback function (ErrFcn) for hdldemolib blocks

% Copyright 2007-2012 The MathWorks, Inc.
%   

% For now the only check is for the dual-port RAM
% But this function can be shared if more blocks are added to hdldemolib in
% the future

% If we are not producing any error return the last error
lerr = sllasterror;
emsg = lerr.Message;

% Checks address port width
try
    addrsz = evalin('base', get_param(bh, 'ram_size'));
    if (addrsz < 2 || addrsz > 32)
        emsg = 'Address port width should be between 2 and 32.'; %move to message catalog
        return;
    end
catch
end
