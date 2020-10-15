set OS [lindex $tcl_platform(os) 0]
if { $OS == "Windows" } {
    set bin_dir "bin64\\"
} else {
    set bin_dir "bin/"
}
set sof_files [glob output_files/*.sof]

foreach sof_file $sof_files {
    set rbf_file [lindex [split $sof_file "."] 0].rbf
    puts "Converting $sof_file"
    puts "$quartus(quartus_rootpath)${bin_dir}quartus_cpf -c -m FPP ${sof_file} ${rbf_file}"
    exec $quartus(quartus_rootpath)${bin_dir}quartus_cpf -c -m FPP ${sof_file} ${rbf_file}
}
