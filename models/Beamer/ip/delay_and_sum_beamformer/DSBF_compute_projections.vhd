-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\conno\Documents\NIH-GitHub\simulink_models\models\delay_and_sum_beamformer\hdlsrc\DSBF\DSBF_compute_projections.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: DSBF_compute_projections
-- Source Path: DSBF/dataplane/compute projections
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DSBF_compute_projections IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        azimuth                           :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En8
        elevation                         :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En8
        sin_azimuth                       :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En14
        cos_elevation                     :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En14
        sin_elevation                     :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En14
        );
END DSBF_compute_projections;


ARCHITECTURE rtl OF DSBF_compute_projections IS

  -- Component Declarations
  COMPONENT DSBF_compute_sine
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          angle                           :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En8
          output_value                    :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En14
          );
  END COMPONENT;

  COMPONENT DSBF_compute_cosine
    PORT( angle                           :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En8
          Out1                            :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En14
          );
  END COMPONENT;

  COMPONENT DSBF_compute_sine1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          angle                           :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En8
          output_value                    :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En14
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : DSBF_compute_sine
    USE ENTITY work.DSBF_compute_sine(rtl);

  FOR ALL : DSBF_compute_cosine
    USE ENTITY work.DSBF_compute_cosine(rtl);

  FOR ALL : DSBF_compute_sine1
    USE ENTITY work.DSBF_compute_sine1(rtl);

  -- Signals
  SIGNAL compute_sine_out1                : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL compute_cosine_out1              : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL compute_cosine_out1_signed       : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL compute_cosine_out1_1            : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL compute_sine1_out1               : std_logic_vector(15 DOWNTO 0);  -- ufix16

BEGIN
  u_compute_sine : DSBF_compute_sine
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              angle => azimuth,  -- sfix16_En8
              output_value => compute_sine_out1  -- sfix16_En14
              );

  u_compute_cosine : DSBF_compute_cosine
    PORT MAP( angle => elevation,  -- sfix16_En8
              Out1 => compute_cosine_out1  -- sfix16_En14
              );

  u_compute_sine1 : DSBF_compute_sine1
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              angle => elevation,  -- sfix16_En8
              output_value => compute_sine1_out1  -- sfix16_En14
              );

  compute_cosine_out1_signed <= signed(compute_cosine_out1);

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      compute_cosine_out1_1 <= to_signed(16#0000#, 16);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        compute_cosine_out1_1 <= compute_cosine_out1_signed;
      END IF;
    END IF;
  END PROCESS delayMatch_process;


  cos_elevation <= std_logic_vector(compute_cosine_out1_1);

  sin_azimuth <= compute_sine_out1;

  sin_elevation <= compute_sine1_out1;

END rtl;

