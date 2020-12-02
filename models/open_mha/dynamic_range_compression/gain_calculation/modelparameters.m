% modelparameters.m  
%
% Copyright 2020 AudioLogic, Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Connor Dack
% AudioLogic, Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

%% Initialize
addpath(genpath('signal_conversion'));       % Signal Conversion Block
addpath(genpath('attack_decay'));            % Attack and Decay Block

addpath(genpath('..\referenced_functions')); % Frost Library

%% Autogen parameters
mp.testFile = [mp.test_signals_path filesep 'auditory_nerve\mef_result_subset.wav'];

mp.sim_prompts = 1;
mp.sim_verify  = 1;
mp.simDuration = 15;
mp.nSamples    = config.system.sampleClockFrequency * mp.simDuration;
mp.useAvalonInterface = false;

%% Open MHA Parameters 
fs          = 48e3;          % Samplig Frequency
coeff_size  = 8;             % Coefficient Address Size
num_bands   = 8;             % Number of Frequency Bands
band_number = 1:1:num_bands; % Create an array of band numbers
num_coeff   = 2;             % Number of C1 Coefficients required by the Attack and Decay Filter

%% Simulation Type - Either 'double' or 'fxpt'
sim_type = 'fxpt';                  

% Data Input/Feedback Fixed Point Paramters
in_fp_size = 40; % Word Size
in_fp_dec  = 32; % Fractional Bits
in_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Define the Input Data Types
if(strcmp(sim_type,'double'))
    input_type    = 'double';
elseif(strcmp(sim_type,'fxpt'))
    input_type    = fixdt(in_fp_sign,in_fp_size,in_fp_dec);
end

%% Initialization 

