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
% Hair Cell Model readme.txt File
% 07/31/2019

The AN_Hair_Cell folder contains all the files necessary for
testing/verification of the Hair Cell Simulink model,
a part of the AN Simulink model.

To test/verify the Simulink model, simply edit the
OHC_IHC_Model_Parameters or OHC_IHC_Get_Parameters MATLAB script parameters
if desired. The OHC_IHC_Model_Parameters script contains the overall Auditory
Nerve Model inputs, while the OHC_IHC_Get_Parameters script contains all other
parameters calculations necessary to run the Hair Cell Simuliink Model.
Next, navigate to the AN_Hearing_Cell folder in MATLAB.
Then, open and run the OHC_IHC_Model Simulink model.

The model calls the OHC_IHC_Test_Parameters init script, which subsequently
calls the OHC_IHC_Model_Parameters and OHC_IHC_Get_Parameters script,
declaring the parameters in the MATLAB workspace. The Simulink model then uses
those parameters to manipulate the test signal, also declared in the parameters
MATLAB script. Once the output of the Simulink model is calculated, the model
calls the Verify_OHC_IHC_Model MATLAB script, which calls various C and
MATLAB functions to calculate the output. The functions work like the
model_IHC_BEZ2018 C source code file, and serve as a golden reference to
which the Simulink model can be compared.

The verify script will output comparison plots of the two results. It will
also print an error values to the Simulink Diagnostics window.
