function hdlblkmask_mac(blk, initValueSetting, initValue)
%

%   Copyright 2016-2018 The MathWorks, Inc.

input3str = [blk, '/In3'];
constStr = [blk, '/Constant'];
adderVarSubsysStr = [blk, '/Add'];

if(length(initValue) > 1)
    error('Initial condition in Multiply-Accumulate block must be scalar.')
end

initValInputExists = getSimulinkBlockHandle(input3str) ~= -1;

variantControlObjectString = 'nonzeroInitVal';
if(all(initValue == 0) && initValueSetting == 1)
    variantControlObjectString = 'zeroInitVal';
end
set_param(adderVarSubsysStr, 'OverrideUsingVariant', variantControlObjectString );

switch initValueSetting
    case 1
        % Configure for internal input
        if initValInputExists
            replace(input3str,'hdlsllib/Sources/Constant');
            set_param(input3str, 'Name', 'Constant');
            set_param(constStr, 'OutDataTypeStr', 'Inherit: Inherit via back propagation'...
                , 'SampleTime', '-1');
        end
        if(isa(initValue,'numeric'))
            set_param(constStr, 'Value', num2str(initValue));
        else
            set_param(constStr, 'Value', initValue.tostring);
        end
        
    case 2
        % Configure for external input
        if ~initValInputExists
            replace(constStr,'built-in/Inport');
            set_param(constStr, 'Name', 'In3',...
                'PortDimensions', '1');
        end
end


function replace(oldblock,newblock)
orient = get_param(oldblock,'Orientation');
delete_block(oldblock);
if contains(newblock,'Constant')
    add_block(newblock,oldblock,'Position',[15 115 45 145],'Orientation',orient);
elseif contains(newblock,'Inport')
    add_block(newblock,oldblock,'Position',[15 123 45 137],'Orientation',orient);
else
end
