% stopCallback
%
% This scripts captures the output signals and then verifies that
% these signals are correct. The script runs after the simulation stops.  
% This is called in the StopFcn callback found in Model Explorer.

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

if mp.useAvalonInterface
    mp.Avalon_Sink_Data.Time    = Avalon_Sink_Data.Time;    
    mp.Avalon_Sink_Data.Data    = Avalon_Sink_Data.Data;          
    mp.Avalon_Sink_Channel.Data = Avalon_Sink_Channel.Data; 
    mp.Avalon_Sink_Valid.Data   = Avalon_Sink_Valid.Data;   
end    


if mp.sim_verify == 1
    verifySimScript = [mp.modelPath filesep 'verifySim.m'];
    if exist(verifySimScript, 'file')
        if mp.useAvalonInterface
            mp = processOutput(mp);  % get the output and convert from Avalon to vector
        end
        run(verifySimScript);          % verify that the output is correct
    else
        disp(['Simulation verification is on but the verification script was not found at:' newline  verifySimScript])
    end
end
