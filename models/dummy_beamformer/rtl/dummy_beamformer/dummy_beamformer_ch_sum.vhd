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

-- VHDL created from dummy_beamformer_ch_sum
-- VHDL created on Fri Apr 05 13:36:52 2019


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

entity dummy_beamformer_ch_sum is
    port (
        d : in std_logic_vector(31 downto 0);  -- sfix32_en28
        v : in std_logic_vector(0 downto 0);  -- ufix1
        c : in std_logic_vector(7 downto 0);  -- ufix8
        dout : out std_logic_vector(31 downto 0);  -- sfix32_en28
        vout : out std_logic_vector(0 downto 0);  -- ufix1
        cout : out std_logic_vector(7 downto 0);  -- ufix8
        clk : in std_logic;
        areset : in std_logic
    );
end dummy_beamformer_ch_sum;

architecture normal of dummy_beamformer_ch_sum is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    component dummy_beamformer_ch_sum_AStInput is
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


    component dummy_beamformer_ch_sum_AStOutput is
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


    component dummy_beamformer_ch_sum_ch_sum is
        port (
            in_1_d : in std_logic_vector(31 downto 0);  -- Fixed Point
            in_2_v : in std_logic_vector(0 downto 0);  -- Fixed Point
            in_3_c : in std_logic_vector(7 downto 0);  -- Fixed Point
            out_1_dout : out std_logic_vector(31 downto 0);  -- Fixed Point
            out_2_vout : out std_logic_vector(0 downto 0);  -- Fixed Point
            out_3_cout : out std_logic_vector(7 downto 0);  -- Fixed Point
            clk : in std_logic;
            areset : in std_logic
        );
    end component;


    signal AStInput_out_1_avalonIfaceRole_valid_input_valid : STD_LOGIC_VECTOR (0 downto 0);
    signal AStInput_out_2_avalonIfaceRole_channel_input_channel : STD_LOGIC_VECTOR (7 downto 0);
    signal AStInput_out_3_avalonIfaceRole_data_input_data : STD_LOGIC_VECTOR (31 downto 0);
    signal AStOutput_out_1_avalonIfaceRole_valid_source_valid : STD_LOGIC_VECTOR (0 downto 0);
    signal AStOutput_out_2_avalonIfaceRole_channel_source_channel : STD_LOGIC_VECTOR (7 downto 0);
    signal AStOutput_out_3_avalonIfaceRole_data_source_data : STD_LOGIC_VECTOR (31 downto 0);
    signal ch_sum_out_1_dout : STD_LOGIC_VECTOR (31 downto 0);
    signal ch_sum_out_2_vout : STD_LOGIC_VECTOR (0 downto 0);
    signal ch_sum_out_3_cout : STD_LOGIC_VECTOR (7 downto 0);

begin


    -- AStInput(BLACKBOX,2)
    theAStInput : dummy_beamformer_ch_sum_AStInput
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

    -- ch_sum(BLACKBOX,4)
    thech_sum : dummy_beamformer_ch_sum_ch_sum
    PORT MAP (
        in_1_d => AStInput_out_3_avalonIfaceRole_data_input_data,
        in_2_v => AStInput_out_1_avalonIfaceRole_valid_input_valid,
        in_3_c => AStInput_out_2_avalonIfaceRole_channel_input_channel,
        out_1_dout => ch_sum_out_1_dout,
        out_2_vout => ch_sum_out_2_vout,
        out_3_cout => ch_sum_out_3_cout,
        clk => clk,
        areset => areset
    );

    -- AStOutput(BLACKBOX,3)
    theAStOutput : dummy_beamformer_ch_sum_AStOutput
    PORT MAP (
        in_1_avalonIfaceRole_valid_output_valid => ch_sum_out_2_vout,
        in_2_avalonIfaceRole_channel_output_channel => ch_sum_out_3_cout,
        in_3_avalonIfaceRole_data_output_data => ch_sum_out_1_dout,
        out_1_avalonIfaceRole_valid_source_valid => AStOutput_out_1_avalonIfaceRole_valid_source_valid,
        out_2_avalonIfaceRole_channel_source_channel => AStOutput_out_2_avalonIfaceRole_channel_source_channel,
        out_3_avalonIfaceRole_data_source_data => AStOutput_out_3_avalonIfaceRole_data_source_data,
        clk => clk,
        areset => areset
    );

    -- dout(GPOUT,8)
    dout <= AStOutput_out_3_avalonIfaceRole_data_source_data;

    -- vout(GPOUT,9)
    vout <= AStOutput_out_1_avalonIfaceRole_valid_source_valid;

    -- cout(GPOUT,10)
    cout <= AStOutput_out_2_avalonIfaceRole_channel_source_channel;

END normal;
