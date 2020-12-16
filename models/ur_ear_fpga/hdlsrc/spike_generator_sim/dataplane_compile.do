vmap -c
vlib work
vmap work work

vcom  dataplane_pkg.vhd
cd mean_spike_rate
do mean_spike_rate_compile.do
cd ..
cd initialize_signal
do initialize_signal_compile.do
cd ..
cd pseudo_random_lut
do pseudo_random_lut_compile.do
cd ..
cd redocking_site
do redocking_site_compile.do
cd ..
cd spike_generator
do spike_generator_compile.do
cd ..
vcom  nfp_mul_single.vhd
vcom  Avalon_Data_Processing.vhd
vcom  dataplane_tc.vhd
vcom  dataplane.vhd
