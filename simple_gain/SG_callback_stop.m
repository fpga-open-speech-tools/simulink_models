%--------------------------------------------------------------------------
% Description:  Matlab script to verify model ran correctly
%               This script runs when the simulation ends (StopFcn
%               callback found in Model Explorer)
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
%--------------------------------------------------------------------------
% Get Avalon data
%-------------------------------------------------------------------------
t = Avalon_Sink_Data.Time;             % time 
d = squeeze(Avalon_Sink_Data.Data);    % data      Note: the Matlab squeeze() function removes singleton dimensions (i.e. dimensions of length 1)
c = squeeze(Avalon_Sink_Channel.Data); % channel
v = squeeze(Avalon_Sink_Valid.Data);   % valid     
left_index = 1;
right_index = 1;
for i=1:length(v)
   if v(i) == 1  % check if valid, valid is asserted when there is data
        if c(i) == 0  % if the channel number is zero, it is left channel data
            left_data_out(left_index) = double(d(i));
            left_time_out(left_index) = t(i);
            left_index            = left_index + 1;
        end
        if c(i) == 1  % if the channel number is one, it is right channel data
            right_data_out(right_index) = double(d(i));
            right_time_out(right_index) = t(i);
            right_index             = right_index + 1;
        end
   end
end

%--------------------------------------------------------------------------
% Verify that the test data got encoded, passed through the model, and 
% decoded correctly.  The input (modified by gain) and output values should be identical.
%--------------------------------------------------------------------------
left_error_max  = max(abs(left_data_in*Register_Control_Left_Gain-left_data_out));
right_error_max = max(abs(right_data_in*Register_Control_Right_Gain-right_data_out));
precision = 2^(-F_bits);
% display popup message
if (left_error_max <= precision) && (right_error_max <= precision) 
    helpdlg(sprintf([' Max Left Error = ' num2str(left_error_max) '\n Max Right Error = ' num2str(right_error_max) '\n Error is within exceptable range \n Least significant bit precision (F_bits = ' num2str(F_bits) ') is ' num2str(2^(-F_bits))]))
else
    helpdlg(sprintf([' Max Left Error = ' num2str(left_error_max) '\n Max Right Error = ' num2str(right_error_max) '\n Error is NOT within exceptable range \n Least significant bit precision (F_bits = ' num2str(F_bits) ') is ' num2str(2^(-F_bits))]))
end

%--------------------------------------------------------------------------
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
