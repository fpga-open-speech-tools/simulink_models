
% Note the HDL coder doesn't allow writing properties to embedded.fi
% so we will create the associated values for the bit bitmask and
% write the Matlab code that does this and that can be pasted into
% the user matlab function block

fid = fopen('bit_mask_code.txt','w');


sline = ['function bitmask = getbitmask(bitlevel)']; fprintf(fid,'%s\n',sline);
sline = ['bitmask=fi(0,0,32,28);']; fprintf(fid,'%s\n',sline);
sline = ['switch(bitlevel)']; fprintf(fid,'%s\n',sline);

bitmask=fi(0,0,32,28);
for i=0:32
    switch(i)
        case 32
            bitmask.bin = '11111111111111111111111111111111';
        case 31
            bitmask.bin = '11111111111111111111111111111110';
        case 30
            bitmask.bin = '11111111111111111111111111111100';
        case 29
            bitmask.bin = '11111111111111111111111111111000';
        case 28
            bitmask.bin = '11111111111111111111111111110000';
        case 27
            bitmask.bin = '11111111111111111111111111100000';
        case 26
            bitmask.bin = '11111111111111111111111111000000';
        case 25
            bitmask.bin = '11111111111111111111111110000000';
        case 24
            bitmask.bin = '11111111111111111111111100000000';
        case 23
            bitmask.bin = '11111111111111111111111000000000';
        case 22
            bitmask.bin = '11111111111111111111110000000000';
        case 21
            bitmask.bin = '11111111111111111111100000000000';
        case 20
            bitmask.bin = '11111111111111111111000000000000';
        case 19
            bitmask.bin = '11111111111111111110000000000000';
        case 18
            bitmask.bin = '11111111111111111100000000000000';
        case 17
            bitmask.bin = '11111111111111111000000000000000';
        case 16
            bitmask.bin = '11111111111111110000000000000000';
        case 15
            bitmask.bin = '11111111111111100000000000000000';
        case 14
            bitmask.bin = '11111111111111000000000000000000';
        case 13
            bitmask.bin = '11111111111110000000000000000000';
        case 12
            bitmask.bin = '11111111111100000000000000000000';
        case 11
            bitmask.bin = '11111111111000000000000000000000';
        case 10
            bitmask.bin = '11111111110000000000000000000000';
        case 9
            bitmask.bin = '11111111100000000000000000000000';
        case 8
            bitmask.bin = '11111111000000000000000000000000';
        case 7
            bitmask.bin = '11111110000000000000000000000000';
        case 6
            bitmask.bin = '11111100000000000000000000000000';
        case 5
            bitmask.bin = '11111000000000000000000000000000';
        case 4
            bitmask.bin = '11110000000000000000000000000000';
        case 3
            bitmask.bin = '11100000000000000000000000000000';
        case 2
            bitmask.bin = '11000000000000000000000000000000';
        case 1
            bitmask.bin = '10000000000000000000000000000000';
        case 0
            bitmask.bin = '00000000000000000000000000000000';
    end
    
    sline = [blanks(4) 'case ' num2str(i)]; fprintf(fid,'%s\n',sline);
    %sline = [blanks(8) 'bitmask = ' num2str(bitmask,'%10d') ';']; fprintf(fid,'%s\n',sline);
    sline = [blanks(8) 'bitmask = fi(' num2str(bitmask,'%4.28f') ',0,32,28);']; fprintf(fid,'%s\n',sline);
    
    %eval(['b = fi(' num2str(bitmask,'%4.28f') ',1,32,28);']);
    %b.bin
   
end
sline = ['end']; fprintf(fid,'%s\n',sline);


