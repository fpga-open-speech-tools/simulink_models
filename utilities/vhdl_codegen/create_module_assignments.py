def create_module_assignments(input_structs):
    built_string = "# # # # # # # # # # # # # # # # # #\n"
    built_string += "# Created in create_module_assignments\n"
    built_string += "# # # # # # # # # # # # # # # # # # # #\n\n"
    built_string += "set_module_assignment embeddedsw.dts.compatible " + input_structs.compatible_flag + "\n"
    built_string += "set_module_assignment embeddedsw.dts.group " + input_structs.group + "\n"
    built_string += "set_module_assignment embeddedsw.dts.vendor " + input_structs.vendor + "\n"
    built_string += "# End create_module_assignments\n\n\n"
    return built_string
