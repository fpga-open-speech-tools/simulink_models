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
% openspeech@flatearthinc.com

% Auditory Nerve Simulink Model Code
% Power Law Adaptation readme.txt File
% 07/31/2019

The AN_PLA folder contains all the files necessary for
testing/verification of the Power Law Adaptation Simulink model,
a part of the AN Simulink model.

To test/verify the Simulink model, simply edit the
Power_Law_Test_Parameters MATLAB script parameters if desired.
Next, navigate to the AN_PLA folder in MATLAB.
Then, open and run the Power_Law_Adaptation Simulink model.

The model calls the Power_Law_Test_Parameters init script,
declaring the parameters in the MATLAB workspace. The Simulink model then uses
those parameters to manipulate the test signal, also declared in the parameters
MATLAB script. Once the output of the Simulink model is calculated, the model
calls the Verify_Power_Law_Adaptation MATLAB script, which calls the PowerLaw
MATLAB function to calculate the output. The PowerLaw MATLAB function works
exactly like the Power Law Adaptation Approximation function implemented in
the model_IHC_BEZ2018 C source code file, and serves as a golden reference to
which the Simulink model can be compared.

The verify script will output a comparison plot of the two results. It will
also print an error value to the Simulink Diagnostics window.
