function reperr = hdlblkmask_fifo_updatemsg( blk, errid, varargin )
% replace a generic Simulink error message about fifo implementation blocks
% with a more instructional message on how to properly use/setup the HDL FIFO

%   Copyright 2013-2014 The MathWorks, Inc.

switch(errid)
    case 'Simulink:SampleTime:IllegalIPortRateTrans'
        ratio = get_param(blk, 'ratio');
        reperr = message('hdlsllib:hdlsllib:FIFOinputrates', ratio).getString;
    case 'Simulink:blocks:TsMultipleNotWorkWithZOHContinuousTs'
        reperr = message('hdlsllib:hdlsllib:FIFOsampleTimeNotDiscrete').getString;
    case 'Simulink:Engine:PortDimsMismatch41'
        reperr = message('hdlsllib:hdlsllib:FIFOdimensionunsupported').getString;
    otherwise
        reperr = varargin{1};
end


