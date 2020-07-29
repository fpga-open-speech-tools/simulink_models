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
% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Ross K. Snider
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

function mp = sm_stop_process_output(mp)

%% Get the Avalon streaming signals from the model
time = mp.Avalon_Sink_Data.Time;             % time
data = squeeze(mp.Avalon_Sink_Data.Data);    % data      Note: the Matlab squeeze() function removes singleton dimensions (i.e. dimensions of length 1)
channel = squeeze(mp.Avalon_Sink_Channel.Data); % channel
valid = squeeze(mp.Avalon_Sink_Valid.Data);   % valid
data = double(data);

channel = int(channel);
idxvalid = valid == 1;
time = time(idxvalid);
data = data(idxvalid);
channel = channel(idxvalid);

% Remove fields for different number of samples (TODO: is this needed?)
data_field = "data_out";
time_field = "time_out";
if isfield(mp, data_field)
    mp = rmfield(mp, data_field);
end
if isfield(mp, time_field)
    mp = rmfield(mp, time_field);
end

for i=1:mp.nChannels
        idxchan = channel == i - 1;
        mp.data_out(i, :) = data(idxchan);
        mp.time_out(i, :) = time(idxchan);
end

