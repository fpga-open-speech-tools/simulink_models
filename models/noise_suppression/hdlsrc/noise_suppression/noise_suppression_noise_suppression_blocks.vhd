-- -------------------------------------------------------------
-- 
-- File Name: /home/trevor/research/NIH_SBIR_R44_DC015443/simulink_models/models/noise_suppression/hdlsrc/noise_suppression/noise_suppression_noise_suppression_blocks.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: noise_suppression_noise_suppression_blocks
-- Source Path: noise_suppression/dataplane/Adaptive_Wiener_Filter Sample Based Filtering/noise suppression blocks
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY noise_suppression_noise_suppression_blocks IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        data_in                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        valid                             :   IN    std_logic;
        noise_variance                    :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En31
        data_out                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END noise_suppression_noise_suppression_blocks;


ARCHITECTURE rtl OF noise_suppression_noise_suppression_blocks IS

  -- Component Declarations
  COMPONENT noise_suppression_noise_suppression
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          noisy_signal                    :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          valid                           :   IN    std_logic;
          noise_variance                  :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32_En31
          estimated_signal                :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : noise_suppression_noise_suppression
    USE ENTITY work.noise_suppression_noise_suppression(rtl);

  -- Signals
  SIGNAL noise_suppression_out1           : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  u_noise_suppression : noise_suppression_noise_suppression
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              noisy_signal => data_in,  -- sfix32_En28
              valid => valid,
              noise_variance => noise_variance,  -- ufix32_En31
              estimated_signal => noise_suppression_out1  -- sfix32_En28
              );

  data_out <= noise_suppression_out1;

END rtl;

