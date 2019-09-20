function [x] = nextpower2(n,x)
%% 
% nextpower2.m
% Created by E. Bailey Galacci, 5/30/19
% This function is a VHDL compatible way to find the smallest power of 2
% greater than the input integer 'n', since nextpow2 isn't recognized by
% the HDL coder.
%
% Inputs: First call: 
%   n, the number you want to find a power of 2 greater than
%
% Recursive call inputs:
%   n, same
%   x, the current iterative power to test
%
% Outputs:
%   x, the smallest power of 2 greater than n


if nargin<2
    x=1;
end
if(2^x < n)
    x=x+1;
    x = nextpower2(n,x);
end

end