function delay = delay_cat(cf)
    A0    = 3.0;  
    A1    = 12.5;
    x     = 11.9 * log10(0.80 + cf / 456.0);
    delay = A0 * exp( -x/A1 ) * 1e-3;
end