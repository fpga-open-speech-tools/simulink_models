-- -------------------------------------------------------------
-- 
-- File Name: /home/cb54103/Documents/fpga-open-speech-tools/simulink_models/models/Dynamic_Compression_Model/hdlsrc/sm_DynamicCompression/sm_DynamicCompression_LSL_N_block3.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: sm_DynamicCompression_LSL_N_block3
-- Source Path: sm_DynamicCompression/dataplane/Avalon Data Processing/Left Channel Processing/recalculate/Nchan_FbankAGC_AID/Compression_3/Compression_Gain_Calc/Linear_Approximation/LSL(N)
-- Hierarchy Level: 8
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY sm_DynamicCompression_LSL_N_block3 IS
  PORT( NShifts                           :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        x_in                              :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
        x_shifted                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- uint32
        );
END sm_DynamicCompression_LSL_N_block3;


ARCHITECTURE rtl OF sm_DynamicCompression_LSL_N_block3 IS

  -- Signals
  SIGNAL NShifts_unsigned                 : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL x_in_unsigned                    : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate_out1                  : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate1_out1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate2_out1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate3_out1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate4_out1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate5_out1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate6_out1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate7_out1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate8_out1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate9_out1                 : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate10_out1                : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate11_out1                : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate12_out1                : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate13_out1                : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Bit_Rotate14_out1                : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Multiport_Switch_out1            : unsigned(31 DOWNTO 0);  -- uint32

BEGIN
  NShifts_unsigned <= unsigned(NShifts);

  x_in_unsigned <= unsigned(x_in);

  Bit_Rotate_out1 <= x_in_unsigned rol 1;

  Bit_Rotate1_out1 <= x_in_unsigned rol 2;

  Bit_Rotate2_out1 <= x_in_unsigned rol 3;

  Bit_Rotate3_out1 <= x_in_unsigned rol 4;

  Bit_Rotate4_out1 <= x_in_unsigned rol 5;

  Bit_Rotate5_out1 <= x_in_unsigned rol 6;

  Bit_Rotate6_out1 <= x_in_unsigned rol 7;

  Bit_Rotate7_out1 <= x_in_unsigned rol 8;

  Bit_Rotate8_out1 <= x_in_unsigned rol 9;

  Bit_Rotate9_out1 <= x_in_unsigned rol 10;

  Bit_Rotate10_out1 <= x_in_unsigned rol 11;

  Bit_Rotate11_out1 <= x_in_unsigned rol 12;

  Bit_Rotate12_out1 <= x_in_unsigned rol 13;

  Bit_Rotate13_out1 <= x_in_unsigned rol 14;

  Bit_Rotate14_out1 <= x_in_unsigned rol 15;

  
  Multiport_Switch_out1 <= x_in_unsigned WHEN NShifts_unsigned = to_unsigned(16#0#, 4) ELSE
      Bit_Rotate_out1 WHEN NShifts_unsigned = to_unsigned(16#1#, 4) ELSE
      Bit_Rotate1_out1 WHEN NShifts_unsigned = to_unsigned(16#2#, 4) ELSE
      Bit_Rotate2_out1 WHEN NShifts_unsigned = to_unsigned(16#3#, 4) ELSE
      Bit_Rotate3_out1 WHEN NShifts_unsigned = to_unsigned(16#4#, 4) ELSE
      Bit_Rotate4_out1 WHEN NShifts_unsigned = to_unsigned(16#5#, 4) ELSE
      Bit_Rotate5_out1 WHEN NShifts_unsigned = to_unsigned(16#6#, 4) ELSE
      Bit_Rotate6_out1 WHEN NShifts_unsigned = to_unsigned(16#7#, 4) ELSE
      Bit_Rotate7_out1 WHEN NShifts_unsigned = to_unsigned(16#8#, 4) ELSE
      Bit_Rotate8_out1 WHEN NShifts_unsigned = to_unsigned(16#9#, 4) ELSE
      Bit_Rotate9_out1 WHEN NShifts_unsigned = to_unsigned(16#A#, 4) ELSE
      Bit_Rotate10_out1 WHEN NShifts_unsigned = to_unsigned(16#B#, 4) ELSE
      Bit_Rotate11_out1 WHEN NShifts_unsigned = to_unsigned(16#C#, 4) ELSE
      Bit_Rotate12_out1 WHEN NShifts_unsigned = to_unsigned(16#D#, 4) ELSE
      Bit_Rotate13_out1 WHEN NShifts_unsigned = to_unsigned(16#E#, 4) ELSE
      Bit_Rotate14_out1;

  x_shifted <= std_logic_vector(Multiport_Switch_out1);

END rtl;

