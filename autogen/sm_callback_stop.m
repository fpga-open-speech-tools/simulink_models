% sm_callback_stop
%
% This scripts captures the output signals and then verifies that
% these signals are correct. The script runs after the simulation stops.  
% This is called in the StopFcn callback found in Model Explorer.
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

%% Put the output into the SG data struct 
% The "To Workspace" block won't accept structs
mp.Avalon_Sink_Data.Time    = Avalon_Sink_Data.Time;    % time
mp.Avalon_Sink_Data.Data    = Avalon_Sink_Data.Data;    % data      
mp.Avalon_Sink_Channel.Data = Avalon_Sink_Channel.Data; % channel
mp.Avalon_Sink_Valid.Data   = Avalon_Sink_Valid.Data;   % valid


if mp.sim_verify == 1
    onPath = contains(path, [mp.modelPath, pathsep]);
    if ~onPath
        addpath(mp.modelPath)
    end
    if exist('sm_stop_verify', 'file')
        mp = sm_stop_process_output(mp);  % get the output and convert from Avalon to vector
        mp = sm_stop_verify(mp, test_signal);          % verify that the output is correct
    end
    if ~onPath
       rmpath(mp.modelPath) 
    end
end
