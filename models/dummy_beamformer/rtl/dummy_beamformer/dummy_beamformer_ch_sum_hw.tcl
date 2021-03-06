# This is the hw.tcl file for 'dummy_beamformer_ch_sum'
# Generated by High Level Design Compiler for Intel(R) FPGAs

package require -exact qsys 14.1

# module dummy_beamformer_ch_sum
set_module_property NAME dummy_beamformer_ch_sum
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property GROUP "Altera DSP Builder Advanced"
set_module_property DISPLAY_NAME dummy_beamformer_ch_sum
set_module_property EDITABLE false

# filesets
add_fileset DSPBA_QUARTUS_SYNTH QUARTUS_SYNTH quartus_synth_callback
set_fileset_property DSPBA_QUARTUS_SYNTH TOP_LEVEL dummy_beamformer_ch_sum

proc quartus_synth_callback {entity_name} {
	add_fileset_file "dspba_library_package.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library_package.vhd"
	add_fileset_file "dspba_library.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library.vhd"
	add_fileset_file "dummy_beamformer_ch_sum.vhd" VHDL PATH "dummy_beamformer_ch_sum.vhd"
	add_fileset_file "dummy_beamformer_ch_sum_AStInput.vhd" VHDL PATH "dummy_beamformer_ch_sum_AStInput.vhd"
	add_fileset_file "dummy_beamformer_ch_sum_AStOutput.vhd" VHDL PATH "dummy_beamformer_ch_sum_AStOutput.vhd"
	add_fileset_file "dummy_beamformer_ch_sum_ch_sum.vhd" VHDL PATH "dummy_beamformer_ch_sum_ch_sum.vhd"
}
add_fileset DSPBA_SIM_VERILOG SIM_VERILOG sim_verilog_callback
set_fileset_property DSPBA_SIM_VERILOG TOP_LEVEL dummy_beamformer_ch_sum

proc sim_verilog_callback {entity_name} {
	add_fileset_file "dspba_library_package.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library_package.vhd"
	add_fileset_file "dspba_library.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library.vhd"
	add_fileset_file "dummy_beamformer_ch_sum.vhd" VHDL PATH "dummy_beamformer_ch_sum.vhd"
	add_fileset_file "dummy_beamformer_ch_sum_AStInput.vhd" VHDL PATH "dummy_beamformer_ch_sum_AStInput.vhd"
	add_fileset_file "dummy_beamformer_ch_sum_AStOutput.vhd" VHDL PATH "dummy_beamformer_ch_sum_AStOutput.vhd"
	add_fileset_file "dummy_beamformer_ch_sum_ch_sum.vhd" VHDL PATH "dummy_beamformer_ch_sum_ch_sum.vhd"
}
add_fileset DSPBA_SIM_VHDL SIM_VHDL sim_vhdl_callback
set_fileset_property DSPBA_SIM_VHDL TOP_LEVEL dummy_beamformer_ch_sum

proc sim_vhdl_callback {entity_name} {
	add_fileset_file "dspba_library_package.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library_package.vhd"
	add_fileset_file "dspba_library.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library.vhd"
	add_fileset_file "dummy_beamformer_ch_sum.vhd" VHDL PATH "dummy_beamformer_ch_sum.vhd"
	add_fileset_file "dummy_beamformer_ch_sum_AStInput.vhd" VHDL PATH "dummy_beamformer_ch_sum_AStInput.vhd"
	add_fileset_file "dummy_beamformer_ch_sum_AStOutput.vhd" VHDL PATH "dummy_beamformer_ch_sum_AStOutput.vhd"
	add_fileset_file "dummy_beamformer_ch_sum_ch_sum.vhd" VHDL PATH "dummy_beamformer_ch_sum_ch_sum.vhd"
}

# interfaces
# Interface clock
add_interface clock clock end
set_interface_property clock ENABLED true
add_interface_port clock clk clk Input 1
add_interface_port clock areset reset Input 1

# Interface "AStInput"
add_interface "AStInput" avalon_streaming sink
set_interface_property "AStInput" errorDescriptor ""
set_interface_property "AStInput" maxChannel 255
set_interface_property "AStInput" readyLatency 0
set_interface_property "AStInput" ASSOCIATED_CLOCK clock
set_interface_property "AStInput" ENABLED true
set_interface_property "AStInput" dataBitsPerSymbol 32
add_interface_port "AStInput" d data Input 32
add_interface_port "AStInput" v valid Input 1
set_port_property v VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port "AStInput" c channel Input 8


# Interface "AStOutput"
add_interface "AStOutput" avalon_streaming source
set_interface_property "AStOutput" errorDescriptor ""
set_interface_property "AStOutput" maxChannel 255
set_interface_property "AStOutput" readyLatency 0
set_interface_property "AStOutput" ASSOCIATED_CLOCK clock
set_interface_property "AStOutput" ENABLED true
set_interface_property "AStOutput" dataBitsPerSymbol 32 
add_interface_port "AStOutput" dout data Output 32
add_interface_port "AStOutput" vout valid Output 1
set_port_property vout VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port "AStOutput" cout channel Output 8
