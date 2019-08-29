function hdlblkmask_streaming_internal_cb(blk)
%

%   Copyright 2016-2018 The MathWorks, Inc.
    en = get_param(blk,'MaskEnables');
    switch get_param(blk,'initValueSetting')
        case 'Input port'
            en{2} = 'off';
        case 'Dialog'
            en{2} = 'on';
        otherwise
            disp('Not a valid option for accumulator initial value')
    end
set_param(blk,'MaskEnables',en);
