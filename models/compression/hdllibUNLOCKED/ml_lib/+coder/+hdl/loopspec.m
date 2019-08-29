%CODER.HDL.LOOPSPEC Unroll or stream loops in generated HDL code
%
%   With loop optimization you can stream or unroll loops in generated
%   code. Loop streaming optimizes for area, and loop unrolling optimizes
%   for speed.
%
%   CODER.HDL.LOOPSPEC('unroll') fully unrolls a loop in the generated HDL
%   code. Instead of a loop statement, the generated code contains multiple
%   instances of the loop body, with one loop body instance per loop
%   iteration.
%
%   CODER.HDL.LOOPSPEC('unroll',unroll_factor) unrolls a loop by the
%   specified unrolling factor, unroll_factor, in the generated HDL code.
%
%   CODER.HDL.LOOPSPEC('stream') generates a single instance of the loop
%   body in the HDL code. Instead of using a loop statement, the generated
%   code implements local oversampling and added logic to match the
%   functionality of the original loop.
%
%   CODER.HDL.LOOPSPEC('stream',stream_factor) unrolls the loop with
%   unroll_factor set to original_loop_iterations / stream_factor rounded
%   down to the nearest integer, and also oversamples the loop. If
%   (original_loop_iterations / stream_factor) has a remainder, the
%   remainder loop body instances outside the loop are not oversampled, and
%   run at the original rate.
%
%   Example:
%     coder.hdl.loopspec('unroll');
%     for i = 1:10
%         y(i) = pv + i;
%     end
%
%   This is a code generation function.  It has no effect in MATLAB.

%#codegen
function loopspec(varargin)

%   Copyright 2014 The MathWorks, Inc.

    coder.internal.prefer_const(varargin);
    coder.internal.assert((nargin == 1) || (nargin == 2), 'hdlmllib:hdlmllib:PragmaBadNumArgs', 'coder.hdl.loopspec', nargin);
    if coder.target('hdl')
        coder.ceval('__hdl_loopspec', varargin{:});
    end
end
