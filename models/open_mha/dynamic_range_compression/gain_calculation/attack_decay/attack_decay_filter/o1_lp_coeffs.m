% o1_lp_coeffs Function: Lines 589 - 599 of mha_filter.cpp
%
% Inputs:
%   tau - time constant in milliseconds
%   fs  - sampling rate in hertz
% Outputs:
%   c1 - Coefficient C1
%   c2 - Coefficient C2
%
% Copyright 2020 AudioLogic, Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Connor Dack
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

function [c1, c2] = o1_lp_coeffs(tau, fs)
    
    if((tau > 0) && (fs > 0))      % Line 594
        c1 = exp(-1.0/(tau * fs)); % Line 595
    else                           % Line 596
        c1 = 0;                    % Line 597
    end
    c2 = 1.0 - c1;                 % Line 598
end