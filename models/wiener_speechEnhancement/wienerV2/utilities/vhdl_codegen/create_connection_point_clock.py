def create_connection_point_clock(input_struct):
    built_string = "# # # # # # # # # # # # # # # # # # # # # #\n"
    built_string += "# Created by create_connection_point_clock\n"
    built_string += "# # # # # # # # # # # # # # # # # # # # # #\n\n"
    built_string += "add_interface clock clock end\n"
    built_string += "set_interface_property clock clockRate " + str(input_struct.clock_rate) + "\n"
    built_string += "set_interface_property clock ENABLED true\n"
    built_string += "set_interface_property clock EXPORT_OF \"\"\n"
    built_string += "set_interface_property clock PORT_NAME_MAP \"\"\n"
    built_string += "set_interface_property clock CMSIS_SVD_VARIABLES \"\"\n"
    built_string += "set_interface_property clock SVD_ADDRESS_GROUP \"\"\n"
    built_string += "add_interface_port clock " + input_struct.clock_abbrev + " " + input_struct.clock_abbrev + " Input 1\n"
    built_string += "# End create_connection_point_clock\n\n\n"
    return built_string
