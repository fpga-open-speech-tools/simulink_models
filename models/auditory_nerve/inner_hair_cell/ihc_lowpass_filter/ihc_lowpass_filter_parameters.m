function [IHCLPcoeffs] = ihc_lowpass_filter_parameters(tdres, Fcihc, gainihc)
    TWOPI= 6.28318530717959; 
    % Calculated Constants
    C = 2.0/tdres;
    c1LPihc = ( C - TWOPI*Fcihc ) / ( C + TWOPI*Fcihc );
    c2LPihc = TWOPI*Fcihc / (TWOPI*Fcihc + C);

    % Filter Coefficients Matrix
    % Coefficients are order as follows
    %       [b01 b11 b21 a01 a11 a21]
    %       [b02 b12 b22 a02 a12 a22]
    %               * * *
    %       [b0m b1m b2m a0m a1m a2m]
    % Added for the Direct Form implementation by Hezekiah Austin 03/10/2020
    IHCLPcoeffs = [ gainihc*c2LPihc gainihc*c2LPihc 0 1 -c1LPihc 0;
                    c2LPihc         c2LPihc         0 1 -c1LPihc 0;
                    c2LPihc         c2LPihc         0 1 -c1LPihc 0;
                    c2LPihc         c2LPihc         0 1 -c1LPihc 0;
                    c2LPihc         c2LPihc         0 1 -c1LPihc 0;
                    c2LPihc         c2LPihc         0 1 -c1LPihc 0;
                    c2LPihc         c2LPihc         0 1 -c1LPihc 0];