def create_file_sets(input_struct):
    built_string = "# # # # # # # # # # # # # # # # # #\n"
    built_string += "# created in create_file_sets\n"
    built_string += "# # # # # # # # # # # # # # # # # #\n\n"
    built_string += "add_fileset QUARTUS_SYNTH QUARTUS_SYNTH \"\" \"\"\n"
    built_string += "set_fileset_property QUARTUS_SYNTH TOP_LEVEL " + input_struct.quartus_synth_top_level + "\n"
    built_string += ("set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS " +
                     str(input_struct.enable_rel_inc_paths).lower() + "\n")
    built_string += ("set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE " +
                     str(input_struct.enable_file_overwrite).lower() + "\n")
    built_string += ("add_fileset_file " + input_struct.vhdl_top_level_file.ljust(60) + " VHDL PATH hdl/" +
                     input_struct.vhdl_top_level_file + " TOP_LEVEL_FILE\n")
    for i in range(len(input_struct.additional_filesets)):
        built_string += ("add_fileset_file " + input_struct.additional_filesets[i].ljust(60, ' ') + " VHDL PATH " +
                     "hdl/" + input_struct.additional_filesets[i] + "\n")
    built_string += "# end create_file_sets\n\n\n"
    return built_string
