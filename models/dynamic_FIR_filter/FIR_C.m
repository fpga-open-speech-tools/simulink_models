function [y_fixedPoint_conv] = FIR_C(x, bk, W_bits, F_bits)
%%This function is dedicated to generate C code that can do convolution
%%super quickly. It's a test.
%
% inputs
%       x      - Input Signal
%       bk     - FIR Coefficient Scalar / Vector
%       W_bits - Word Length
%       F_bits - Num Fractional Bits
% outputs
%       y_fixedPoint = sum(k=0)^(M) bk[k] x[n-k]
%          where M = Filter Order (length of bk)

% Fixed point properties
Fm = fimath('CastBeforeSum', 1, ...
            'OverflowAction', 'Wrap', ...
            'ProductFractionLength', F_bits, ...
            'ProductMode', 'SpecifyPrecision', ...
            'ProductWordLength', W_bits, ...
            'RoundingMethod', 'Zero', ...
            'SumFractionLength', F_bits, ...
            'SumMode', 'SpecifyPrecision', ...
            'SumWordLength', W_bits);

% Cast to Fixed Point
x  = fi( x, 1, W_bits, F_bits, Fm);
bk = fi(bk, 1, W_bits, F_bits, Fm); 
M  = fi(length(bk), 1, W_bits, F_bits, Fm); % Filter Order
% Determine Filter Indicies to cutoff
N  = fi(length( x)+length(bk) -1, 1, W_bits, F_bits, Fm); % Signal Length
ind1 = N - (N-M) + 2;
% Output Signal Initialization
y_fixedPoint_conv = conv(x, bk);
y_fixedPoint_conv(ind1:N) = [];


end