function gen_avalon_wrapper(infile, outfile, verbose, print_output)
    % make sure the current folder is on the python search path
    if count(py.sys.path,'') == 0
        insert(py.sys.path,int32(0),'');
    end

    py.vgen_avalon_wrapper.main(infile, outfile, verbose, print_output)
