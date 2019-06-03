function json = readjson(filename)
% READJSON read a json file and return a json-formatted string
%
% json = READJSON(filename)
%
% filename: the input filename
% json: the json-formatted string

%https://www.mathworks.com/matlabcentral/answers/326764-how-can-i-read-a-json-file
json = jsondecode(fileread(filename));