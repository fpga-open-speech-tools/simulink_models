# # # # # # # # # # # # # # # # # #
# Built in create_header_file_stuff
# # # # # # # # # # # # # # # # # #

package require -exact qsys 16.1
# End create_header_file_stuff


# # # # # # # # # # # # # # # # #
# Created in create_module
# # # # # # # # # # # # # # # # #

set_module_property DESCRIPTION ""
set_module_property NAME "simple_gain"
set_module_property VERSION 1.0
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "simple_gain"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property VERSION 1.0
set_module_property REPORT_HIERARCHY false
# end of create_module


# # # # # # # # # # # # # # # # # #
# created in create_file_sets
# # # # # # # # # # # # # # # # # #

add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL SG_DataPlane_avalon
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file SG_dataplane_avalon.vhd                                      VHDL PATH hdl/SG_dataplane_avalon.vhd TOP_LEVEL_FILE
#add_fileset_file SG_DataPlane.vhd                                             VHDL PATH hdl/SG_DataPlane.vhd
add_fileset_file SG_DataPlane_addr_decoder.vhd                                VHDL PATH hdl/SG_DataPlane_addr_decoder.vhd
add_fileset_file SG_DataPlane_dut.vhd                                         VHDL PATH hdl/SG_DataPlane_dut.vhd
add_fileset_file SG_DataPlane_rdfifo_data.vhd                                 VHDL PATH hdl/SG_DataPlane_rdfifo_data.vhd
add_fileset_file SG_DataPlane_rdfifo_data_classic.vhd                         VHDL PATH hdl/SG_DataPlane_rdfifo_data_classic.vhd
add_fileset_file SG_DataPlane_rdfifo_last.vhd                                 VHDL PATH hdl/SG_DataPlane_rdfifo_last.vhd
add_fileset_file SG_DataPlane_rdfifo_last_classic.vhd                         VHDL PATH hdl/SG_DataPlane_rdfifo_last_classic.vhd
add_fileset_file SG_DataPlane_rdfifo_rid.vhd                                  VHDL PATH hdl/SG_DataPlane_rdfifo_rid.vhd
add_fileset_file SG_DataPlane_rdfifo_rid_classic.vhd                          VHDL PATH hdl/SG_DataPlane_rdfifo_rid_classic.vhd
add_fileset_file SG_DataPlane_reset_sync.vhd                                  VHDL PATH hdl/SG_DataPlane_reset_sync.vhd
add_fileset_file SG_DataPlane_SimpleDualPortRAM_generic.vhd                   VHDL PATH hdl/SG_DataPlane_SimpleDualPortRAM_generic.vhd
add_fileset_file SG_DataPlane_SimpleDualPortRAM_singlebit.vhd                 VHDL PATH hdl/SG_DataPlane_SimpleDualPortRAM_singlebit.vhd
add_fileset_file SG_DataPlane_src_Avalon_Data_Processing.vhd                  VHDL PATH hdl/SG_DataPlane_src_Avalon_Data_Processing.vhd
add_fileset_file SG_DataPlane_src_Left_Channel_Processing.vhd                 VHDL PATH hdl/SG_DataPlane_src_Left_Channel_Processing.vhd
add_fileset_file SG_DataPlane_src_Right_Channel_Processing.vhd                VHDL PATH hdl/SG_DataPlane_src_Right_Channel_Processing.vhd
add_fileset_file SG_DataPlane_src_SG_DataPlane.vhd                            VHDL PATH hdl/SG_DataPlane_src_SG_DataPlane.vhd
# end create_file_sets


# # # # # # # # # # # # # # # # # #
# Created in create_module_assignments
# # # # # # # # # # # # # # # # # # # #

set_module_assignment embeddedsw.dts.compatible dev,fe-simple_gain
set_module_assignment embeddedsw.dts.group simple_gain
set_module_assignment embeddedsw.dts.vendor fe
# End create_module_assignments


# # # # # # # # # # # # # # # # # # # # # #
# Created by create_connection_point_clock
# # # # # # # # # # # # # # # # # # # # # #

add_interface clock clock end
set_interface_property clock clockRate 98304000.0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""
add_interface_port clock clk clk Input 1
# End create_connection_point_clock


# # # # # # # # # # # # # # # # # # # # # #
# Created by create_connection_point_reset
# # # # # # # # # # # # # # # # # # # # # #

add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF true
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""
add_interface_port reset reset reset Input 1
# End create_connection_point_reset


# # # # # # # # # # # # # # # # # # # # #
# Created by create_mm_connection_point
# # # # # # # # # # # # # # # # # # # # #

add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock
set_interface_property avalon_slave associatedReset reset
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 0
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave setupTime 1
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave avalon_slave_address address Input 1
add_interface_port avalon_slave avalon_slave_read read Input 1
add_interface_port avalon_slave avalon_slave_readdata readdata Output 32
add_interface_port avalon_slave avalon_slave_write write Input 1
add_interface_port avalon_slave avalon_slave_writedata writedata Input 32
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0
# End create_mm_connection_point


# # # # # # # # # # # # # # # # # # # # # #
# Created by create_sink_connection_point
# # # # # # # # # # # # # # # # # # # # # #

add_interface avalon_streaming_sink avalon_streaming end
set_interface_property avalon_streaming_sink associatedClock clock
set_interface_property avalon_streaming_sink associatedReset reset
set_interface_property avalon_streaming_sink dataBitsPerSymbol 8
set_interface_property avalon_streaming_sink errorDescriptor ""
set_interface_property avalon_streaming_sink firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_sink maxChannel 3
set_interface_property avalon_streaming_sink readyLatency 0
set_interface_property avalon_streaming_sink ENABLED true
set_interface_property avalon_streaming_sink EXPORT_OF ""
set_interface_property avalon_streaming_sink PORT_NAME_MAP ""
set_interface_property avalon_streaming_sink CMSIS_SVD_VARIABLES ""
set_interface_property avalon_streaming_sink SVD_ADDRESS_GROUP ""
add_interface_port avalon_streaming_sink avalon_sink_valid valid Input 1
add_interface_port avalon_streaming_sink avalon_sink_data data Input 32
add_interface_port avalon_streaming_sink avalon_sink_channel channel Input 2
add_interface_port avalon_streaming_sink avalon_sink_error error Input 2
# End create_sink_connection_point


# # # # # # # # # # # # # # # # # # # # # # #
# Created in create_source_connection_point
# # # # # # # # # # # # # # # # # # # # # # #

add_interface avalon_streaming_source avalon_streaming start
set_interface_property avalon_streaming_source associatedClock clock
set_interface_property avalon_streaming_source associatedReset reset
set_interface_property avalon_streaming_source dataBitsPerSymbol 8
set_interface_property avalon_streaming_source errorDescriptor ""
set_interface_property avalon_streaming_source firstSymbolInHighOrderBits true
set_interface_property avalon_streaming_source maxChannel 3
set_interface_property avalon_streaming_source readyLatency 0
set_interface_property avalon_streaming_source ENABLED true
set_interface_property avalon_streaming_source EXPORT_OF ""
set_interface_property avalon_streaming_source PORT_NAME_MAP ""
set_interface_property avalon_streaming_source CMSIS_SVD_VARIABLES ""
set_interface_property avalon_streaming_source SVD_ADDRESS_GROUP ""
add_interface_port avalon_streaming_source avalon_source_valid valid Output 1
add_interface_port avalon_streaming_source avalon_source_data data Output 32
add_interface_port avalon_streaming_source avalon_source_channel channel Output 2
add_interface_port avalon_streaming_source avalon_source_error error Output 2
# End create_sink_connection_point


