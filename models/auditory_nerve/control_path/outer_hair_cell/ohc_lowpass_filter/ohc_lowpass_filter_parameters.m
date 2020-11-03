function [OHCLPcoeffs] = ohc_lowpass_filter_parameters(tdres, Fcohc, gainohc)
    TWOPI= 6.28318530717959; 
    % Calculated Constants
    C = 2.0/tdres;
    c1LPohc = ( C - TWOPI*Fcohc ) / ( C + TWOPI*Fcohc );
    c2LPohc = TWOPI*Fcohc / (TWOPI*Fcohc + C);
    OHCLPcoeffs = [gainohc*c2LPohc gainohc*c2LPohc 0 1 -c1LPohc 0; gainohc*c2LPohc gainohc*c2LPohc 0 1 -c1LPohc 0];