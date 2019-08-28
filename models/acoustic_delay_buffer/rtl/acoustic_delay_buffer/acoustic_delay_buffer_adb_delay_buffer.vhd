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

entity acoustic_delay_buffer_adb_delay_buffer is
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
end acoustic_delay_buffer_adb_delay_buffer;

architecture normal of acoustic_delay_buffer_adb_delay_buffer is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_PostCast_primWireOut_sel_x_b : STD_LOGIC_VECTOR (7 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_a : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_b : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_o : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_q : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_CmpEQ1_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Const1_x_q : STD_LOGIC_VECTOR (7 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Const3_x_q : STD_LOGIC_VECTOR (4 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_cnt : UNSIGNED (4 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_dec : UNSIGNED (4 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_dn : UNSIGNED (5 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_en : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_i : STD_LOGIC_VECTOR (4 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_inc : UNSIGNED (4 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_l : STD_LOGIC_VECTOR (4 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_ld : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_q : STD_LOGIC_VECTOR (4 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_s : STD_LOGIC_VECTOR (4 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_up : UNSIGNED (4 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Select1_x_q : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_a : STD_LOGIC_VECTOR (7 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_b : STD_LOGIC_VECTOR (7 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_o : STD_LOGIC_VECTOR (7 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_q : STD_LOGIC_VECTOR (7 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_reset0 : std_logic;
    signal acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_ia : STD_LOGIC_VECTOR (31 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_aa : STD_LOGIC_VECTOR (11 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_ab : STD_LOGIC_VECTOR (11 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_iq : STD_LOGIC_VECTOR (31 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_q : STD_LOGIC_VECTOR (31 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_Const2_x_q : STD_LOGIC_VECTOR (11 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_Const4_x_q : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_cnt : UNSIGNED (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_dec : UNSIGNED (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_dn : UNSIGNED (13 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_en : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_i : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_inc : UNSIGNED (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_l : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_ld : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_q : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_s : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_up : UNSIGNED (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_cnt : UNSIGNED (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_dec : UNSIGNED (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_dn : UNSIGNED (13 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_en : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_i : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_inc : UNSIGNED (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_l : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_ld : STD_LOGIC_VECTOR (0 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_q : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_s : STD_LOGIC_VECTOR (12 downto 0);
    signal acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_up : UNSIGNED (12 downto 0);
    signal CmpNE_q : STD_LOGIC_VECTOR (0 downto 0);
    signal Or_rsrvd_fix_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal Or_rsrvd_fix_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist0_GPIn_in_4_delay_compensation_1_q : STD_LOGIC_VECTOR (11 downto 0);
    signal redist1_CmpNE_q_1_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist2_CmpNE_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist3_ChannelIn_in_1_valid_in_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist4_ChannelIn_in_2_channel_in_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist6_acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_q_2_q : STD_LOGIC_VECTOR (12 downto 0);
    signal redist7_acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_q_1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist8_acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_q_3_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist9_acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x_q_4_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_ChannelIn_in_3_din_3_mem_reset0 : std_logic;
    signal redist5_ChannelIn_in_3_din_3_mem_ia : STD_LOGIC_VECTOR (31 downto 0);
    signal redist5_ChannelIn_in_3_din_3_mem_aa : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_ChannelIn_in_3_din_3_mem_ab : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_ChannelIn_in_3_din_3_mem_iq : STD_LOGIC_VECTOR (31 downto 0);
    signal redist5_ChannelIn_in_3_din_3_mem_q : STD_LOGIC_VECTOR (31 downto 0);
    signal redist5_ChannelIn_in_3_din_3_rdcnt_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_ChannelIn_in_3_din_3_rdcnt_i : UNSIGNED (0 downto 0);
    attribute preserve : boolean;
    attribute preserve of redist5_ChannelIn_in_3_din_3_rdcnt_i : signal is true;
    signal redist5_ChannelIn_in_3_din_3_wraddr_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_ChannelIn_in_3_din_3_cmpReg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_ChannelIn_in_3_din_3_notEnable_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_ChannelIn_in_3_din_3_nor_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist5_ChannelIn_in_3_din_3_sticky_ena_q : STD_LOGIC_VECTOR (0 downto 0);
    attribute preserve_syn_only : boolean;
    attribute preserve_syn_only of redist5_ChannelIn_in_3_din_3_sticky_ena_q : signal is true;
    signal redist5_ChannelIn_in_3_din_3_enaAnd_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_Const4_x(CONSTANT,26)
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_Const4_x_q <= "1000000000000";

    -- acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_Const2_x(CONSTANT,24)
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_Const2_x_q <= "111111111111";

    -- redist0_GPIn_in_4_delay_compensation_1(DELAY,47)
    redist0_GPIn_in_4_delay_compensation_1 : dspba_delay
    GENERIC MAP ( width => 12, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => in_4_delay_compensation, xout => redist0_GPIn_in_4_delay_compensation_1_q, clk => clk, aclr => areset );

    -- CmpNE(LOGICAL,40)@0
    CmpNE_q <= "1" WHEN redist0_GPIn_in_4_delay_compensation_1_q /= in_4_delay_compensation ELSE "0";

    -- redist1_CmpNE_q_1(DELAY,48)
    redist1_CmpNE_q_1 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => CmpNE_q, xout => redist1_CmpNE_q_1_q, clk => clk, aclr => areset );

    -- redist2_CmpNE_q_2(DELAY,49)
    redist2_CmpNE_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => redist1_CmpNE_q_1_q, xout => redist2_CmpNE_q_2_q, clk => clk, aclr => areset );

    -- redist3_ChannelIn_in_1_valid_in_2(DELAY,50)
    redist3_ChannelIn_in_1_valid_in_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => in_1_valid_in, xout => redist3_ChannelIn_in_1_valid_in_2_q, clk => clk, aclr => areset );

    -- acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x(ADD,5)@1
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_a <= STD_LOGIC_VECTOR("000000000000" & VCC_q);
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_b <= STD_LOGIC_VECTOR("0" & redist0_GPIn_in_4_delay_compensation_1_q);
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_o <= STD_LOGIC_VECTOR(UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_a) + UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_b));
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_q <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_o(12 downto 0);

    -- acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x(LOADABLECOUNTER,34)@0 + 1
    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_en <= in_1_valid_in;
    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_ld <= CmpNE_q;
    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_i <= STD_LOGIC_VECTOR("000000000000" & GND_q);
    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_s <= STD_LOGIC_VECTOR("000000000000" & VCC_q);
    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_l <= acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_Const4_x_q;
    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_up <= acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_cnt + acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_inc;
    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_dn <= UNSIGNED(resize(unsigned(acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_cnt(12 downto 0)), 14)) - UNSIGNED(resize(unsigned(acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_dec(12 downto 0)), 14));
    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_cnt <= "0111111111111";
            acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_inc <= "0000000000001";
            acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_dec <= "0111111111111";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_ld = "1") THEN
                IF (FALSE and acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_s(12) = '1') THEN
                    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_inc <= UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_l) + UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_s);
                    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_dec <= UNSIGNED(TO_UNSIGNED(0, 13)) - UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_s);
                ELSE
                    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_inc <= UNSIGNED(TO_UNSIGNED(0, 13)) + UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_s);
                    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_dec <= UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_l) - UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_s);
                END IF;
            END IF;
            IF (acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_ld = "1" or acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_en = "1") THEN
                IF (acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_ld = "1") THEN
                    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_cnt <= UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_i);
                ELSE
                    IF (acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_dn(13) = '1') THEN
                        acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_cnt <= acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_up;
                    ELSE
                        acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_cnt <= acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_dn(12 downto 0);
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_q <= STD_LOGIC_VECTOR(acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_cnt);

    -- acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_CmpEQ1_x(LOGICAL,7)@1
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_CmpEQ1_x_q <= "1" WHEN acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_q = acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Add_x_q ELSE "0";

    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Select1_x(SELECTOR,16)@1 + 1
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Select1_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Select1_x_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Select1_x_q <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Select1_x_q;
            IF (acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_CmpEQ1_x_q = "1") THEN
                acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Select1_x_q <= VCC_q;
            END IF;
            IF (redist1_CmpNE_q_1_q = "1") THEN
                acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Select1_x_q <= GND_q;
            END IF;
        END IF;
    END PROCESS;

    -- acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x(LOGICAL,6)@2
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x_q <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Select1_x_q and redist3_ChannelIn_in_1_valid_in_2_q;

    -- acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x(LOADABLECOUNTER,28)@2 + 1
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_en <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x_q;
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_ld <= redist2_CmpNE_q_2_q;
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_i <= STD_LOGIC_VECTOR("0" & acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_Const2_x_q);
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_s <= STD_LOGIC_VECTOR("000000000000" & VCC_q);
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_l <= acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_Const4_x_q;
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_up <= acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_cnt + acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_inc;
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_dn <= UNSIGNED(resize(unsigned(acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_cnt(12 downto 0)), 14)) - UNSIGNED(resize(unsigned(acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_dec(12 downto 0)), 14));
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_cnt <= "0111111111111";
            acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_inc <= "0000000000001";
            acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_dec <= "0111111111111";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_ld = "1") THEN
                IF (FALSE and acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_s(12) = '1') THEN
                    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_inc <= UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_l) + UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_s);
                    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_dec <= UNSIGNED(TO_UNSIGNED(0, 13)) - UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_s);
                ELSE
                    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_inc <= UNSIGNED(TO_UNSIGNED(0, 13)) + UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_s);
                    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_dec <= UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_l) - UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_s);
                END IF;
            END IF;
            IF (acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_ld = "1" or acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_en = "1") THEN
                IF (acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_ld = "1") THEN
                    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_cnt <= UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_i);
                ELSE
                    IF (acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_dn(13) = '1') THEN
                        acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_cnt <= acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_up;
                    ELSE
                        acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_cnt <= acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_dn(12 downto 0);
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_q <= STD_LOGIC_VECTOR(acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_cnt);

    -- redist5_ChannelIn_in_3_din_3_notEnable(LOGICAL,61)
    redist5_ChannelIn_in_3_din_3_notEnable_q <= STD_LOGIC_VECTOR(not (VCC_q));

    -- redist5_ChannelIn_in_3_din_3_nor(LOGICAL,62)
    redist5_ChannelIn_in_3_din_3_nor_q <= not (redist5_ChannelIn_in_3_din_3_notEnable_q or redist5_ChannelIn_in_3_din_3_sticky_ena_q);

    -- redist5_ChannelIn_in_3_din_3_cmpReg(REG,60)
    redist5_ChannelIn_in_3_din_3_cmpReg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist5_ChannelIn_in_3_din_3_cmpReg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist5_ChannelIn_in_3_din_3_cmpReg_q <= STD_LOGIC_VECTOR(VCC_q);
        END IF;
    END PROCESS;

    -- redist5_ChannelIn_in_3_din_3_sticky_ena(REG,63)
    redist5_ChannelIn_in_3_din_3_sticky_ena_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist5_ChannelIn_in_3_din_3_sticky_ena_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (redist5_ChannelIn_in_3_din_3_nor_q = "1") THEN
                redist5_ChannelIn_in_3_din_3_sticky_ena_q <= STD_LOGIC_VECTOR(redist5_ChannelIn_in_3_din_3_cmpReg_q);
            END IF;
        END IF;
    END PROCESS;

    -- redist5_ChannelIn_in_3_din_3_enaAnd(LOGICAL,64)
    redist5_ChannelIn_in_3_din_3_enaAnd_q <= redist5_ChannelIn_in_3_din_3_sticky_ena_q and VCC_q;

    -- redist5_ChannelIn_in_3_din_3_rdcnt(COUNTER,58)
    -- low=0, high=1, step=1, init=0
    redist5_ChannelIn_in_3_din_3_rdcnt_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist5_ChannelIn_in_3_din_3_rdcnt_i <= TO_UNSIGNED(0, 1);
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist5_ChannelIn_in_3_din_3_rdcnt_i <= redist5_ChannelIn_in_3_din_3_rdcnt_i + 1;
        END IF;
    END PROCESS;
    redist5_ChannelIn_in_3_din_3_rdcnt_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(redist5_ChannelIn_in_3_din_3_rdcnt_i, 1)));

    -- redist5_ChannelIn_in_3_din_3_wraddr(REG,59)
    redist5_ChannelIn_in_3_din_3_wraddr_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            redist5_ChannelIn_in_3_din_3_wraddr_q <= "1";
        ELSIF (clk'EVENT AND clk = '1') THEN
            redist5_ChannelIn_in_3_din_3_wraddr_q <= STD_LOGIC_VECTOR(redist5_ChannelIn_in_3_din_3_rdcnt_q);
        END IF;
    END PROCESS;

    -- redist5_ChannelIn_in_3_din_3_mem(DUALMEM,57)
    redist5_ChannelIn_in_3_din_3_mem_ia <= STD_LOGIC_VECTOR(in_3_din);
    redist5_ChannelIn_in_3_din_3_mem_aa <= redist5_ChannelIn_in_3_din_3_wraddr_q;
    redist5_ChannelIn_in_3_din_3_mem_ab <= redist5_ChannelIn_in_3_din_3_rdcnt_q;
    redist5_ChannelIn_in_3_din_3_mem_reset0 <= areset;
    redist5_ChannelIn_in_3_din_3_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 32,
        widthad_a => 1,
        numwords_a => 2,
        width_b => 32,
        widthad_b => 1,
        numwords_b => 2,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK1",
        outdata_aclr_b => "CLEAR1",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "TRUE",
        intended_device_family => "Arria 10"
    )
    PORT MAP (
        clocken1 => redist5_ChannelIn_in_3_din_3_enaAnd_q(0),
        clocken0 => VCC_q(0),
        clock0 => clk,
        aclr1 => redist5_ChannelIn_in_3_din_3_mem_reset0,
        clock1 => clk,
        address_a => redist5_ChannelIn_in_3_din_3_mem_aa,
        data_a => redist5_ChannelIn_in_3_din_3_mem_ia,
        wren_a => VCC_q(0),
        address_b => redist5_ChannelIn_in_3_din_3_mem_ab,
        q_b => redist5_ChannelIn_in_3_din_3_mem_iq
    );
    redist5_ChannelIn_in_3_din_3_mem_q <= redist5_ChannelIn_in_3_din_3_mem_iq(31 downto 0);

    -- Or_rsrvd_fix(LOGICAL,42)@2 + 1
    Or_rsrvd_fix_qi <= redist3_ChannelIn_in_1_valid_in_2_q or redist2_CmpNE_q_2_q;
    Or_rsrvd_fix_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => Or_rsrvd_fix_qi, xout => Or_rsrvd_fix_q, clk => clk, aclr => areset );

    -- redist6_acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_q_2(DELAY,53)
    redist6_acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_q_2 : dspba_delay
    GENERIC MAP ( width => 13, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_q, xout => redist6_acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_q_2_q, clk => clk, aclr => areset );

    -- acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x(DUALMEM,18)@3 + 2
    acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_ia <= STD_LOGIC_VECTOR(redist5_ChannelIn_in_3_din_3_mem_q);
    acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_aa <= redist6_acoustic_delay_buffer_adb_delay_buffer_write_addr_counter_LoadableCounter_x_q_2_q(11 downto 0);
    acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_ab <= acoustic_delay_buffer_adb_delay_buffer_read_addr_counter_LoadableCounter_x_q(11 downto 0);
    acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_reset0 <= areset;
    acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M20K",
        operation_mode => "DUAL_PORT",
        width_a => 32,
        widthad_a => 12,
        numwords_a => 4096,
        width_b => 32,
        widthad_b => 12,
        numwords_b => 4096,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK0",
        outdata_aclr_b => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "FALSE",
        init_file => "D:/trevor/research/NIH_SBIR_R44_DC015443/Audio_Beamforming/hw/library/acoustic_delay_buffer/./rtl/acoustic_delay_buffer/acoustic_delay_buffer_adb_delay_buffer_acoustic_delay_buffer_adb_delay_buffer_ciA0Zbuffer_DualMem_x.hex",
        init_file_layout => "PORT_B",
        intended_device_family => "Arria 10"
    )
    PORT MAP (
        clocken0 => '1',
        aclr0 => acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_reset0,
        clock0 => clk,
        address_a => acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_aa,
        data_a => acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_ia,
        wren_a => Or_rsrvd_fix_q(0),
        address_b => acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_ab,
        q_b => acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_iq
    );
    acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_q <= acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_iq(31 downto 0);

    -- redist7_acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_q_1(DELAY,54)
    redist7_acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_q_1 : dspba_delay
    GENERIC MAP ( width => 32, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_q, xout => redist7_acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_q_1_q, clk => clk, aclr => areset );

    -- acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Const3_x(CONSTANT,11)
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Const3_x_q <= "10000";

    -- acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Const1_x(CONSTANT,9)
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Const1_x_q <= "00000001";

    -- redist4_ChannelIn_in_2_channel_in_2(DELAY,51)
    redist4_ChannelIn_in_2_channel_in_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => in_2_channel_in, xout => redist4_ChannelIn_in_2_channel_in_2_q, clk => clk, aclr => areset );

    -- acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x(SUB,17)@2
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_a <= redist4_ChannelIn_in_2_channel_in_2_q;
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_b <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Const1_x_q;
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_o <= STD_LOGIC_VECTOR(UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_a) - UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_b));
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_q <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_o(7 downto 0);

    -- acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x(LOADABLECOUNTER,14)@2 + 1
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_en <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x_q;
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_ld <= redist2_CmpNE_q_2_q;
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_i <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Sub_x_q(4 downto 0);
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_s <= STD_LOGIC_VECTOR("0000" & VCC_q);
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_l <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_Const3_x_q;
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_up <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_cnt + acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_inc;
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_dn <= UNSIGNED(resize(unsigned(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_cnt(4 downto 0)), 6)) - UNSIGNED(resize(unsigned(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_dec(4 downto 0)), 6));
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_cnt <= "01111";
            acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_inc <= "00001";
            acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_dec <= "01111";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_ld = "1") THEN
                IF (FALSE and acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_s(4) = '1') THEN
                    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_inc <= UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_l) + UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_s);
                    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_dec <= UNSIGNED(TO_UNSIGNED(0, 5)) - UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_s);
                ELSE
                    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_inc <= UNSIGNED(TO_UNSIGNED(0, 5)) + UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_s);
                    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_dec <= UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_l) - UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_s);
                END IF;
            END IF;
            IF (acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_ld = "1" or acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_en = "1") THEN
                IF (acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_ld = "1") THEN
                    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_cnt <= UNSIGNED(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_i);
                ELSE
                    IF (acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_dn(5) = '1') THEN
                        acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_cnt <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_up;
                    ELSE
                        acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_cnt <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_dn(4 downto 0);
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_q <= STD_LOGIC_VECTOR(acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_cnt);

    -- redist8_acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_q_3(DELAY,55)
    redist8_acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_q_3 : dspba_delay
    GENERIC MAP ( width => 5, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_q, xout => redist8_acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_q_3_q, clk => clk, aclr => areset );

    -- acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_PostCast_primWireOut_sel_x(BITSELECT,2)@6
    acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_PostCast_primWireOut_sel_x_b <= std_logic_vector(resize(unsigned(redist8_acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_x_q_3_q(4 downto 0)), 8));

    -- redist9_acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x_q_4(DELAY,56)
    redist9_acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x_q_4 : dspba_delay
    GENERIC MAP ( width => 1, depth => 4, reset_kind => "ASYNC" )
    PORT MAP ( xin => acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x_q, xout => redist9_acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x_q_4_q, clk => clk, aclr => areset );

    -- ChannelOut(PORTOUT,39)@6 + 1
    out_1_valid_out <= redist9_acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_And_x_q_4_q;
    out_2_channel_out <= acoustic_delay_buffer_adb_delay_buffer_channel_valid_generator_LoadableCounter_PostCast_primWireOut_sel_x_b;
    out_3_dout <= redist7_acoustic_delay_buffer_adb_delay_buffer_circular_buffer_DualMem_x_q_1_q;

END normal;
