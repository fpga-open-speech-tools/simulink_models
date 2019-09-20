-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 18.0 (Release Build #614)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2018 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05
-- VHDL created on Fri Apr 05 13:33:36 2019


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

library twentynm;
use twentynm.twentynm_components.twentynm_fp_mac;

entity busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05 is
    port (
        busIn_writedata : in std_logic_vector(31 downto 0);  -- ufix32
        busIn_address : in std_logic_vector(0 downto 0);  -- ufix1
        busIn_write : in std_logic_vector(0 downto 0);  -- ufix1
        busIn_read : in std_logic_vector(0 downto 0);  -- ufix1
        busOut_readdatavalid : out std_logic_vector(0 downto 0);  -- ufix1
        busOut_readdata : out std_logic_vector(31 downto 0);  -- ufix32
        out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x : out std_logic_vector(11 downto 0);  -- ufix12
        clk : in std_logic;
        areset : in std_logic;
        h_areset : in std_logic
    );
end busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05;

architecture normal of busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal addr_0_readHit_and_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal addr_0_writeHit_and_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_RegField_bitsel_x_b : STD_LOGIC_VECTOR (11 downto 0);
    signal addr_0_cmp_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal mm_reg_0_data_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal bus_selector_q : STD_LOGIC_VECTOR (31 downto 0);
    signal bus_selector_v : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- addr_0_cmp_x(LOGICAL,7)@0
    addr_0_cmp_x_q <= "1" WHEN GND_q = busIn_address ELSE "0";

    -- addr_0_writeHit_and_x(LOGICAL,3)@0
    addr_0_writeHit_and_x_q <= addr_0_cmp_x_q and busIn_write;

    -- mm_reg_0_data_x(REG,9)@0
    mm_reg_0_data_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            mm_reg_0_data_x_q <= "00000000000000000000000000000000";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (addr_0_writeHit_and_x_q = "1") THEN
                mm_reg_0_data_x_q <= busIn_writedata;
            END IF;
        END IF;
    END PROCESS;

    -- addr_0_readHit_and_x(LOGICAL,2)@0
    addr_0_readHit_and_x_q <= addr_0_cmp_x_q and busIn_read;

    -- bus_selector(SELECTOR,12)@0 + 1
    bus_selector_clkproc: PROCESS (clk, h_areset)
    BEGIN
        IF (h_areset = '1') THEN
            bus_selector_q <= (others => '0');
            bus_selector_v <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            bus_selector_q <= STD_LOGIC_VECTOR("0000000000000000000000000000000" & GND_q);
            bus_selector_v <= "0";
            IF (addr_0_readHit_and_x_q = "1") THEN
                bus_selector_q <= mm_reg_0_data_x_q;
                bus_selector_v <= "1";
            END IF;
        END IF;
    END PROCESS;

    -- busOut(BUSOUT,11)@1
    busOut_readdatavalid <= bus_selector_v;
    busOut_readdata <= bus_selector_q;

    -- acoustic_delay_buffer_adb_RegField_bitsel_x(BITSELECT,4)@0
    acoustic_delay_buffer_adb_RegField_bitsel_x_b <= mm_reg_0_data_x_q(11 downto 0);

    -- out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x(GPOUT,14)@0
    out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x <= acoustic_delay_buffer_adb_RegField_bitsel_x_b;

END normal;
