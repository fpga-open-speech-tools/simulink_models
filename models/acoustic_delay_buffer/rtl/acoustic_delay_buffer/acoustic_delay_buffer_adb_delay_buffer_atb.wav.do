onerror {resume}

# obtain Modelsim version and extract the NN.Nc part after vsim
quietly set vsim_ver [regexp -inline {vsim (\d+\.\d+)(\w?)} [vsim -version]]
quietly set has_fixpt_radix 0
if {[lindex $vsim_ver 1] == 10.2} {
    if {[lindex $vsim_ver 2] >= "d"} {
        quietly set has_fixpt_radix 1
    }
} elseif {[lindex $vsim_ver 1] > 10.2} {
    quietly set has_fixpt_radix 1
}

proc add_fixpt_wave {name width frac_width signed} {
    global has_fixpt_radix
    if {$frac_width > 0 && $has_fixpt_radix} {
        set type "[string index $signed 0]fix${width}_En${frac_width}"
        if {[lsearch [radix names] $type] < 0} {
            if {$signed == "signed"} {
                radix define $type -fixed -signed -fraction $frac_width
            } else {
                radix define $type -fixed -fraction $frac_width
            }
        }
        add wave -noupdate -format Literal -radix $type $name
    } else {
        add wave -noupdate -format Literal -radix $signed $name
    }
}

add wave -noupdate -divider {Input Ports}
add wave -noupdate -format Logic /acoustic_delay_buffer_adb_delay_buffer_atb/dut/clk
add wave -noupdate -format Logic /acoustic_delay_buffer_adb_delay_buffer_atb/dut/areset
add wave -noupdate -format Logical /acoustic_delay_buffer_adb_delay_buffer_atb/sim/in_1_valid_in_stm
add_fixpt_wave /acoustic_delay_buffer_adb_delay_buffer_atb/sim/in_2_channel_in_stm 8 0 unsigned
add_fixpt_wave /acoustic_delay_buffer_adb_delay_buffer_atb/sim/in_3_din_stm 32 28 signed
add_fixpt_wave /acoustic_delay_buffer_adb_delay_buffer_atb/sim/in_4_delay_compensation_stm 12 0 unsigned
add wave -noupdate -divider {Output Ports}
add wave -noupdate -format Logical /acoustic_delay_buffer_adb_delay_buffer_atb/dut/out_1_valid_out
add wave -noupdate -format Logical /acoustic_delay_buffer_adb_delay_buffer_atb/sim/out_1_valid_out_stm
add_fixpt_wave /acoustic_delay_buffer_adb_delay_buffer_atb/dut/out_2_channel_out 8 0 unsigned
add_fixpt_wave /acoustic_delay_buffer_adb_delay_buffer_atb/sim/out_2_channel_out_stm 8 0 unsigned
add_fixpt_wave /acoustic_delay_buffer_adb_delay_buffer_atb/dut/out_3_dout 32 28 signed
add_fixpt_wave /acoustic_delay_buffer_adb_delay_buffer_atb/sim/out_3_dout_stm 32 28 signed
TreeUpdate [SetDefaultTree]
