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
% CP Gammatone Filter readme.txt File
% 06/27/2019

The AN_CP_Gammatone_Filter folder contains all the files necessary for
testing/verification of the CP Gammatone Filter Simulink model,
a part of the AN Simulink model.

The CP filter may be referenced as both "CP Wideband Gammatone Filter" or
"CP Gammatone Filter."  Know that both are with reference to the same filter.
CP stands for Control Path.

To test/verify the Simulink model, simply edit the
CP_Gammatone_Test_Parameters MATLAB script parameters if desired.
Next, navigate to the AN_CP_Gammatone_Filter folder in MATLAB.
Then, open and run the CP_Gammatone_Filter Simulink model.

The model calls the CP_Gammatone_Test_Parameters init script,
declaring the parameters in the MATLAB workspace. The Simulink model then uses
those parameters to filter the test signal, also declared in the
parameters MATLAB script. Once the output of the Simulink model is calculated,
the model calls the Verify_CP_Gammatone_Filter MATLAB script,
which creates a MEX wrapper and then calls the WBGammaTone C function to
calculate the filter output. The MEX wrapper allows for the C function to be
executed after it is called in MATLAB. The WBGammaTone C function works exactly
like the WBGammaTone function in the model_IHC_BEZ2018 C source code file,
and serves as a golden reference to which the Simulink model can be compared.

The verify script will output a comparison plot of the two results. It will
also print an error value to the Simulink Diagnostics window.
