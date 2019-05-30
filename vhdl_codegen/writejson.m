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
