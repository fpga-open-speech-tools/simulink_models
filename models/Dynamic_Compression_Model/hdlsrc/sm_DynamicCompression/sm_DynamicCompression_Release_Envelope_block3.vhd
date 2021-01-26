-- -------------------------------------------------------------
-- 
-- File Name: /home/cb54103/Documents/fpga-open-speech-tools/simulink_models/models/Dynamic_Compression_Model/hdlsrc/sm_DynamicCompression/sm_DynamicCompression_Release_Envelope_block3.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: sm_DynamicCompression_Release_Envelope_block3
-- Source Path: sm_DynamicCompression/dataplane/Avalon Data Processing/Left Channel Processing/recalculate/Nchan_FbankAGC_AID/Compression_5/Compression_Envelope/Release_Envelope
-- Hierarchy Level: 7
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY sm_DynamicCompression_Release_Envelope_block3 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_1024_0                      :   IN    std_logic;
        Curr                              :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Desired                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Enable                            :   IN    std_logic;
        Gain_out                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END sm_DynamicCompression_Release_Envelope_block3;


ARCHITECTURE rtl OF sm_DynamicCompression_Release_Envelope_block3 IS

  -- Signals
  SIGNAL Enable_out3                      : std_logic;
  SIGNAL Desired_signed                   : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Curr_signed                      : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Subtract_sub_cast                : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL Subtract_sub_cast_1              : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL Subtract_out1                    : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL r_rel_5_out1                     : signed(63 DOWNTO 0);  -- sfix64_En60
  SIGNAL Product_mul_temp                 : signed(96 DOWNTO 0);  -- sfix97_En88
  SIGNAL Apply_Envelope                   : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL Subtract1_sub_cast               : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL Subtract1_sub_cast_1             : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL Subtract1_sub_temp               : signed(33 DOWNTO 0);  -- sfix34_En28
  SIGNAL Subtract1_out1                   : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Subtract1_out1_bypass            : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Subtract1_out1_last_value        : signed(31 DOWNTO 0);  -- sfix32_En28

  ATTRIBUTE multstyle : string;

BEGIN
  -- RELEASE
  -- 

  Enable_out3 <= Enable;

  Desired_signed <= signed(Desired);

  Curr_signed <= signed(Curr);

  Subtract_sub_cast <= resize(Desired_signed, 33);
  Subtract_sub_cast_1 <= resize(Curr_signed, 33);
  Subtract_out1 <= Subtract_sub_cast - Subtract_sub_cast_1;

  r_rel_5_out1 <= signed'(X"0FFFCDB351D7C300");

  Product_mul_temp <= Subtract_out1 * r_rel_5_out1;
  Apply_Envelope <= Product_mul_temp(92 DOWNTO 60);

  Subtract1_sub_cast <= resize(Desired_signed, 34);
  Subtract1_sub_cast_1 <= resize(Apply_Envelope, 34);
  Subtract1_sub_temp <= Subtract1_sub_cast - Subtract1_sub_cast_1;
  Subtract1_out1 <= Subtract1_sub_temp(31 DOWNTO 0);

  Gain_out_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Subtract1_out1_last_value <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Subtract1_out1_last_value <= Subtract1_out1_bypass;
      END IF;
    END IF;
  END PROCESS Gain_out_bypass_process;


  
  Subtract1_out1_bypass <= Subtract1_out1_last_value WHEN Enable_out3 = '0' ELSE
      Subtract1_out1;

  Gain_out <= std_logic_vector(Subtract1_out1_bypass);

END rtl;
