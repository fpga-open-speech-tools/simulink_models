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
in_fp_size = 40; % Word Size
in_fp_dec  = 32; % Fractional Bits
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

%% Look Up Table Parameters
lookup_table_size = 2048*16;
dB_low            = 0;
dB_high           = 96;

% Look Up Table Indexing 
table_indexing_start   = fi(2^-3,0,40,32);%dB2lin(dB_low,1);
table_indexing_spacing = fi((dB2lin(dB_high,1)-dB2lin(dB_low,1))/lookup_table_size,0,40,32);

% Look Up Table dB Values
table_init = zeros(lookup_table_size,1);
for i = 1:lookup_table_size
    table_init(i) = 10*log10(2500000000*((double(table_indexing_spacing*(i-1)))+double(table_indexing_start)));
end
table_init_fp = fi(table_init,in_fp_sign,in_fp_size,in_fp_dec);

%% Declare Input Signals
% Data Input Signal (Input Level level_in)
% Designed to simulate all possible input intensity levels
% from 0 dB to 96 dB
dB_level_in = linspace(dB_low, dB_high, simulation_length);
% Converting input signal from units of dBSPL to Pascal-squared
[level_in,~] = dB2lin(dB_level_in,1);



%% PLUT INIT SCRIPT
%
% This script is a copy of code used in the Programmable Look-Up Table's
% init script in the DSP_FPGA_Accelerated_Toolbox.

% Copyright 2020 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% E. Bailey Galacci
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

% things to display: table size, input bounds, function, accuracy
% things to figure out: M_bits, N_bits, Min_val, X_in table, Y_out table,
% max_error, ram_size, table_size 

% Block Parameters
maxInput = 1;
binaryOffset = ceil(log2(maxInput)); % used for binary tricks, as well as identifying input range
IGOTTHIS = false;
floorParam = 2^-31;
errorParam = 1;
tableFnParam = '10.*log10(2500000000.*xIn)';
ERR_DIAG   = 0;
PLOT_TABLE = 0;
SAVE_TABLE = 0;
W_bits = 40;
F_bits = 32;
ram_size = 8;
% Initialization Function
N_bits = ceil(log2(binaryOffset-log2(floorParam)+1));
M_bits = 1; %this will be updated later as needed

repeatFlag = true;
while(repeatFlag)
    % Define a N point log2 spaced range of inputs, from 2^(d-(2^N_bits -1)) to almost 2^(d+1), 
    % this effectively covers the user defined input range, down to a floor
    % value.
    xIn = zeros(1, 2^(M_bits+N_bits));
    addr = 1;
    for NShifts = 2^N_bits-1:-1:0
        for M = 0:2^M_bits - 1
            xIn(addr) = 2^(binaryOffset-NShifts) + M*2^(binaryOffset-NShifts-M_bits);
            addr = addr+1;
        end
    end

    % use function to define output. note: function must contain input xIn
    % within the string to work properly, and the only output of the function
    % must be the table values.
    tableInit = eval(tableFnParam);
    Table_Init = tableInit;

    RAM_SIZE = N_bits+M_bits;
    maxVal = 2^binaryOffset+ (2^M_bits -1)*2^(binaryOffset-M_bits);
    minVal = 2^(binaryOffset-(2^N_bits-1));
    %set_param(gcb,'MaskDisplay',"disp(sprintf('Programmable Look-up Table\nMemory Used = %d samples and coeffs\nClock Rate Needed = %d Hz', FIR_Uprate*2, Max_Rate)); port_label('input',1,'data'); port_label('input',2,'valid'); port_label('input',3,'Wr_Data'); port_label('input',4,'Wr_Addr'); port_label('input',5,'Wr_En'); port_label('output',1,'data'); port_label('output',2,'valid'); port_label('output',3,'RW_Dout');")

    %%%%%%%%%% check and identify error %%%%%%%%%%%
    % Define a set of test cases for the lookup table with log spaced points
    xTest = logspace(log10(minVal), log10(maxVal), 2^(RAM_SIZE+2));
    xTemp = xIn;
    xIn = xTest;
    % identify the values of the function at xTest
    yTest = eval(tableFnParam);

    % move lookup table input values back to xIn
    xIn = xTemp;

    % Find lookup addresses for each point in xTest
    % Effectively assumes the highest input value, then decreases address until test input is greater than associated table input at that address
    addrTest = zeros(1,length(xTest));
    for it = 1:length(xTest)
        addrTest(it) = 2^RAM_SIZE;
        while(xTest(it) < xIn(addrTest(it)) && addrTest(it) ~= 1)   % find the address associated with an input value closest to and below xTest
            addrTest(it) = addrTest(it) - 1;
        end
        if(addrTest(it)==0)
            addrTest(it) = 1;
        end
    end

    % Check for any possible out of bounds errors (handled similarly in hardware)
    addrTest(addrTest == 2^RAM_SIZE) = 2^RAM_SIZE -1;

    % Get values for linear interpolation of xIn
    xLow  = xIn(addrTest);
    xHigh = xIn(addrTest+1);

    % apply point-slope formula to preform linear interpolation for the table readout
    yLow  = tableInit(addrTest);
    yHigh = tableInit(addrTest+1);
    slope  = (yHigh-yLow) ./ (xHigh - xLow);
    yInter = slope.*(xTest-xLow)+yLow;
    
    % percent error: obt-exp / exp
    %errorFloor = (yTest-yLow)./yTest;  % w/out linear interpolation
    errorInter = (yTest-yInter)./yTest; % w/ linear interpolation
    maxErr = max(abs(errorInter));
    %check while loop condition
    if(100*maxErr <= abs(errorParam))
        repeatFlag = false;
    else

        if(100*maxErr > 8*errorParam)
            M_bits = M_bits+3;
        elseif(100*maxErr > 4*errorParam)
            M_bits = M_bits+2;
        else
            M_bits = M_bits+1;
        end
    end
end
