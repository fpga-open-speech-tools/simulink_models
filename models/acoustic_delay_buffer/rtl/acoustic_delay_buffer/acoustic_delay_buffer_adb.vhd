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

-- VHDL created from acoustic_delay_buffer_adb
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

entity acoustic_delay_buffer_adb is
    port (
        busIn_writedata : in std_logic_vector(31 downto 0);  -- ufix32
        busIn_address : in std_logic_vector(0 downto 0);  -- ufix1
        busIn_write : in std_logic_vector(0 downto 0);  -- ufix1
        busIn_read : in std_logic_vector(0 downto 0);  -- ufix1
        busOut_readdatavalid : out std_logic_vector(0 downto 0);  -- ufix1
        busOut_readdata : out std_logic_vector(31 downto 0);  -- ufix32
        busOut_waitrequest : out std_logic_vector(0 downto 0);  -- ufix1
        d : in std_logic_vector(31 downto 0);  -- sfix32_en28
        v : in std_logic_vector(0 downto 0);  -- ufix1
        c : in std_logic_vector(7 downto 0);  -- ufix8
        dout : out std_logic_vector(31 downto 0);  -- sfix32_en28
        vout : out std_logic_vector(0 downto 0);  -- ufix1
        cout : out std_logic_vector(7 downto 0);  -- ufix8
        clk : in std_logic;
        areset : in std_logic;
        h_areset : in std_logic
    );
end acoustic_delay_buffer_adb;

architecture normal of acoustic_delay_buffer_adb is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    component acoustic_delay_buffer_adb_AStInput is
        port (
            in_1_avalonIfaceRole_valid_sink_valid : in std_logic_vector(0 downto 0);  -- Fixed Point
            in_2_avalonIfaceRole_channel_sink_channel : in std_logic_vector(7 downto 0);  -- Fixed Point
            in_3_avalonIfaceRole_data_sink_data : in std_logic_vector(31 downto 0);  -- Fixed Point
            out_1_avalonIfaceRole_valid_input_valid : out std_logic_vector(0 downto 0);  -- Fixed Point
            out_2_avalonIfaceRole_channel_input_channel : out std_logic_vector(7 downto 0);  -- Fixed Point
            out_3_avalonIfaceRole_data_input_data : out std_logic_vector(31 downto 0);  -- Fixed Point
            clk : in std_logic;
            areset : in std_logic
        );
    end component;


    component acoustic_delay_buffer_adb_AStOutput is
        port (
            in_1_avalonIfaceRole_valid_output_valid : in std_logic_vector(0 downto 0);  -- Fixed Point
            in_2_avalonIfaceRole_channel_output_channel : in std_logic_vector(7 downto 0);  -- Fixed Point
            in_3_avalonIfaceRole_data_output_data : in std_logic_vector(31 downto 0);  -- Fixed Point
            out_1_avalonIfaceRole_valid_source_valid : out std_logic_vector(0 downto 0);  -- Fixed Point
            out_2_avalonIfaceRole_channel_source_channel : out std_logic_vector(7 downto 0);  -- Fixed Point
            out_3_avalonIfaceRole_data_source_data : out std_logic_vector(31 downto 0);  -- Fixed Point
            clk : in std_logic;
            areset : in std_logic
        );
    end component;


    component busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05 is
        port (
            busIn_writedata : in std_logic_vector(31 downto 0);  -- Fixed Point
            busIn_address : in std_logic_vector(0 downto 0);  -- Fixed Point
            busIn_write : in std_logic_vector(0 downto 0);  -- Fixed Point
            busIn_read : in std_logic_vector(0 downto 0);  -- Fixed Point
            busOut_readdata : out std_logic_vector(31 downto 0);  -- Fixed Point
            busOut_readdatavalid : out std_logic_vector(0 downto 0);  -- Fixed Point
            out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x : out std_logic_vector(11 downto 0);  -- Fixed Point
            clk : in std_logic;
            areset : in std_logic;
            h_areset : in std_logic
        );
    end component;


    component acoustic_delay_buffer_adb_delay_buffer is
        port (
            in_1_valid_in : in std_logic_vector(0 downto 0);  -- Fixed Point
            in_2_channel_in : in std_logic_vector(7 downto 0);  -- Fixed Point
            in_3_din : in std_logic_vector(31 downto 0);  -- Fixed Point
            in_4_delay_compensation : in std_logic_vector(11 downto 0);  -- Fixed Point
            out_1_valid_out : out std_logic_vector(0 downto 0);  -- Fixed Point
            out_2_channel_out : out std_logic_vector(7 downto 0);  -- Fixed Point
            out_3_dout : out std_logic_vector(31 downto 0);  -- Fixed Point
            clk : in std_logic;
            areset : in std_logic
        );
    end component;


    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal AStInput_out_1_avalonIfaceRole_valid_input_valid : STD_LOGIC_VECTOR (0 downto 0);
    signal AStInput_out_2_avalonIfaceRole_channel_input_channel : STD_LOGIC_VECTOR (7 downto 0);
    signal AStInput_out_3_avalonIfaceRole_data_input_data : STD_LOGIC_VECTOR (31 downto 0);
    signal AStOutput_out_1_avalonIfaceRole_valid_source_valid : STD_LOGIC_VECTOR (0 downto 0);
    signal AStOutput_out_2_avalonIfaceRole_channel_source_channel : STD_LOGIC_VECTOR (7 downto 0);
    signal AStOutput_out_3_avalonIfaceRole_data_source_data : STD_LOGIC_VECTOR (31 downto 0);
    signal busSlaveFabric_busOut_readdata : STD_LOGIC_VECTOR (31 downto 0);
    signal busSlaveFabric_busOut_readdatavalid : STD_LOGIC_VECTOR (0 downto 0);
    signal busSlaveFabric_out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x : STD_LOGIC_VECTOR (11 downto 0);
    signal delay_buffer_out_1_valid_out : STD_LOGIC_VECTOR (0 downto 0);
    signal delay_buffer_out_2_channel_out : STD_LOGIC_VECTOR (7 downto 0);
    signal delay_buffer_out_3_dout : STD_LOGIC_VECTOR (31 downto 0);
    signal acoustic_delay_buffer_adb_readDelayed_q : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_readDataValid_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- busSlaveFabric(BLACKBOX,9)
    thebusSlaveFabric : busSlaveFabric_acoustic_delay_buffer_adb_3c06i26010e10x10y10070o7054cz5iwt1y05
    PORT MAP (
        busIn_writedata => busIn_writedata,
        busIn_address => busIn_address,
        busIn_write => busIn_write,
        busIn_read => busIn_read,
        busOut_readdata => busSlaveFabric_busOut_readdata,
        busOut_readdatavalid => busSlaveFabric_busOut_readdatavalid,
        out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x => busSlaveFabric_out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x,
        clk => clk,
        areset => areset,
        h_areset => h_areset
    );

    -- acoustic_delay_buffer_adb_readDelayed(DELAY,24)
    acoustic_delay_buffer_adb_readDelayed : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => busIn_read, xout => acoustic_delay_buffer_adb_readDelayed_q, clk => clk, aclr => h_areset );

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- acoustic_delay_buffer_adb_readDataValid(LOGICAL,25)
    acoustic_delay_buffer_adb_readDataValid_q <= busSlaveFabric_busOut_readdatavalid or acoustic_delay_buffer_adb_readDelayed_q;

    -- busOut(BUSOUT,8)
    busOut_readdatavalid <= acoustic_delay_buffer_adb_readDataValid_q;
    busOut_readdata <= busSlaveFabric_busOut_readdata;
    busOut_waitrequest <= GND_q;

    -- AStInput(BLACKBOX,5)
    theAStInput : acoustic_delay_buffer_adb_AStInput
    PORT MAP (
        in_1_avalonIfaceRole_valid_sink_valid => v,
        in_2_avalonIfaceRole_channel_sink_channel => c,
        in_3_avalonIfaceRole_data_sink_data => d,
        out_1_avalonIfaceRole_valid_input_valid => AStInput_out_1_avalonIfaceRole_valid_input_valid,
        out_2_avalonIfaceRole_channel_input_channel => AStInput_out_2_avalonIfaceRole_channel_input_channel,
        out_3_avalonIfaceRole_data_input_data => AStInput_out_3_avalonIfaceRole_data_input_data,
        clk => clk,
        areset => areset
    );

    -- delay_buffer(BLACKBOX,10)
    thedelay_buffer : acoustic_delay_buffer_adb_delay_buffer
    PORT MAP (
        in_1_valid_in => AStInput_out_1_avalonIfaceRole_valid_input_valid,
        in_2_channel_in => AStInput_out_2_avalonIfaceRole_channel_input_channel,
        in_3_din => AStInput_out_3_avalonIfaceRole_data_input_data,
        in_4_delay_compensation => busSlaveFabric_out_AMMregisterWireData_acoustic_delay_buffer_adb_RegField_x,
        out_1_valid_out => delay_buffer_out_1_valid_out,
        out_2_channel_out => delay_buffer_out_2_channel_out,
        out_3_dout => delay_buffer_out_3_dout,
        clk => clk,
        areset => areset
    );

    -- AStOutput(BLACKBOX,6)
    theAStOutput : acoustic_delay_buffer_adb_AStOutput
    PORT MAP (
        in_1_avalonIfaceRole_valid_output_valid => delay_buffer_out_1_valid_out,
        in_2_avalonIfaceRole_channel_output_channel => delay_buffer_out_2_channel_out,
        in_3_avalonIfaceRole_data_output_data => delay_buffer_out_3_dout,
        out_1_avalonIfaceRole_valid_source_valid => AStOutput_out_1_avalonIfaceRole_valid_source_valid,
        out_2_avalonIfaceRole_channel_source_channel => AStOutput_out_2_avalonIfaceRole_channel_source_channel,
        out_3_avalonIfaceRole_data_source_data => AStOutput_out_3_avalonIfaceRole_data_source_data,
        clk => clk,
        areset => areset
    );

    -- dout(GPOUT,14)
    dout <= AStOutput_out_3_avalonIfaceRole_data_source_data;

    -- vout(GPOUT,15)
    vout <= AStOutput_out_1_avalonIfaceRole_valid_source_valid;

    -- cout(GPOUT,16)
    cout <= AStOutput_out_2_avalonIfaceRole_channel_source_channel;

END normal;
