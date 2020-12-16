-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\spike_generator_sim\redocking_site\redocking_site_Xsum_Component.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: redocking_site_Xsum_Component
-- Source Path: redocking_site/Xsum Component
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY redocking_site_Xsum_Component IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_2048_1                      :   IN    std_logic;
        enb                               :   IN    std_logic;
        synout                            :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        nSites                            :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        reset_1                           :   IN    std_logic;
        increment                         :   IN    std_logic;
        Xsum                              :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
        );
END redocking_site_Xsum_Component;


ARCHITECTURE rtl OF redocking_site_Xsum_Component IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT redocking_site_nfp_div_single
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  COMPONENT redocking_site_nfp_add_single
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : redocking_site_nfp_div_single
    USE ENTITY work.redocking_site_nfp_div_single(rtl);

  FOR ALL : redocking_site_nfp_add_single
    USE ENTITY work.redocking_site_nfp_add_single(rtl);

  -- Signals
  SIGNAL reset_2                          : std_logic;
  SIGNAL reset_3                          : std_logic;
  SIGNAL increment_1                      : std_logic;
  SIGNAL increment_2                      : std_logic;
  SIGNAL Divide_out1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch2_out1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Delay1_bypass_reg                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch2_out1_1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Add_out1                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Delay_bypass_reg                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch2_out1_2                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Delay_out1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Delay_out1_1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch1_out1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Delay2_bypass_reg                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch2_out1_3                   : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  -- Lines 592 and 626

  u_nfp_div_comp : redocking_site_nfp_div_single
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in1 => synout,  -- ufix32
              nfp_in2 => nSites,  -- ufix32
              nfp_out => Divide_out1  -- ufix32
              );

  u_nfp_add_comp : redocking_site_nfp_add_single
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in1 => Switch2_out1_1,  -- ufix32
              nfp_in2 => Divide_out1,  -- ufix32
              nfp_out => Add_out1  -- ufix32
              );

  reset_2 <= reset_1;

  delayMatch2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      reset_3 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        reset_3 <= reset_2;
      END IF;
    END IF;
  END PROCESS delayMatch2_process;


  increment_1 <= increment;

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      increment_2 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        increment_2 <= increment_1;
      END IF;
    END IF;
  END PROCESS delayMatch_process;


  Constant_out1 <= X"00000000";

  Delay1_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay1_bypass_reg <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_1 = '1' THEN
        Delay1_bypass_reg <= Switch2_out1;
      END IF;
    END IF;
  END PROCESS Delay1_bypass_process;

  
  Switch2_out1_1 <= Switch2_out1 WHEN enb_1_2048_1 = '1' ELSE
      Delay1_bypass_reg;

  Delay_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_bypass_reg <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_1 = '1' THEN
        Delay_bypass_reg <= Switch2_out1;
      END IF;
    END IF;
  END PROCESS Delay_bypass_process;

  
  Switch2_out1_2 <= Switch2_out1 WHEN enb_1_2048_1 = '1' ELSE
      Delay_bypass_reg;

  Delay_out1 <= Switch2_out1_2;

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_out1_1 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay_out1_1 <= Delay_out1;
      END IF;
    END IF;
  END PROCESS delayMatch1_process;


  
  Switch1_out1 <= Delay_out1_1 WHEN increment_2 = '0' ELSE
      Add_out1;

  
  Switch2_out1 <= Switch1_out1 WHEN reset_3 = '0' ELSE
      Constant_out1;

  Delay2_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay2_bypass_reg <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_1 = '1' THEN
        Delay2_bypass_reg <= Switch2_out1;
      END IF;
    END IF;
  END PROCESS Delay2_bypass_process;

  
  Switch2_out1_3 <= Switch2_out1 WHEN enb_1_2048_1 = '1' ELSE
      Delay2_bypass_reg;

  Xsum <= Switch2_out1_3;

END rtl;
