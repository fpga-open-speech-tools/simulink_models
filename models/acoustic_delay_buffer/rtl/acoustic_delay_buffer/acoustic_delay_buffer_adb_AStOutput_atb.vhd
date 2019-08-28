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
use work.dspba_sim_library_package.all;
entity acoustic_delay_buffer_adb_AStOutput_atb is
end;

architecture normal of acoustic_delay_buffer_adb_AStOutput_atb is

component acoustic_delay_buffer_adb_AStOutput is
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
end component;

component acoustic_delay_buffer_adb_AStOutput_stm is
    port (
        in_1_avalonIfaceRole_valid_output_valid_stm : out std_logic_vector(0 downto 0);
        in_2_avalonIfaceRole_channel_output_channel_stm : out std_logic_vector(7 downto 0);
        in_3_avalonIfaceRole_data_output_data_stm : out std_logic_vector(31 downto 0);
        out_1_avalonIfaceRole_valid_source_valid_stm : out std_logic_vector(0 downto 0);
        out_2_avalonIfaceRole_channel_source_channel_stm : out std_logic_vector(7 downto 0);
        out_3_avalonIfaceRole_data_source_data_stm : out std_logic_vector(31 downto 0);
        clk : out std_logic;
        areset : out std_logic
    );
end component;

signal in_1_avalonIfaceRole_valid_output_valid_stm : STD_LOGIC_VECTOR (0 downto 0);
signal in_2_avalonIfaceRole_channel_output_channel_stm : STD_LOGIC_VECTOR (7 downto 0);
signal in_3_avalonIfaceRole_data_output_data_stm : STD_LOGIC_VECTOR (31 downto 0);
signal out_1_avalonIfaceRole_valid_source_valid_stm : STD_LOGIC_VECTOR (0 downto 0);
signal out_2_avalonIfaceRole_channel_source_channel_stm : STD_LOGIC_VECTOR (7 downto 0);
signal out_3_avalonIfaceRole_data_source_data_stm : STD_LOGIC_VECTOR (31 downto 0);
signal in_1_avalonIfaceRole_valid_output_valid_dut : STD_LOGIC_VECTOR (0 downto 0);
signal in_2_avalonIfaceRole_channel_output_channel_dut : STD_LOGIC_VECTOR (7 downto 0);
signal in_3_avalonIfaceRole_data_output_data_dut : STD_LOGIC_VECTOR (31 downto 0);
signal out_1_avalonIfaceRole_valid_source_valid_dut : STD_LOGIC_VECTOR (0 downto 0);
signal out_2_avalonIfaceRole_channel_source_channel_dut : STD_LOGIC_VECTOR (7 downto 0);
signal out_3_avalonIfaceRole_data_source_data_dut : STD_LOGIC_VECTOR (31 downto 0);
        signal clk : std_logic;
        signal areset : std_logic;

begin

-- Channelized data in real output
checkChannelIn : process (clk, areset, in_3_avalonIfaceRole_data_output_data_dut, in_3_avalonIfaceRole_data_output_data_stm)
begin
END PROCESS;


-- Channelized data out check
checkChannelOut : process (clk, areset, out_3_avalonIfaceRole_data_source_data_dut, out_3_avalonIfaceRole_data_source_data_stm)
variable mismatch_out_1_avalonIfaceRole_valid_source_valid : BOOLEAN := FALSE;
variable mismatch_out_2_avalonIfaceRole_channel_source_channel : BOOLEAN := FALSE;
variable mismatch_out_3_avalonIfaceRole_data_source_data : BOOLEAN := FALSE;
variable ok : BOOLEAN := TRUE;
begin
    IF ((areset = '1')) THEN
        -- do nothing during reset
    ELSIF (clk'EVENT AND clk = '0') THEN -- falling clock edge to avoid transitions
        ok := TRUE;
        mismatch_out_1_avalonIfaceRole_valid_source_valid := FALSE;
        mismatch_out_2_avalonIfaceRole_channel_source_channel := FALSE;
        mismatch_out_3_avalonIfaceRole_data_source_data := FALSE;
        IF ( (out_1_avalonIfaceRole_valid_source_valid_dut /= out_1_avalonIfaceRole_valid_source_valid_stm)) THEN
            mismatch_out_1_avalonIfaceRole_valid_source_valid := TRUE;
            report "mismatch in out_1_avalonIfaceRole_valid_source_valid signal" severity Failure;
        END IF;
        IF (out_1_avalonIfaceRole_valid_source_valid_dut = "1") THEN
            IF ( (out_2_avalonIfaceRole_channel_source_channel_dut /= out_2_avalonIfaceRole_channel_source_channel_stm)) THEN
                mismatch_out_2_avalonIfaceRole_channel_source_channel := TRUE;
                report "mismatch in out_2_avalonIfaceRole_channel_source_channel signal" severity Warning;
            END IF;
            IF ( (out_3_avalonIfaceRole_data_source_data_dut /= out_3_avalonIfaceRole_data_source_data_stm)) THEN
                mismatch_out_3_avalonIfaceRole_data_source_data := TRUE;
                report "mismatch in out_3_avalonIfaceRole_data_source_data signal" severity Warning;
            END IF;
        END IF;
        IF (mismatch_out_1_avalonIfaceRole_valid_source_valid = TRUE or mismatch_out_2_avalonIfaceRole_channel_source_channel = TRUE or mismatch_out_3_avalonIfaceRole_data_source_data = TRUE) THEN
            ok := FALSE;
        END IF;
        IF (ok = FALSE) THEN
            report "Mismatch detected" severity Failure;
        END IF;
    END IF;
END PROCESS;


dut : acoustic_delay_buffer_adb_AStOutput port map (
    in_1_avalonIfaceRole_valid_output_valid_stm,
    in_2_avalonIfaceRole_channel_output_channel_stm,
    in_3_avalonIfaceRole_data_output_data_stm,
    out_1_avalonIfaceRole_valid_source_valid_dut,
    out_2_avalonIfaceRole_channel_source_channel_dut,
    out_3_avalonIfaceRole_data_source_data_dut,
        clk,
        areset
);

sim : acoustic_delay_buffer_adb_AStOutput_stm port map (
    in_1_avalonIfaceRole_valid_output_valid_stm,
    in_2_avalonIfaceRole_channel_output_channel_stm,
    in_3_avalonIfaceRole_data_output_data_stm,
    out_1_avalonIfaceRole_valid_source_valid_stm,
    out_2_avalonIfaceRole_channel_source_channel_stm,
    out_3_avalonIfaceRole_data_source_data_stm,
        clk,
        areset
);

end normal;
