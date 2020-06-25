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
% OHC Lowpass Filter readme.txt File
% 06/26/2019

The AN_OHC_Lowpass_Filter folder contains all the files necessary for
testing/verification of the OHC Lowpass Filter Simulink model,
a part of the AN Simulink model.

To test/verify the Simulink model, simply edit the
OHC_Lowpass_Test_Parameters MATLAB script parameters if desired.
Next, navigate to the AN_OHC_Lowpass_Filter folder in MATLAB.
Then, open and run the OHC_Lowpass_Filter Simulink model.

The model calls the OHC_Lowpass_Test_Parameters init script,
declaring the parameters in the MATLAB workspace. The Simulink model then uses
those parameters to filter the test signal, also declared in the
parameters MATLAB script. Once the output of the Simulink model is calculated,
the model calls the Verify_OHC_Lowpass_Filter MATLAB script,
which creates a MEX wrapper and then calls the OhcLowPass C function to
calculate the filter output. The MEX wrapper allows for the C function to be
executed after it is called in MATLAB. The OhcLowPass C function works exactly
like the OhcLowPass function in the model_IHC_BEZ2018 C source code file,
and serves as a golden reference to which the Simulink model can be compared.

The verify script will output a comparison plot of the two results. It will
also print an error value to the Simulink Diagnostics window.
