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

-- VHDL created from acoustic_delay_buffer_adb_AStOutput
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

entity acoustic_delay_buffer_adb_AStOutput is
    port (
        in_1_avalonIfaceRole_valid_output_valid : in std_logic_vector(0 downto 0);  -- ufix1
        in_2_avalonIfaceRole_channel_output_channel : in std_logic_vector(7 downto 0);  -- ufix8
        in_3_avalonIfaceRole_data_output_data : in std_logic_vector(31 downto 0);  -- sfix32_en28
        out_1_avalonIfaceRole_valid_source_valid : out std_logic_vector(0 downto 0);  -- ufix1
        out_2_avalonIfaceRole_channel_source_channel : out std_logic_vector(7 downto 0);  -- ufix8
        out_3_avalonIfaceRole_data_source_data : out std_logic_vector(31 downto 0);  -- sfix32_en28
        clk : in std_logic;
        areset : in std_logic
    );
end acoustic_delay_buffer_adb_AStOutput;

architecture normal of acoustic_delay_buffer_adb_AStOutput is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    

begin


    -- ChannelOut(PORTOUT,3)@0 + 1
    out_1_avalonIfaceRole_valid_source_valid <= in_1_avalonIfaceRole_valid_output_valid;
    out_2_avalonIfaceRole_channel_source_channel <= in_2_avalonIfaceRole_channel_output_channel;
    out_3_avalonIfaceRole_data_source_data <= in_3_avalonIfaceRole_data_output_data;

END normal;
