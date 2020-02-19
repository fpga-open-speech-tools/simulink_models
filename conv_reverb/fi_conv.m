function [y] = fi_conv(x_fi,h_fi) 
        %#codegen
        % make the below into c
        y = conv(x_fi, h_fi);
end