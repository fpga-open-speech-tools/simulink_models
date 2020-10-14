-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\wickh\Documents\NIH\Review\simulink_models\models\fft_filters\hdlsrc\fft_filters\fft_filters_FFT_Frame_Pulse_Gen_block.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: fft_filters_FFT_Frame_Pulse_Gen_block
-- Source Path: fft_filters/dataplane/FFT_Analysis_Synthesis_Right/Analysis/FFT Frame Buffering/FFT_pulse_gen/FFT_Frame_Pulse_Gen
-- Hierarchy Level: 5
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY fft_filters_FFT_Frame_Pulse_Gen_block IS
  PORT( counter_value                     :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        Frame_Pulse                       :   OUT   std_logic
        );
END fft_filters_FFT_Frame_Pulse_Gen_block;


ARCHITECTURE rtl OF fft_filters_FFT_Frame_Pulse_Gen_block IS

  -- Signals
  SIGNAL counter_value_unsigned           : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Bit_Slice_out1                   : unsigned(4 DOWNTO 0);  -- ufix5
  SIGNAL Compare_To_Zero_out1             : std_logic;

BEGIN
  -- Create a FFT frame pulse that happens every FFT_size/4 samples.
  -- We do this by watching when an appropriate subset of the counter bits 
  -- become zero.

  counter_value_unsigned <= unsigned(counter_value);

  Bit_Slice_out1 <= counter_value_unsigned(4 DOWNTO 0);

  
  Compare_To_Zero_out1 <= '1' WHEN Bit_Slice_out1 = to_unsigned(16#00#, 5) ELSE
      '0';

  Frame_Pulse <= Compare_To_Zero_out1;

END rtl;

