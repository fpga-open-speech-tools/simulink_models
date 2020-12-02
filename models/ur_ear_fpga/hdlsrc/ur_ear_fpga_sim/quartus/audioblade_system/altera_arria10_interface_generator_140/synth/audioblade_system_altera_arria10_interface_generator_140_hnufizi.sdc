create_clock -period 10.0 [get_pins -compatibility_mode *|fpga_interfaces|s2f_user0_clk*]
create_clock -name hps_spim0_sclk_out -period 10.0 [get_nodes *spim_0_clk]
create_clock -name hps_i2c_internal -period 2500.000 [get_registers {*~l4_sp_clk.reg}]