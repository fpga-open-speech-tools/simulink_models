% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Matthew Blunt
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

% Auditory Nerve Simulink Model Code
% Get tauwb readme.txt File
% 06/27/2019

The AN_Get_tauwb folder contains all the files necessary for
testing/verification of the Get_tauwb MATLAB function, a part of the AN
Simulink Model init script.

To test/verify the MATLAB function, simply navigate to the AN_Get_tauwb folder
in MATLAB, and edit the parameters in the Verify_Get_tauwb MATLAB script if
desired. Then, run the Verify_Get_tauwb script.

The Verify_Get_tauwb script declares the necessary test parameters and compiles
a MEX wrapper, which allows the C function Get_tauwb_mex to be ran through
MATLAB. Then, both the Get_tauwb MATLAB function and the Get_tauwb_mex C
function are called. The outputs are compared, and the error is displayed in
the MATLAB command window. This error represents the difference between the
Get_tauwb C source code function and the Get_tauwb MATLAB function used in the
AN Simulink Model.
