function gen_avalon_wrapper(infile, outfile, verbose, print_output)
% GEN_AVALON_WRAPPER generate an avalon vhdl wrapper from a json input file
%
% GEN_AVALON_WRAPPER(infile, outfile, verbose, print_output)
%
% infile: the json input filename
% outfile: the vhdl output filename
% verbose: verbose output
% print_output: print the output vhdl in the console

% TODO: add default values to input arguments

% make sure the current folder is on the python search path
if count(py.sys.path,'') == 0
    insert(py.sys.path,int32(0),'');
end

% call the python file that autogens the vhdl code
py.vgen_avalon_wrapper.main(infile, outfile, verbose, print_output)
