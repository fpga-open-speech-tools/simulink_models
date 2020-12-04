% intensity Function: Lines 1937-1965 of mha_signal.cpp
% Edited to match data flow architecture
%
% Inputs:
%   self_re     - Real Component of FFT Data Bin
%   self_im     - Imaginary Component of Input FFT Data Bin
%   accumulator_reset   - Control Signal Indicating Change in Frequency Band
%   bin_num     - Current bin index (0 to fftlen-1)
%   fftlen      - FFT length
% Outputs:
%   level    - Current Frequency Band Intensity Level in units of Pascal-squared
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


function level = intensity(s_re, s_im, accumulator_reset, bin_num, fftlen)

% Accumulates the bin intensities until a new frequency band is detected.
% Takes in the current complex FFT bin data s_re and s_im, 
% an accumulator reset control signal, bin number and FFT length. If the 
% accumulator_reset is true, the sum is reset starting with the current 
% frequency bin intensity. This is a slight edit to the openMHA function
% necessary for the data flow architecture.

persistent total;

if isempty(total)
    total = 0;
end

if bin_num == 0 || bin_num == fftlen/2
    k_nyquist = true;
else
    k_nyquist = false;
end

if k_nyquist == true && accumulator_reset == true
    total = 0.5*abs2(s_re, s_im);
elseif k_nyquist == true && accumulator_reset == false
    total = total + 0.5*abs2(s_re, s_im);
elseif k_nyquist == false && accumulator_reset == true
    total = abs2(s_re, s_im);
elseif k_nyquist == false && accumulator_reset == false
    total = total + abs2(s_re, s_im);
else
    total = 0;
    error('Incorrect Logic in accumulate_band function!');
end

level = 2*total;
% including negative frequencies!! Thus factor of 2:
% no sqrt invocation here because intensity is wanted.