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
% Auditory Nerve Simulink Model Version 1 readme.txt File
% 08/02/2019

-------------------------------------------------------------------------------

** Quick Start Instructions **

If the user desires to simply run the model as is, refer to the Quick Start
Instructions pdf, which gives a quick visual tutorial on running the Auditory
Nerve Simulink Model.

-------------------------------------------------------------------------------

** Modify Model Instructions **

If the user desires to make modifications to the model before runtime,
refer to the Modify Model Instructions pdf, which gives a quick visual
tutorial on modifying the Auditory Nerve Simulink Model.

-------------------------------------------------------------------------------

** Verify Model Instructions **

If the user desires to verify model functionality against the original 
model source code, instructions are listed below, as well as in the Model 
Instructions block in the Simulink Model.

1. Make sure MATLAB R2019a and a compatible C compiler are downloaded on the
machine the model will be running on. The C compiler is needed for C functions
used in the test/verification process. The compiler used for testing was the
MinGW-w64 C/C++ Compiler. This can be easily accessed for free in the Add-On
Explorer found in the MATLAB home tab.

2. Open the AN_Simulink_Model_v1_Doubles folder in MATLAB. This is necessary in
order for the Simulink model to interact with MATLAB.

3. Edit model parameters, if necessary. This can be done by adjusting the
overall model parameters set in the AN_Set_Model_Parameters script, or adjusting
other parameters in the AN_Get_Model_Parameters script. Both scripts are found
in the AN_Simulink_Model_v1_Doubles folder.

4. Set the 'verificationflag' boolean to 'true' in the AN_Set_Model_Parameters
script. This enables the model to run the comparison C/MATLAB source functions
which are compared to the Simulink Model.

5. Run the model. This is done by simply clicking the green 'Run' button
located at the top panel of Simulink. In addition, the model can be stepped
through in increments, using the 'Step Through' button to the right of the
'Run' button.

-------------------------------------------------------------------------------

** Model Description **

The AN_Simulink_Model_v1_Doubles folder contains all the files necessary to run
the Auditory Nerve Simulink Model. The Simulink Model is under the name
AN_Simulink_Model_v1.slx

Four other files are found in the AN_Simulink_Model_v1_Doubles folder.
The script AN_InitFcn_Callback is an initialization file for the Simulink model,
meaning it is a MATLAB script that is called at the start of the Simulink Model
simulation. The script calls both the AN_Set_Model_Parameters and
AN_Get_Model_Parameters scripts, both which initialize parameters in the MATLAB
workspace, which are then used by reference in the Simulink model.

AN_Set_Model_Parameters contains the high-level inputs to the Auditory Nerve
Simulink Model, including the characteristic frequency of the neuron. In
addition, the script allows the user to set a verification flag, which if set
to true allows the model to call the necessary functions which emulate the
original model source code. The outputs to these functions can then be compared
against the outputs of the Simulink Model.

AN_Get_Model_Parameters contains a variety of parameter calculations, many of
which depend on the parameters set in AN_Set_Model_Parameters. Also, the script
is responsible for providing the input signal to the model. The default input
signal is set to a signal that replicates that in the original source code.

The AN_StopFcn_Callback script is called at the end
of the Simulink Model simulation, allowing for post-processing of data. This
serves as a helpful tool in testing/verification of the model if the
verification flag is set, and provides a means of displaying the outputs of the
Simulink Model.

There are also two subfolders located in the AN_Simulink_Model_v1_Doubles
folder. The AN_Model_Verification folder contains all MATLAB
scripts, MATLAB functions, C functions, C header files, and test tones
necessary to run the full Auditory Nerve Simulink Model as well as the
necessary files for verification of the full Auditory Nerve Simulink Model.

The AN_Subfunction_Verification folder contains a variety of folders, all which
isolate a particular function or set of functions used in the overall Auditory
Nerve Simulink Model. Each function folder contains the necessary files to test
and verify said function(s). This provides verification of individual Simulink
block performance, and allows for the user to experiment with single function
blocks without needing to run the entire Simulink model. Instructions to run
the Function Simulink models are found in their respective readme files.

-------------------------------------------------------------------------------

** Contact Information **

Any model-related questions are happily welcomed by Matthew Blunt.
Contact information is given below.


Matthew Blunt
Phone: (406) 951-1943
Email: mblunt97@yahoo.com


// End of readme //
