function hdlblkmask_mac_cb(blk)
%

%   Copyright 2016 The MathWorks, Inc.
    en = get_param(blk,'MaskEnables');
    switch get_param(blk,'initValueSetting')
        case 'Input port'
            en{3} = 'off';
        case 'Dialog'
            en{3} = 'on';
        otherwise
            disp('Not a valid option for accumulator initial value')
    end
set_param(blk,'MaskEnables',en);
