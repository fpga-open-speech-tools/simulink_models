# # # # # # # # # # # # # # # # # #
# Built in create_header_file_stuff
# # # # # # # # # # # # # # # # # #

package require -exact qsys 16.1
# End create_header_file_stuff


# # # # # # # # # # # # # # # # #
# Created in create_module
# # # # # # # # # # # # # # # # #

set_module_property DESCRIPTION ""
set_module_property NAME "DynamicCompressionWithRx"
set_module_property VERSION 1.0
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "DynamicCompressionWithRx"
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
add_fileset_file sm_DynamicCompression_Addr_Gen_block2.vhd VHDL PATH sm_DynamicCompression_Addr_Gen_block2.vhd
add_fileset_file sm_DynamicCompression_Static_pFIR1.vhd VHDL PATH sm_DynamicCompression_Static_pFIR1.vhd
add_fileset_file sm_DynamicCompression_Linear_Approximation_block3.vhd VHDL PATH sm_DynamicCompression_Linear_Approximation_block3.vhd
add_fileset_file sm_DynamicCompression_Addr_Gen_block3.vhd VHDL PATH sm_DynamicCompression_Addr_Gen_block3.vhd
add_fileset_file sm_DynamicCompression_Avalon_Data_Processing.vhd VHDL PATH sm_DynamicCompression_Avalon_Data_Processing.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_A_block4.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_A_block4.vhd
add_fileset_file sm_DynamicCompression_Low_Gain_Table_block.vhd VHDL PATH sm_DynamicCompression_Low_Gain_Table_block.vhd
add_fileset_file sm_DynamicCompression_Linear_Approximation.vhd VHDL PATH sm_DynamicCompression_Linear_Approximation.vhd
add_fileset_file sm_DynamicCompression_Left_Channel_Processing.vhd VHDL PATH sm_DynamicCompression_Left_Channel_Processing.vhd
add_fileset_file sm_DynamicCompression_Release_Envelope.vhd VHDL PATH sm_DynamicCompression_Release_Envelope.vhd
add_fileset_file sm_DynamicCompression_dataplane_tc.vhd VHDL PATH sm_DynamicCompression_dataplane_tc.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_A_block2.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_A_block2.vhd
add_fileset_file sm_DynamicCompression_LSL_N_block8.vhd VHDL PATH sm_DynamicCompression_LSL_N_block8.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_B_block3.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_B_block3.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_A.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_A.vhd
add_fileset_file sm_DynamicCompression_Attack_Envelope_block2.vhd VHDL PATH sm_DynamicCompression_Attack_Envelope_block2.vhd
add_fileset_file sm_DynamicCompression_High_Gain_Table_block3.vhd VHDL PATH sm_DynamicCompression_High_Gain_Table_block3.vhd
add_fileset_file sm_DynamicCompression_B_k_Memory_Block.vhd VHDL PATH sm_DynamicCompression_B_k_Memory_Block.vhd
add_fileset_file sm_DynamicCompression_LSR_N.vhd VHDL PATH sm_DynamicCompression_LSR_N.vhd
add_fileset_file sm_DynamicCompression_LSL_N.vhd VHDL PATH sm_DynamicCompression_LSL_N.vhd
add_fileset_file sm_DynamicCompression_LSR_N_block.vhd VHDL PATH sm_DynamicCompression_LSR_N_block.vhd
add_fileset_file sm_DynamicCompression_Static_pFIR.vhd VHDL PATH sm_DynamicCompression_Static_pFIR.vhd
add_fileset_file sm_DynamicCompression_LSR_N_block2.vhd VHDL PATH sm_DynamicCompression_LSR_N_block2.vhd
add_fileset_file sm_DynamicCompression_Static_pFIR3.vhd VHDL PATH sm_DynamicCompression_Static_pFIR3.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_B_block4.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_B_block4.vhd
add_fileset_file sm_DynamicCompression_LSL_N_block7.vhd VHDL PATH sm_DynamicCompression_LSL_N_block7.vhd
add_fileset_file sm_DynamicCompression_Compression_Envelope_block2.vhd VHDL PATH sm_DynamicCompression_Compression_Envelope_block2.vhd
add_fileset_file sm_DynamicCompression_High_Gain_Table_block2.vhd VHDL PATH sm_DynamicCompression_High_Gain_Table_block2.vhd
add_fileset_file sm_DynamicCompression_Static_pFIR4.vhd VHDL PATH sm_DynamicCompression_Static_pFIR4.vhd
add_fileset_file sm_DynamicCompression_Compression_Envelope_block1.vhd VHDL PATH sm_DynamicCompression_Compression_Envelope_block1.vhd
add_fileset_file sm_DynamicCompression_Linear_Approximation_block.vhd VHDL PATH sm_DynamicCompression_Linear_Approximation_block.vhd
add_fileset_file sm_DynamicCompression_dataplane_pkg.vhd VHDL PATH sm_DynamicCompression_dataplane_pkg.vhd
add_fileset_file sm_DynamicCompression_B_k_Memory_Block_block.vhd VHDL PATH sm_DynamicCompression_B_k_Memory_Block_block.vhd
add_fileset_file sm_DynamicCompression_LSR_N_block3.vhd VHDL PATH sm_DynamicCompression_LSR_N_block3.vhd
add_fileset_file sm_DynamicCompression_LogAddressing_block.vhd VHDL PATH sm_DynamicCompression_LogAddressing_block.vhd
add_fileset_file sm_DynamicCompression_Multiply_And_Sum_block.vhd VHDL PATH sm_DynamicCompression_Multiply_And_Sum_block.vhd
add_fileset_file sm_DynamicCompression_Multiply_And_Sum_block2.vhd VHDL PATH sm_DynamicCompression_Multiply_And_Sum_block2.vhd
add_fileset_file sm_DynamicCompression_LSL_N_block6.vhd VHDL PATH sm_DynamicCompression_LSL_N_block6.vhd
add_fileset_file sm_DynamicCompression_Addr_Gen_block.vhd VHDL PATH sm_DynamicCompression_Addr_Gen_block.vhd
add_fileset_file sm_DynamicCompression_B_k_Memory_Block_block1.vhd VHDL PATH sm_DynamicCompression_B_k_Memory_Block_block1.vhd
add_fileset_file sm_DynamicCompression_Attack_Envelope_block.vhd VHDL PATH sm_DynamicCompression_Attack_Envelope_block.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_B.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_B.vhd
add_fileset_file sm_DynamicCompression_Release_Envelope_block2.vhd VHDL PATH sm_DynamicCompression_Release_Envelope_block2.vhd
add_fileset_file sm_DynamicCompression_LSL_N_block1.vhd VHDL PATH sm_DynamicCompression_LSL_N_block1.vhd
add_fileset_file sm_DynamicCompression_Compression_Envelope_block3.vhd VHDL PATH sm_DynamicCompression_Compression_Envelope_block3.vhd
add_fileset_file sm_DynamicCompression_Addr_Gen.vhd VHDL PATH sm_DynamicCompression_Addr_Gen.vhd
add_fileset_file sm_DynamicCompression_B_k_Memory_Block2.vhd VHDL PATH sm_DynamicCompression_B_k_Memory_Block2.vhd
add_fileset_file sm_DynamicCompression_LSL_N_block3.vhd VHDL PATH sm_DynamicCompression_LSL_N_block3.vhd
add_fileset_file sm_DynamicCompression_Static_pFIR_block.vhd VHDL PATH sm_DynamicCompression_Static_pFIR_block.vhd
add_fileset_file sm_DynamicCompression_Release_Envelope_block3.vhd VHDL PATH sm_DynamicCompression_Release_Envelope_block3.vhd
add_fileset_file sm_DynamicCompression_Multiply_And_Sum.vhd VHDL PATH sm_DynamicCompression_Multiply_And_Sum.vhd
add_fileset_file sm_DynamicCompression_LSL_N_block.vhd VHDL PATH sm_DynamicCompression_LSL_N_block.vhd
add_fileset_file sm_DynamicCompression_Multiply_And_Sum_block1.vhd VHDL PATH sm_DynamicCompression_Multiply_And_Sum_block1.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_B_block1.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_B_block1.vhd
add_fileset_file sm_DynamicCompression_High_Gain_Table_block1.vhd VHDL PATH sm_DynamicCompression_High_Gain_Table_block1.vhd
add_fileset_file sm_DynamicCompression_Compression_2.vhd VHDL PATH sm_DynamicCompression_Compression_2.vhd
add_fileset_file sm_DynamicCompression_LogAddressing.vhd VHDL PATH sm_DynamicCompression_LogAddressing.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_B_block.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_B_block.vhd
add_fileset_file sm_DynamicCompression_Compression_4.vhd VHDL PATH sm_DynamicCompression_Compression_4.vhd
add_fileset_file sm_DynamicCompression_LSL_N_block2.vhd VHDL PATH sm_DynamicCompression_LSL_N_block2.vhd
add_fileset_file sm_DynamicCompression_Compression_Gain_Calc_block3.vhd VHDL PATH sm_DynamicCompression_Compression_Gain_Calc_block3.vhd
add_fileset_file sm_DynamicCompression_Release_Envelope_block.vhd VHDL PATH sm_DynamicCompression_Release_Envelope_block.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_B_block2.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_B_block2.vhd
add_fileset_file sm_DynamicCompression_Low_Gain_Table_block1.vhd VHDL PATH sm_DynamicCompression_Low_Gain_Table_block1.vhd
add_fileset_file sm_DynamicCompression_LSL_N_block5.vhd VHDL PATH sm_DynamicCompression_LSL_N_block5.vhd
add_fileset_file sm_DynamicCompression_MATLAB_Function.vhd VHDL PATH sm_DynamicCompression_MATLAB_Function.vhd
add_fileset_file sm_DynamicCompression_Addr_Gen_block1.vhd VHDL PATH sm_DynamicCompression_Addr_Gen_block1.vhd
add_fileset_file sm_DynamicCompression_Multiply_And_Sum_block4.vhd VHDL PATH sm_DynamicCompression_Multiply_And_Sum_block4.vhd
add_fileset_file sm_DynamicCompression_Addr_Gen_block4.vhd VHDL PATH sm_DynamicCompression_Addr_Gen_block4.vhd
add_fileset_file sm_DynamicCompression_Compression_Gain_Calc.vhd VHDL PATH sm_DynamicCompression_Compression_Gain_Calc.vhd
add_fileset_file sm_DynamicCompression_LogAddressing_block3.vhd VHDL PATH sm_DynamicCompression_LogAddressing_block3.vhd
add_fileset_file sm_DynamicCompression_Low_Gain_Table.vhd VHDL PATH sm_DynamicCompression_Low_Gain_Table.vhd
add_fileset_file sm_DynamicCompression_Compression_Gain_Calc_block.vhd VHDL PATH sm_DynamicCompression_Compression_Gain_Calc_block.vhd
add_fileset_file sm_DynamicCompression_B_k_Memory_Block_block2.vhd VHDL PATH sm_DynamicCompression_B_k_Memory_Block_block2.vhd
add_fileset_file sm_DynamicCompression_Linear_Approximation_block1.vhd VHDL PATH sm_DynamicCompression_Linear_Approximation_block1.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_A_block.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_A_block.vhd
add_fileset_file sm_DynamicCompression_Addr_Splitter.vhd VHDL PATH sm_DynamicCompression_Addr_Splitter.vhd
add_fileset_file sm_DynamicCompression_recalculate.vhd VHDL PATH sm_DynamicCompression_recalculate.vhd
add_fileset_file sm_DynamicCompression_Attack_Envelope_block1.vhd VHDL PATH sm_DynamicCompression_Attack_Envelope_block1.vhd
add_fileset_file sm_DynamicCompression_Right_Channel_Processing.vhd VHDL PATH sm_DynamicCompression_Right_Channel_Processing.vhd
add_fileset_file sm_DynamicCompression_Compression_Envelope_block.vhd VHDL PATH sm_DynamicCompression_Compression_Envelope_block.vhd
add_fileset_file sm_DynamicCompression_LSL_N_block4.vhd VHDL PATH sm_DynamicCompression_LSL_N_block4.vhd
add_fileset_file sm_DynamicCompression_Compression_5.vhd VHDL PATH sm_DynamicCompression_Compression_5.vhd
add_fileset_file sm_DynamicCompression_Attack_Envelope.vhd VHDL PATH sm_DynamicCompression_Attack_Envelope.vhd
add_fileset_file sm_DynamicCompression_LogAddressing_block1.vhd VHDL PATH sm_DynamicCompression_LogAddressing_block1.vhd
add_fileset_file sm_DynamicCompression_Compression_Gain_Calc_block2.vhd VHDL PATH sm_DynamicCompression_Compression_Gain_Calc_block2.vhd
add_fileset_file sm_DynamicCompression_Multiply_And_Sum_block3.vhd VHDL PATH sm_DynamicCompression_Multiply_And_Sum_block3.vhd
add_fileset_file sm_DynamicCompression_SimpleDualPortRAM_generic.vhd VHDL PATH sm_DynamicCompression_SimpleDualPortRAM_generic.vhd
add_fileset_file sm_DynamicCompression_Static_pFIR2.vhd VHDL PATH sm_DynamicCompression_Static_pFIR2.vhd
add_fileset_file sm_DynamicCompression_LSR_N_block1.vhd VHDL PATH sm_DynamicCompression_LSR_N_block1.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_A_block1.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_A_block1.vhd
add_fileset_file sm_DynamicCompression_Linear_Approximation_block2.vhd VHDL PATH sm_DynamicCompression_Linear_Approximation_block2.vhd
add_fileset_file sm_DynamicCompression_Compression_3.vhd VHDL PATH sm_DynamicCompression_Compression_3.vhd
add_fileset_file sm_DynamicCompression_Compression_Envelope.vhd VHDL PATH sm_DynamicCompression_Compression_Envelope.vhd
add_fileset_file sm_DynamicCompression_Data_Type_Conversion_Inherited_A_block3.vhd VHDL PATH sm_DynamicCompression_Data_Type_Conversion_Inherited_A_block3.vhd
add_fileset_file sm_DynamicCompression_Compression_1.vhd VHDL PATH sm_DynamicCompression_Compression_1.vhd
add_fileset_file sm_DynamicCompression_dataplane.vhd VHDL PATH sm_DynamicCompression_dataplane.vhd
add_fileset_file sm_DynamicCompression_Nchan_FbankAGC_AID.vhd VHDL PATH sm_DynamicCompression_Nchan_FbankAGC_AID.vhd
add_fileset_file sm_DynamicCompression_Attack_Envelope_block3.vhd VHDL PATH sm_DynamicCompression_Attack_Envelope_block3.vhd
add_fileset_file sm_DynamicCompression_Low_Gain_Table_block3.vhd VHDL PATH sm_DynamicCompression_Low_Gain_Table_block3.vhd
add_fileset_file sm_DynamicCompression_Low_Gain_Table_block2.vhd VHDL PATH sm_DynamicCompression_Low_Gain_Table_block2.vhd
add_fileset_file sm_DynamicCompression_Compression_Gain_Calc_block1.vhd VHDL PATH sm_DynamicCompression_Compression_Gain_Calc_block1.vhd
add_fileset_file sm_DynamicCompression_Release_Envelope_block1.vhd VHDL PATH sm_DynamicCompression_Release_Envelope_block1.vhd
add_fileset_file sm_DynamicCompression_High_Gain_Table.vhd VHDL PATH sm_DynamicCompression_High_Gain_Table.vhd
add_fileset_file sm_DynamicCompression_High_Gain_Table_block.vhd VHDL PATH sm_DynamicCompression_High_Gain_Table_block.vhd
add_fileset_file sm_DynamicCompression_B_k_Memory_Block_block3.vhd VHDL PATH sm_DynamicCompression_B_k_Memory_Block_block3.vhd
add_fileset_file sm_DynamicCompression_LogAddressing_block2.vhd VHDL PATH sm_DynamicCompression_LogAddressing_block2.vhd
set_fileset_property QUARTUS_SYNTH TOP_LEVEL sm_DynamicCompression_dataplane_avalon
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file sm_DynamicCompression_dataplane_avalon.vhd VHDL PATH sm_DynamicCompression_dataplane_avalon.vhd TOP_LEVEL_FILE
# end create_file_sets


# # # # # # # # # # # # # # # # # #
# Created in create_module_assignments
# # # # # # # # # # # # # # # # # # # #

set_module_assignment embeddedsw.dts.compatible dev,fe-DynamicCompressionWithRx
set_module_assignment embeddedsw.dts.group DynamicCompressionWithRx
set_module_assignment embeddedsw.dts.vendor fe
# End create_module_assignments


# # # # # # # # # # # # # # # # # # # # # #
# Created by create_connection_point_clock
# # # # # # # # # # # # # # # # # # # # # #

add_interface clock clock end
set_interface_property clock clockRate 49152000.0
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


