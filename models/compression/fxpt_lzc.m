function lzc = fxpt_lzc( xi )
%leading zero count in binary word of fixed-point string

% count the number of leading zeros in fixed-point binary word
s = xi.bin;
Kz1 = strfind(s,'0');
if isempty(Kz1)
    lzc = 0;
else
    if s(1) == '1'
        lzc = 0;
    else
        Fz1 = diff(find([1 diff(Kz1 - (1:length(Kz1)))]));
        splitvec = mat2cell(Kz1,1,[Fz1 length(Kz1)-sum(Fz1)]);
        NumConsec0 = cellfun(@numel,splitvec);
        lzc = NumConsec0(1);
    end
end

end

