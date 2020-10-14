-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\wickh\Documents\NIH\Review\simulink_models\models\fft_filters\hdlsrc\fft_filters\fft_filters_Fast_Transition_block.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: fft_filters_Fast_Transition_block
-- Source Path: fft_filters/dataplane/FFT_Analysis_Synthesis_Right/Analysis/FFT Frame Buffering/Fast_Transition
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY fft_filters_Fast_Transition_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_2048_0                      :   IN    std_logic;
        enb_1_16_1                        :   IN    std_logic;
        enb_1_2048_1                      :   IN    std_logic;
        Slow_Pulse                        :   IN    std_logic;
        Slow_Enable                       :   IN    std_logic;
        Slow_Passthrough                  :   IN    std_logic;
        Slow_select                       :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        Fast_Pulse                        :   OUT   std_logic;
        Fast_Enable                       :   OUT   std_logic;
        Fast_Passthrough                  :   OUT   std_logic;
        Fast_select                       :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
        );
END fft_filters_Fast_Transition_block;


ARCHITECTURE rtl OF fft_filters_Fast_Transition_block IS

  -- Signals
  SIGNAL Upsample_zero                    : std_logic;
  SIGNAL Upsample_muxout                  : std_logic;
  SIGNAL Upsample_bypass_reg              : std_logic;  -- ufix1
  SIGNAL Upsample_bypassout               : std_logic;
  SIGNAL Rate_Transition_out1             : std_logic;
  SIGNAL Rate_Transition1_out1            : std_logic;
  SIGNAL Slow_select_unsigned             : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL Rate_Transition2_out1            : unsigned(1 DOWNTO 0);  -- ufix2

BEGIN
  -- The upsample block inserts zeros between samples.
  -- We want the pulse only one clock period wide at the 
  -- faster clock rate, so inserting zeros is what we want.
  -- 
  -- Transistion Signals to Fast Clock Rate
  -- 
  -- The rate transition block registers and keeps the same 
  -- value.  We want the enable signal to always be enabled, 
  -- so keeping the same value using the unit delay is what we want.
  -- 
  -- The rate transition block registers and keeps the same 
  -- value.  We want the enable signal to always be enabled, 
  -- so keeping the same value using the unit delay is what we want.
  -- 
  -- The rate transition block registers and keeps the same 
  -- value.  We want the enable signal to always be enabled, 
  -- so keeping the same value using the unit delay is what we want.

  -- Upsample: Upsample by 128, Sample offset 0 
  Upsample_zero <= '0';

  
  Upsample_muxout <= Slow_Pulse WHEN enb_1_2048_1 = '1' ELSE
      Upsample_zero;

  -- Upsample bypass register
  Upsample_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Upsample_bypass_reg <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_1 = '1' THEN
        Upsample_bypass_reg <= Upsample_muxout;
      END IF;
    END IF;
  END PROCESS Upsample_bypass_process;

  
  Upsample_bypassout <= Upsample_muxout WHEN enb_1_16_1 = '1' ELSE
      Upsample_bypass_reg;

  Rate_Transition_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' THEN
        Rate_Transition_out1 <= Slow_Enable;
      END IF;
    END IF;
  END PROCESS Rate_Transition_process;


  Rate_Transition1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition1_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' THEN
        Rate_Transition1_out1 <= Slow_Passthrough;
      END IF;
    END IF;
  END PROCESS Rate_Transition1_process;


  Slow_select_unsigned <= unsigned(Slow_select);

  Rate_Transition2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition2_out1 <= to_unsigned(16#3#, 2);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' THEN
        Rate_Transition2_out1 <= Slow_select_unsigned;
      END IF;
    END IF;
  END PROCESS Rate_Transition2_process;


  Fast_select <= std_logic_vector(Rate_Transition2_out1);

  Fast_Pulse <= Upsample_bypassout;

  Fast_Enable <= Rate_Transition_out1;

  Fast_Passthrough <= Rate_Transition1_out1;

END rtl;

