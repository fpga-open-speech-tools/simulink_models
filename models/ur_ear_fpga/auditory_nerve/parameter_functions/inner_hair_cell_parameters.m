function [corner, strength, ihcasym_c1, slope_c1, ihcasym_c2, slope_c2, IHCLPcoeffs] = inner_hair_cell_parameters(tdres, Fcihc, gainihc)
    % IHC Nonlinear Log Function Parameters
    [~, ~, ihcasym_c1, slope_c1, ~] = ihc_nl_log_parameter('c1_chirp');           % C1 Chirp Filter
    [corner, strength, ihcasym_c2, slope_c2, ~] = ihc_nl_log_parameter('c2_wbf'); % C2 Wideband Filter
    
    % IHC Lowpass Filter Parameters
    [IHCLPcoeffs] = ihc_lowpass_filter_parameters(tdres, Fcihc, gainihc);