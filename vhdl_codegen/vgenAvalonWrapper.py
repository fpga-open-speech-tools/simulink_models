#!/usr/bin/python

# @file vgenAvalonWrapper.py
#
#     Python function to auto generate vhdl code given json generated from a corresponding matlab func.
#
#     @author Trevor Vannoy, Aaron Koenigsberg
#     @date 2019
#     @copyright 2019 Flat Earth Inc
#
#     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#     INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#     PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
#     FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
#     ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#     Trevor Vannoy
#     Flat Earth Inc
#     985 Technology Blvd
#     Bozeman, MT 59718
#     support@flatearthinc.com

import json
import argparse
import re
from textwrap import dedent
from math import ceil, log

# TODO: add comment header to this file                       (done, may be worth expanding)
# TODO: make generated VHDL match the coding style guideline  (done?)
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

    entity += indent*2 + "clk".ljust(26, ' ') + ": in  std_logic;\n"
    entity += indent*2 + "reset".ljust(26, ' ') + ": in  std_logic;\n"

    # avalon streaming sink
    if sink_enabled:
        for signal in sink:
            datatype = convert_data_type(signal['data_type'])
            entity += indent*2 + (signal['name']).ljust(26, ' ') + ": in  " + datatype + "; --" +\
                signal['data_type'] + '\n'


    # avalon streaming source
    if source_enabled:
        for signal in source:
            datatype = convert_data_type(signal['data_type'])
            entity += indent*2 + signal['name'].ljust(26, ' ') + ": out " + datatype + "; --" +\
                signal['data_type'] + '\n'

    # avalon memorymapped bus
    if registers_enabled:
        entity += indent*2 + "s1_address".ljust(26, ' ') + ": in  std_logic_vector({} downto 0);\
            \n".format(str(int(ceil(log(len(registers),2)) - 1)).ljust(3, ' '))

        entity += indent*2 + "s1_read".ljust(26, ' ') + ": in  std_logic;\n"
        entity += indent*2 + "s1_readdata".ljust(26, ' ') + ": out std_logic_vector(31  downto 0);\n"

        entity += indent*2 + "s1_write".ljust(26, ' ') + ": in  std_logic;\n"
        entity += indent*2 + "s1_writedata".ljust(26, ' ') +": in  std_logic_vector(31  downto 0);\n"

    # input conduit signals
    if conduit_in_enabled:
        for signal in conduit_in:
            name = re.search('Export_(.*)', signal['name']).group(1)
            datatype = convert_data_type(signal['data_type'])

            entity += indent*2 + name.ljust(30, ' ') + ": in " + datatype + "; --" + \
                signal['data_type'] + '\n'

    # output conduit signals
    if conduit_out_enabled:
        for signal in conduit_out:
            name = re.search('Export_(.*)', signal['name']).group(1)
            datatype = convert_data_type(signal['data_type'])

            entity += indent*2 + name.ljust(26, ' ') + ": out " + datatype + "; --" + \
                signal['data_type'] + '\n'

    # remove the semicolon from the last entity port definition
    semicolon_idx = entity.rfind(';')
    entity = entity[:semicolon_idx] + entity[semicolon_idx+1:]

    entity += ENTITY_END

    return entity

# TODO: add support for instantiating the entity being wrapped by this avalon code
def create_architecture(name, registers_enabled, registers, register_defaults,
    component_declaration, component_instantiation, clock,
    sink_flag, sink_signal, mm_flag, mm_signal, ci_flag, ci_signal, source_flag, source_signal, co_flag, co_signal):
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
        #architecture += create_component_reg_defaults(mm_flag=mm_flag, mm_signal=mm_signal)
        register_defaults = create_component_reg_defaults(mm_flag, mm_signal)
        for register in register_defaults:
            architecture += indent + "signal " + register.replace('<=',
                ': std_logic_vector(31  downto 0) :=') + "\n"


    architecture += "\n"
    architecture += create_component_declaration2(clock=clock, entity=name, sink_flag=sink_flag, sink_signal=sink_signal,
                            mm_flag=mm_flag, mm_signal=mm_signal, ci_flag=ci_flag, ci_signal=ci_signal,
                            source_flag=source_flag, source_signal=source_signal, co_flag=co_flag, co_signal=co_signal)

    # begin architecture
    architecture += "\nbegin\n\n"

    architecture += create_component_instantiation2(ts_system=clock, entity=name, sink_flag=sink_flag, sink_signal=sink_signal,
                            mm_flag=mm_flag, mm_signal=mm_signal, ci_flag=ci_flag, ci_signal=ci_signal,
                            source_flag=source_flag, source_signal=source_signal, co_flag=co_flag, co_signal=co_signal)

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
        #architecture += create_component_reg_defaults(mm_flag=mm_flag, mm_signal=mm_signal)
        for reg in register_defaults:
            architecture += indent * 3 + reg + "\n"

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

def convert_data_type(intype):
    # TODO: add support for more data types (e.g. integer, signed, unsigned)?
    if intype in {'boolean', 'ufix1'}:
        outtype = 'std_logic'
    else:
        match = re.search('\d+', intype)
        if match:
            width = int(match.group())
            outtype = 'std_logic_vector({} downto 0)'.format(str(width-1).ljust(3, ' '))
        else:
            # TODO: error handling
            pass

    return outtype

def int_to_bitstring(integer, tot_bits, frac_bits):
    if not (isinstance(integer, int) or integer.is_integer()):
        print("Default value must be an integer. Must manually modify vhdl")
    bit_string = bin(integer)[2:]
    bit_string += ("0" * frac_bits)
    bit_string = bit_string.rjust(tot_bits, "0")
    return bit_string


def create_component_declaration2(clock, entity, sink_flag, sink_signal, mm_flag, mm_signal, ci_flag, ci_signal, source_flag, source_signal, co_flag, co_signal):
    global indent
    decl = "ComPoNeNt " + entity + "_src_" + entity + "\n"
    decl += indent * 1 + "port(\n"
    decl += indent * 2 + "clk".ljust(26, ' ') + ": in  std_logic; -- clk_freq = " + str(clock['frequency']) + " Hz, period = " + str(clock['period']) + "\n"
    decl += indent * 2 + "clk_enable".ljust(26, ' ') + ": in  std_logic;\n"
    decl += indent * 2 + "reset".ljust(26, ' ') + ": in  std_logic;\n"
    if sink_flag == 1:
        for i in range(len(sink_signal)):
            name = sink_signal[i]["name"]
            data_type = sink_signal[i]["data_type"]
            decl += (indent * 2 + name).ljust(30, ' ') + (": in  " + convert_data_type(data_type) + ";").ljust(45, ' ') + " -- " + data_type + "\n"
    if mm_flag == 1:
        for i in range(len(mm_signal)):
            name = mm_signal[i]["name"]
            data_type = mm_signal[i]["data_type"]
            decl += (indent * 2 + name).ljust(30, ' ') + (": in  " + convert_data_type(data_type) + ";").ljust(45, ' ') + " -- " + data_type + "\n"
    if ci_flag == 1:
        for i in range(len(ci_signal)):
            name = ci_signal[i]["name"]
            data_type = ci_signal[i]["data_type"]
            decl += (indent * 2 + name).ljust(30, ' ') + (": in  " + convert_data_type(data_type) + ";").ljust(45, ' ') + " -- " + data_type + "\n"
    decl += (indent * 2 + "ce_out").ljust(30, ' ') + ": out std_logic;\n"
    if source_flag == 1:
        for i in range(len(source_signal)):
            name = source_signal[i]["name"]
            data_type = source_signal[i]["data_type"]
            decl += (indent * 2 + name).ljust(30, ' ') + (": out " + convert_data_type(data_type) + ";").ljust(45, ' ') + " -- " + data_type + "\n"
    if co_flag == 1:
        for i in range(len(co_signal)):
            name = co_signal[i]["name"]
            data_type = co_signal[i]["data_type"]
            decl += (indent * 2 + name).ljust(30, ' ') + (": out " + convert_data_type(data_type) + ";").ljust(45, ' ') + " -- " + data_type + "\n"
    last_semi_ind = decl.rfind(";")
    decl = decl[:last_semi_ind] + ' ' + decl[last_semi_ind + 1:]
    decl += indent * 1 + ");\n"
    return decl

def create_component_instantiation2(ts_system, entity, sink_flag, sink_signal, mm_flag, mm_signal, ci_flag, ci_signal, source_flag, source_signal, co_flag, co_signal):
    global indent
    inst = "u_" + entity + "_src_" + entity + " : " + entity + "_src_" + entity + "\n"
    inst += indent * 1 + "port map(\n"
    inst += (indent * 2 + "clk").ljust(30, ' ') + "=>  clk,\n"
    inst += (indent * 2 + "clk_enable").ljust(30, ' ') + "=>  '1',\n"
    inst += (indent * 2 + "reset").ljust(30, ' ') + "=>  reset,\n"
    if sink_flag == 1:
        for i in range(len(sink_signal)):
            name = sink_signal[i]["name"]
            data_type = sink_signal[i]["data_type"]
            inst += (indent * 2 + name).ljust(30, ' ') + "=>  " + (name + ",").ljust(30, ' ') + " -- " + data_type + "\n"
    if mm_flag == 1:
        for i in range(len(mm_signal)):
            name = mm_signal[i]["name"]
            name2 = name.replace("Register_Control_", "")
            data_type = sink_signal[i]["data_type"]
            inst += (indent * 2 + name).ljust(30, ' ') + "=>  " + (name2 + ",").ljust(30, ' ') + " -- " + data_type + "\n"
    if ci_flag == 1:
        for i in range(len(ci_signal)):
            name = ci_signal[i]["name"]
            name2 = name.replace("Export_", "")
            data_type = sink_signal[i]["data_type"]
            inst += (indent * 2 + name).ljust(30, ' ') + "=>  " + (name2 + ",").ljust(30, ' ') + " -- " + data_type + "\n"
    if source_flag == 1:
        for i in range(len(source_signal)):
            name = source_signal[i]["name"]
            data_type = sink_signal[i]["data_type"]
            inst += (indent * 2 + name).ljust(30, ' ') + "=>  " + (name + ",").ljust(30, ' ') + " -- " + data_type + "\n"
    if co_flag == 1:
        for i in range(len(co_signal)):
            name = co_signal[i]["name"]
            name2 = name.replace("Export_", "")
            data_type = sink_signal[i]["data_type"]
            inst += (indent * 2 + name).ljust(30, ' ') + "=>  " + (name2 + ",").ljust(30, ' ') + " -- " + data_type + "\n"
    last_comma_ind = inst.rfind(',')
    inst = inst[:last_comma_ind] + ' ' + inst[last_comma_ind + 1:]
    inst += indent * 1 + ");\n"
    return inst


def create_component_reg_defaults(mm_flag, mm_signal):
    global indent
    reg_defs = []
    if mm_flag == 1:
        for i in range(len(mm_signal)):
            name = mm_signal[i]["name"]
            name2 = name.replace("Register_Control_", "")
            def_val = mm_signal[i]["default_value"]
            # todo: generalize this to work for more than just int to fp32_16 type
            if i == 0 or i == 1:
                bitstring = int_to_bitstring(def_val, 32, 16)
            else:
                bitstring = int_to_bitstring(def_val, 32, 0)
            if i == 0:
                reg_defs.append(name2.ljust(24, ' ') + "  <=  \"" + bitstring + "\";")
            else:
                reg_defs.append(name2.ljust(24, ' ') + "  <=  \"" + bitstring + "\";")
    return reg_defs


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
    register_defaults = None#avalon['vhdl']['register_defaults']
    component_declaration = None#avalon['vhdl']['component_declaration']
    component_instantiation = None#avalon['vhdl']['component_instantiation']
    clock = {'frequency': 1, 'period': .1}#avalon['clock']


    vhdl_out = create_library()
    vhdl_out += create_entity(name=name, sink_enabled=sink_enabled, sink=sink, source_enabled=source_enabled, source=source,
        registers_enabled=registers_enabled, registers=registers, conduit_out_enabled=conduit_out_enabled,
        conduit_out=conduit_out, conduit_in_enabled=conduit_in_enabled, conduit_in=conduit_in)
    vhdl_out += create_architecture(name, registers_enabled, registers,
        register_defaults, component_declaration, component_instantiation, clock=clock, sink_flag=sink_enabled, sink_signal=sink,
        source_flag=source_enabled, source_signal=source, mm_flag=registers_enabled, mm_signal=registers,
        co_flag=conduit_out_enabled, co_signal=conduit_out, ci_flag=conduit_in_enabled,
        ci_signal=conduit_in)

    if print_output:
        print(vhdl_out)

    with open(outfile, 'w') as f:
        f.write(vhdl_out)

if __name__ == '__main__':
    (infile, outfile, verbose, print_output) = parseargs()
    main(infile, outfile, verbose, print_output)
