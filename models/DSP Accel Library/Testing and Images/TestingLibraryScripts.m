%% TESTING OF Programmable Look-Up Table (PLUT) MASK INIT SCRIPT 
% USER DEFINED VARS %%%
clear;
TableFn = "log(X_in)";	% function the LUT is to represent 
maxInput = 1;			% highest expected input to the PLUT
floor_in_tab = 2^-12;	% lowest input cared about in the PLUT
error_cap_tab = 0.001;	% allowed error after linear interpolation 
ERR_DIAG = true;		% flag to show graphs and init steps
N_bits_tab = 4;			% bits of LZC if manual flag set 
M_bits_tab = 5;			% number of bits added to address to increase table precision
igotthis = false;		% manual settings flag 
W_bits = 32;			% fixed-point word size 
F_bits = 28;			% fixed-point fractional bit count 
%%%%%%%%%%%%%%%%%%%%%%%
% things to display on mask surface: table size, min valid input, max valid input, max error of output when in input range
% things to figure out within the script: M_bits, N_bits, Min_val, X_in table, Y_out table, max_error, ram_size, table_size 

d = ceil(log2(maxInput));	% offset used for some binary tricks later, based on Max input
if(igotthis)	% manual table declaration
    N_bits = N_bits_tab;	% bits of the Leading Zero Counter (LZC)
    M_bits = M_bits_tab;	% bits used to add precision to the table after LZC
else
    N_bits = ceil(log2(d-log2(floor_in_tab)+1));	% ensure LZC is big enough to meet expected input specs
    % M_bits needs to be defined later, as it must be just enough to meet
    % accuracy standards defined by user, with linear interpolation
    M_bits = 1; %this will be updated later as needed, larger : more memory with more accuracy 
end;

repeatFlag = true; 
while(repeatFlag)
    % Define a N point log2 spaced range of inputs, from 2^(d-(2^N_bits -1)) to 2^(d+1)-2^(d-M_bits), 
    % this effectively covers the user defined input range, with some padding above and below.
    X_in = zeros(1, 2^(M_bits+N_bits));	% inputs mapped to memory addresses of PLUT
    addr = 1;
    for NShifts = 2^N_bits-1:-1:0		% number of LSL of the binary string until x_in>= 2^d
        for M = 0:2^M_bits - 1			% the value of the M_bits bits after the first 1 in the binary string of x_in
            X_in(addr) = 2^(d-NShifts) + M*2^(d-NShifts-M_bits);
            addr = addr+1;
        end
    end

    % use function to define output. note: function must contain input X_in
    % within the string to work properly, and the only output of the function
    % must be Y_out.
    Y_out = eval(TableFn);

    ram_size = N_bits+M_bits; 			% size of address line into the PLUT
    Table_init = Y_out;					% initial values of the PLUT memory 
    max_val = 2^(d+1) - 2^(d-M_bits);	% max valid input to the PLUT
    min_val = 2^(d-(2^N_bits-1));		% min valid input to the PLUT
    
    %%%%%%%%%% check and identify error %%%%%%%%%%%
    % Make some values that cover the expected input range with log spaced points
    X_in_Ideal = logspace(log10(min_val), log10(max_val), 2^(ram_size+2));
    X_LUT = X_in; % temporarily move X_in so the user-defined function can be evaluated on X_in_Ideal
    X_in = X_in_Ideal;
    % identify the values of the function at X_in_Ideal
    Y_out_Ideal = eval(TableFn);		% eval necessary since user inputs a string representing the desired function, with X_in as the input 

    % Set X_in to input values for the lookup table (already have X_LUT)
    X_in = X_LUT;

    % Find lookup addresses for each point in X_in_Ideal
    x_addr = zeros(1,length(X_in_Ideal));
    for it = 1:length(X_in_Ideal)
        x_addr(it) = 2^ram_size;
        X_Shift = X_in_Ideal(it); 
		% find the address in X_in less than X_in_Ideal(it), the table value nearest below our test input
        while(X_Shift < X_in(x_addr(it)) && x_addr(it) ~= 1) % ensures address doesn't go to 0, where MATLAB would throw an error reading from matrix location 0 
            x_addr(it) = x_addr(it) - 1;
        end
        if(x_addr(it)==0) % a more primitive sanity check to make sure address doesn't go to 0
            x_addr(it) = 1;
        end
    end

    % Check for any possible out of bounds errors (handled similarly in
    % hardware)
    x_addr(x_addr == 2^ram_size) = 2^ram_size -1;

    % Get values for linear interpolation of X_in_Ideal
    x_low  = X_in(x_addr);
    x_high = X_in(x_addr+1);


    y_low  = Y_out(x_addr);
    y_high = Y_out(x_addr+1);
    slope  = (y_high-y_low) ./ (x_high - x_low);
    y_inter = slope.*(X_in_Ideal-x_low)+y_low;
    % percent error: obt-exp / exp
    %errorFloor = (Y_out_Ideal-y_low)./Y_out_Ideal;
    errorInter = (Y_out_Ideal-y_inter)./Y_out_Ideal;
    %maxFloorErr(ix) = 100*max(abs(errorFloor(ix, 2870:9839)));
    %maxInterErr(ix) = 100*max(abs(errorInter(ix, 2870:9839)));
    maxErr = max(abs(errorInter));
    
    %check while loop condition
    if(igotthis) 
        repeatFlag = false;
    else
        if(maxErr <= error_cap_tab)
            repeatFlag = false;
            if(ERR_DIAG)
                figure(1); 
                subplot(2,1,1); semilogx(X_in_Ideal,y_inter, X_in_Ideal,Y_out_Ideal,X_in,Y_out,'k*'); title('Output Values over Input Range'); xlabel('Inputs'); ylabel('Outputs'); legend('Interpolated','Ideal','Table Points');
                subplot(2,1,2); semilogx(X_in_Ideal,100*errorInter); title('Error of Output over Input Range'); xlabel('Inputs'); ylabel('Percent Error');
            end
        else
            if(ERR_DIAG)
                f = msgbox(sprintf('Err = %.2d, M_bits = %d', maxErr, M_bits),'Configuring PLUT','replace');
            end
            if(maxErr > 8*error_cap_tab)
                M_bits = M_bits+3;
            elseif(maxErr > 4*error_cap_tab)
                M_bits = M_bits+2;
            else
                M_bits = M_bits+1;
            end
        end
    end
end%end while loop

%maxFloorErrTot = max(maxFloorErr);
%maxInterErrTot = max(maxInterErr);
% things to display: table size, floor input?, max input, accuracy

%set_param(gcb,'MaskDisplay',"disp(sprintf('Programmable Look-Up Table\nMemory Used = %d fixed point numbers\nInput Bounds: %.2d <= x <= %.2d\n Maximum Error: %.2d %', 2^ram_size, min_val, max_val, 100*maxErr)); port_label('input',1,'Data_In'); port_label('input',2,'Table_Wr_Data'); port_label('input',3,'Table_Wr_Addr'); port_label('input',4,'Table_Wr_En'); port_label('output',1,'Data_Out'); port_label('output',2,'Table_RW_Dout');")

