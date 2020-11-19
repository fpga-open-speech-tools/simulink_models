%#codegen
function band = band_state_controller(bin_num, band_edges, num_bins, FFTsize, valid_data)
% Moore State Machine

%------------------------------------------------------------------------%
% The following is a Moore State Machine in which each state represents the
% frequency band in which the dynamic compression model is operating. The
% frequency bin number or index is the input to the state machine and
% determines whether whether the next state will be in the current, next,
% or previous frequency band. The band_edges input is designed to read 
% from a precomputed band edge index vector, which sets the boundaries 
% between each frequency band and serves as the conditional value.
%------------------------------------------------------------------------%

% y = f(x) : 
% all actions are state actions and 
% outputs are pure functions of state only 

% Defining All Possible Frequency Band States
fb1 = 1;
fb2 = 2;
fb3 = 3;
fb4 = 4;
fb5 = 5;
fb6 = 6;
fb7 = 7;
fb8 = 8;
fb9 = 9;
fb10 = 10;
fb11 = 11;
fb12 = 12;
fb13 = 13;
fb14 = 14;
fb15 = 15;
fb16 = 16;
fb17 = 17;
fb18 = 18;
fb19 = 19;
fb20 = 20;
fb21 = 21;
fb22 = 22;
fb23 = 23;
fb24 = 24;
fb25 = 25;
fb26 = 26;
fb27 = 27;
fb28 = 28;
fb29 = 29;
fb30 = 30;
fb31 = 31;
fb32 = 32;


% Using persistent keyword to model state registers in hardware
persistent curr_state;
if isempty(curr_state)
    curr_state = fb1;   
end

% Switch to new state (frequency band) based on the value state register
switch (curr_state)
    
    case fb1
        
        % value of output band depends only on state and not on inputs
        band = uint8(1);
        
        % decide next state value based on inputs
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins - 1
            curr_state = fb1;
        elseif (bin_num >= band_edges(band)) && (valid_data == true)
            curr_state = fb2;
        else
            curr_state = fb1;
        end
        
        
    case fb2
        
        band = uint8(2);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb1;
            else
                curr_state = fb2;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb3;
        else
            curr_state = fb2;
        end
        
        
    case fb3
        
        band = uint8(3);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb2;
            else
                curr_state = fb3;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb4;
        else
            curr_state = fb3;
        end
        

    case fb4
        
        band = uint8(4);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb3;
            else
                curr_state = fb4;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb5;
        else
            curr_state = fb4;
        end

        
    case fb5
        
        band = uint8(5);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb4;
            else
                curr_state = fb5;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb6;
        else
            curr_state = fb5;
        end        

        
    case fb6
        
        band = uint8(6);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb5;
            else
                curr_state = fb6;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb7;
        else
            curr_state = fb6;
        end  
        
        
    case fb7
        
        band = uint8(7);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb6;
            else
                curr_state = fb7;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb8;
        else
            curr_state = fb7;
        end  
        
        
    case fb8
        
        band = uint8(8);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb7;
            else
                curr_state = fb8;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb9;
        else
            curr_state = fb8;
        end  
        
        
    case fb9
        
        band = uint8(9);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb8;
            else
                curr_state = fb9;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb10;
        else
            curr_state = fb9;
        end  
        
        
    case fb10
        
        band = uint8(10);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb9;
            else
                curr_state = fb10;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb11;
        else
            curr_state = fb10;
        end  
        
        
    case fb11
        
        band = uint8(11);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb10;
            else
                curr_state = fb11;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb12;
        else
            curr_state = fb11;
        end  
        
        
    case fb12
        
        band = uint8(12);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb11;
            else
                curr_state = fb12;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb13;
        else
            curr_state = fb12;
        end  
        
        
    case fb13
        
        band = uint8(13);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb12;
            else
                curr_state = fb13;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb14;
        else
            curr_state = fb13;
        end  
        
        
    case fb14
        
        band = uint8(14);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb13;
            else
                curr_state = fb14;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb15;
        else
            curr_state = fb14;
        end  
        
        
    case fb15
        
        band = uint8(15);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb14;
            else
                curr_state = fb15;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb16;
        else
            curr_state = fb15;
        end  
        
        
    case fb16
        
        band = uint8(16);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb15;
            else
                curr_state = fb16;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb17;
        else
            curr_state = fb16;
        end  
        
        
    case fb17
        
        band = uint8(17);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb16;
            else
                curr_state = fb17;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb18;
        else
            curr_state = fb17;
        end  
        
        
    case fb18
        
        band = uint8(18);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb17;
            else
                curr_state = fb18;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb19;
        else
            curr_state = fb18;
        end  
        
        
    case fb19
        
        band = uint8(19);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb18;
            else
                curr_state = fb19;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb20;
        else
            curr_state = fb19;
        end  
        
        
    case fb20
        
        band = uint8(20);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb19;
            else
                curr_state = fb20;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb21;
        else
            curr_state = fb20;
        end  
        
        
    case fb21
        
        band = uint8(21);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb20;
            else
                curr_state = fb21;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb22;
        else
            curr_state = fb21;
        end
        
        
    case fb22
        
        band = uint8(22);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb21;
            else
                curr_state = fb22;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb23;
        else
            curr_state = fb22;
        end
        
        
    case fb23
        
        band = uint8(23);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb22;
            else
                curr_state = fb23;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb24;
        else
            curr_state = fb23;
        end
        
        
    case fb24
        
        band = uint8(24);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb23;
            else
                curr_state = fb24;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb25;
        else
            curr_state = fb24;
        end
        
        
    case fb25
        
        band = uint8(25);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb24;
            else
                curr_state = fb25;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb26;
        else
            curr_state = fb25;
        end
        
        
    case fb26
        
        band = uint8(26);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb25;
            else
                curr_state = fb26;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb27;
        else
            curr_state = fb26;
        end
        
        
    case fb27
        
        band = uint8(27);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb26;
            else
                curr_state = fb27;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb28;
        else
            curr_state = fb27;
        end
        
        
    case fb28
        
        band = uint8(28);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb27;
            else
                curr_state = fb28;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb29;
        else
            curr_state = fb28;
        end
        
        
    case fb29
        
        band = uint8(29);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb28;
            else
                curr_state = fb29;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb30;
        else
            curr_state = fb29;
        end
        
        
    case fb30
        
        band = uint8(30);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb29;
            else
                curr_state = fb30;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb31;
        else
            curr_state = fb30;
        end
        
        
    case fb31
        
        band = uint8(31);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb30;
            else
                curr_state = fb31;
            end
        elseif (bin_num >= band_edges(band))
            curr_state = fb32;
        else
            curr_state = fb31;
        end
        
        
    case fb32
        
        band = uint8(32);
        
        if bin_num >= FFTsize-1
            curr_state = fb1;
        elseif bin_num >= num_bins-1
            if bin_num >= band_edges(band + (length(band_edges)/2))
                curr_state = fb31;
            else
                curr_state = fb32;
            end
        else
            curr_state = fb32;
        end
        
    otherwise
        band = uint8(1);
        
end