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

-- VHDL created from acoustic_delay_buffer_adb_delay_buffer
-- VHDL created on Fri Apr 05 13:33:36 2019


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.dspba_sim_library_package.all;
entity acoustic_delay_buffer_adb_delay_buffer_atb is
end;

architecture normal of acoustic_delay_buffer_adb_delay_buffer_atb is

component acoustic_delay_buffer_adb_delay_buffer is
    port (
        in_1_valid_in : in std_logic_vector(0 downto 0);  -- ufix1
        in_2_channel_in : in std_logic_vector(7 downto 0);  -- ufix8
        in_3_din : in std_logic_vector(31 downto 0);  -- sfix32_en28
        out_1_valid_out : out std_logic_vector(0 downto 0);  -- ufix1
        out_2_channel_out : out std_logic_vector(7 downto 0);  -- ufix8
        out_3_dout : out std_logic_vector(31 downto 0);  -- sfix32_en28
        in_4_delay_compensation : in std_logic_vector(11 downto 0);  -- ufix12
        clk : in std_logic;
        areset : in std_logic
    );
end component;

component acoustic_delay_buffer_adb_delay_buffer_stm is
    port (
        in_1_valid_in_stm : out std_logic_vector(0 downto 0);
        in_2_channel_in_stm : out std_logic_vector(7 downto 0);
        in_3_din_stm : out std_logic_vector(31 downto 0);
        out_1_valid_out_stm : out std_logic_vector(0 downto 0);
        out_2_channel_out_stm : out std_logic_vector(7 downto 0);
        out_3_dout_stm : out std_logic_vector(31 downto 0);
        in_4_delay_compensation_stm : out std_logic_vector(11 downto 0);
        clk : out std_logic;
        areset : out std_logic
    );
end component;

signal in_1_valid_in_stm : STD_LOGIC_VECTOR (0 downto 0);
signal in_2_channel_in_stm : STD_LOGIC_VECTOR (7 downto 0);
signal in_3_din_stm : STD_LOGIC_VECTOR (31 downto 0);
signal out_1_valid_out_stm : STD_LOGIC_VECTOR (0 downto 0);
signal out_2_channel_out_stm : STD_LOGIC_VECTOR (7 downto 0);
signal out_3_dout_stm : STD_LOGIC_VECTOR (31 downto 0);
signal in_4_delay_compensation_stm : STD_LOGIC_VECTOR (11 downto 0);
signal in_1_valid_in_dut : STD_LOGIC_VECTOR (0 downto 0);
signal in_2_channel_in_dut : STD_LOGIC_VECTOR (7 downto 0);
signal in_3_din_dut : STD_LOGIC_VECTOR (31 downto 0);
signal out_1_valid_out_dut : STD_LOGIC_VECTOR (0 downto 0);
signal out_2_channel_out_dut : STD_LOGIC_VECTOR (7 downto 0);
signal out_3_dout_dut : STD_LOGIC_VECTOR (31 downto 0);
signal in_4_delay_compensation_dut : STD_LOGIC_VECTOR (11 downto 0);
        signal clk : std_logic;
        signal areset : std_logic;

begin

-- Channelized data in real output
checkChannelIn : process (clk, areset, in_3_din_dut, in_3_din_stm)
begin
END PROCESS;


-- Channelized data out check
checkChannelOut : process (clk, areset, out_3_dout_dut, out_3_dout_stm)
variable mismatch_out_1_valid_out : BOOLEAN := FALSE;
variable mismatch_out_2_channel_out : BOOLEAN := FALSE;
variable mismatch_out_3_dout : BOOLEAN := FALSE;
variable ok : BOOLEAN := TRUE;
begin
    IF ((areset = '1')) THEN
        -- do nothing during reset
    ELSIF (clk'EVENT AND clk = '0') THEN -- falling clock edge to avoid transitions
        ok := TRUE;
        mismatch_out_1_valid_out := FALSE;
        mismatch_out_2_channel_out := FALSE;
        mismatch_out_3_dout := FALSE;
        IF ( (out_1_valid_out_dut /= out_1_valid_out_stm)) THEN
            mismatch_out_1_valid_out := TRUE;
            report "mismatch in out_1_valid_out signal" severity Failure;
        END IF;
        IF (out_1_valid_out_dut = "1") THEN
            IF ( (out_2_channel_out_dut /= out_2_channel_out_stm)) THEN
                mismatch_out_2_channel_out := TRUE;
                report "mismatch in out_2_channel_out signal" severity Warning;
            END IF;
            IF ( (out_3_dout_dut /= out_3_dout_stm)) THEN
                mismatch_out_3_dout := TRUE;
                report "mismatch in out_3_dout signal" severity Warning;
            END IF;
        END IF;
        IF (mismatch_out_1_valid_out = TRUE or mismatch_out_2_channel_out = TRUE or mismatch_out_3_dout = TRUE) THEN
            ok := FALSE;
        END IF;
        IF (ok = FALSE) THEN
            report "Mismatch detected" severity Failure;
        END IF;
    END IF;
END PROCESS;


-- General Purpose data in real output
checkGPIn : process (clk, areset, in_4_delay_compensation_dut, in_4_delay_compensation_stm)
begin
END PROCESS;


dut : acoustic_delay_buffer_adb_delay_buffer port map (
    in_1_valid_in_stm,
    in_2_channel_in_stm,
    in_3_din_stm,
    out_1_valid_out_dut,
    out_2_channel_out_dut,
    out_3_dout_dut,
    in_4_delay_compensation_stm,
        clk,
        areset
);

sim : acoustic_delay_buffer_adb_delay_buffer_stm port map (
    in_1_valid_in_stm,
    in_2_channel_in_stm,
    in_3_din_stm,
    out_1_valid_out_stm,
    out_2_channel_out_stm,
    out_3_dout_stm,
    in_4_delay_compensation_stm,
        clk,
        areset
);

end normal;
