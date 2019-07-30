import json
import math
import re
from input_structure import InputStructure
def parse_json(inputFilename):
    with open(inputFilename, "r") as file:
        in_str = file.read()
        json_dict = json.loads(in_str)
        input_struct = InputStructure()
        input_struct.name = json_dict['model_name']
        input_struct.quartus_synth_top_level = json_dict['entity'] + "_avalon"
        input_struct.vhdl_top_level_file = json_dict['model_abbreviation'] + "_dataplane.vhd"
        input_struct.compatible_flag = "dev,fe-" + json_dict['linux_device_name']
        input_struct.group = json_dict['model_name']
        input_struct.vendor = "fe"
        input_struct.clock_rate = json_dict['clocks']['system_frequency_Hz']
        input_struct.clock_abbrev = "clk"
        input_struct.display_name = json_dict['model_name']

        if json_dict['avalon_memorymapped_flag'] == 1:
            input_struct.avalon_mm_slave_signal_name = 'mm_signal'
            input_struct.has_avalon_mm_slave_signal = True
            input_struct.data_bus_size = 32
            input_struct.address_bus_size = math.ceil(math.log(len(json_dict['avalon_memorymapped']['register'])))
        if json_dict['avalon_sink_flag'] == 1:
            input_struct.sink_signal_name = 'avalon_streaming_sink'
            input_struct.has_sink_signal = True
            for signal in json_dict['avalon_sink']['signal']:
                input_struct.sink_signal_port_names_and_widths[signal['name']] = datatype_to_bits(signal['data_type'])
                if 'channel' in signal['name']:
                    input_struct.sink_max_channel = int(math.pow(2, input_struct.sink_signal_port_names_and_widths[signal['name']]) - 1)
        if json_dict['avalon_source_flag'] == 1:
            input_struct.source_signal_name = 'avalon_streaming_source'
            input_struct.has_source_signal = True
            for signal in json_dict['avalon_source']['signal']:
                input_struct.source_signal_port_names_and_widths[signal['name']] = datatype_to_bits(signal['data_type'])
                if 'channel' in signal['name']:
                    input_struct.source_max_channel = int(math.pow(2, input_struct.source_signal_port_names_and_widths[signal['name']]) - 1)
    return input_struct



def datatype_to_bits(str_type):
    if str_type == 'boolean':
        return 1
    if str_type == 'ufix2':
        return 2
    match = re.match(r'.*(\d+)', str_type)
    if match:
        return int(match[1])
