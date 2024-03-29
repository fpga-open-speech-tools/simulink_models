%

% Copyright 2016-2017 The MathWorks, Inc.
function [InputWordLength, YData, TableWordLength, TableFracLength, OutputWordLength,...
    OutputFracLength] = hdlblkmask_cos(block_name, TableDataTypeStr, NumDataPoints)

% suppress saturation warning
Simulink.suppressDiagnostic([block_name '/CastU16En2'], 'SimulinkFixedPoint:util:Saturationoccurred');
% suppress overflow warning
Simulink.suppressDiagnostic([block_name '/insig'], 'SimulinkFixedPoint:util:Overflowoccurred');
% turn off warning reg precision loss
oldsQuery = warning('query','SimulinkFixedPoint:util:fxpParameterPrecisionLoss');
warning('off','SimulinkFixedPoint:util:fxpParameterPrecisionLoss');
warCleanup = onCleanup(@() warning(oldsQuery.state,...
    'SimulinkFixedPoint:util:fxpParameterPrecisionLoss') );

needDelayBlock = strcmpi(get_param(block_name,'SimulateLUTROMDelay'),'on');

dlyBlock = [block_name,'/Unit Delay'];
delayBlockExists = getSimulinkBlockHandle(dlyBlock)~=-1;

raw_log2_InputWordLength = log2(NumDataPoints+1); % power of 2 contain 1 more data point
InputWordLength = ceil(raw_log2_InputWordLength) + 1; % FL needs 1 more precision for two quarters

mdlIsCorrect = ~xor(needDelayBlock, delayBlockExists);

% Either the block exists and we don't want it, or it doesn't exist and we need
% it.
if ~mdlIsCorrect
    tblPort = ['Look-Up',newline,'Table/1'];
    dlyPort = 'Unit Delay/1';
    negPort = 'Negate/1';
    posPort = 'Positive/1';
    if delayBlockExists
        % remove the delay block if the user did not desire it
        delete_line(block_name, dlyPort, negPort);
        delete_line(block_name, dlyPort, posPort);
        delete_line(block_name, tblPort, dlyPort);
        delete_block(dlyBlock);
        add_line(block_name, tblPort, negPort, 'AutoRouting', 'On');
        add_line(block_name, tblPort, posPort,'AutoRouting', 'On');
    else
        % Converse of above; add the Unit Delay block.
        delete_line(block_name, tblPort, negPort);
        delete_line(block_name, tblPort, posPort);
        add_block('built-in/Delay', dlyBlock, 'Position', [780, 410, 810, 440]);
        set_param(dlyBlock, 'DelayLengthSource', 'Dialog');
        set_param(dlyBlock, 'DelayLength', '1');
        add_line(block_name, dlyPort, negPort, 'AutoRouting', 'On');
        add_line(block_name, dlyPort, posPort, 'AutoRouting', 'On');
        add_line(block_name, tblPort, dlyPort, 'AutoRouting', 'On');
    end
end

% Do our best to make sure that the delay has its HDL reset type set correctly,
% and that the output switch is delay balanced.
RAMDelayBalance = [block_name '/RAMDelayBalance'];
if needDelayBlock
    set_param(RAMDelayBalance, 'DelayLength', '1');
   try
        % Eat any exception here; the callback is invoked during load_system
        % before the hdlcoder object exists.
        hdlset_param([block_name,'/Unit Delay'], 'ResetType', 'None');
    catch
   end
else
    set_param(RAMDelayBalance, 'DelayLength', '0');
end

% Deduce OutputWordLength and OutputFractionLength from the TableDataTypeStr.
if strcmpi(TableDataTypeStr,'Inherit: auto')
    OutputWordLength = InputWordLength;
    TableWordLength = OutputWordLength - 1;
    TableFracLength = TableWordLength - 2;
    OutputFracLength = TableFracLength;
elseif isa(TableDataTypeStr, 'Simulink.NumericType')
    OutputWordLength = TableDataTypeStr.WordLength + 1;
    TableWordLength = TableDataTypeStr.WordLength;
    TableFracLength = TableDataTypeStr.FractionLength;
    OutputFracLength = TableFracLength;
else
    error('Unsupported setting for TableDataTypeStr');
end

% Sine data for Cosine is not a mistake; parameter pooling can open up data
% sharing with this design.
XData = linspace(0, 0.25, NumDataPoints);
YData = sin(2*pi*XData);

% switch the saturation on/off based on if NPts is power of 2
if isequal(InputWordLength, raw_log2_InputWordLength)
    set_param([block_name,'/pow2switch'],'value','0');
else
    set_param([block_name,'/pow2switch'],'value','1');
end

delete(warCleanup);
end
