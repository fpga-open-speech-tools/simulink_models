function [corner, strength, ihcasym, slope] = ihc_nl_log_parameter(data_path)
    corner    = 80; 
    strength  = (20.0e6)/(10^(corner/20));
    
    if(strcmp(data_path, 'c1_chirp') == 1)
        % C1 Chirp Filter
        ihcasym     = 3.0; % Ratio of positive Max to negative Max
        slope       = 0.1; % Hard-coded as 0.1 for the output of the C1 filter
    elseif(strcmp(data_path, 'c2_wbf') == 1)
        % C2 Wideband Filter
        ihcasym     = 1.0; % Ratio of positive Max to negative Max
        slope       = 0.2; % Hard-coded as 0.1 for the output of the C1 filter
    else
        disp('Unkown Path')
        return
    end