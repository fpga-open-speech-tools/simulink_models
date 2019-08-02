class InputStructure:
    def __init__(self):
        self.description = ""
        self.name = "Fill me in"
        self.version = "1.0"
        self.internal = False
        self.opaque_address_map = True
        self.author = ""
        self.display_name = "Fill me in"
        self.model_abbreviation = "Fill me in"
        self.inst_in_sys_mod = True
        self.editable = True
        self.report_to_talkback = False
        self.allow_greybox_generation = False
        self.report_hierarchy = False
        self.additional_module_properties = []

        self.quartus_synth_top_level = "Fill me in"
        self.enable_rel_inc_paths = False
        self.enable_file_overwrite = False
        self.vhdl_top_level_file = "Fill me in"
        self.additional_filesets = []

        self.parameters = []

        self.compatible_flag = "Fill me in"
        self.group = "Fill me in"
        self.vendor = "fe"

        self.clock_rate = 0
        self.clock_abbrev = "clk"

        self.has_avalon_mm_slave_signal = True
        self.avalon_mm_slave_signal_name = "Fill me in (or not)"
        self.data_bus_size = 32
        self.address_bus_size = 0

        self.has_sink_signal = True
        self.sink_signal_name = "Fill me in (or not)"
        self.sink_signal_port_names_and_widths = {} #{"channel": 2, "data": 32, "error": 3, "valid": 1}
        self.sink_max_channel = 0

        self.has_source_signal = True
        self.source_signal_name = "Fill me in (or not)"
        self.source_signal_port_names_and_widths = {} #{"channel": 2, "data": 32, "error": 3, "valid": 1}
        self.source_max_channel = 0
