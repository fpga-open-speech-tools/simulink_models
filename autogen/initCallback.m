% initCallback.m
%
% This scripts initializes the model variables and parameters. The script 
% runs before the simulation starts.  This is called in the InitFcn callback 
% found in Model Explorer.

% Copyright 2019 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Dylan Wickham, Trevor Vannoy, Ross K. Snider
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

% set to true so old models will still function if they don't override this
% flag
mp.useAvalonInterface = true;

[modelPath,modelAbbreviation,~] = fileparts(which(bdroot));
mp.modelPath = char(modelPath);
mp.modelAbbreviation = char(modelAbbreviation);
% onPath = contains(path, [modelPath, pathsep]);
% if ~onPath
%     addpath(modelPath)
% end
configureModel;

testSignal = AudioSource.fromFile(mp.testFile, mp.Fs, mp.nSamples);
stopTime = testSignal.duration;

if mp.useAvalonInterface
    avalonSource = testSignal.toAvalonSource();

    mp.avalonSim = avalonSource.astimeseries();

    mp.Avalon_Source_Data     = mp.avalonSim.data;
    mp.Avalon_Source_Valid    = mp.avalonSim.valid;
    mp.Avalon_Source_Channel  = mp.avalonSim.channel;
    mp.Avalon_Source_Error    = mp.avalonSim.error;
    % TODO: support sim prompts in vectorized models as well
    if mp.sim_prompts == 1  % Note: sim_prompts is set in Run_me_first.m and is set to zero when hdl code generation is run
        disp(['Simulation time has been set to ' num2str(stopTime) ' seconds'])
        disp(['    Processing ' num2str(avalonSource.nSamples) ' Avalon streaming samples.'])
        disp(['    The test signal length (current set to ' num2str(testSignal.duration)  ' sec = ' num2str(testSignal.nSamples)  ' samples)'])
    end

    clear avalonSource;
end
% if ~onPath
%     rmpath(modelPath)
% end

