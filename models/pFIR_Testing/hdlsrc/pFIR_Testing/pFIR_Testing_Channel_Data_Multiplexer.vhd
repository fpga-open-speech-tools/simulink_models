-- -------------------------------------------------------------
-- 
-- File Name: C:\Flat Earth\fpga-open-speech-tools\simulink_models\models\pFIR_Testing\hdlsrc\pFIR_Testing\pFIR_Testing_Channel_Data_Multiplexer.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: pFIR_Testing_Channel_Data_Multiplexer
-- Source Path: pFIR_Testing/dataplane/Test FIR with Custom FIR Libraries Sample Based Filtering/Channel_Data_Multiplexer
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pFIR_Testing_Channel_Data_Multiplexer IS
  PORT( dataPrev                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        leftData                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        leftValid                         :   IN    std_logic;
        rightData                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        rightValid                        :   IN    std_logic;
        chanPrev                          :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        sourceData                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        sourceChannel                     :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
        sourceValid                       :   OUT   std_logic  -- ufix1
        );
END pFIR_Testing_Channel_Data_Multiplexer;


ARCHITECTURE rtl OF pFIR_Testing_Channel_Data_Multiplexer IS

  ATTRIBUTE multstyle : string;

  -- Signals
  SIGNAL dataPrev_signed                  : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL leftData_signed                  : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL rightData_signed                 : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL chanPrev_unsigned                : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL sourceData_tmp                   : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL sourceChannel_tmp                : unsigned(1 DOWNTO 0);  -- ufix2

BEGIN
  dataPrev_signed <= signed(dataPrev);

  leftData_signed <= signed(leftData);

  rightData_signed <= signed(rightData);

  chanPrev_unsigned <= unsigned(chanPrev);

  Channel_Data_Multiplexer_output : PROCESS (chanPrev_unsigned, dataPrev_signed, leftData_signed, leftValid,
       rightData_signed, rightValid)
  BEGIN
    --MATLAB Function 'dataplane/Test FIR with Custom FIR Libraries Sample Based Filtering/Channel_Data_Multiplexer': '<S9>:1'
    IF leftValid = '1' THEN 
      --'<S9>:1:3'
      -- left channel ready
      --'<S9>:1:4'
      sourceData_tmp <= leftData_signed;
      --'<S9>:1:5'
      sourceChannel_tmp <= to_unsigned(16#0#, 2);
      --'<S9>:1:6'
      sourceValid <= '1';
    ELSIF rightValid = '1' THEN 
      --'<S9>:1:7'
      -- right channel ready 
      --'<S9>:1:8'
      sourceData_tmp <= rightData_signed;
      --'<S9>:1:9'
      sourceChannel_tmp <= to_unsigned(16#1#, 2);
      --'<S9>:1:10'
      sourceValid <= '1';
    ELSE 
      -- neither channel output is ready
      --'<S9>:1:12'
      sourceData_tmp <= dataPrev_signed;
      --'<S9>:1:13'
      sourceChannel_tmp <= chanPrev_unsigned;
      --'<S9>:1:14'
      sourceValid <= '0';
    END IF;
  END PROCESS Channel_Data_Multiplexer_output;


  sourceData <= std_logic_vector(sourceData_tmp);

  sourceChannel <= std_logic_vector(sourceChannel_tmp);

END rtl;
