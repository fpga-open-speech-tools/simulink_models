# DSP FPGA ACCELERATED TOOLBOX

% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Justin P. Williams
% E. Bailey Galacci
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

This README is focused on explaining how to use each of the blocks provided within this library.
There will also be detailed explanation on the design of each block.

The DSP FPGA Accelerated Toolbox is designed as a hardware friendly support to the existing hdllib library. 


## Table of Contents
1. Programmable Look-Up Table
2. Programmable Look-Up Table, Linear Scale
3. Static Upclocked FIR 
4. Programmable Upclocked FIR 

### Programmable Look-Up Table (PLUT)
A log-scale lookup table, designed to emulate transcendental functions with minimal resource usage.  
Accuracy is boosted through the use of linear interpolation, without the use of division.  
On initialization, the PLUT represents a single user-defined function with input "xIn". xIn does not need to be defined in the workspace, 
as it will be defined in the initialization script of the block in the local workspace.  
The PLUT adjusts its own size to fit the user-defined accuracy. Note points are pseudo-logarithmically spaced to increase precision throughout the input space.

Tables can be initialized on system startup and rewritten during runtime using the Table_Wr lines.
Min input cannot be 0, because inputs are pseudo-logarithmically spaced.

Input and Output set can be saved as "xIn" and "tableInit" within the file "<path name> init.mat" for ease of reprogramming. Input values remain constant
until the mask parameters are updated. Table Output values can be reprogrammed during runtime using the Wr_Data, Wr_En and RW_Addr lines.

Uses pseudo-logarithmic spacing of inputs for maximum accuracy in non-linear functions, as well as linear interpolation between points to further increase accuracy. Because of this, it is assumed that function input is unsigned. If this is undesired, a second table would need to be implemented to cover negative values, or some other solution outside the block.

Capable of automatically determining required table size to meet a given accuracy requirement within the entire data range, or can be manually set to a specific size with M_bits and N_bits. N_bits determines the data range as a power of 1/2 of the maximum input. M_bits determines the number of bits in the address used to increase function precision, by increasing the number of points stored between each log2 spaced input point.



#### Mask Parameters 

Table Represented Function:
  Function to estimate using the lookup table. Must contain the variable "X_in" as an input to a function, or as a variable within the executable code string, as this is used in the Initialization code to evaluate the function. If a function, that function must also have a single output which will define the values to fill the table with given input value X_in.

Save Table Input/Output set as .mat
  If asserted, the table's inputs and outputs will be saved in a .mat file named "<path name>_init.mat". By loading this, it is possible to see all precalculated points of the look-up table. This is especially useful when trying to reprogram the table, as all input points are shown along with their associated addresses.

--Table Parameters--
  Maximum Input Value: 
    The maximum input value the table should be expected to represent. If the input value is greater than this parameter's nearest higher power of 2, the table will output the value for the highest input.

--Define Input Threshold and Accuracy Tab--
  Minimum Input Threshold: 
    The minimum input to recognize by the table. If the input value is less than this parameter's the nearest lower power of 2, the table will output the value for the lowest input.

  Maximum Allowed Error (%):
    The amount of percent error allowed by the table. Used by the init script to identify the size of the table required to meet this parameter. This is found by testing a set of examples 4 times larger than the table set, therefore it is possible on rare occasion for some points to exceed this error. Decreasing this will increase the memory required for the table, but increase precision. 

  Show Error Calculation:
    When asserted, the block will pop-up graphs showing the error calculation and a pop-up detailing the amount of memory used, size of the RAM allocated, and maximum error.

--Define Address Space Manually Tab--
  N_bits:
    Only used when Manual Bit Definition Override is asserted.
    The width of the address dedicated to breadth of valid data. Increasing this will cause the table to recognize smaller numbers (by increasing the size of the Leading Zero Counter's output)  at the cost of memory used, and more logic required in the LZC. 
  M_bits: 
    Only used when Manual Bit Definition Override is asserted.
    The width of the address dedicated to depth of valid data. Increasing this will cause more bits of the input to be considered as part of the address after the Leading Zero Counter, increasing precision at the cost of memory.

  Manual Bit Definition Override:
    Checking this box will skip automatic size definition of Leading Zero Counter and precision bit size. Use with caution, as percent error will not be guaranteed with this setting on. Read the formal documentation for more details, kept within the file structure this library is stored in.


--Data Parameters dropdown--
Word Bits: 
  Size of fixed point word of both the input signal and table memory.

Fractional Bits:
  Number of fractional bits in the fixed point word of both the input signal and table memory.

----------
Block I/O
----------
INPUTS: 

--Data_In--
  Input signal to be looked-up. Expected size fixdt(0,Word Bits, Fractional Bits).

--Table_Wr_Data-- % Table Write Data
  Data to write to the table, in location Table_RW_Addr, when Table_Wr_En is asserted. Expected size fixdt(0,Word Bits, Fractional Bits).

--Table_RW_Addr-- % Table Read/Write Address
  The location within the table to read or overwrite. Expected size changes based on the function and allowed error as initialized, and is shown on the Mask Label as RAM Width, or by checking the "Show Error Calculation" button as RAM Width. 
  There is an internal check that will correct a signal of the wrong size to the correct address size, but it may be useful to know the X values associated with table output at any given address. Using the "Save Table Input/Output as .mat" option will save the entire set of initialized inputs and outputs along with their associated addresses.
  For a full explanation on how xIn is derived, see the formal documentation contained within the file structure this library is stored in.

--Table_Wr_En-- % Table Write Enable
  Boolean. If this line is asserted, address Table_RW_Addr will be overwritten with data Table_Wr_Data. 


OUTPUTS: 
--Data_Out-- 
  Output data of the table. Size fixdt(1,Word Bits, Fractional Bits).

--Table_RW_Dout-- % Table Read/Write Data Out
  Outputs the data currently within address Table_RW_Addr (after writing if Table_Wr_En is asserted).


### Programmable Look-Up Table, Linear Scale


### Static Upclocked FIR 


### Programmable Upclocked FIR 

