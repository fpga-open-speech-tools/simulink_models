function countrange = checkCounterParams(wordlen, fraclen, issigned, initval, minval, stepval, maxval, freerun)
% Check HDL counter parameters to make sure that they make sense and that
% we can build the counter successfully. Derived from hdlblkmask_counter.m
% and shared with pirelab.getCounterComp.m

% ENSURE THAT THE SAME CODE IS PRESENT IN pirelab.getCounterComp.m. We
% cannot share the code as pirelab.getCounterComp.m (hdlcoder) and
% hdlblkmask_counter.m (hdllib) belong to different components.

% Copyright 2017 The MathWorks, Inc.

% Check word length
if ~isequal(wordlen, floor(wordlen)) || wordlen <= 0
    error(message('hdlsllib:hdlsllib:wordlength'));
elseif issigned && wordlen == 1
    error(message('hdlsllib:hdlsllib:signedwordlength'));
end
maxwlen = 125;
if wordlen > maxwlen % g1587576
    error(message('hdlsllib:hdlsllib:maxwordlength', sprintf('%d', maxwlen)));
end
wordlen = double(wordlen); % g1587576

% Check fraction length
if ~isequal(fraclen, floor(fraclen)) || fraclen < 0
    error(message('hdlsllib:hdlsllib:fraclength'));
end

% Check fraction and word length relation
if ~issigned && (fraclen > wordlen)
    error(message('hdlsllib:hdlsllib:fraclengthunsigned'));
elseif issigned && (fraclen >= wordlen)
    error(message('hdlsllib:hdlsllib:fraclengthsigned'));
end

% Calculate counter range
countrange = [0 2^wordlen-1] - issigned*(2^(wordlen-1));

% Check initial value
CheckCountValue(countrange, fraclen, initval, 'Initial value');

if ~freerun
    % Check count from (min) value in count limited mode
    CheckCountValue(countrange, fraclen, minval, 'Count from value');
    % Check count to (max) value in count limited mode
    CheckCountValue(countrange, fraclen, maxval, 'Count to value');
    % Check initial value to lie between the count from (min) value and the
    % count to (max) value. handle up and down counting.
    sortedval = sort([minval maxval]);
    if ((initval < sortedval(1)) || (initval > sortedval(2)))
        error(message('hdlsllib:hdlsllib:initoutofrange', initval, minval, maxval));
    end
end

% Check step value
if stepval == 0
    error(message('hdlsllib:hdlsllib:zerostepvalue'));
else
    % Since sign of step value is used for direction, the most negative
    % value of a signed number is not allowed.
    CheckCountValue(countrange, fraclen, abs(stepval), 'Step value');
end
end

%--------------------------------------------------------------------------
function CheckCountValue(countrange, fraclen, userval, valname)
% Checks range of user-defined count values
countval = userval*(2^fraclen);

if (countval < countrange(1)) || (countval > countrange(2))
    error(message('hdlsllib:hdlsllib:countvalrange', valname));
end

if ~isequal(countval, floor(countval))
    error(message('hdlsllib:hdlsllib:countfracrange', valname));
end
end

% LocalWords:  hdlblkmask signedwordlength fraclength fraclengthunsigned
% LocalWords:  fraclengthsigned zerostepvalue initoutofrange countvalrange
% LocalWords:  countfracrange