% WRITEJSON Take a json-compatible Matlab object and save it to a file
%
% WRITEJSON(data, filename)
%
% This function uses python to pretty-print the string before we save it to a file
%
% Inputs:
%   data = json-compatible Matlab object
%   filename = the output json file name

% Copyright 2019 Flat Earth Inc, Montana State University
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
% INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
% PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
% FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
% ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% Trevor Vannoy
% Flat Earth Inc
% 985 Technology Blvd
% Bozeman, MT 59718
% support@flatearthinc.com

function writejson(data, filename)

% pretty-printing taken from https://blogs.mathworks.com/pick/2016/11/11/r2016b-features-markerindices-jsonencode-jsondecode/

% import python libraries
py.importlib.import_module('json');
collections = py.importlib.import_module('collections');

% encode the data
jsonstr = jsonencode(data);

% create the pretty-printed json string
prettyjson = char(py.json.dumps(py.json.loads(jsonstr), pyargs('indent', int32(4))));

% save the string to a file
fid = fopen(filename, 'w');
fprintf(fid, '%s', prettyjson);
