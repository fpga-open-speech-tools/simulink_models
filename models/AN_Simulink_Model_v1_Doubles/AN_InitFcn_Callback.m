% Copyright 2019 Audio Logic
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
% AN_InitFcn_Callback
% 08/02/2019

%clear all;
%close all;


%% NOTES

% The following script is the sole Init Function call for the AN Simulink
% Model. This script calls various other scripts to declare/calculate all
% necessary parameters in the MATLAB workspace, which are then referenced
% by the Simulink model. Each script will be accompanied by a comment
% describing the function of the script.

%% ADD FOLDER PATH

% All MATLAB scripts, MATLAB functions, C functions, Header files, etc. are
% located in the 'AN_Model_Verification' folder. The following command
% adds the folder to the MATLAB path, a necessary step in order to get
% access to the various files and functions used to calculate all the
% initial parameters for the Auditory Nerve Simulink Model, in addition to
% the functions used for model verification.

addpath('AN_Model_Verification');


%% MODEL PARAMETERS

% The script 'AN_Set_Model_Parameters' includes the highest level input
% parameters to the AN Simulink Model. Many parameters calculated afterword
% will depend on these parameters.

AN_Set_Model_Parameters;

%% GET OTHER PARAMETERS

% The script 'AN_Get_Model_Parameters' includes all other calculations for
% parameters not included in the model parameters. Many of these parameters
% depend on those set in 'AN_Set_Model_Parameters'

% There are various function calls included in the script, and each
% function call will include comments describing the desired functionality

% NOTE: This is the script which contains the input signal. The default
% input is set to a signal equivalent to that in the source code.

AN_Get_Model_Parameters;


% End of AN_InitFcn_Callback
