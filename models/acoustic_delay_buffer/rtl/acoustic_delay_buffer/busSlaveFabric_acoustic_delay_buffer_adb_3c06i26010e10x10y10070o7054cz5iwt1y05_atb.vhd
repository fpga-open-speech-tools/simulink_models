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
use work.dspba_sim_library_package.all;
entity busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05_atb is
end;

architecture normal of busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05_atb is

component busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05 is
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
end component;

component busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05_stm is
    port (
        busIn_writedata_stm : out std_logic_vector(31 downto 0);
        busIn_address_stm : out std_logic_vector(0 downto 0);
        busIn_write_stm : out std_logic_vector(0 downto 0);
        busIn_read_stm : out std_logic_vector(0 downto 0);
        busOut_readdatavalid_stm : out std_logic_vector(0 downto 0);
        busOut_readdata_stm : out std_logic_vector(31 downto 0);
        out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x_stm : out std_logic_vector(11 downto 0);
        clk : out std_logic;
        areset : out std_logic;
        h_areset : out std_logic
    );
end component;

signal busIn_writedata_stm : STD_LOGIC_VECTOR (31 downto 0);
signal busIn_address_stm : STD_LOGIC_VECTOR (0 downto 0);
signal busIn_write_stm : STD_LOGIC_VECTOR (0 downto 0);
signal busIn_read_stm : STD_LOGIC_VECTOR (0 downto 0);
signal busOut_readdatavalid_stm : STD_LOGIC_VECTOR (0 downto 0);
signal busOut_readdata_stm : STD_LOGIC_VECTOR (31 downto 0);
signal out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x_stm : STD_LOGIC_VECTOR (11 downto 0);
signal busIn_writedata_dut : STD_LOGIC_VECTOR (31 downto 0);
signal busIn_address_dut : STD_LOGIC_VECTOR (0 downto 0);
signal busIn_write_dut : STD_LOGIC_VECTOR (0 downto 0);
signal busIn_read_dut : STD_LOGIC_VECTOR (0 downto 0);
signal busOut_readdatavalid_dut : STD_LOGIC_VECTOR (0 downto 0);
signal busOut_readdata_dut : STD_LOGIC_VECTOR (31 downto 0);
signal out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x_dut : STD_LOGIC_VECTOR (11 downto 0);
        signal clk : std_logic;
        signal areset : std_logic;
        signal h_areset : std_logic;

begin

dut : busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05 port map (
    busIn_writedata_stm,
    busIn_address_stm,
    busIn_write_stm,
    busIn_read_stm,
    busOut_readdatavalid_dut,
    busOut_readdata_dut,
    out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x_dut,
        clk,
        areset,
        h_areset
);

sim : busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05_stm port map (
    busIn_writedata_stm,
    busIn_address_stm,
    busIn_write_stm,
    busIn_read_stm,
    busOut_readdatavalid_stm,
    busOut_readdata_stm,
    out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x_stm,
        clk,
        areset,
        h_areset
);

end normal;
