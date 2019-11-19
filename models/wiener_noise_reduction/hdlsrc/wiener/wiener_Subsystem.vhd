-- -------------------------------------------------------------
-- 
-- File Name: /mnt/data/trevor/research/NIH_SBIR_R44_DC015443/simulink_models/models/wiener_noise_reduction/hdlsrc/wiener/wiener_Subsystem.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: wiener_Subsystem
-- Source Path: wiener/dataplane/Adaptive_Wiener_Filter Sample Based Filtering/Left Channel Processing/Subsystem
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY wiener_Subsystem IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        win_mean                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Enable                            :   IN    std_logic;
        left_data_source                  :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END wiener_Subsystem;


ARCHITECTURE rtl OF wiener_Subsystem IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT wiener_wienFilter1
    PORT( winMean                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          left_source_data                :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : wiener_wienFilter1
    USE ENTITY work.wiener_wienFilter1(rtl);

  -- Signals
  SIGNAL Enable_out5                      : std_logic;
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL Enable_out5_1                    : std_logic;
  SIGNAL wienFilter1_out1                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL wienFilter1_out1_signed          : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL wienFilter1_out1_bypass          : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL wienFilter1_out1_last_value      : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- NOTE: wienStats is currently not being used as wienFilter1 just uses the mean as the output for each sample.
  -- 

  -- 
  u_wienFilter1 : wiener_wienFilter1
    PORT MAP( winMean => win_mean,  -- sfix32_En28
              left_source_data => wienFilter1_out1  -- sfix32_En28
              );

  Enable_out5 <= Enable;

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= Enable_out5;
        delayMatch_reg(1) <= delayMatch_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  Enable_out5_1 <= delayMatch_reg(1);

  wienFilter1_out1_signed <= signed(wienFilter1_out1);

  left_data_source_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      wienFilter1_out1_last_value <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        wienFilter1_out1_last_value <= wienFilter1_out1_bypass;
      END IF;
    END IF;
  END PROCESS left_data_source_bypass_process;


  
  wienFilter1_out1_bypass <= wienFilter1_out1_last_value WHEN Enable_out5_1 = '0' ELSE
      wienFilter1_out1_signed;

  left_data_source <= std_logic_vector(wienFilter1_out1_bypass);

END rtl;

