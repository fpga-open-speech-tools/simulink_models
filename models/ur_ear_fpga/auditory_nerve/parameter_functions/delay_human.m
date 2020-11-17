function delay = delay_human(cf)
    A    = -0.37;  
    B    = 11.09/2;
    delay = B * pow(cf * 1e-3,A)*1e-3;
end