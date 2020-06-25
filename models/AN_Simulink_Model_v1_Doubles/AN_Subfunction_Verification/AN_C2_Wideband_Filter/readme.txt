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
% C2 Wideband Filter readme.txt File
% 06/27/2019

The AN_C2_Wideband_Filter folder contains all the files necessary for
testing/verification of the C2 Wideband Filter Simulink model,
a part of the AN Simulink model.

The C2 filter may be referenced as both "C2 Wideband Filter" or
"C2 Chirp Filter."  Know that both are with reference to the same filter.

To test/verify the Simulink model, simply edit the
C2_Wideband_Test_Parameters MATLAB script parameters if desired.
Next, navigate to the AN_C2_Wideband_Filter folder in MATLAB.
Then open and run the C2_Wideband_Filter Simulink model.

The model calls the C2_Wideband_Test_Parameters init script,
declaring the parameters in the MATLAB workspace. In the
C2_Wideband_Test_Parameters init script, the C2Coefficients MATLAB function
is called. This function simply calculates the coefficients for the filter
as well as the normalizing gain. The Simulink model then uses
those parameters to filter the test signal, also declared in the
parameters MATLAB script. Once the output of the Simulink model is calculated,
the model calls the Verify_C2_Wideband_Filter MATLAB script,
which creates a MEX wrapper and then calls the C2ChirpFilt C function to
calculate the filter output. The MEX wrapper allows for the C function to be
executed after it is called in MATLAB. The C2ChirpFilt C function works exactly
like the C2ChirpFilt function in the model_IHC_BEZ2018 C source code file,
and serves as a golden reference to which the Simulink model can be compared.

The verify script will output a comparison plot of the two results. It will
also print an error value to the Simulink Diagnostics window.
