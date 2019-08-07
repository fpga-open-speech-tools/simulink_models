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
% Get taubm readme.txt File
% 06/27/2019

The AN_Get_taubm folder contains all the files necessary for
testing/verification of the Get_taubm MATLAB function, a part of the AN
Simulink Model init script.

To test/verify the MATLAB function, simply navigate to the AN_Get_taubm folder
in MATLAB, and edit the parameters in the Verify_Get_taubm MATLAB script if
desired. Then, run the Verify_Get_taubm script.

The Verify_Get_taubm script declares the necessary test parameters and compiles
a MEX wrapper, which allows the C function Get_taubm_mex to be ran through
MATLAB. Then, both the Get_taubm MATLAB function and the Get_taubm_mex C
function are called. The outputs are compared, and the error is displayed in
the MATLAB command window. This error represents the difference between the
Get_taubm C source code function and the Get_taubm MATLAB function used in the
AN Simulink Model.
