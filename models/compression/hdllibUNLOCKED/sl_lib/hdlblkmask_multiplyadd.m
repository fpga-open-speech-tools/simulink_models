function hdlblkmask_multiplyadd()
%

%   Copyright 2015 The MathWorks, Inc.

mablk=gcb;
sumblk=[mablk '/Sum'];
rndMode = get_param(mablk, 'RndMeth');
set_param(sumblk, 'RndMeth', rndMode);
sat = get_param(mablk, 'DoSatur');
set_param(sumblk, 'SaturateOnIntegerOverflow', sat);
func = get_param(mablk, 'Function');
if(strcmp(func,'c-(a.*b)') == 1)
    set_param(sumblk, 'ListOfSigns', '+-');
elseif(strcmp(func,'c+(a.*b)') == 1)
    set_param(sumblk, 'ListOfSigns', '++');
else
    set_param(sumblk, 'ListOfSigns', '-+');
end
end
