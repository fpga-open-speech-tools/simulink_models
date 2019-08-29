%CODER.HDL.PIPELINE insert pipeline registers at output of MATLAB expression
%
%   With the coder.hdl.pipeline pragma, you can specify the placement and
%   number of pipeline registers in the HDL code generated for a MATLAB
%   expression.
%
%   If you insert pipeline registers and enable distributed pipelining,
%   HDL Coder automatically moves the pipeline registers to break the
%   critical path.
%
%   out = CODER.HDL.PIPELINE(expr) inserts one pipeline register at the
%   output of expr in the generated HDL code. 
%
%   out = CODER.HDL.PIPELINE(expr,num) inserts num pipeline registers at
%   the output of expr in the generated HDL code.
%
%   Example:
%     y = coder.hdl.pipeline(b * c, 5);
%
%   This is a code generation function.  It has no effect in MATLAB.

%#codegen
function e = pipeline(varargin)

%   Copyright 2014 The MathWorks, Inc.

  coder.internal.prefer_const(varargin);
  coder.internal.assert((nargin == 1) || (nargin == 2), 'hdlmllib:hdlmllib:PragmaBadNumArgs', 'coder.hdl.pipeline', nargin);
  if coder.target('hdl')
      if (nargin == 1)
          coder.ceval('__hdl_pipeline', 1);
      elseif (nargin == 2)
        coder.ceval('__hdl_pipeline', varargin{2});
      end
  end
  
  coder.internal.assert((nargout == 1), 'hdlmllib:hdlmllib:PipePragmaBadNumOut', nargout);
  
  e = varargin{1};
end
