-- -------------------------------------------------------------
-- 
-- File Name: /home/cb54103/Documents/fpga-open-speech-tools/simulink_models/models/Dynamic_Compression_Model/hdlsrc/sm_DynamicCompression/sm_DynamicCompression_Compression_Envelope_block1.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: sm_DynamicCompression_Compression_Envelope_block1
-- Source Path: sm_DynamicCompression/dataplane/Avalon Data Processing/Left Channel Processing/recalculate/Nchan_FbankAGC_AID/Compression_3/Compression_Envelope
-- Hierarchy Level: 6
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY sm_DynamicCompression_Compression_Envelope_block1 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_1024_0                      :   IN    std_logic;
        Desired_Gain                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Curr_Gain                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Gain_Out                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END sm_DynamicCompression_Compression_Envelope_block1;


ARCHITECTURE rtl OF sm_DynamicCompression_Compression_Envelope_block1 IS

  -- Component Declarations
  COMPONENT sm_DynamicCompression_Release_Envelope_block1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          Curr                            :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Desired                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Enable                          :   IN    std_logic;
          Gain_out                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Attack_Envelope_block1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          Curr                            :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Desired                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Enable                          :   IN    std_logic;
          Gain_out                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : sm_DynamicCompression_Release_Envelope_block1
    USE ENTITY work.sm_DynamicCompression_Release_Envelope_block1(rtl);

  FOR ALL : sm_DynamicCompression_Attack_Envelope_block1
    USE ENTITY work.sm_DynamicCompression_Attack_Envelope_block1(rtl);

  -- Signals
  SIGNAL Curr_Gain_signed                 : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Desired_Gain_signed              : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Subtract_out1                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Compare_To_Zero_out1             : std_logic;
  SIGNAL Logical_Operator_out1            : std_logic;
  SIGNAL switch_compare_1                 : std_logic;
  SIGNAL Release_Envelope_out1            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Release_Envelope_out1_signed     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Attack_Envelope_out1             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Attack_Envelope_out1_signed      : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Switch_out1                      : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- Curr > Desired:
  -- Attack 
  -- 
  -- Curr < Desired:
  -- Release 

  u_Release_Envelope : sm_DynamicCompression_Release_Envelope_block1
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              Curr => Curr_Gain,  -- sfix32_En28
              Desired => Desired_Gain,  -- sfix32_En28
              Enable => Logical_Operator_out1,
              Gain_out => Release_Envelope_out1  -- sfix32_En28
              );

  u_Attack_Envelope : sm_DynamicCompression_Attack_Envelope_block1
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              Curr => Curr_Gain,  -- sfix32_En28
              Desired => Desired_Gain,  -- sfix32_En28
              Enable => Compare_To_Zero_out1,
              Gain_out => Attack_Envelope_out1  -- sfix32_En28
              );

  Curr_Gain_signed <= signed(Curr_Gain);

  Desired_Gain_signed <= signed(Desired_Gain);

  Subtract_out1 <= Curr_Gain_signed - Desired_Gain_signed;

  
  Compare_To_Zero_out1 <= '1' WHEN Subtract_out1 >= to_signed(0, 32) ELSE
      '0';

  Logical_Operator_out1 <=  NOT Compare_To_Zero_out1;

  
  switch_compare_1 <= '1' WHEN Subtract_out1 >= to_signed(0, 32) ELSE
      '0';

  Release_Envelope_out1_signed <= signed(Release_Envelope_out1);

  Attack_Envelope_out1_signed <= signed(Attack_Envelope_out1);

  
  Switch_out1 <= Release_Envelope_out1_signed WHEN switch_compare_1 = '0' ELSE
      Attack_Envelope_out1_signed;

  Gain_Out <= std_logic_vector(Switch_out1);

END rtl;

