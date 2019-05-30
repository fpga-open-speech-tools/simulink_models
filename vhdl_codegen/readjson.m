function json = readjson(filename)
%https://www.mathworks.com/matlabcentral/answers/326764-how-can-i-read-a-json-file
json = jsondecode(fileread(filename));