function [MEcoeffs, MEscale, shift, s1, s0, x1, x0, OHCLPcoeffs, s0_nl, minR, order_of_zero, fs_bilinear, CF, preal, pimag, C1initphase, norm_gainc1, C2coeffs, norm_gainc2, ...
            corner, strength, ihcasym_c1, slope_c1, ihcasym_c2, slope_c2, IHCLPcoeffs] = auditory_nerve_parameters(tdres, fp, ohcasym, Fcohc, gainohc, taumax, taumin, cf, taumaxc2, fcohcc2, Fcihc, gainihc)
    
    [MEcoeffs, MEscale] = middle_ear_filter_parameter(tdres, fp);                                                                    % Middle Ear Filter Parameters
    [shift, s1, s0, x1, x0, OHCLPcoeffs, s0_nl, minR] = outer_hair_cell_parameters(tdres, ohcasym, Fcohc, gainohc, taumax, taumin);  % Outer Hair Cell Parameters
    [order_of_zero, fs_bilinear, CF, preal, pimag, C1initphase, norm_gainc1] = c1_chirp_parameter(cf, tdres, taumax);                % C1 Chirp Filter Parameters
    [C2coeffs, norm_gainc2] = C2Coefficients(tdres, cf, taumaxc2, fcohcc2);                                                          % C2 Chirp Filter Parameters
    [corner, strength, ihcasym_c1, slope_c1, ihcasym_c2, slope_c2, IHCLPcoeffs] = inner_hair_cell_parameters(tdres, Fcihc, gainihc); % Inner Hair Cell Parameters