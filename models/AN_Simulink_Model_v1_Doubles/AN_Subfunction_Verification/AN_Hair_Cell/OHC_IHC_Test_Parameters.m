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
% OHC_IHC_Test_Parameters
% 07/31/2019

%clear all;
%close all;

%% NOTES

% The following script is the sole Init Function call for the OHC/IHC Simulink
% Model. This script calls various other scripts to declare/calculate all
% necessary parameters in the MATLAB workspace, which are then referenced
% by the Simulink model. Each script will be accompanied by a comment
% describing the function of the script.

%% MODEL PARAMETERS

% The script 'OHC_IHC_Model_Parameters' includes the highest level input
% parameters to the AN Simulink Model. All parameters calculated afterword
% will depend on these parameters.

OHC_IHC_Model_Parameters;

%% GET OTHER PARAMETERS

% The script 'OHC_IHC_Get_Parameters' includes all other calculations for
% parameters not included in the model parameters. Many of these parameters
% depend on those set in 'OHC_IHC_Model_Parameters'

% There are various function calls included in the script, and each
% function call will include comments describing the desired functionality

OHC_IHC_Get_Parameters;

% End of script
