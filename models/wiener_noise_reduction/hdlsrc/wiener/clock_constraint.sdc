
# Timing Specification Constraints

create_clock -name clk -period 0.002604ns -waveform {0.0ns 0.001302ns} [get_ports {clk}]
derive_pll_clocks
derive_clock_uncertainty
