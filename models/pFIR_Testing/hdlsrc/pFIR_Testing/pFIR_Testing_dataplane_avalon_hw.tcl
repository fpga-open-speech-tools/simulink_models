# TCL File Generated by Component Editor 18.1
# Wed Apr 15 16:09:08 MDT 2020
# DO NOT MODIFY


# 
# pFIR_Testing "pFIR_Testing" v1.0
#  2020.04.15.16:09:08
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module pFIR_Testing
# 
set_module_property DESCRIPTION ""
set_module_property NAME pFIR_Testing
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME pFIR_Testing
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL pFIR_Testing_dataplane_avalon
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file pFIR_Testing_Addr_Gen.vhd VHDL PATH pFIR_Testing_Addr_Gen.vhd
add_fileset_file pFIR_Testing_Addr_Gen_block.vhd VHDL PATH pFIR_Testing_Addr_Gen_block.vhd
add_fileset_file pFIR_Testing_B_k_Memory_Block2.vhd VHDL PATH pFIR_Testing_B_k_Memory_Block2.vhd
add_fileset_file pFIR_Testing_B_k_Memory_Block2_block.vhd VHDL PATH pFIR_Testing_B_k_Memory_Block2_block.vhd
add_fileset_file pFIR_Testing_dataplane.vhd VHDL PATH pFIR_Testing_dataplane.vhd
add_fileset_file pFIR_Testing_dataplane_pkg.vhd VHDL PATH pFIR_Testing_dataplane_pkg.vhd
add_fileset_file pFIR_Testing_dataplane_tc.vhd VHDL PATH pFIR_Testing_dataplane_tc.vhd
add_fileset_file pFIR_Testing_Data_Type_Conversion_Inherited_A.vhd VHDL PATH pFIR_Testing_Data_Type_Conversion_Inherited_A.vhd
add_fileset_file pFIR_Testing_Data_Type_Conversion_Inherited_A_block.vhd VHDL PATH pFIR_Testing_Data_Type_Conversion_Inherited_A_block.vhd
add_fileset_file pFIR_Testing_Data_Type_Conversion_Inherited_B.vhd VHDL PATH pFIR_Testing_Data_Type_Conversion_Inherited_B.vhd
add_fileset_file pFIR_Testing_Data_Type_Conversion_Inherited_B_block.vhd VHDL PATH pFIR_Testing_Data_Type_Conversion_Inherited_B_block.vhd
add_fileset_file pFIR_Testing_Left_Channel_Processing.vhd VHDL PATH pFIR_Testing_Left_Channel_Processing.vhd
add_fileset_file pFIR_Testing_MATLAB_Function.vhd VHDL PATH pFIR_Testing_MATLAB_Function.vhd
add_fileset_file pFIR_Testing_Multiply_And_Sum.vhd VHDL PATH pFIR_Testing_Multiply_And_Sum.vhd
add_fileset_file pFIR_Testing_Multiply_And_Sum_block.vhd VHDL PATH pFIR_Testing_Multiply_And_Sum_block.vhd
add_fileset_file pFIR_Testing_Programmable_Upclocked_FIR.vhd VHDL PATH pFIR_Testing_Programmable_Upclocked_FIR.vhd
add_fileset_file pFIR_Testing_Programmable_Upclocked_FIR_block.vhd VHDL PATH pFIR_Testing_Programmable_Upclocked_FIR_block.vhd
add_fileset_file pFIR_Testing_Right_Channel_Processing.vhd VHDL PATH pFIR_Testing_Right_Channel_Processing.vhd
add_fileset_file pFIR_Testing_SimpleDualPortRAM_generic.vhd VHDL PATH pFIR_Testing_SimpleDualPortRAM_generic.vhd
add_fileset_file pFIR_Testing_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering.vhd VHDL PATH pFIR_Testing_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering.vhd
add_fileset_file pFIR_Testing_dataplane_avalon.vhd VHDL PATH pFIR_Testing_dataplane_avalon.vhd TOP_LEVEL_FILE
add_fileset_file pFIR_Testing_Channel_Data_Multiplexer.vhd VHDL PATH pFIR_Testing_Channel_Data_Multiplexer.vhd


# 
# parameters
# 


# 
# module assignments
# 
set_module_assignment embeddedsw.dts.compatible dev,fe-pFIR_Testing
set_module_assignment embeddedsw.dts.group pFIR_Testing
set_module_assignment embeddedsw.dts.vendor fe


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 98304000
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF true
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point avalon_streaming_sink
# 
add_interface avalon_streaming_sink avalon_streaming end
set_interface_property avalon_streaming_sink associatedClock clock
set_interface_property avalon_streaming_sink associatedReset reset
set_interface_property avalon_streaming_sink dataBitsPerSymbol 32
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


# 
# connection point avalon_streaming_source
# 
add_interface avalon_streaming_source avalon_streaming start
set_interface_property avalon_streaming_source associatedClock clock
set_interface_property avalon_streaming_source associatedReset reset
set_interface_property avalon_streaming_source dataBitsPerSymbol 32
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


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock
set_interface_property avalon_slave_0 associatedReset reset
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 avalon_slave_0_address address Input 1
add_interface_port avalon_slave_0 avalon_slave_0_read read Input 1
add_interface_port avalon_slave_0 avalon_slave_0_readdata readdata Output 32
add_interface_port avalon_slave_0 avalon_slave_0_write write Input 1
add_interface_port avalon_slave_0 avalon_slave_0_writedata writedata Input 32
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_slave_1
# 
add_interface avalon_slave_1 avalon end
set_interface_property avalon_slave_1 addressUnits WORDS
set_interface_property avalon_slave_1 associatedClock clock
set_interface_property avalon_slave_1 associatedReset reset
set_interface_property avalon_slave_1 bitsPerSymbol 8
set_interface_property avalon_slave_1 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_1 burstcountUnits WORDS
set_interface_property avalon_slave_1 explicitAddressSpan 0
set_interface_property avalon_slave_1 holdTime 0
set_interface_property avalon_slave_1 linewrapBursts false
set_interface_property avalon_slave_1 maximumPendingReadTransactions 0
set_interface_property avalon_slave_1 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_1 readLatency 0
set_interface_property avalon_slave_1 readWaitTime 1
set_interface_property avalon_slave_1 setupTime 0
set_interface_property avalon_slave_1 timingUnits Cycles
set_interface_property avalon_slave_1 writeWaitTime 0
set_interface_property avalon_slave_1 ENABLED true
set_interface_property avalon_slave_1 EXPORT_OF ""
set_interface_property avalon_slave_1 PORT_NAME_MAP ""
set_interface_property avalon_slave_1 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_1 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_1 avalon_slave_1_address address Input 9
add_interface_port avalon_slave_1 avalon_slave_1_read read Input 1
add_interface_port avalon_slave_1 avalon_slave_1_readdata readdata Output 32
add_interface_port avalon_slave_1 avalon_slave_1_write write Input 1
add_interface_port avalon_slave_1 avalon_slave_1_writedata writedata Input 32
set_interface_assignment avalon_slave_1 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_1 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_1 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_1 embeddedsw.configuration.isPrintableDevice 0

