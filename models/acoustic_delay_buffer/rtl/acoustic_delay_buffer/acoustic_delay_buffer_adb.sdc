create_clock -period 40.690 -name {clk} [get_ports {clk}]
create_generated_clock -name {clk} [get_ports {clk}] -source clk -divide_by 1 -multiply_by 1
