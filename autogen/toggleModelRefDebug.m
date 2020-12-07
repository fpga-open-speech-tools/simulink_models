function aaa = toggleModelRefDebug(debug)
%TOGGLEMODELREFDEBUG Summary of this function goes here
%   Detailed explanation goes here

if debug
    numInstancesAllowed = 'Single';
    commented = 'off';
else
    numInstancesAllowed = 'Multi';
    commented = 'on';
end
blockpath = gcbp;
rootModel = bdroot(blockpath.getBlock(1));
mdlrefs = find_mdlrefs(rootModel);
disp(mdlrefs)
searchDepth = Simulink.FindOptions('SearchDepth',10);
for index=1:length(mdlrefs)
    mdl = mdlrefs{index};
    if strcmp(mdl,rootModel)
        continue;
    end
    blocks = getfullname(Simulink.findBlocksOfType(mdl, 'ToWorkspace', searchDepth));
    if isempty(blocks)
        continue;
    end
    
    if ischar(blocks)
        set_param(blocks, 'commented', commented);
    else
        for  blockIndex=1:length(blocks)
            block = blocks{blockIndex};
            set_param(block, 'commented', commented)
        end
    end
    set_param(mdl,'ModelReferenceNumInstancesAllowed', numInstancesAllowed)
end
disp(['Model references num instances allowed have been updated to ' numInstancesAllowed ]);
disp(['where ToWorkspace blocks have been found and commented set to ' commented]);
end

