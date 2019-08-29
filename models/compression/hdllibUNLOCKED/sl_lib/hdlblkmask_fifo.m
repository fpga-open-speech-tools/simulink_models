function hdlblkmask_fifo(prop, varargin)
% HDLBLKMASK_FIFO
%
% handles callbacks for FIFO Block
% prop indicates which property the callback is for
% All properties need DSP System Toolbox to be installed and we error for only one
% property, so that there aren't too many error messages

%   Copyright 2009-2014 The MathWorks, Inc.

if(~isempty(varargin))
    blk = varargin{1};
else
    blk=gcb();
end

switch lower(prop)
    case 'addwrapoverflow'
        adder_wrapoverflow_setup_callback(blk);
    case 'init'
        init_callback(blk);
    case 'size_check'
        size_check_callback(blk);
    case 'ratio_check'
        ratio_check_callback(blk);
end

function init_callback(blk)
    % setup output
    output_setup(blk);
    
    % setup ratio
    ratio_setup(blk);
    
    % setup size
    size_setup(blk);
    
    % setup msg
    msg_setup(blk);


function output_setup(blk)
    % initialize settings for all the output port data (note that this
    % is called not through a callback, but in the initialization area
    % of the mask)
    output_info.names={'Empty','Full','Num'};
    output_info.vars={'show_empty','show_full','show_num'};
    output_info.offset=strcmpi(cellfun(@(c) get_param(blk,c), output_info.vars, 'uniformoutput', false),'on');
    
    output_callback(blk, output_info);


function ratio = ratio_setup(blk)
ratio = hdlslResolve('ratio', blk);

if ratio >= 1
    I = '1';
    O = 'ratio';
else
    I = 'ratio';
    O = '1';
end

% In order to get required precision for rate transition blocks, evaluation
% should happen within the rate transition blocks. Therefore, each numerical
% setting on the rate transition block is set as a string to be evaluated
% using mask parameters
inUpRtn = [blk '/Upsample/Rate Transition'];
inUpCtn = [blk '/Upsample/Counter'];
set_param(inUpRtn,'OutPortSampleTimeMultiple',I);
set_param(inUpCtn,'uplimit', ['(1/' I ') - 1']);

pushUpRtn = [blk '/Upsample1/Rate Transition'];
pushUpCtn = [blk '/Upsample1/Counter'];
set_param(pushUpRtn,'OutPortSampleTimeMultiple', I);
set_param(pushUpCtn,'uplimit', ['(1/' I ') - 1']);

popUpRtn = [blk '/Upsample2/Rate Transition'];
popUpCtn = [blk '/Upsample2/Counter'];
set_param(popUpRtn,'OutPortSampleTimeMultiple', ['1/' O]);
set_param(popUpCtn,'uplimit', [O ' - 1']);

outDwn = [blk '/Downsample'];
set_param(outDwn,'OutPortSampleTimeMultiple', O);

function ratio_check_callback(blk)
ratio = hdlslResolve('ratio', blk);

if ratio >= 1
    I = '1';
    O = 'ratio';
else
    I = 'ratio';
    O = '1';
end

err=@(x) (x-floor(x))>eps(x);
if err(eval(O)) || err(1/eval(I))
	set_param(blk, 'ratio', '1');
	error(message('hdlsllib:hdlsllib:rateRatioError'));
end

function size_setup(blk)
N=hdlslResolve('fifo_size', blk);
address_size = ceil(log2(N));
address_max = 2^address_size - 1;
address_adj = address_max - (N-1) + 1;

counter_bitwidth = ceil(log2(N+1));
counter_comp = 2^(counter_bitwidth) - 1;

ram = [blk, '/Simple Dual Port RAM'];
set_param(ram, 'ram_size', num2str(address_size));

pushIdx_Add = [blk, '/PushIdx/AddSatOff'];
set_param(pushIdx_Add, 'OutDataTypeStr', ['fixdt(0,' num2str(address_size) ',0,''DataTypeOverride'', ''Off'')']);
pushIdx_AdjConstant = [blk, '/PushIdx/AddrAdjustConstant'];
pushIdx_IncrConstant = [blk, '/PushIdx/IncrConstant'];
set_param(pushIdx_AdjConstant,'value', num2str(address_adj));
set_param(pushIdx_AdjConstant, 'OutDataTypeStr', ['fixdt(0,' num2str(address_size) ',0,''DataTypeOverride'', ''Off'')']);
set_param(pushIdx_IncrConstant, 'OutDataTypeStr', ['fixdt(0,' num2str(address_size) ',0,''DataTypeOverride'', ''Off'')']);

popIdx_Add = [blk, '/PopIdx/AddSatOff'];
set_param(popIdx_Add, 'OutDataTypeStr', ['fixdt(0,' num2str(address_size) ',0,''DataTypeOverride'', ''Off'')']);
popIdx_AdjConstant = [blk, '/PopIdx/AddrAdjustConstant'];
popIdx_IncrConstant = [blk, '/PopIdx/IncrConstant'];
set_param(popIdx_AdjConstant,'value', num2str(address_adj));
set_param(popIdx_AdjConstant, 'OutDataTypeStr', ['fixdt(0,' num2str(address_size) ',0,''DataTypeOverride'', ''Off'')']);
set_param(popIdx_IncrConstant, 'OutDataTypeStr', ['fixdt(0,' num2str(address_size) ',0,''DataTypeOverride'', ''Off'')']);

adjustSampleOutNum_Add = [blk, '/AdjustSampleOutNum/AddSatOff'];
set_param(adjustSampleOutNum_Add, 'OutDataTypeStr', ['fixdt(0,' num2str(counter_bitwidth) ',0,''DataTypeOverride'', ''Off'')']);
adjustSampleOutNum_NumConstant = [blk, '/AdjustSampleOutNum/NumConstant'];
set_param(adjustSampleOutNum_NumConstant,'value', num2str(counter_comp));
set_param(adjustSampleOutNum_NumConstant,'OutDataTypeStr', ['fixdt(0,' num2str(counter_bitwidth) ',0,''DataTypeOverride'', ''Off'')']);

nextSampleOutNum_Add = [blk, '/NextSampleOutNum/AddSatOff'];
set_param(nextSampleOutNum_Add, 'OutDataTypeStr', ['fixdt(0,' num2str(counter_bitwidth) ',0,''DataTypeOverride'', ''Off'')']);
nextSampleOutNum_IncrConstant = [blk, '/NextSampleOutNum/IncrConstant'];
set_param(nextSampleOutNum_IncrConstant,'OutDataTypeStr', ['fixdt(0,' num2str(counter_bitwidth) ',0,''DataTypeOverride'', ''Off'')']);


function size_check_callback(blk)
N=hdlslResolve('fifo_size', blk);
if N<4
	error(message('hdlsllib:hdlsllib:fifoSizeError'));
end

function msg_setup(blk)
popMsgType = get_param(blk, 'pop_msg');
popEmpty_Assert = [blk, '/ControlSignalsValidation/Assertion PopEmpty'];
setupMsgTypeCmds(popEmpty_Assert, popMsgType, 'FIFOPopEmpty');

pushMsgType = get_param(blk, 'push_msg'); 
pushEmpty_Assert = [blk, '/ControlSignalsValidation/Assertion PushOntoFull'];
setupMsgTypeCmds(pushEmpty_Assert, pushMsgType, 'FIFOPushFull');

function setupMsgTypeCmds(msgblkpath, msgtype, msgid)

msgTypes = {'Ignore','Warning','Error'}; 
whichMsgType = cellfun(@(c) strcmpi(msgtype, c), msgTypes);

if whichMsgType(1) % Ignore
    set_param(msgblkpath, 'Enabled', 'off');
elseif whichMsgType(2) % Warning
        set_param(msgblkpath, 'Enabled', 'on');
        set_param(msgblkpath, 'StopWhenAssertionFail', 'off');
        set_param(msgblkpath, 'AssertionFailFcn', ['warning(message(''hdlsllib:hdlsllib:' msgid '''))']);
elseif whichMsgType(3) % Error
        set_param(msgblkpath, 'Enabled', 'on');
        set_param(msgblkpath, 'StopWhenAssertionFail', 'on');
        set_param(msgblkpath, 'AssertionFailFcn',['error(message(''hdlsllib:hdlsllib:' msgid '''))']);
end

function output_callback(blk, output_info)
for i=1:length(output_info.names)
	on=strcmpi(get_param(blk, output_info.vars{i}), 'on');
	block_path=[blk,'/',output_info.names{i}];
	is_outport=strcmpi(get_param(block_path,'blocktype'),'outport');
	
	pos=get_param(block_path,'position');
	if ~on && is_outport
		delete_block(block_path);
		add_block('built-in/Terminator', block_path,...
			'position', pos);
	elseif on && ~is_outport
		delete_block(block_path);
		add_block('built-in/Outport', block_path,...
			'position', pos,...
			'port', num2str(sum(output_info.offset(1:i))+1));
	end
end

function adder_wrapoverflow_setup_callback(blk)
    addTypeStr = get_param(blk,'OutDataTypeStr');
    try 
        addType = eval(addTypeStr);
    catch
        addType = [];
    end
    
    if ~isempty(addType)
        outWL = addType.WordLength;
        
        % extend internal adder WL
        addBlock = [blk, '/Add'];
        newAddTypeStr = ['fixdt(0, ' num2str(outWL + 1) ', 0,''DataTypeOverride'', ''Off'')'];
        set_param(addBlock, 'OutDataTypeStr', newAddTypeStr);
        
        % Extract bits
        extBitsBlock = [blk '/Bitwise Operator'];
        set_param(extBitsBlock, 'BitMask', num2str(2^outWL-1));
        
        % Set out data type
        outDTCblock = [blk '/Data Type Conversion'];
        set_param(outDTCblock, 'OutDataTypeStr', ...
                            ['fixdt(0,' num2str(outWL) ',0,''DataTypeOverride'', ''Off'')']);
    end

    
