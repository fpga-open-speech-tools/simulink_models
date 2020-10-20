function y = fcolshift(x,s)
    %FCOLSHIFT Fractional circular shift over the column dimension by a vector s.
    %   y = fcolshift(X, S) where X is a 2D matrix of M rows x N columns. S
    %   is a vector of length N. The function will circular shift
    %   the i-th of X by an amount equal to s[i]. 
    %
    %   Examples:
    %      X = [ 1 2 3; 4 5 6; 7 8 9];  % Input matrix
    %      S = [1 -2 0] % Amount of shift to perform.
    %      Y = fcolshift(X, S)
    %      Y = 7     8     3
    %          1     2     6
    %          4     5     9
    %   Based on the first implementation of fshift by Francois Bouffard.
    %   Author:   Tan H. Nguyen - Massachusetts Institute of technology.
	%   Email: thnguyn@mit.edu
    Ncols = size(x, 2);
	if (length(s) ~= Ncols)
        disp(["Length of s: " length(s) " Length of x: " Ncols])
		error('Length of the vector s must be equal to the number of colums in x')
	end
    N = size(x, 1); 
    r = floor(N/2)+1; 
    f = ((1:N)-r) / (N/2);
    fMat = repmat(f(:), [1 Ncols]);
    sMat = repmat(s(:)', [N 1]);
    p = exp(-1j * pi * sMat .* fMat);
    if ~mod(N,2)
        % N is even. This becomes important for complex signals.
        % Thanks to Ahmed Fasih for pointing out the bug.
        % For even signals, f(1) = -1 and phase is sampled at -pi. 
        % The correct value for p(1) should be the average of the f = -1 and
        % f = 1 cases. Since f has antisymmetric phase and unitary (and thus
        % symmetric) magnitude, the average is the real part of p.
        p(1, :) = real(p(1, :));
    end
    y = ifft(fft(x, [], 1) .* ifftshift(p, 1), [], 1); 
    if isreal(x)
        y = real(y); 
    end
end