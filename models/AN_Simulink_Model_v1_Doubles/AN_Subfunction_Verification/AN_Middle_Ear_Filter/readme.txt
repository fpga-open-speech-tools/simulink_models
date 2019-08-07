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
% Middle Ear Filter readme.txt File
% 06/26/2019

The AN_Middle_Ear_Filter folder contains all the files necessary for
testing/verification of the Middle Ear Filter Simulink model, a part of the AN
Simulink Model.

To test/verify the Simulink model, simply edit the Middle_Ear_Test_Parameters
MATLAB script parameters if desired.
Next, navigate to the AN_Middle_Ear_Filter folder in MATLAB.
Then, open and run the Middle_Ear_Filter Simulink model.

The model calls the Middle_Ear_Test_Parameters init script, declaring the
parameters in the MATLAB workspace. The Simulink model then uses those
parameters to filter the test signal, also declared in the parameters MATLAB
script. Once the output of the Simulink model is calculated, the model calls
the Verify_Middle_Ear MATLAB script, which subsequently calls the Middle_Ear
MATLAB function to calculate the filter output. This function works exactly
like the Middle Ear filter in the model_IHC_BEZ2018 C source code file,
and serves as a golden reference to which the Simulink model can be compared.

The verify script will output a comparison plot of the two results. It will
also print an error value to the Simulink Diagnostics window.
