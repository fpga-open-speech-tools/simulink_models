-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\bugsbunny\NIH\simulink_models\models\echo\hdlsrc\SE\SE_echo_block.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: SE_echo_block
-- Source Path: SE/dataplane/Avalon Data Processing/Right Channel Processing/echo
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SE_echo_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        input                             :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        delay                             :   IN    std_logic_vector(14 DOWNTO 0);  -- ufix15
        decay                             :   IN    std_logic_vector(4 DOWNTO 0);  -- ufix5_En4
        Enable_out6                       :   IN    std_logic;
        output                            :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END SE_echo_block;


ARCHITECTURE rtl OF SE_echo_block IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT SE_variable_delay_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          data_in                         :   IN    std_logic_vector(32 DOWNTO 0);  -- sfix33_En28
          delay                           :   IN    std_logic_vector(14 DOWNTO 0);  -- ufix15
          Enable_out6                     :   IN    std_logic;
          data_out                        :   OUT   std_logic_vector(32 DOWNTO 0)  -- sfix33_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : SE_variable_delay_block
    USE ENTITY work.SE_variable_delay_block(rtl);

  -- Signals
  SIGNAL input_signed                     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL decay_unsigned                   : unsigned(4 DOWNTO 0);  -- ufix5_En4
  SIGNAL Product_out1                     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Sum_add_cast                     : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL Sum_add_cast_1                   : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL Sum_out1                         : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL variable_delay_out1              : std_logic_vector(32 DOWNTO 0);  -- ufix33
  SIGNAL variable_delay_out1_signed       : signed(32 DOWNTO 0);  -- sfix33_En28
  SIGNAL Product_cast                     : signed(5 DOWNTO 0);  -- sfix6_En4
  SIGNAL Product_mul_temp                 : signed(38 DOWNTO 0);  -- sfix39_En32
  SIGNAL Product_cast_1                   : signed(37 DOWNTO 0);  -- sfix38_En32

BEGIN
  u_variable_delay : SE_variable_delay_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              data_in => std_logic_vector(Sum_out1),  -- sfix33_En28
              delay => delay,  -- ufix15
              Enable_out6 => Enable_out6,
              data_out => variable_delay_out1  -- sfix33_En28
              );

  input_signed <= signed(input);

  decay_unsigned <= unsigned(decay);

  Sum_add_cast <= resize(Product_out1, 33);
  Sum_add_cast_1 <= resize(input_signed, 33);
  Sum_out1 <= Sum_add_cast + Sum_add_cast_1;

  variable_delay_out1_signed <= signed(variable_delay_out1);

  Product_cast <= signed(resize(decay_unsigned, 6));
  Product_mul_temp <= variable_delay_out1_signed * Product_cast;
  Product_cast_1 <= Product_mul_temp(37 DOWNTO 0);
  Product_out1 <= Product_cast_1(35 DOWNTO 4);

  output <= std_logic_vector(Product_out1);

END rtl;

