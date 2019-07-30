def create_module(input_struct):
    built_string = "# # # # # # # # # # # # # # # # #\n"
    built_string += "# Created in create_module\n"
    built_string += "# # # # # # # # # # # # # # # # #\n\n"
    built_string += "set_module_property DESCRIPTION \"" + input_struct.description + "\"\n"
    built_string += "set_module_property NAME \"" + input_struct.name + "\"\n"
    built_string += "set_module_property VERSION " + input_struct.version + "\n"
    built_string += "set_module_property OPAQUE_ADDRESS_MAP " + str(input_struct.opaque_address_map).lower() + "\n"
    built_string += "set_module_property AUTHOR \"" + input_struct.author + "\"\n"
    built_string += "set_module_property DISPLAY_NAME \"" + input_struct.display_name + "\"\n"
    built_string += "set_module_property INSTANTIATE_IN_SYSTEM_MODULE " + str(input_struct.inst_in_sys_mod).lower() + "\n"
    built_string += "set_module_property EDITABLE " + str(input_struct.editable).lower() + "\n"
    built_string += "set_module_property REPORT_TO_TALKBACK " + str(input_struct.report_to_talkback).lower() + "\n"
    built_string += "set_module_property ALLOW_GREYBOX_GENERATION " + str(input_struct.allow_greybox_generation).lower() + "\n"
    built_string += "set_module_property VERSION " + input_struct.version + "\n"
    built_string += "set_module_property REPORT_HIERARCHY " + str(input_struct.report_hierarchy).lower() + "\n"
    for i in range(len(input_struct.additional_module_properties)):
        built_string += ("set_module_property " + input_struct.additional_module_properties[i][0] +
                         " " + input_struct.additional_module_properties[i][1] + "\n")
    built_string += "# end of create_module\n\n\n"
    return built_string
