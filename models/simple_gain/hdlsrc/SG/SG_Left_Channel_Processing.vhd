-- -------------------------------------------------------------
-- 
-- File Name: /mnt/data/NIH/simulink_models/models/simple_gain/hdlsrc/SG/SG_Left_Channel_Processing.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: SG_Left_Channel_Processing
-- Source Path: SG/dataplane/Avalon Data Processing/Left Channel Processing
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SG_Left_Channel_Processing IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        Left_Data_In                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Left_Gain                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Enable                            :   IN    std_logic;
        Left_Data_Out                     :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END SG_Left_Channel_Processing;


ARCHITECTURE rtl OF SG_Left_Channel_Processing IS

  ATTRIBUTE multstyle : string;

  -- Signals
  SIGNAL Enable_out3                      : std_logic;
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL Enable_out3_1                    : std_logic;
  SIGNAL Left_Data_In_signed              : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Left_Data_In_1                   : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Left_Gain_signed                 : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Left_Gain_1                      : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Product_out1                     : signed(63 DOWNTO 0);  -- sfix64_En56
  SIGNAL Product_out1_1                   : signed(63 DOWNTO 0);  -- sfix64_En56
  SIGNAL Data_Type_Conversion_out1        : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Data_Type_Conversion_out1_bypass : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Data_Type_Conversion_out1_last_value : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- Apply Left Gain
  -- 
  -- An enabled subsystem
  -- This subsystem only runs when the data valid signal is enabled (asserted)
  -- 

  Enable_out3 <= Enable;

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= Enable_out3;
        delayMatch_reg(1) <= delayMatch_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  Enable_out3_1 <= delayMatch_reg(1);

  Left_Data_In_signed <= signed(Left_Data_In);

  HwModeRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Left_Data_In_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Left_Data_In_1 <= Left_Data_In_signed;
      END IF;
    END IF;
  END PROCESS HwModeRegister_process;


  Left_Gain_signed <= signed(Left_Gain);

  HwModeRegister1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Left_Gain_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Left_Gain_1 <= Left_Gain_signed;
      END IF;
    END IF;
  END PROCESS HwModeRegister1_process;


  Product_out1 <= Left_Data_In_1 * Left_Gain_1;

  PipelineRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Product_out1_1 <= to_signed(0, 64);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Product_out1_1 <= Product_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister_process;


  Data_Type_Conversion_out1 <= Product_out1_1(59 DOWNTO 28);

  Left_Data_Out_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Data_Type_Conversion_out1_last_value <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Data_Type_Conversion_out1_last_value <= Data_Type_Conversion_out1_bypass;
      END IF;
    END IF;
  END PROCESS Left_Data_Out_bypass_process;


  
  Data_Type_Conversion_out1_bypass <= Data_Type_Conversion_out1_last_value WHEN Enable_out3_1 = '0' ELSE
      Data_Type_Conversion_out1;

  Left_Data_Out <= std_logic_vector(Data_Type_Conversion_out1_bypass);

END rtl;

