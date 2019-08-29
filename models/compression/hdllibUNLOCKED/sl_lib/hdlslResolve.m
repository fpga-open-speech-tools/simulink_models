function val = hdlslResolve(prop, block)
% This function takes a property name and a block (name/pointer)
% and resolves the value of the property in the model and base
% workspace scope.

%   Copyright 2008-2018 The MathWorks, Inc.

prop_val = get_param(block, prop);
if all(ishandle(block))
    slbh = block;
    block = getfullname(block);
else
    slbh = [];
end
try
    val = slResolve(prop_val, block);
catch me
    if strcmp(me.identifier, 'Simulink:Data:SlResolveNotResolved')
        % With a bus expansion subsystem, the handle (slbh) and the full block
        % name (block) do not refer to the same object. The handle is
        % preferable; only use the name if the handle is not available.
        if isempty(slbh)
            parent = get_param(block, 'Parent');
        else
            parent = get_param(slbh, 'Parent');
        end
        parH = get_param(parent, 'Handle');
        expSS = slInternal('busDiagnostics', 'handleToExpandedSubsystem', parH);
        if slhdlcoder.SimulinkFrontEnd.isBusExpansionSubsystem(expSS)
            % For the contents of bus expansion subsystems, we need to perform
            % the resolution in the context of the original nonsynthetic block.
            val = slResolve(prop_val, parent);
        else
            val = prop_val; %most resolution we get so return val exists on function
        end
    else
        me.rethrow;
    end
end
end

% LocalWords:  slbh
