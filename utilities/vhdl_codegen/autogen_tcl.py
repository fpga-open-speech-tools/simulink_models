from create_connection_point_clock import create_connection_point_clock
from create_connection_point_reset import create_connection_point_reset
from create_file_sets import create_file_sets
from create_module import create_module
from create_module_assignments import create_module_assignments
from create_header_file_stuff import create_header_file_stuff
from create_mm_connection_point import create_mm_connection_point
from create_sink_connection_point import create_sink_connection_point
from create_source_connection_point import  create_source_connection_point
from input_structure import InputStructure
from parse_json import parse_json
def main(inputFilename, outputFilename):
    input_struct = parse_json(inputFilename)
    write_tcl(input_struct, outputFilename)

def write_tcl(input_struct, outputFilename):
    with open(outputFilename, "w") as out_file:
        out_file.write(create_header_file_stuff(input_struct))
        out_file.write(create_module(input_struct))
        out_file.write(create_file_sets(input_struct))
        out_file.write(create_module_assignments(input_struct))
        out_file.write(create_connection_point_clock(input_struct))
        out_file.write(create_connection_point_reset(input_struct))
        out_file.write(create_mm_connection_point(input_struct))
        out_file.write(create_sink_connection_point(input_struct))
        out_file.write(create_source_connection_point(input_struct))
