function [corner, strength, ihcasym, slope, plot_title] = ihc_nl_log_parameter(data_path)
    corner    = 80;                        % Hard-coded: Line 926
    strength  = (20.0e6)/(10^(corner/20)); % Hard-coded: Line 927
    
    if(strcmp(data_path, 'c1_chirp') == 1)
        % C1 Chirp Filter
        slope       = 0.1; % Hard-coded: Line 354
        ihcasym     = 3.0; % Hard-codec: Line 261
        plot_title  = 'C1 Chirp Filter';
    elseif(strcmp(data_path, 'c2_wbf') == 1)
        % C2 Wideband Filter
        slope       = 0.2; % Hard-coded: Line 356
        ihcasym     = 1.0; % Hard-codec: Line 356
        plot_title  = 'C2 WB Filter';
    else
        disp('Unkown Path')
        return
    end