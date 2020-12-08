% dB_lookup_table_sim_init.m
%
% The following script is designed as an init script for the dB Lookup
% Table Simulink model. It sets the parameters for both the 
% Simulink model and the comparison MATLAB computation. In addition, it 
% provides the test signals for the Simulink Model.
%
% Copyright 2020 Audio Logic
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

% openMHA Dynamic Compression Simulink Model Code
% dB Lookup Table Test/Verification Simulation Init Script
% 11/18/2020

%% Initialization
% close all;
addpath(genpath('..\..\..\referenced_functions'));    % Programmable Look Up Table - Frost Library

%% Simulation Type - Either 'double' or 'fxpt'
sim_type = 'fxpt';                  

% Data Input/Feedback Fixed Point Paramters
in_fp_size = 32; % Word Size
in_fp_dec  = 23; % Fractional Bits
in_fp_sign = 1;  % Unsigned = 0, Signed = 1

% Define the Input Data Types
if(strcmp(sim_type,'double'))
    input_type    = 'double';
elseif(strcmp(sim_type,'fxpt'))
    input_type    = fixdt(in_fp_sign,in_fp_size,in_fp_dec);
end

%% Declare Simulation Parameters
fs                = 48000;
simulation_length = 20000;
stop_time         = (simulation_length - 1)/fs;

%% Declare Input Signals
level_in_low  = 4e-10;
level_in_high = 2;
level_in      = linspace(level_in_low, level_in_high, simulation_length);
% Data Input Signal (Input Level level_in)
% Designed to simulate all possible input intensity levels
% from 0 dB to 96 dB
dB_level_in = linspace(dB_low, dB_high, simulation_length);
% Converting input signal from units of dBSPL to Pascal-squared
[level_in,~] = dB2lin(dB_level_in,1);

%% Look Up Table Parameters
look_up_table_size = 256;
dB_low             = 0;
dB_high            = 96;
% Look Up Table dB Values
table_init         = linspace(dB_low, dB_high, look_up_table_size)';
table_init_fp      = fi(tableInit,in_fp_sign,in_fp_size,in_fp_dec);
% Look Up Table Indexing 
% table_indexing     = logspace(log10(level_in(1)), log10(level_in(end)), look_up_table_size)';
table_indexing     = logspace(log10(level_in_low), log10(level_in_high), look_up_table_size)';
table_indexing_fp  = fi(table_indexing,0,40,38);
