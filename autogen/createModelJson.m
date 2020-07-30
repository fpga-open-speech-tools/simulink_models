% createModelJson(modelName)
%
% This function creates `model.json`configuration file in the current
% directory with defaults set, a device added with no registers
% and the device name set to modelName. 
%
% Inputs:
%   modelName, which is the name of the Simulink model that the `model.json` is for

% Copyright 2020 Audio Logic
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Dylan Wickham
% Audio Logic
% 985 Technology Blvd
% Bozeman, MT 59718
% openspeech@flatearthinc.com

function createModelJson(modelName)
    autogenDir = erase(mfilename('fullpath'), mfilename); 
    configPath = autogenDir + "defaultModel.json";
    config =  jsondecode(fileread(configPath));
    config.devices(1).name = char(modelName);
    writejson(config, "model.json")
end

