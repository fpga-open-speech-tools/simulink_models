function s = hdlblkmask_drdpram
% Top level mask dynamic dialog function for Dual Rate Dual Port RAM block.

%   Copyright 2013-2014 The MathWorks, Inc.
blk=gcb;
s=[];

% Simulink can't build a 29-bit DPDRAM due to the maximum DWork size for a model.
hdlblkmask_dpram(28);
pcon = get_param(blk, 'portConnectivity');
addrASrc = pcon(2).SrcBlock;
addrBSrc = pcon(5).SrcBlock;

if addrASrc == addrBSrc
    warning(message('hdlsllib:hdlsllib:DualRateDualPortRAMSameAddrDriver'));
end
end

% LocalWords:  DPDRAM Addr
