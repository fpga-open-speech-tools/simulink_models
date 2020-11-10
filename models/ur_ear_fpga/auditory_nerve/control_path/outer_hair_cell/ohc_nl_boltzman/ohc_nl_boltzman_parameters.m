function [shift, s1, s0, x1, x0] = ohc_nl_boltzman_parameters(ohcasym)
    shift = 1.0/(1.0+ohcasym);
    s1 = 5.0;
    s0 = 12.0;
    x1 = 5.0;
    x0 = s0*log((1.0/shift-1)/(1+exp(x1/s1)));