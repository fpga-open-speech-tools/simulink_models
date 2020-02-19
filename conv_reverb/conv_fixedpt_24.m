function [y]=conv_fixedpt_24(x, h)
%#codegen

% make the below into c
width = 24;
frac = width - 2;
Fm = fimath('RoundingMethod','Floor',...
        'OverflowAction','Wrap',...
        'ProductMode','SpecifyPrecision',...
        'ProductWordLength',width,...
        'ProductFractionLength',frac,...
        'SumMode','SpecifyPrecision',...
        'SumWordLength',width,...
        'SumFractionLength',frac);
    
x_fi = fi(x, 1, width, frac, Fm);
h_fi = fi(h, 1, width, frac, Fm);
y = conv(x_fi, h_fi);