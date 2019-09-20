# This is the hw.tcl file for 'acoustic_delay_buffer_adb'
# Generated by High Level Design Compiler for Intel(R) FPGAs

package require -exact qsys 14.1

# module acoustic_delay_buffer_adb
set_module_property NAME acoustic_delay_buffer_adb
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property GROUP "Altera DSP Builder Advanced"
set_module_property DISPLAY_NAME acoustic_delay_buffer_adb
set_module_property EDITABLE true

# filesets
add_fileset DSPBA_QUARTUS_SYNTH QUARTUS_SYNTH quartus_synth_callback
set_fileset_property DSPBA_QUARTUS_SYNTH TOP_LEVEL acoustic_delay_buffer_adb

proc quartus_synth_callback {entity_name} {
	add_fileset_file "dspba_library_package.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library_package.vhd"
	add_fileset_file "dspba_library.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library.vhd"
	add_fileset_file "acoustic_delay_buffer_adb.vhd" VHDL PATH "acoustic_delay_buffer_adb.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_AStInput.vhd" VHDL PATH "acoustic_delay_buffer_adb_AStInput.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_AStOutput.vhd" VHDL PATH "acoustic_delay_buffer_adb_AStOutput.vhd"
	add_fileset_file "busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05.vhd" VHDL PATH "busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_delay_buffer.vhd" VHDL PATH "acoustic_delay_buffer_adb_delay_buffer.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_delay_buffer_acoustic_delay_buffer_adb_delay_buffer_ciA0Zbuffer_DualMem_x.hex" HEX PATH "acoustic_delay_buffer_adb_delay_buffer_acoustic_delay_buffer_adb_delay_buffer_ciA0Zbuffer_DualMem_x.hex"
}
add_fileset DSPBA_SIM_VERILOG SIM_VERILOG sim_verilog_callback
set_fileset_property DSPBA_SIM_VERILOG TOP_LEVEL acoustic_delay_buffer_adb

proc sim_verilog_callback {entity_name} {
	add_fileset_file "dspba_library_package.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library_package.vhd"
	add_fileset_file "dspba_library.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library.vhd"
	add_fileset_file "acoustic_delay_buffer_adb.vhd" VHDL PATH "acoustic_delay_buffer_adb.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_AStInput.vhd" VHDL PATH "acoustic_delay_buffer_adb_AStInput.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_AStOutput.vhd" VHDL PATH "acoustic_delay_buffer_adb_AStOutput.vhd"
	add_fileset_file "busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05.vhd" VHDL PATH "busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_delay_buffer.vhd" VHDL PATH "acoustic_delay_buffer_adb_delay_buffer.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_delay_buffer_acoustic_delay_buffer_adb_delay_buffer_ciA0Zbuffer_DualMem_x.hex" HEX PATH "acoustic_delay_buffer_adb_delay_buffer_acoustic_delay_buffer_adb_delay_buffer_ciA0Zbuffer_DualMem_x.hex"
}
add_fileset DSPBA_SIM_VHDL SIM_VHDL sim_vhdl_callback
set_fileset_property DSPBA_SIM_VHDL TOP_LEVEL acoustic_delay_buffer_adb

proc sim_vhdl_callback {entity_name} {
	add_fileset_file "dspba_library_package.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library_package.vhd"
	add_fileset_file "dspba_library.vhd" VHDL PATH "$::env(QUARTUS_ROOTDIR)/dspba/Libraries/vhdl/base/dspba_library.vhd"
	add_fileset_file "acoustic_delay_buffer_adb.vhd" VHDL PATH "acoustic_delay_buffer_adb.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_AStInput.vhd" VHDL PATH "acoustic_delay_buffer_adb_AStInput.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_AStOutput.vhd" VHDL PATH "acoustic_delay_buffer_adb_AStOutput.vhd"
	add_fileset_file "busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05.vhd" VHDL PATH "busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_delay_buffer.vhd" VHDL PATH "acoustic_delay_buffer_adb_delay_buffer.vhd"
	add_fileset_file "acoustic_delay_buffer_adb_delay_buffer_acoustic_delay_buffer_adb_delay_buffer_ciA0Zbuffer_DualMem_x.hex" HEX PATH "acoustic_delay_buffer_adb_delay_buffer_acoustic_delay_buffer_adb_delay_buffer_ciA0Zbuffer_DualMem_x.hex"
}

# interfaces
# Interface clock
add_interface clock clock end
set_interface_property clock ENABLED true
add_interface_port clock clk clk Input 1
add_interface_port clock areset reset Input 1

# Interface bus_reset
add_interface bus_reset reset end
set_interface_property bus_reset ENABLED true
set_interface_property bus_reset ASSOCIATED_CLOCK clock
add_interface_port bus_reset h_areset reset Input 1

# Interface bus
add_interface bus avalon slave
set_interface_property bus maximumPendingReadTransactions 1
set_interface_property bus setupTime 0
set_interface_property bus ASSOCIATED_CLOCK clock
set_interface_property bus ENABLED true
add_interface_port bus busIn_address address Input 1
set_port_property busIn_address VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port bus busIn_read read Input 1
set_port_property busIn_read VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port bus busIn_write write Input 1
set_port_property busIn_write VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port bus busIn_writedata writedata Input 32
add_interface_port bus busOut_readdata readdata Output 32
add_interface_port bus busOut_readdatavalid readdatavalid Output 1
set_port_property busOut_readdatavalid VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port bus busOut_waitrequest waitrequest Output 1
set_port_property busOut_waitrequest VHDL_TYPE STD_LOGIC_VECTOR

# Interface "AStInput"
add_interface "AStInput" avalon_streaming sink
set_interface_property "AStInput" errorDescriptor ""
set_interface_property "AStInput" maxChannel 255
set_interface_property "AStInput" readyLatency 0
set_interface_property "AStInput" ASSOCIATED_CLOCK clock
set_interface_property "AStInput" ENABLED true
set_interface_property "AStInput" dataBitsPerSymbol 8
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
set_interface_property "AStOutput" dataBitsPerSymbol 8
add_interface_port "AStOutput" dout data Output 32
add_interface_port "AStOutput" vout valid Output 1
set_port_property vout VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port "AStOutput" cout channel Output 8
