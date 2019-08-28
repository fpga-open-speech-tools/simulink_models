
proc checkDepends {dst src} {
    if {! [file exists $dst]} { return 1 }
    if {[file mtime $dst] < [file mtime $src]} { return 1 }
    return 0
}

if [info exists ::env(DSPBA_HDL_DIR)] {
    quietly set dspba_hdl_dir $::env(DSPBA_HDL_DIR)
} else {
    quietly set dspba_hdl_dir $quartus_dir/dspba/backend/Libraries
}

if {[checkDepends "$base_dir/work/dspba_library_package/_primary.dat" "$dspba_hdl_dir/vhdl/base/dspba_library_package.vhd"] || [checkDepends "$base_dir/work/dspba_library_package/_primary.dat" "$dspba_hdl_dir/vhdl/base/dspba_library.vhd"]} {
    vcom -quiet -93  "$dspba_hdl_dir/vhdl/base/dspba_library_package.vhd"
    vcom -quiet -93  "$dspba_hdl_dir/vhdl/base/dspba_library.vhd"
}
if {[checkDepends "$base_dir/work/dspba_sim_library_package/_primary.dat" "$dspba_hdl_dir/vhdl/sim/dspba_sim_library_package.vhd"]} {
    vcom -quiet -93  "$dspba_hdl_dir/vhdl/sim/dspba_sim_library_package.vhd"
}
