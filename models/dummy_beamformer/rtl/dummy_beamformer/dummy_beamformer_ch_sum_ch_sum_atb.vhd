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

-- VHDL created from dummy_beamformer_ch_sum_ch_sum
-- VHDL created on Fri Apr 05 13:36:52 2019


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.dspba_sim_library_package.all;
entity dummy_beamformer_ch_sum_ch_sum_atb is
end;

architecture normal of dummy_beamformer_ch_sum_ch_sum_atb is

component dummy_beamformer_ch_sum_ch_sum is
    port (
        in_2_v : in std_logic_vector(0 downto 0);  -- ufix1
        in_3_c : in std_logic_vector(7 downto 0);  -- ufix8
        in_1_d : in std_logic_vector(31 downto 0);  -- sfix32_en28
        out_2_vout : out std_logic_vector(0 downto 0);  -- ufix1
        out_3_cout : out std_logic_vector(7 downto 0);  -- ufix8
        out_1_dout : out std_logic_vector(31 downto 0);  -- sfix32_en28
        clk : in std_logic;
        areset : in std_logic
    );
end component;

component dummy_beamformer_ch_sum_ch_sum_stm is
    port (
        in_2_v_stm : out std_logic_vector(0 downto 0);
        in_3_c_stm : out std_logic_vector(7 downto 0);
        in_1_d_stm : out std_logic_vector(31 downto 0);
        out_2_vout_stm : out std_logic_vector(0 downto 0);
        out_3_cout_stm : out std_logic_vector(7 downto 0);
        out_1_dout_stm : out std_logic_vector(31 downto 0);
        clk : out std_logic;
        areset : out std_logic
    );
end component;

signal in_2_v_stm : STD_LOGIC_VECTOR (0 downto 0);
signal in_3_c_stm : STD_LOGIC_VECTOR (7 downto 0);
signal in_1_d_stm : STD_LOGIC_VECTOR (31 downto 0);
signal out_2_vout_stm : STD_LOGIC_VECTOR (0 downto 0);
signal out_3_cout_stm : STD_LOGIC_VECTOR (7 downto 0);
signal out_1_dout_stm : STD_LOGIC_VECTOR (31 downto 0);
signal in_2_v_dut : STD_LOGIC_VECTOR (0 downto 0);
signal in_3_c_dut : STD_LOGIC_VECTOR (7 downto 0);
signal in_1_d_dut : STD_LOGIC_VECTOR (31 downto 0);
signal out_2_vout_dut : STD_LOGIC_VECTOR (0 downto 0);
signal out_3_cout_dut : STD_LOGIC_VECTOR (7 downto 0);
signal out_1_dout_dut : STD_LOGIC_VECTOR (31 downto 0);
        signal clk : std_logic;
        signal areset : std_logic;

begin

-- Channelized data in real output
checkChannelIn : process (clk, areset, in_1_d_dut, in_1_d_stm)
begin
END PROCESS;


-- Channelized data out check
checkChannelOut : process (clk, areset, out_1_dout_dut, out_1_dout_stm)
variable mismatch_out_2_vout : BOOLEAN := FALSE;
variable mismatch_out_3_cout : BOOLEAN := FALSE;
variable mismatch_out_1_dout : BOOLEAN := FALSE;
variable ok : BOOLEAN := TRUE;
begin
    IF ((areset = '1')) THEN
        -- do nothing during reset
    ELSIF (clk'EVENT AND clk = '0') THEN -- falling clock edge to avoid transitions
        ok := TRUE;
        mismatch_out_2_vout := FALSE;
        mismatch_out_3_cout := FALSE;
        mismatch_out_1_dout := FALSE;
        IF ( (out_2_vout_dut /= out_2_vout_stm)) THEN
            mismatch_out_2_vout := TRUE;
            report "mismatch in out_2_vout signal" severity Failure;
        END IF;
        IF (out_2_vout_dut = "1") THEN
            IF ( (out_3_cout_dut /= out_3_cout_stm)) THEN
                mismatch_out_3_cout := TRUE;
                report "mismatch in out_3_cout signal" severity Warning;
            END IF;
            IF ( (out_1_dout_dut /= out_1_dout_stm)) THEN
                mismatch_out_1_dout := TRUE;
                report "mismatch in out_1_dout signal" severity Warning;
            END IF;
        END IF;
        IF (mismatch_out_2_vout = TRUE or mismatch_out_3_cout = TRUE or mismatch_out_1_dout = TRUE) THEN
            ok := FALSE;
        END IF;
        IF (ok = FALSE) THEN
            report "Mismatch detected" severity Failure;
        END IF;
    END IF;
END PROCESS;


dut : dummy_beamformer_ch_sum_ch_sum port map (
    in_2_v_stm,
    in_3_c_stm,
    in_1_d_stm,
    out_2_vout_dut,
    out_3_cout_dut,
    out_1_dout_dut,
        clk,
        areset
);

sim : dummy_beamformer_ch_sum_ch_sum_stm port map (
    in_2_v_stm,
    in_3_c_stm,
    in_1_d_stm,
    out_2_vout_stm,
    out_3_cout_stm,
    out_1_dout_stm,
        clk,
        areset
);

end normal;
