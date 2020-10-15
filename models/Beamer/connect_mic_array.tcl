package require qsys 

load_system {reflex_system.qsys}

remove_connection FE_Qsys_AD1939_Audio_Research_v1_0.Line_In/DSBF_0.avalon_streaming_sink
add_connection mic_array_adapter_0.data_output DSBF_0.avalon_streaming_sink

save_system {reflex_system}
