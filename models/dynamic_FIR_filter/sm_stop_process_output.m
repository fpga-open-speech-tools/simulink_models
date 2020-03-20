% mp = sm_stop_process_output(mp)
%
% Matlab function that gets the Avalon Streaming output and converts it
% to a vector format that is useful for verification.
%
% Inputs:
%   mp, which is the model data structure that holds the model parameters
%
% Outputs:
%   mp, the model data structure that now contains the left/right channel
%   data, which is in the following format:
%          mp.left_data_out         - The processed left channel data
%          mp.left_time_out         - time of left channel data
%          mp.right_data_out        - The processed right channel data
%          mp.right_time_out        - time of right channel data
%
% Copyright 2019 Flat Earth Inc
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

function mp = sm_stop_process_output(mp)

%% Get the Avalon streaming signals from the model
t = mp.Avalon_Sink_Data.Time;             % time
d = squeeze(mp.Avalon_Sink_Data.Data);    % data      Note: the Matlab squeeze() function removes singleton dimensions (i.e. dimensions of length 1)
c = squeeze(mp.Avalon_Sink_Channel.Data); % channel
v = squeeze(mp.Avalon_Sink_Valid.Data);   % valid
left_index = 1;
right_index = 1;
for i=1:length(v)
    if v(i) == 1  % check if valid, valid is asserted when there is data
        if c(i) == 0  % if the channel number is zero, it is left channel data
            mp.left_data_out(left_index) = double(d(i));
            mp.left_time_out(left_index) = t(i);
            left_index            = left_index + 1;
        end
        if c(i) == 1  % if the channel number is one, it is right channel data
            mp.right_data_out(right_index) = double(d(i));
            mp.right_time_out(right_index) = t(i);
            right_index             = right_index + 1;
        end
    end
end

