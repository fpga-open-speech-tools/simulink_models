%% Tcl Script Creation

% master_read_32 $m 0x0 0x5
% master_write_32 $m 0x0 -- Enable 0x00000000
% WR_data 0x00000000 
% RW_addr 0x0000000
% WR_en   0x00000000



fileID = fopen('lpf_coefficients.txt', 'w');

coefficient_length = 512;
%                    start  enable filter   data    address    write data
% master_write_32 $m 0x0    0x0             0x0     0x00000000 0x00000001

%fprintf(file, '%s\n', data);

fprintf(fileID, '%s\n', "set m [ get_service_paths master ]");
fprintf(fileID, '%s\n', "open_service master $m");
fprintf(fileID, '%s\n', "master_write_32 $m 0x0 0x00000000 0x0 0x0 0x00000001");

counter = 1;


for i = 1:coefficient_length
    
   fprintf(fileID, '%s\n', "master_write_32 $m 0x0 0x0 " + "0x" + string(hex(fi(LPF_PB1000_SB1300(counter),1,32,28)))+ " " + "0x" + string(hex(fi(counter,0,32,0))));
   counter = counter + 1;
end



counter = 0;