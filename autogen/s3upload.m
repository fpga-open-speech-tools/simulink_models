% s3upload(bucket, path)
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

function paths = s3upload(mp, bucket, path, clean)


    s3path = 's3://' + string(bucket) + '/' + string(path);
    disp(s3path)
    if exist('clean', 'var') && clean
        cmd = "aws s3 rm " + s3path + " --recursive";
        system(cmd);
    end
    
    paths = getArtifactPaths(mp);
    for k=1:length(paths)
        path = paths{k};
        %disp(path)
        %disp(isfile(path)); 
        cmd = "aws s3 cp " + path + " " + s3path + "/";
        system(cmd);
    end
    %;
end

function paths = getArtifactPaths(mp)
    paths = {};
    paths{end+1} = mp.modelPath + "/model.json";
    hdlpath = mp.modelPath + "/hdlsrc/" + mp.modelName + "/";
    target = lower(char(mp.target));
    paths{end+1} = hdlpath + mp.modelName + ".ko";
    paths{end+1} = hdlpath + mp.modelName + "_" + target + ".dtbo";
    paths{end+1} = hdlpath + "quartus/output_files/" + mp.modelName + "_" + target + ".rbf"; 
end
