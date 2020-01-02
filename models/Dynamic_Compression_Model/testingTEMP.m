try
    disp(sprintf("Programmable Look-Up Table\nMemory Used = %d fixed point numbers\nInput Bounds: %d <= x <= %d\n Maximum Error: %d", 2^ram_size, min_val, max_val, maxErr));
    %disp(dispString);
    port_label('input',1,"Data_In"); 
    port_label('input',2,"Table_Wr_Data"); 
    port_label('input',3,"Table_Wr_Addr"); 
    port_label('input',4,"Table_Wr_En"); 
    port_label('output',1,"Data_Out"); 
    port_label('output',2,"Table_RW_Dout");
catch ME
    disp(sprintf("threw error %s", ME.identifier));
    %disp(['Programmable Look-Up Table' char(10) 'Memory Used = -- fixed point numbers' char(10) 'Input Bounds: -- <= x <= --' char(10) 'Maximum Error: -- % ']); port_label('input',1,'Data_In'); port_label('input',2,'Table_Wr_Data'); port_label('input',3,'Table_Wr_Addr'); port_label('input',4,'Table_Wr_En'); port_label('output',1,'Data_Out'); port_label('output',2,'Table_RW_Dout');
end
