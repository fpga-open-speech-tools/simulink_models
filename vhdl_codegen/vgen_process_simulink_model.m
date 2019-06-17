%--------------------------------------------------------------------------
% Description:  Matlab script to setup environment for Simulink VHDL code
%               generation
%--------------------------------------------------------------------------
% Author:       Ross K. Snider
% Company:      Flat Earth Inc
%               985 Technology Blvd
%               Bozeman, MT 59718
%               support@flatearthinc.com
% Create Date:  June 7, 2019
% Tool Version: MATLAB R2019a
% Revision:     1.0
% License:      MIT License (see license at end of code)
%--------------------------------------------------------------------------
%------------- BEGIN CODE --------------

% ---------------------------------------------------------
% Parse the Simulink Model to get the Avalon signals
% and the registers
%----------------------------------------------------------
avalon = vgen_get_simulink_block_interfaces();
avalon.vhdl = vgen_generate_VHDL_component(avalon);
disp(avalon.vhdl.component_declaration)
disp(avalon.vhdl.component_instantiation)
disp(avalon.vhdl.register_defaults)

% save the specified clock frequencies
avalon.clocks.sample_frequency_Hz   = Fs;
avalon.clocks.sample_period_seconds = Ts;
avalon.clocks.system_frequency_Hz   = Fs_system;
avalon.clocks.system_period_seconds = Ts_system;

% Save the avalon structure to a json file and a .mat file
writejson(avalon, [avalon.entity,'.json'])
save([model_name '_avalon'], 'avalon')

% Generate the VHDL code
eval([model_name '_hdlworkflow'])

%------------- END OF CODE --------------
%--------------------------------------------------------------------------
% MIT License
% Copyright (c) 2019 Flat Earth Inc
%
%Permission is hereby granted, free of charge, to any person obtaining a copy
%of this software and associated documentation files (the "Software"), to deal
%in the Software without restriction, including without limitation the rights
%to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%copies of the Software, and to permit persons to whom the Software is
%furnished to do so, subject to the following conditions:
%
%The above copyright notice and this permission notice shall be included in all
%copies or substantial portions of the Software.
%
%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%SOFTWARE.
%--------------------------------------------------------------------------





