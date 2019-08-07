% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

% Auditory Nerve Simulink Model Code
% gain_groupdelay readme.txt File
% 06/27/2019

The AN_gain_groupdelay folder contains all the files necessary for
testing/verification of the gain_groupdelay MATLAB function, a part of the AN
Simulink Model init script.

To test/verify the MATLAB function, simply navigate to the AN_gain_groupdelay folder
in MATLAB, and edit the parameters in the Verify_gain_groupdelay MATLAB script if
desired. Then, run the Verify_gain_groupdelay script.

The Verify_gain_groupdelay script declares the necessary test parameters and compiles
a MEX wrapper, which allows the C function Get_gain_groupdelay_mex to be ran through
MATLAB. Then, both the gain_groupdelay MATLAB function and the gain_groupdelay_mex C
function are called. The outputs are compared, and the error is displayed in
the MATLAB command window. This error represents the difference between the
gain_groupdelay C source code function and the gain_groupdelay MATLAB function used in the
AN Simulink Model.
