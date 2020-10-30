function [s0_nl, minR] = ohc_nonlinear_filter_parameters(ohcasym, taumax, taumin)
    
    minR    = 0.05; % Declared as constant in function
    R = taumin/taumax;

    if R < minR
        minR = 0.5*R;
    end

    dc = (ohcasym-1)/(ohcasym+1.0)/2.0-minR;
    R1 = R-minR;

    % Denoted in C code: For new nonlinearity
    s0_nl = -dc/log(R1/(1-minR));