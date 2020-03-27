-- -------------------------------------------------------------
-- 
-- File Name: /mnt/data/trevor/research/NIH_SBIR_R44_DC015443/simulink_models/models/delay_and_sum_beamformer/hdlsrc/DSBF/DSBF_Addressable_Delay_Line_block1.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: DSBF_Addressable_Delay_Line_block1
-- Source Path: DSBF/dataplane/Avalon Data Processing/delay signals/delay signal/CIC interpolation compensator/Addressable 
-- Delay Lin
-- Hierarchy Level: 5
-- 
-- Addressable Delay Line
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DSBF_Addressable_Delay_Line_block1 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_2048_0                      :   IN    std_logic;
        dataIn                            :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        validIn                           :   IN    std_logic;
        shiftEn                           :   IN    std_logic;
        rdAddr                            :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        delayLineEnd                      :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        dataOut                           :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END DSBF_Addressable_Delay_Line_block1;


ARCHITECTURE rtl OF DSBF_Addressable_Delay_Line_block1 IS

  -- Signals
  SIGNAL dataIn_signed                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL delayedSignals0                  : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL rdAddr_unsigned                  : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL ZEROCONST                        : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL switchDataOut                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL dataOut_tmp                      : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  dataIn_signed <= signed(dataIn);

  delay0_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayedSignals0 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' AND validIn = '1' THEN
        delayedSignals0 <= dataIn_signed;
      END IF;
    END IF;
  END PROCESS delay0_process;


  delayLineEnd <= std_logic_vector(delayedSignals0);

  rdAddr_unsigned <= unsigned(rdAddr);

  ZEROCONST <= to_signed(0, 32);

  
  switchDataOut <= delayedSignals0 WHEN rdAddr_unsigned = to_unsigned(16#0#, 4) ELSE
      ZEROCONST WHEN rdAddr_unsigned = to_unsigned(16#1#, 4) ELSE
      ZEROCONST WHEN rdAddr_unsigned = to_unsigned(16#2#, 4) ELSE
      ZEROCONST WHEN rdAddr_unsigned = to_unsigned(16#3#, 4) ELSE
      ZEROCONST WHEN rdAddr_unsigned = to_unsigned(16#4#, 4) ELSE
      ZEROCONST WHEN rdAddr_unsigned = to_unsigned(16#5#, 4) ELSE
      ZEROCONST WHEN rdAddr_unsigned = to_unsigned(16#6#, 4) ELSE
      ZEROCONST WHEN rdAddr_unsigned = to_unsigned(16#7#, 4) ELSE
      ZEROCONST WHEN rdAddr_unsigned = to_unsigned(16#8#, 4) ELSE
      ZEROCONST WHEN rdAddr_unsigned = to_unsigned(16#9#, 4) ELSE
      ZEROCONST WHEN rdAddr_unsigned = to_unsigned(16#A#, 4) ELSE
      ZEROCONST;

  dataOutReg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dataOut_tmp <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' THEN
        dataOut_tmp <= switchDataOut;
      END IF;
    END IF;
  END PROCESS dataOutReg_process;


  dataOut <= std_logic_vector(dataOut_tmp);

END rtl;
