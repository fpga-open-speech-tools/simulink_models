% abs2 Function: Lines 1291-1300 of mha_signal.hh
%
% Inputs:
%   self_re     - Real Component of FFT Data Bin
%   self_im     - Imaginary Componenet of Input FFT Data Bin
% Outputs:
%   bin_intensity    - Bin Intensity Value in units of Pascal-squared
%
% Copyright 2020 AudioLogic, Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

function bin_intensity = abs2(self_re, self_im)

% Takes in the current real and imaginary FFT data bin and calculates the
% intensity of the bin in Pascal-squared.

bin_intensity = self_re.*self_re + self_im.*self_im;

end