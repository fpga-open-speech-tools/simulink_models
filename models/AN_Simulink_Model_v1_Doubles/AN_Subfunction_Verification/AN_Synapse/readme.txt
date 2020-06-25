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
% Synapse readme.txt File
% 07/31/2019

The AN_Synapse folder contains all the files necessary for
testing of the Synapse Simulink model, a part of the AN Simulink model.

To test the Simulink model, simply edit the
Synapse_Test_Parameters MATLAB script parameters if desired.
Next, navigate to the AN_Synapse folder in MATLAB.
Then, open and run the Synapse Simulink model.

The model calls the Synapse_Test_Parameters init script,
declaring the parameters in the MATLAB workspace. The Simulink model then uses
those parameters to manipulate the test signal, also declared in the parameters
MATLAB script. Once the output of the Simulink model is calculated, the model
calls the Verify_Synapse MATLAB script. Due to the random nature of the
Spike Generator, the model cannot be verified exactly. Instead, the results are
simply plotted for testing purposes.
