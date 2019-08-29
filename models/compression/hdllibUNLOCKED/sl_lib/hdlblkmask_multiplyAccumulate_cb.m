classdef hdlblkmask_multiplyAccumulate_cb
%

%   Copyright 2018 The MathWorks, Inc.

    properties
    end
    
    methods (Static = true)

        function input_bias_cb1(blk)
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
        end

        function input_bias_cb2(blk)
            en = get_param(blk,'MaskEnables');   
            switch get_param(blk,'initValueSetting2')
                case 'Input port'
                    en{5} = 'off';
                case 'Dialog'
                    en{5} = 'on';
                otherwise
                    disp('Not a valid option for accumulator initial value')
            end
            set_param(blk,'MaskEnables',en);  

        end


        function input_bias_cb3(blk)
            en = get_param(blk,'MaskEnables');
            switch get_param(blk,'initValueSetting3')
                case 'Input port'
                    en{7} = 'off';
                case 'Dialog'
                    en{7} = 'on';
                otherwise
                    disp('Not a valid option for accumulator initial value')
            end
            set_param(blk,'MaskEnables',en);

        end
     end
end
