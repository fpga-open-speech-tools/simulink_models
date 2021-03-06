-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\conno\Documents\NIH-GitHub\simulink_models\models\delay_and_sum_beamformer\hdlsrc\DSBF\DSBF_FilterCoef.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: DSBF_FilterCoef
-- Source Path: DSBF/dataplane/Avalon Data Processing/delay signals/delay signal/CIC interpolation compensator/FilterBank/FilterCoef
-- Hierarchy Level: 6
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.DSBF_dataplane_pkg.ALL;

ENTITY DSBF_FilterCoef IS
  PORT( CoefOut                           :   OUT   vector_of_std_logic_vector16(0 TO 18)  -- sfix16_En15 [19]
        );
END DSBF_FilterCoef;


ARCHITECTURE rtl OF DSBF_FilterCoef IS

  -- Signals
  SIGNAL CoefData                         : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_1                       : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_2                       : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_3                       : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_4                       : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_5                       : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_6                       : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_7                       : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_8                       : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_9                       : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_10                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_11                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_12                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_13                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_14                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_15                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_16                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_17                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefData_18                      : signed(15 DOWNTO 0);  -- sfix16_En15
  SIGNAL CoefOut_tmp                      : vector_of_signed16(0 TO 18);  -- sfix16_En15 [19]

BEGIN
  -- CoefReg_1
  CoefData <= to_signed(-16#0056#, 16);

  -- CoefReg_2
  CoefData_1 <= to_signed(16#019A#, 16);

  -- CoefReg_3
  CoefData_2 <= to_signed(-16#0300#, 16);

  -- CoefReg_4
  CoefData_3 <= to_signed(16#036B#, 16);

  -- CoefReg_5
  CoefData_4 <= to_signed(-16#00A3#, 16);

  -- CoefReg_6
  CoefData_5 <= to_signed(-16#06B7#, 16);

  -- CoefReg_7
  CoefData_6 <= to_signed(16#11A7#, 16);

  -- CoefReg_8
  CoefData_7 <= to_signed(-16#1AD2#, 16);

  -- CoefReg_9
  CoefData_8 <= to_signed(16#1261#, 16);

  -- CoefReg_10
  CoefData_9 <= to_signed(16#7934#, 16);

  -- CoefReg_11
  CoefData_10 <= to_signed(16#1261#, 16);

  -- CoefReg_12
  CoefData_11 <= to_signed(-16#1AD2#, 16);

  -- CoefReg_13
  CoefData_12 <= to_signed(16#11A7#, 16);

  -- CoefReg_14
  CoefData_13 <= to_signed(-16#06B7#, 16);

  -- CoefReg_15
  CoefData_14 <= to_signed(-16#00A3#, 16);

  -- CoefReg_16
  CoefData_15 <= to_signed(16#036B#, 16);

  -- CoefReg_17
  CoefData_16 <= to_signed(-16#0300#, 16);

  -- CoefReg_18
  CoefData_17 <= to_signed(16#019A#, 16);

  -- CoefReg_19
  CoefData_18 <= to_signed(-16#0056#, 16);

  CoefOut_tmp(0) <= CoefData;
  CoefOut_tmp(1) <= CoefData_1;
  CoefOut_tmp(2) <= CoefData_2;
  CoefOut_tmp(3) <= CoefData_3;
  CoefOut_tmp(4) <= CoefData_4;
  CoefOut_tmp(5) <= CoefData_5;
  CoefOut_tmp(6) <= CoefData_6;
  CoefOut_tmp(7) <= CoefData_7;
  CoefOut_tmp(8) <= CoefData_8;
  CoefOut_tmp(9) <= CoefData_9;
  CoefOut_tmp(10) <= CoefData_10;
  CoefOut_tmp(11) <= CoefData_11;
  CoefOut_tmp(12) <= CoefData_12;
  CoefOut_tmp(13) <= CoefData_13;
  CoefOut_tmp(14) <= CoefData_14;
  CoefOut_tmp(15) <= CoefData_15;
  CoefOut_tmp(16) <= CoefData_16;
  CoefOut_tmp(17) <= CoefData_17;
  CoefOut_tmp(18) <= CoefData_18;

  outputgen: FOR k IN 0 TO 18 GENERATE
    CoefOut(k) <= std_logic_vector(CoefOut_tmp(k));
  END GENERATE;

END rtl;

