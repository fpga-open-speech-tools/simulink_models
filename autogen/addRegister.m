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

function addRegister(name, signed, wordLength, fractionLength, defaultValue,device)
    arguments 
        name string
        signed logical
        wordLength uint32
        fractionLength uint32
        defaultValue double
        device uint32 = 1
    end
    config =  jsondecode(fileread('model.json'));
    nRegs = numel(config.devices(device).registers);
    tempReg.name = name;
    tempReg.dataType.signed = signed;
    tempReg.dataType.wordLength = wordLength;
    tempReg.dataType.fractionLength = fractionLength;
    tempReg.defaultValue = defaultValue;
    tempReg.registerNumber = nRegs;
    
    config.devices(device).registers(end + 1) = tempReg;
    writejson(config, "model.json")
end

