# MATLAB DPR Interface Example
This project shows an example platform driver interface with MATLAB's simple DPR block.  The driver takes in a list of 512 numbers, parses the list, and writes each value to the RAM.  The design assumes the number format of the data to be fixed point with eight fractional bits and eight integer bits.  This can be configured as desired, however.  Audio data is also passed directly through the design.

## Building the Project
1. Build the project by following the [FrOST user guides](https://github.com/fpga-open-speech-tools/docs/tree/master/getting_started)

This will generate the full Quartus project as well as a loadable kernel module for the design and device tree entry.  The autogen software does not support writing to a dual port RAM, so a new kernel module must be made and a different device tree blob should be used.  

1. Copy the `dpr_test.c` file from the base directory into the `hdlsrc\dpr_test` directory
2. In WSL, change to this directory and run 
    - `export CROSS_COMPILE=arm-linux-gnueabihf-`
    - `make clean`
    - `make`
3. Transfer the `dpr_test.ko` file to `/home/root/` directory of the DE10 
4. Compile the `soc_system.dts` with the SoC EDS tool using the command:
    - `dtc -I dts -O dtb -o soc_system.dtb soc_system_dc.dts -@`
6. Copy the `soc_system.dtb` in the base directory to the FAT32 partition of the SD card

## Running the Project
Currently, writing to MATLAB's dual port RAM is not supported by the FrOST autogen app, so the example project should be programmed manually and controlled from the command line.  
1. Open the `hdlsrc\dpr_test\quartus` directory
2. Open `dpr_test.qpf` with Quartus
3. Open the programmer tool
4. Power the DE10 and connect both the UART and USB Blaster ports to the computer
5. Select the appropriate DE10 
6. Select the `dpr_test.sof` file in the `output_files` directory
7. Click Program
8. Connect to the DE10 using the appropriate COM port or IP address
    - Username: `root`
    - Password: `root`
9. Run `insmod dpr_test.ko`

Now, the dual port RAM can be written to.  Simply `echo` in a string of numbers or `cat` in a file of numbers.  Note, this example is set up for accepting 512 numbers at a time.  

Example commands:
- `echo "1.0 2.0 ... 510.0 511.0 512.0" > /sys/class/fe_dpr_test_xxx>/fe_dpr_test_xxx/dpr_data`
- `cat test_data > /sys/class/fe_dpr_test_xxx>/fe_dpr_test_xxx/dpr_data`
where `test_data` is a file containing a list of 512 numbers.

## Future work
1. Implement the reading interface to pull data from the dual port RAM block.
2. Integrate the DPR interface into the FrOST framework, greatly simplifying the installation process.
