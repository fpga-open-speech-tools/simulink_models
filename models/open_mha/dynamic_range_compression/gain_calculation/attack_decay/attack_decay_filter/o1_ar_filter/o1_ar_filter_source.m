% o1_ar_filter_t Operator Function: Lines 196-206 of mha_filter.hh
% Simplifed to a single channel
%
% Inputs:
%   x       - Data Input
%   c1_a    - Attack Coefficient C1
%   c2_a    - Attack Coefficient C2
%   c1_r    - Release Coefficient C1
%   c2_r    - Release Coefficient C2
%   buff_in - Previous Filter Result
% Outputs:
%   y       - Filter Result
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

function y = o1_ar_filter_source(x, c1_a, c2_a, c1_r, c2_r, buff_in)
    if(x >= buff_in)                       % Line 200
        y = (c1_a * buff_in) + (c2_a * x); % Line 201
    else                                   % Line 202
        y = (c1_r * buff_in) + (c2_r * x); % Line 203
    end
end