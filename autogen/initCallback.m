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


[modelPath,modelAbbreviation,~] = fileparts(which(bdroot));
if contains(bdroot, "gm_") || (isfield(mp, 'generation_active') && mp.generation_active)
    return
end
mp.modelPath = char(modelPath);
mp.modelAbbreviation = char(modelAbbreviation);

configureModel;

testSignal = AudioSource.fromFile(mp.testFile, mp.Fs, mp.nSamples, mp.audio_dt);
stopTime = testSignal.duration;

nSamples = testSignal.nSamples;

if mp.useAvalonInterface
    avalonSource = testSignal.toAvalonSource();
    nSamples = avalonSource.nSamples;

    mp.avalonSim = avalonSource.astimeseries();

    mp.Avalon_Source_Data     = mp.avalonSim.data;
    mp.Avalon_Source_Valid    = mp.avalonSim.valid;
    mp.Avalon_Source_Channel  = mp.avalonSim.channel;
    mp.Avalon_Source_Error    = mp.avalonSim.error;
end

if mp.sim_prompts == 1  % Note: sim_prompts is set in Run_me_first.m and is set to zero when hdl code generation is run
    disp(['Simulation time has been set to ' num2str(stopTime) ' seconds'])
    disp(['Processing ' num2str(nSamples) ' samples.'])
end

clear AvalonSource
clear nSamples

