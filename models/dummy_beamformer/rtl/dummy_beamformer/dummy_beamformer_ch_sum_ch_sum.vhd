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

entity dummy_beamformer_ch_sum_ch_sum is
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
end dummy_beamformer_ch_sum_ch_sum;

architecture normal of dummy_beamformer_ch_sum_ch_sum is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_0_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_0_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_0_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_1_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_1_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_1_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_2_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_2_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_2_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_3_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_3_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_3_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_4_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_4_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_4_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_5_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_5_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_5_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_6_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_6_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_6_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_7_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_7_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_7_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_8_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_8_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_8_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_9_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_9_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_9_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_10_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_10_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_10_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_11_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_11_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_11_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_12_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_12_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_12_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_13_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_13_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_13_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_14_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_14_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_14_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal Demux_15_decoder_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_15_mux_x_s : STD_LOGIC_VECTOR (0 downto 0);
    signal Demux_15_mux_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal And_rsrvd_fix_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal And_rsrvd_fix_q : STD_LOGIC_VECTOR (0 downto 0);
    signal BitExtract_b : STD_LOGIC_VECTOR (31 downto 0);
    signal CmpEQ_b : STD_LOGIC_VECTOR (7 downto 0);
    signal CmpEQ_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Const_rsrvd_fix_q : STD_LOGIC_VECTOR (7 downto 0);
    signal Const1_q : STD_LOGIC_VECTOR (3 downto 0);
    signal Add_re_add_0_0_a : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_0_b : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_0_o : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_0_q : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_1_a : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_1_b : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_1_o : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_1_q : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_2_a : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_2_b : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_2_o : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_2_q : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_3_a : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_3_b : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_3_o : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_3_q : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_4_a : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_4_b : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_4_o : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_4_q : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_5_a : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_5_b : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_5_o : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_5_q : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_6_a : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_6_b : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_6_o : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_6_q : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_7_a : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_7_b : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_7_o : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_0_7_q : STD_LOGIC_VECTOR (32 downto 0);
    signal Add_re_add_1_0_a : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_0_b : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_0_o : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_0_q : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_1_a : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_1_b : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_1_o : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_1_q : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_2_a : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_2_b : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_2_o : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_2_q : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_3_a : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_3_b : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_3_o : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_1_3_q : STD_LOGIC_VECTOR (33 downto 0);
    signal Add_re_add_2_0_a : STD_LOGIC_VECTOR (34 downto 0);
    signal Add_re_add_2_0_b : STD_LOGIC_VECTOR (34 downto 0);
    signal Add_re_add_2_0_o : STD_LOGIC_VECTOR (34 downto 0);
    signal Add_re_add_2_0_q : STD_LOGIC_VECTOR (34 downto 0);
    signal Add_re_add_2_1_a : STD_LOGIC_VECTOR (34 downto 0);
    signal Add_re_add_2_1_b : STD_LOGIC_VECTOR (34 downto 0);
    signal Add_re_add_2_1_o : STD_LOGIC_VECTOR (34 downto 0);
    signal Add_re_add_2_1_q : STD_LOGIC_VECTOR (34 downto 0);
    signal Add_re_add_3_0_a : STD_LOGIC_VECTOR (35 downto 0);
    signal Add_re_add_3_0_b : STD_LOGIC_VECTOR (35 downto 0);
    signal Add_re_add_3_0_o : STD_LOGIC_VECTOR (35 downto 0);
    signal Add_re_add_3_0_q : STD_LOGIC_VECTOR (35 downto 0);
    signal redist0_ChannelIn_in_1_d_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist1_BitExtract_b_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist2_And_rsrvd_fix_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist3_Demux_15_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist4_Demux_14_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist5_Demux_13_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist6_Demux_12_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist7_Demux_11_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist8_Demux_10_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist9_Demux_9_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist10_Demux_8_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist11_Demux_7_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist12_Demux_6_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist13_Demux_5_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist14_Demux_4_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist15_Demux_3_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist16_Demux_2_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist17_Demux_1_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist18_Demux_0_mux_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);

begin


    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- redist0_ChannelIn_in_1_d_1(DELAY,73)
    redist0_ChannelIn_in_1_d_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => in_1_d, xout => redist0_ChannelIn_in_1_d_1_q, clk => clk, aclr => areset );

    -- redist3_Demux_15_mux_x_q_1(DELAY,76)
    redist3_Demux_15_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_15_mux_x_q, xout => redist3_Demux_15_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_15_decoder_x(DECODE,47)@0 + 1
    Demux_15_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_15_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00001111") THEN
                Demux_15_decoder_x_q <= in_2_v;
            ELSE
                Demux_15_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_15_mux_x(MUX,49)@1
    Demux_15_mux_x_s <= Demux_15_decoder_x_q;
    Demux_15_mux_x_combproc: PROCESS (Demux_15_mux_x_s, redist3_Demux_15_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_15_mux_x_s) IS
            WHEN "0" => Demux_15_mux_x_q <= redist3_Demux_15_mux_x_q_1_q;
            WHEN "1" => Demux_15_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_15_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist4_Demux_14_mux_x_q_1(DELAY,77)
    redist4_Demux_14_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_14_mux_x_q, xout => redist4_Demux_14_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_14_decoder_x(DECODE,44)@0 + 1
    Demux_14_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_14_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00001110") THEN
                Demux_14_decoder_x_q <= in_2_v;
            ELSE
                Demux_14_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_14_mux_x(MUX,46)@1
    Demux_14_mux_x_s <= Demux_14_decoder_x_q;
    Demux_14_mux_x_combproc: PROCESS (Demux_14_mux_x_s, redist4_Demux_14_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_14_mux_x_s) IS
            WHEN "0" => Demux_14_mux_x_q <= redist4_Demux_14_mux_x_q_1_q;
            WHEN "1" => Demux_14_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_14_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- Add_re_add_0_7(ADD,65)@1
    Add_re_add_0_7_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_14_mux_x_q(31)) & Demux_14_mux_x_q));
    Add_re_add_0_7_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_15_mux_x_q(31)) & Demux_15_mux_x_q));
    Add_re_add_0_7_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_0_7_a) + SIGNED(Add_re_add_0_7_b));
    Add_re_add_0_7_q <= Add_re_add_0_7_o(32 downto 0);

    -- redist5_Demux_13_mux_x_q_1(DELAY,78)
    redist5_Demux_13_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_13_mux_x_q, xout => redist5_Demux_13_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_13_decoder_x(DECODE,41)@0 + 1
    Demux_13_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_13_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00001101") THEN
                Demux_13_decoder_x_q <= in_2_v;
            ELSE
                Demux_13_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_13_mux_x(MUX,43)@1
    Demux_13_mux_x_s <= Demux_13_decoder_x_q;
    Demux_13_mux_x_combproc: PROCESS (Demux_13_mux_x_s, redist5_Demux_13_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_13_mux_x_s) IS
            WHEN "0" => Demux_13_mux_x_q <= redist5_Demux_13_mux_x_q_1_q;
            WHEN "1" => Demux_13_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_13_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist6_Demux_12_mux_x_q_1(DELAY,79)
    redist6_Demux_12_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_12_mux_x_q, xout => redist6_Demux_12_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_12_decoder_x(DECODE,38)@0 + 1
    Demux_12_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_12_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00001100") THEN
                Demux_12_decoder_x_q <= in_2_v;
            ELSE
                Demux_12_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_12_mux_x(MUX,40)@1
    Demux_12_mux_x_s <= Demux_12_decoder_x_q;
    Demux_12_mux_x_combproc: PROCESS (Demux_12_mux_x_s, redist6_Demux_12_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_12_mux_x_s) IS
            WHEN "0" => Demux_12_mux_x_q <= redist6_Demux_12_mux_x_q_1_q;
            WHEN "1" => Demux_12_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_12_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- Add_re_add_0_6(ADD,64)@1
    Add_re_add_0_6_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_12_mux_x_q(31)) & Demux_12_mux_x_q));
    Add_re_add_0_6_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_13_mux_x_q(31)) & Demux_13_mux_x_q));
    Add_re_add_0_6_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_0_6_a) + SIGNED(Add_re_add_0_6_b));
    Add_re_add_0_6_q <= Add_re_add_0_6_o(32 downto 0);

    -- Add_re_add_1_3(ADD,69)@1
    Add_re_add_1_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((33 downto 33 => Add_re_add_0_6_q(32)) & Add_re_add_0_6_q));
    Add_re_add_1_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((33 downto 33 => Add_re_add_0_7_q(32)) & Add_re_add_0_7_q));
    Add_re_add_1_3_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_1_3_a) + SIGNED(Add_re_add_1_3_b));
    Add_re_add_1_3_q <= Add_re_add_1_3_o(33 downto 0);

    -- redist7_Demux_11_mux_x_q_1(DELAY,80)
    redist7_Demux_11_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_11_mux_x_q, xout => redist7_Demux_11_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_11_decoder_x(DECODE,35)@0 + 1
    Demux_11_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_11_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00001011") THEN
                Demux_11_decoder_x_q <= in_2_v;
            ELSE
                Demux_11_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_11_mux_x(MUX,37)@1
    Demux_11_mux_x_s <= Demux_11_decoder_x_q;
    Demux_11_mux_x_combproc: PROCESS (Demux_11_mux_x_s, redist7_Demux_11_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_11_mux_x_s) IS
            WHEN "0" => Demux_11_mux_x_q <= redist7_Demux_11_mux_x_q_1_q;
            WHEN "1" => Demux_11_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_11_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist8_Demux_10_mux_x_q_1(DELAY,81)
    redist8_Demux_10_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_10_mux_x_q, xout => redist8_Demux_10_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_10_decoder_x(DECODE,32)@0 + 1
    Demux_10_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_10_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00001010") THEN
                Demux_10_decoder_x_q <= in_2_v;
            ELSE
                Demux_10_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_10_mux_x(MUX,34)@1
    Demux_10_mux_x_s <= Demux_10_decoder_x_q;
    Demux_10_mux_x_combproc: PROCESS (Demux_10_mux_x_s, redist8_Demux_10_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_10_mux_x_s) IS
            WHEN "0" => Demux_10_mux_x_q <= redist8_Demux_10_mux_x_q_1_q;
            WHEN "1" => Demux_10_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_10_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- Add_re_add_0_5(ADD,63)@1
    Add_re_add_0_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_10_mux_x_q(31)) & Demux_10_mux_x_q));
    Add_re_add_0_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_11_mux_x_q(31)) & Demux_11_mux_x_q));
    Add_re_add_0_5_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_0_5_a) + SIGNED(Add_re_add_0_5_b));
    Add_re_add_0_5_q <= Add_re_add_0_5_o(32 downto 0);

    -- redist9_Demux_9_mux_x_q_1(DELAY,82)
    redist9_Demux_9_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_9_mux_x_q, xout => redist9_Demux_9_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_9_decoder_x(DECODE,29)@0 + 1
    Demux_9_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_9_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00001001") THEN
                Demux_9_decoder_x_q <= in_2_v;
            ELSE
                Demux_9_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_9_mux_x(MUX,31)@1
    Demux_9_mux_x_s <= Demux_9_decoder_x_q;
    Demux_9_mux_x_combproc: PROCESS (Demux_9_mux_x_s, redist9_Demux_9_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_9_mux_x_s) IS
            WHEN "0" => Demux_9_mux_x_q <= redist9_Demux_9_mux_x_q_1_q;
            WHEN "1" => Demux_9_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_9_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist10_Demux_8_mux_x_q_1(DELAY,83)
    redist10_Demux_8_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_8_mux_x_q, xout => redist10_Demux_8_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_8_decoder_x(DECODE,26)@0 + 1
    Demux_8_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_8_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00001000") THEN
                Demux_8_decoder_x_q <= in_2_v;
            ELSE
                Demux_8_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_8_mux_x(MUX,28)@1
    Demux_8_mux_x_s <= Demux_8_decoder_x_q;
    Demux_8_mux_x_combproc: PROCESS (Demux_8_mux_x_s, redist10_Demux_8_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_8_mux_x_s) IS
            WHEN "0" => Demux_8_mux_x_q <= redist10_Demux_8_mux_x_q_1_q;
            WHEN "1" => Demux_8_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_8_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- Add_re_add_0_4(ADD,62)@1
    Add_re_add_0_4_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_8_mux_x_q(31)) & Demux_8_mux_x_q));
    Add_re_add_0_4_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_9_mux_x_q(31)) & Demux_9_mux_x_q));
    Add_re_add_0_4_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_0_4_a) + SIGNED(Add_re_add_0_4_b));
    Add_re_add_0_4_q <= Add_re_add_0_4_o(32 downto 0);

    -- Add_re_add_1_2(ADD,68)@1
    Add_re_add_1_2_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((33 downto 33 => Add_re_add_0_4_q(32)) & Add_re_add_0_4_q));
    Add_re_add_1_2_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((33 downto 33 => Add_re_add_0_5_q(32)) & Add_re_add_0_5_q));
    Add_re_add_1_2_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_1_2_a) + SIGNED(Add_re_add_1_2_b));
    Add_re_add_1_2_q <= Add_re_add_1_2_o(33 downto 0);

    -- Add_re_add_2_1(ADD,71)@1
    Add_re_add_2_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 34 => Add_re_add_1_2_q(33)) & Add_re_add_1_2_q));
    Add_re_add_2_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 34 => Add_re_add_1_3_q(33)) & Add_re_add_1_3_q));
    Add_re_add_2_1_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_2_1_a) + SIGNED(Add_re_add_2_1_b));
    Add_re_add_2_1_q <= Add_re_add_2_1_o(34 downto 0);

    -- redist11_Demux_7_mux_x_q_1(DELAY,84)
    redist11_Demux_7_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_7_mux_x_q, xout => redist11_Demux_7_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_7_decoder_x(DECODE,23)@0 + 1
    Demux_7_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_7_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00000111") THEN
                Demux_7_decoder_x_q <= in_2_v;
            ELSE
                Demux_7_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_7_mux_x(MUX,25)@1
    Demux_7_mux_x_s <= Demux_7_decoder_x_q;
    Demux_7_mux_x_combproc: PROCESS (Demux_7_mux_x_s, redist11_Demux_7_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_7_mux_x_s) IS
            WHEN "0" => Demux_7_mux_x_q <= redist11_Demux_7_mux_x_q_1_q;
            WHEN "1" => Demux_7_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_7_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist12_Demux_6_mux_x_q_1(DELAY,85)
    redist12_Demux_6_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_6_mux_x_q, xout => redist12_Demux_6_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_6_decoder_x(DECODE,20)@0 + 1
    Demux_6_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_6_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00000110") THEN
                Demux_6_decoder_x_q <= in_2_v;
            ELSE
                Demux_6_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_6_mux_x(MUX,22)@1
    Demux_6_mux_x_s <= Demux_6_decoder_x_q;
    Demux_6_mux_x_combproc: PROCESS (Demux_6_mux_x_s, redist12_Demux_6_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_6_mux_x_s) IS
            WHEN "0" => Demux_6_mux_x_q <= redist12_Demux_6_mux_x_q_1_q;
            WHEN "1" => Demux_6_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_6_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- Add_re_add_0_3(ADD,61)@1
    Add_re_add_0_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_6_mux_x_q(31)) & Demux_6_mux_x_q));
    Add_re_add_0_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_7_mux_x_q(31)) & Demux_7_mux_x_q));
    Add_re_add_0_3_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_0_3_a) + SIGNED(Add_re_add_0_3_b));
    Add_re_add_0_3_q <= Add_re_add_0_3_o(32 downto 0);

    -- redist13_Demux_5_mux_x_q_1(DELAY,86)
    redist13_Demux_5_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_5_mux_x_q, xout => redist13_Demux_5_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_5_decoder_x(DECODE,17)@0 + 1
    Demux_5_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_5_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00000101") THEN
                Demux_5_decoder_x_q <= in_2_v;
            ELSE
                Demux_5_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_5_mux_x(MUX,19)@1
    Demux_5_mux_x_s <= Demux_5_decoder_x_q;
    Demux_5_mux_x_combproc: PROCESS (Demux_5_mux_x_s, redist13_Demux_5_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_5_mux_x_s) IS
            WHEN "0" => Demux_5_mux_x_q <= redist13_Demux_5_mux_x_q_1_q;
            WHEN "1" => Demux_5_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_5_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist14_Demux_4_mux_x_q_1(DELAY,87)
    redist14_Demux_4_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_4_mux_x_q, xout => redist14_Demux_4_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_4_decoder_x(DECODE,14)@0 + 1
    Demux_4_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_4_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00000100") THEN
                Demux_4_decoder_x_q <= in_2_v;
            ELSE
                Demux_4_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_4_mux_x(MUX,16)@1
    Demux_4_mux_x_s <= Demux_4_decoder_x_q;
    Demux_4_mux_x_combproc: PROCESS (Demux_4_mux_x_s, redist14_Demux_4_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_4_mux_x_s) IS
            WHEN "0" => Demux_4_mux_x_q <= redist14_Demux_4_mux_x_q_1_q;
            WHEN "1" => Demux_4_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_4_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- Add_re_add_0_2(ADD,60)@1
    Add_re_add_0_2_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_4_mux_x_q(31)) & Demux_4_mux_x_q));
    Add_re_add_0_2_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_5_mux_x_q(31)) & Demux_5_mux_x_q));
    Add_re_add_0_2_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_0_2_a) + SIGNED(Add_re_add_0_2_b));
    Add_re_add_0_2_q <= Add_re_add_0_2_o(32 downto 0);

    -- Add_re_add_1_1(ADD,67)@1
    Add_re_add_1_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((33 downto 33 => Add_re_add_0_2_q(32)) & Add_re_add_0_2_q));
    Add_re_add_1_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((33 downto 33 => Add_re_add_0_3_q(32)) & Add_re_add_0_3_q));
    Add_re_add_1_1_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_1_1_a) + SIGNED(Add_re_add_1_1_b));
    Add_re_add_1_1_q <= Add_re_add_1_1_o(33 downto 0);

    -- redist15_Demux_3_mux_x_q_1(DELAY,88)
    redist15_Demux_3_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_3_mux_x_q, xout => redist15_Demux_3_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_3_decoder_x(DECODE,11)@0 + 1
    Demux_3_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_3_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00000011") THEN
                Demux_3_decoder_x_q <= in_2_v;
            ELSE
                Demux_3_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_3_mux_x(MUX,13)@1
    Demux_3_mux_x_s <= Demux_3_decoder_x_q;
    Demux_3_mux_x_combproc: PROCESS (Demux_3_mux_x_s, redist15_Demux_3_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_3_mux_x_s) IS
            WHEN "0" => Demux_3_mux_x_q <= redist15_Demux_3_mux_x_q_1_q;
            WHEN "1" => Demux_3_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_3_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist16_Demux_2_mux_x_q_1(DELAY,89)
    redist16_Demux_2_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_2_mux_x_q, xout => redist16_Demux_2_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_2_decoder_x(DECODE,8)@0 + 1
    Demux_2_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_2_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00000010") THEN
                Demux_2_decoder_x_q <= in_2_v;
            ELSE
                Demux_2_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_2_mux_x(MUX,10)@1
    Demux_2_mux_x_s <= Demux_2_decoder_x_q;
    Demux_2_mux_x_combproc: PROCESS (Demux_2_mux_x_s, redist16_Demux_2_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_2_mux_x_s) IS
            WHEN "0" => Demux_2_mux_x_q <= redist16_Demux_2_mux_x_q_1_q;
            WHEN "1" => Demux_2_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_2_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- Add_re_add_0_1(ADD,59)@1
    Add_re_add_0_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_2_mux_x_q(31)) & Demux_2_mux_x_q));
    Add_re_add_0_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_3_mux_x_q(31)) & Demux_3_mux_x_q));
    Add_re_add_0_1_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_0_1_a) + SIGNED(Add_re_add_0_1_b));
    Add_re_add_0_1_q <= Add_re_add_0_1_o(32 downto 0);

    -- redist17_Demux_1_mux_x_q_1(DELAY,90)
    redist17_Demux_1_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_1_mux_x_q, xout => redist17_Demux_1_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_1_decoder_x(DECODE,5)@0 + 1
    Demux_1_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_1_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00000001") THEN
                Demux_1_decoder_x_q <= in_2_v;
            ELSE
                Demux_1_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_1_mux_x(MUX,7)@1
    Demux_1_mux_x_s <= Demux_1_decoder_x_q;
    Demux_1_mux_x_combproc: PROCESS (Demux_1_mux_x_s, redist17_Demux_1_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_1_mux_x_s) IS
            WHEN "0" => Demux_1_mux_x_q <= redist17_Demux_1_mux_x_q_1_q;
            WHEN "1" => Demux_1_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_1_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- redist18_Demux_0_mux_x_q_1(DELAY,91)
    redist18_Demux_0_mux_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Demux_0_mux_x_q, xout => redist18_Demux_0_mux_x_q_1_q, clk => clk, aclr => areset );

    -- Demux_0_decoder_x(DECODE,2)@0 + 1
    Demux_0_decoder_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            Demux_0_decoder_x_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (in_3_c(7 downto 0) = "00000000") THEN
                Demux_0_decoder_x_q <= in_2_v;
            ELSE
                Demux_0_decoder_x_q <= "0";
            END IF;
        END IF;
    END PROCESS;

    -- Demux_0_mux_x(MUX,4)@1
    Demux_0_mux_x_s <= Demux_0_decoder_x_q;
    Demux_0_mux_x_combproc: PROCESS (Demux_0_mux_x_s, redist18_Demux_0_mux_x_q_1_q, redist0_ChannelIn_in_1_d_1_q)
    BEGIN
        CASE (Demux_0_mux_x_s) IS
            WHEN "0" => Demux_0_mux_x_q <= redist18_Demux_0_mux_x_q_1_q;
            WHEN "1" => Demux_0_mux_x_q <= redist0_ChannelIn_in_1_d_1_q;
            WHEN OTHERS => Demux_0_mux_x_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- Add_re_add_0_0(ADD,58)@1
    Add_re_add_0_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_0_mux_x_q(31)) & Demux_0_mux_x_q));
    Add_re_add_0_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((32 downto 32 => Demux_1_mux_x_q(31)) & Demux_1_mux_x_q));
    Add_re_add_0_0_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_0_0_a) + SIGNED(Add_re_add_0_0_b));
    Add_re_add_0_0_q <= Add_re_add_0_0_o(32 downto 0);

    -- Add_re_add_1_0(ADD,66)@1
    Add_re_add_1_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((33 downto 33 => Add_re_add_0_0_q(32)) & Add_re_add_0_0_q));
    Add_re_add_1_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((33 downto 33 => Add_re_add_0_1_q(32)) & Add_re_add_0_1_q));
    Add_re_add_1_0_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_1_0_a) + SIGNED(Add_re_add_1_0_b));
    Add_re_add_1_0_q <= Add_re_add_1_0_o(33 downto 0);

    -- Add_re_add_2_0(ADD,70)@1
    Add_re_add_2_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 34 => Add_re_add_1_0_q(33)) & Add_re_add_1_0_q));
    Add_re_add_2_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((34 downto 34 => Add_re_add_1_1_q(33)) & Add_re_add_1_1_q));
    Add_re_add_2_0_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_2_0_a) + SIGNED(Add_re_add_2_0_b));
    Add_re_add_2_0_q <= Add_re_add_2_0_o(34 downto 0);

    -- Add_re_add_3_0(ADD,72)@1
    Add_re_add_3_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((35 downto 35 => Add_re_add_2_0_q(34)) & Add_re_add_2_0_q));
    Add_re_add_3_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((35 downto 35 => Add_re_add_2_1_q(34)) & Add_re_add_2_1_q));
    Add_re_add_3_0_o <= STD_LOGIC_VECTOR(SIGNED(Add_re_add_3_0_a) + SIGNED(Add_re_add_3_0_b));
    Add_re_add_3_0_q <= Add_re_add_3_0_o(35 downto 0);

    -- BitExtract(BITSELECT,52)@1
    BitExtract_b <= STD_LOGIC_VECTOR(Add_re_add_3_0_q(35 downto 4));

    -- redist1_BitExtract_b_1(DELAY,74)
    redist1_BitExtract_b_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => BitExtract_b, xout => redist1_BitExtract_b_1_q, clk => clk, aclr => areset );

    -- Const_rsrvd_fix(CONSTANT,56)
    Const_rsrvd_fix_q <= "00000000";

    -- Const1(CONSTANT,57)
    Const1_q <= "1111";

    -- CmpEQ(LOGICAL,55)@0
    CmpEQ_b <= STD_LOGIC_VECTOR("0000" & Const1_q);
    CmpEQ_q <= "1" WHEN in_3_c = CmpEQ_b ELSE "0";

    -- And_rsrvd_fix(LOGICAL,51)@0 + 1
    And_rsrvd_fix_qi <= in_2_v and CmpEQ_q;
    And_rsrvd_fix_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => And_rsrvd_fix_qi, xout => And_rsrvd_fix_q, clk => clk, aclr => areset );

    -- redist2_And_rsrvd_fix_q_2(DELAY,75)
    redist2_And_rsrvd_fix_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => And_rsrvd_fix_q, xout => redist2_And_rsrvd_fix_q_2_q, clk => clk, aclr => areset );

    -- ChannelOut(PORTOUT,54)@2 + 1
    out_2_vout <= redist2_And_rsrvd_fix_q_2_q;
    out_3_cout <= Const_rsrvd_fix_q;
    out_1_dout <= redist1_BitExtract_b_1_q;

END normal;
