#!/usr/bin/python

import json
import argparse
import re
from textwrap import dedent
from math import ceil, log

# TODO: add comment header to this file
# TODO: make generated VHDL match the coding style guideline
# TODO: error checking

indent = '  '

def create_library():
    LIBRARIES=dedent("""\
        library ieee;
        use ieee.std_logic_1164.all;
        use ieee.numeric_std.all;\n
        """)
    return LIBRARIES

def create_entity(name, sink_enabled, sink, source_enabled, source,
    registers_enabled, registers, conduit_out_enabled, conduit_out,
    conduit_in_enabled, conduit_in):

    global indent

    ENTITY_BEGIN=dedent("""\
        entity {}_avalon is
          port (
          """.format(name))
    ENTITY_END=dedent("""\
          );
        end entity {}_avalon;\n
        """.format(name))

    entity = ENTITY_BEGIN

    entity += indent*2 + "clk : in std_logic;\n"
    entity += indent*2 + "reset : in std_logic;\n"

    # avalon streaming sink
    if sink_enabled:
        for signal in sink:
            datatype = convert_data_type(signal['data_type'])
            entity += indent*2 + signal['name'] + " : in " + datatype + "; --" +\
                signal['data_type'] + '\n'


    # avalon streaming source
    if source_enabled:
        for signal in source:
            datatype = convert_data_type(signal['data_type'])
            entity += indent*2 + signal['name'] + " : out " + datatype + "; --" +\
                signal['data_type'] + '\n'

    # avalon memorymapped bus
    if registers_enabled:
        entity += indent*2 + "s1_address : in std_logic_vector({} downto 0);\
            \n".format(int(ceil(log(len(registers),2)) - 1))

        entity += indent*2 + "s1_read : in std_logic;\n"
        entity += indent*2 + "s1_readdata : out std_logic_vector(31 downto 0);\n"

        entity += indent*2 + "s1_write : in std_logic;\n"
        entity += indent*2 + "s1_writedata : in std_logic_vector(31 downto 0);\n"

    # input conduit signals
    if conduit_in_enabled:
        for signal in conduit_in:
            name = re.search('Export_(.*)', signal['name']).group(1)
            datatype = convert_data_type(signal['data_type'])

            entity += indent*2 + name + " : in " + datatype + "; --" + \
                signal['data_type'] + '\n'

    # output conduit signals
    if conduit_out_enabled:
        for signal in conduit_out:
            name = re.search('Export_(.*)', signal['name']).group(1)
            datatype = convert_data_type(signal['data_type'])

            entity += indent*2 + name + " : out " + datatype + "; --" + \
                signal['data_type'] + '\n'

    # remove the semicolon from the last entity port definition
    semicolon_idx = entity.rfind(';')
    entity = entity[:semicolon_idx] + entity[semicolon_idx+1:]

    entity += ENTITY_END

    return entity

# TODO: add support for instantiating the entity being wrapped by this avalon code
def create_architecture(name, registers_enabled, registers, register_defaults,
    component_declaration, component_instantiation):
    global indent

    ARCH_BEGIN = "architecture {}_avalon_arch of {}_avalon is\n\n".format(name, name)
    ARCH_END = "end architecture;"

    architecture = ARCH_BEGIN

    if registers_enabled:
        # sort registers according to register number
        registers = sorted(registers, key=lambda k: k['reg_num'])

        # remove Register_Control from register names
        for register in registers:
            register['name'] = re.search('Register_Control_(.*)',
                register['name']).group(1)

        # declare register signals
        # NOTE: this block will be refactored later when the format of the
        # matlab struct gets updated to be more conducive.
        # for register in registers:
            # architecture += indent + "signal " + register['name'] + \
            #  " : std_logic_vector(31 downto 0)"
            # if 'default_value' in register:
            #     default = convert_default_value(register['default_value'])
            #     architecture += " := " + default + "; --" + \
            #         register['data_type'] + "\n"
            # else:
            #     architecture += ";\n"
        for register in register_defaults:
            architecture += indent + "signal " + register.replace('<=',
                ': std_logic_vector(31 downto 0) :=') + "\n"


    architecture += "\n"
    architecture += create_component_declaration(component_declaration)

    # begin architecture
    architecture += "\nbegin\n\n"

    architecture += create_component_instantiation(component_instantiation)

    if registers_enabled:
        addr_width = int(ceil(log(len(registers),2)))

        # create read process
        architecture += indent + "bus_read : process(clk)\n" + indent + "begin\n"
        architecture += indent*2 + "if rising_edge(clk) and s1_read = '1' then\n"
        architecture += indent*3 + "case s1_address is\n"

        for addr, register in enumerate(registers):
            architecture += indent*4 + \
                "when \"{0:0{1}b}\" => s1_readdata <= {2};\n".format(addr,\
                addr_width, register['name'])

        architecture += indent*4 + "when others => s1_readdata <= (others => '0');\n"
        architecture += indent*3 + "end case;\n" + indent*2 + "end if;\n" + \
            indent + "end process;\n\n"

        # create write process
        architecture += indent + "bus_write : process(clk, reset)\n" + indent + "begin\n"
        architecture += indent*2 + "if reset = '1' then\n"

        # reset registers to default values on reset
        # NOTE: this code block can be refactored and used later once the
        # matlab struct is more conducive
        # for register in registers:
        #     architecture += indent*3 + register['name'] + " <= "
        #     if 'default_value' in register:
        #         default = convert_default_value(register['default_value'])
        #         architecture += default + ";\n"
        for register in register_defaults:
            architecture += indent*3 + register + "\n"

        architecture += indent*2 + "elsif rising_edge(clk) and " + \
            "s1_write = '1' then\n"
        architecture += indent*3 + "case s1_address is\n"

        for addr, register in enumerate(registers):
            architecture += indent*4 + \
                "when \"{0:0{1}b}\" => {2} <= ".format(addr, addr_width,\
                register['name']) + "s1_writedata;\n"

        architecture += indent*4 + "when others => null;\n"
        architecture += indent*3 + "end case;\n" + indent*2 + "end if;\n" + \
            indent + "end process;\n\n"

    architecture += ARCH_END

    return architecture

def create_component_declaration(component_declaration):
    # NOTE: this might be expanded if I generate the VHDL in this script
    # instead of generating it from matlab like is currently being done;
    # thus I'm creating this function for future use
    global indent
    vhdl = ''
    for line in component_declaration:
        vhdl += indent + line + "\n"
    return vhdl

def create_component_instantiation(component_instantiation):
    # NOTE: this might be expanded if I generate the VHDL in this script
    # instead of generating it from matlab like is currently being done;
    # thus I'm creating this function for future use
    global indent
    vhdl = ''
    for line in component_instantiation:
        vhdl += indent + line + "\n"
    return vhdl

def convert_data_type(intype):
    # TODO: add support for more data types (e.g. integer, signed, unsigned)?
    if intype in {'boolean', 'ufix1'}:
        outtype = 'std_logic'
    else:
        match = re.search('\d+', intype)
        if match:
            width = int(match.group())
            outtype = 'std_logic_vector({} downto 0)'.format(width-1)
        else:
            # TODO: error handling
            pass

    return outtype


def convert_default_value(value):
    if isinstance(value, int):
        default_value = "std_logic_vector(to_unsigned({}, 32))".format(value)
    elif isinstance(value, str):
        # hex string
        if value[0] == 'x':
            default_value = "x\"{}\"".format(value[1:])
        # binary string
        elif value[0] == 'b':
            default_value = "\"{}\"".format(value[1:])

    return default_value


def parseargs():
    parser = argparse.ArgumentParser(description=\
        "Generate VHDL code for Avalon streaming and memory-mapped interfaces.")
    parser.add_argument('infile',
        help="json file containing the interface and register specifications")
    parser.add_argument('-v', '--verbose', action='store_true',
        help="verbose output")
    parser.add_argument('-p', '--print', action='store_true', dest='print_output',
        help="print out the generated vhdl code")
    parser.add_argument('outfile', help="the name of the output vhdl file")
    args = parser.parse_args()
    return (args.infile, args.outfile, args.verbose, args.print_output)


# TODO: make a default filename?
def main(infile, outfile, verbose, print_output):
    with open(infile) as f:
        avalon = json.load(f)

    name = avalon['entity']
    sink_enabled = avalon['avalon_sink_flag']
    sink = avalon['avalon_sink']['signal'] if sink_enabled else None
    source_enabled = avalon['avalon_source_flag']
    source = avalon['avalon_source']['signal'] if source_enabled else None
    registers_enabled = avalon['avalon_memorymapped_flag']
    registers = avalon['avalon_memorymapped']['register'] if registers_enabled else None
    conduit_in_enabled = avalon['conduit_input_flag']
    conduit_in = avalon['conduit_input']['signal'] if conduit_in_enabled else None
    conduit_out_enabled = avalon['conduit_output_flag']
    conduit_out = avalon['conduit_output']['signal'] if conduit_out_enabled else None
    register_defaults = avalon['vhdl']['register_defaults']
    component_declaration = avalon['vhdl']['component_declaration']
    component_instantiation = avalon['vhdl']['component_instantiation']

    vhdl_out = create_library()
    vhdl_out += create_entity(name, sink_enabled, sink, source_enabled, source,
        registers_enabled, registers, conduit_out_enabled, conduit_out,
        conduit_in_enabled, conduit_in)
    vhdl_out += create_architecture(name, registers_enabled, registers,
        register_defaults, component_declaration, component_instantiation)

    if print_output:
        print(vhdl_out)

    with open(outfile, 'w') as f:
        f.write(vhdl_out)

if __name__ == '__main__':
    (infile, outfile, verbose, print_output) = parseargs()
    main(infile, outfile, verbose, print_output)
