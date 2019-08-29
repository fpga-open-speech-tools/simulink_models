function [maxval_sc, freerun, samptime] = hdlblkmask_counter
% Mask dynamic dialog function for the HDL Counter block

%   Copyright 2008-2017 The MathWorks, Inc.

blk = gcb;

if nargout == 0
    counter_dynamic(blk);
else
    [maxval_sc, freerun, samptime] = counter_init(blk);
end
end

%--------------------------------------------------------------------------
function counter_dynamic(blk)
% Get current mask enable settings
maskenb = get_param(blk, 'MaskEnables');
maskenb_new = maskenb;

% Mask parameter definition
CountMax = 4;           % Count to value
CountMin = 6;           % Count from value
CountMinSpecify = 5;    % Count from selection (Specify/Initial value)
CountSampTime = 14;     % Sample time

% If the counter is free running, disable the count to (max) value, count
% from selection and the count from (min) value settings
freerun = strcmp(get_param(blk, 'CountType'), 'Free running');
if freerun
    % disable the count to (max) value setting
    maskenb_new{CountMax} = 'off';
    % set the count from selection to 'Initial value' and disable the
    % setting
    set_param(blk, 'CountFromType', 'Initial value');
    maskenb_new{CountMinSpecify} = 'off';
    % set the count from (min) value to the initial value and disable the
    % setting
    initval = get_param(blk, 'CountInit');
    set_param(blk, 'CountFrom', initval);
    maskenb_new{CountMin} = 'off';
else
    % in count limited mode, enable the count to (max) value and the count
    % from selection settings
    maskenb_new{CountMax} = 'on';
    maskenb_new{CountMinSpecify} = 'on';
    
    % If count from selection is set to 'Specify', then enable the count
    % from (min) value setting
    countMinSpecifyVal = strcmp(get_param(blk, 'CountFromType'), 'Specify');
    if countMinSpecifyVal
        maskenb_new{CountMin} = 'on';
    else
        % set the count from (min) value to the initial value and disable
        % the setting
        initval = get_param(blk, 'CountInit');
        set_param(blk, 'CountFrom', initval);
        maskenb_new{CountMin} = 'off';
    end
end

% If any port is turned on, disable the sample time setting
countport(1) = strcmp(get_param(blk, 'CountResetPort'), 'on');
countport(2) = strcmp(get_param(blk, 'CountLoadPort'), 'on');
countport(3) = strcmp(get_param(blk, 'CountEnbPort'), 'on');
countport(4) = strcmp(get_param(blk, 'CountDirPort'), 'on');
if any(countport)
    maskenb_new{CountSampTime} = 'off';
else
    maskenb_new{CountSampTime} = 'on';
end

% Set mask enables
if ~isequal(maskenb_new, maskenb)
    set_param(blk, 'MaskEnables', maskenb_new);
end
end

%--------------------------------------------------------------------------
function [maxval_sc, freerun, samptime] = counter_init(blk)
% Get current mask enable settings
maskenb = get_param(blk, 'MaskEnables');

% Mask parameter definition
CountMax = 4;
CountResetPort = 7;
CountLoadPort = 8;
CountEnbPort = 9;
CountDirPort = 10;
CountSampTime = 14;

% Add / remove ports according to mask settings
% This must be done first before attempting to get values from edit-type
% mask parameters, since this function simply stops executing if it
% encounters an error, when it's called by clicking OK/Apply on the mask.
% It does not call the subsystem error function. Otherwise, if user sets a
% mask value to an undefined variable and checks a port checkbox at the
% same time, the function will exit when it cannot evaluate the mask value
% without adding the port and without any error message, and that will
% appear as a bug.
portstruct.pos = [CountResetPort CountLoadPort CountEnbPort CountDirPort];
portstruct.num = [1 2 1 1];

AddCountPort(blk, portstruct, {'rst'}, {'0'}, CountResetPort);
AddCountPort(blk, portstruct, {'load', 'load_val'}, {'0', '0'}, CountLoadPort);
AddCountPort(blk, portstruct, {'enb'}, {'1'}, CountEnbPort);
AddCountPort(blk, portstruct, {'dir'}, {'1'}, CountDirPort);

% Gather data to perform error checking on the mask parameters
issigned = strcmp(get_param(blk, 'CountDataType'), 'Signed');
wordlen = hdlslResolve_local('CountWordLen', blk);
fraclen = hdlslResolve_local('CountFracLen', blk); % always 0 for now

initval = hdlslResolve_local('CountInit', blk);
minval = hdlslResolve_local('CountFrom', blk);
stepval = hdlslResolve_local('CountStep', blk);
freerun = strcmp(get_param(blk, 'CountType'), 'Free running');
if freerun
    maxval = [];
else
    maxval = hdlslResolve_local('CountMax', blk);
end

% Perform the mask param error checking.
countrange = checkCounterParams(wordlen, fraclen, issigned, initval, minval, ...
    stepval, maxval, freerun);

% Set data type string for load_val port (overwrite default boolean), after
% CountWordLen & CountFracLen are validated (g536610)
DTStr = 'fixdt(issigned,CountWordLen,CountFracLen,''DataTypeOverride'',''Off'')';
SetCountPortDT(blk, 'load_val', DTStr);

% Compute the final 'count to' (max) value
if ~freerun && strcmp(maskenb{CountMax}, 'on')
    if initval == maxval && minval == maxval
        error(message('hdlsllib:hdlsllib:initequalmax'));
    end
    maxval_sc = maxval*(2^fraclen);
else
    maxval_sc = countrange(2);
end

% COMMENT OUT THE FOLLOWING FOR NOW
% Doesn't seem like it should be an error. Warning is probably better. Code
% seems to work with brief testing, but should be tested more later.

% % Check if max value is reachable (init + n*step = max) (count limited only)
% % Use the scaled init/step/max value for the following checks
% % If step is +ve (count up) and max > init, or if step is -ve (count down)
% % and max < init, end value of vector init:step:max should equal max
% % If step is +ve but max < init, add 2^wordlen to end value before check
% % If step is -ve but max > init, subtract 2^wordlen to end value before check
% % Example:
% % 4-bit signed counter
% % 1:2:7  --- 1 3 5 7
% % 1:-2:7 --- 1 -1 -3 -5 -7 7(-9) --- max-16
% % 7:-2:1 --- 7 5 3 1
% % 7:2:1  --- 7 -7(9) -5(11) -3(13) -1(15) 1(17) --- max+16
% % Use case:
% % 0:3:-7 (valid but fails in SysGen counter)
% %
% initval_sc = initval*(2^fraclen);
% stepval_sc = stepval*(2^fraclen);
%
% if isempty(initval_sc:stepval_sc:maxval_sc)
%     if sign(stepval) == 1
%         endval = maxval_sc + 2^wordlen;
%     else
%         endval = maxval_sc - 2^wordlen;
%     end
% else
%     endval = maxval_sc;
% end
%
% cval_vec = initval_sc:stepval_sc:endval;
% if cval_vec(end) ~= endval
%     error('hdlsllib:hdlsllib:invalidseq', ...
%         'Count to value cannot be reached with the current initial and step value settings.');
% end

% Get block sample time
if strcmp(maskenb{CountSampTime}, 'on')
    samptime = hdlslResolve_local('CountSampTime', blk);
else
    samptime = -1;
end
end

%--------------------------------------------------------------------------
function val = hdlslResolve_local(param, blk)
% Resolve and validate parameter value
val = hdlslResolve(param, blk);

if ~(isnumeric(val) && isreal(val) && isscalar(val))
    error(message('hdlsllib:hdlsllib:invalidcounterparam'));
end
end

%--------------------------------------------------------------------------
function AddCountPort(blk, PortStruct, PortName, ConstVal, MaskPos)
% When mask checkbox is 'on', add port with name PORTNAME.
% When 'off', remove port and add a constant block with value CONSTVAL.
% MASKPOS is position of parameter in mask.
MaskValCell = get_param(blk,'MaskValues');

for n = 1:length(PortName)
    PortConst = ['const_' PortName{n}];
    PortPath = [blk '/' PortName{n}];
    PortConstPath = [blk '/' PortConst];

    if strcmp(MaskValCell{MaskPos}, 'on')
        % When mask is set to ON, add port if it is not already there
        if isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
                'SearchDepth',1,'Name',PortName{n}))

            % Get constant blk position, then delete it
            PortPosition = get_param(PortConstPath, 'Position');
            delete_block(PortConstPath);

            % Get port number offset, and add port
            PortOffset = GetPortOffset(PortStruct, MaskPos, MaskValCell);
            add_block('built-in/Inport', PortPath, 'Port', num2str(PortOffset+n), ...
                'Position', PortPosition, 'OutDataTypeStr', 'boolean', 'PortDimensions', '1');
        end

        % When mask is set to OFF, add constant block if it is not already there
    elseif isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
            'SearchDepth',1,'Name',PortConst))

        % Get port position, then delete it
        PortPosition = get_param(PortPath, 'Position');
        delete_block(PortPath);

        % Add constant block
        add_block('built-in/Constant', PortConstPath, 'Value', ConstVal{n}, ...
            'Position', PortPosition, 'OutDataTypeStr', 'boolean');
    end
end
end

%--------------------------------------------------------------------------
function PortOffset = GetPortOffset(PortStruct, MaskPos, MaskValCell)
% PORTSTRUCT defines position of all port parameters in mask, and number of
% ports for each parameter
% MASKPOS is the position of the port parameter in the block mask
% MASKVALCELL is the cell array of the block mask values

for n = 1:length(PortStruct.pos)
    % Overwrite element of PortSizeVec with zero if a port is turned off
    if strcmp(MaskValCell{PortStruct.pos(n)}, 'off')
        PortStruct.num(n) = 0;
    end
end

PortPriority = find(PortStruct.pos == MaskPos);
PortOffset = sum(PortStruct.num(1:PortPriority-1));
end

%--------------------------------------------------------------------------
function SetCountPortDT(blk, PortName, DTStr)
PortPath = [blk '/' PortName];
PortConst = ['const_' PortName];
PortConstPath = [blk '/' PortConst];

if ~isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
        'SearchDepth',1,'Name',PortName))

    set_param(PortPath, 'OutDataTypeStr', DTStr);
end

if ~isempty(find_system(blk,'LookUnderMasks','all','FollowLinks','on',...
        'SearchDepth',1,'Name',PortConst))

    set_param(PortConstPath, 'OutDataTypeStr', DTStr);
end
end

% LocalWords:  rst initequalmax ve wordlen initval sc fraclen stepval maxval
% LocalWords:  endval cval vec invalidseq Samp invalidcounterparam PORTNAME
% LocalWords:  CONSTVAL MASKPOS PORTSTRUCT MASKVALCELL