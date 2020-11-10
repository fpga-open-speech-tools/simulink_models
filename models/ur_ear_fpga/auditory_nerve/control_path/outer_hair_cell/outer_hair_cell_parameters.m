function [shift, s1, s0, x1, x0, OHCLPcoeffs, s0_nl, minR] = outer_hair_cell_parameters(tdres, ohcasym, Fcohc, gainohc, taumax, taumin)

    [shift, s1, s0, x1, x0] = ohc_nl_boltzman_parameters(ohcasym);            % OHC Nonlinear Boltzman Filter
    [OHCLPcoeffs] = ohc_lowpass_filter_parameters(tdres, Fcohc, gainohc);     % OHC Lowpass Filter
    [s0_nl, minR] = ohc_nonlinear_filter_parameters(ohcasym, taumax, taumin); % OHC Nonlinear Filter 