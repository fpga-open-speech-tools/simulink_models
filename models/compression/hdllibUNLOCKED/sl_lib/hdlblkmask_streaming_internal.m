%

%   Copyright 2016-2018 The MathWorks, Inc.

function hdlblkmask_streaming_internal(blk, initValueSetting, initValue, varargin)


    %%%input port growth for bias
    input3str = [blk, '/c'];
    constStr = [blk, '/const_initValue'];

    if(length(initValue) > 1)
        error('Initial condition in Multiply-Accumulate block must be scalar.')
    end

    initValInputExists = getSimulinkBlockHandle(input3str) ~= -1;

    switch initValueSetting
        case 1
            % Configure for internal input
            if initValInputExists            
                replace(input3str,'hdlsllib/Sources/Constant');
                set_param(input3str, 'Name', 'const_initValue');
                set_param(constStr, 'OutDataTypeStr', 'Inherit: Inherit via back propagation'...
                                           , 'SampleTime', '-1');
            end
            if(isa(initValue,'numeric'))%this block moved outside
                set_param(constStr, 'Value', num2str(initValue));
            else
                set_param(constStr, 'Value', initValue.tostring);
            end
        case 2
            % Configure for external input
            if ~initValInputExists
                replace(constStr,'built-in/Inport');
                set_param(constStr, 'Name', 'c',...
                                             'PortDimensions', '1');
            end
    end
    
    if nargin==4 %%if num_samples_internal is passed
            %set counter outputbitwidth
            raw_var = varargin{1};
            if ischar(raw_var)
                num_samples = str2num(raw_var);
            else
                num_samples = raw_var;
            end
            wordlen =  num2str(ceil(log2(num_samples+1)));
            set_param([blk, '/Counter'],'countwordlen',wordlen);
    end
    
end

function replace(oldblock,newblock)
    pos = get_param(oldblock,'Position');
    orient = get_param(oldblock,'Orientation');
    delete_block(oldblock);
    if(contains(newblock,'Constant'))
        add_block(newblock,oldblock,'Position',pos,'Orientation',orient);
    elseif(contains(newblock,'Inport'))
        add_block(newblock,oldblock,'Position',pos,'Orientation',orient);
    end
end
