-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\spike_generator_sim\redocking_site\redocking_site_Current_Refactory_Component.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: redocking_site_Current_Refactory_Component
-- Source Path: redocking_site/Current Refactory Component
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY redocking_site_Current_Refactory_Component IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_2048_1                      :   IN    std_logic;
        enb                               :   IN    std_logic;
        enb_1_2048_0                      :   IN    std_logic;
        current_release_times             :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        Tref                              :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        recalculate                       :   IN    std_logic;
        current_refactory_period          :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
        );
END redocking_site_Current_Refactory_Component;


ARCHITECTURE rtl OF redocking_site_Current_Refactory_Component IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT initialize_signal
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          initalize                       :   OUT   std_logic_vector(63 DOWNTO 0)  -- double
          );
  END COMPONENT;

  COMPONENT redocking_site_nfp_relop_double
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          nfp_in1                         :   IN    std_logic_vector(63 DOWNTO 0);  -- ufix64
          nfp_in2                         :   IN    std_logic_vector(63 DOWNTO 0);  -- ufix64
          nfp_out1                        :   OUT   std_logic
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
  FOR ALL : initialize_signal
    USE ENTITY work.initialize_signal_initialize_signal(rtl);

  FOR ALL : redocking_site_nfp_relop_double
    USE ENTITY work.redocking_site_nfp_relop_double(rtl);

  FOR ALL : redocking_site_nfp_add_single
    USE ENTITY work.redocking_site_nfp_add_single(rtl);

  -- Signals
  SIGNAL Initialization_Signal_out1       : std_logic_vector(63 DOWNTO 0);  -- ufix64
  SIGNAL Switch_threshold                 : std_logic_vector(63 DOWNTO 0);  -- ufix64
  SIGNAL recalculate_1                    : std_logic;
  SIGNAL Switch_control                   : std_logic;
  SIGNAL Add_out1                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch_out1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Delay_bypass_reg                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch_out1_1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Delay_out1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch1_out1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch_out1_2                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Delay2_bypass_reg                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch_out1_3                    : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  -- Line 620

  u_Initialization_Signal_block2 : initialize_signal
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2048_0 => enb_1_2048_0,
              initalize => Initialization_Signal_out1  -- double
              );

  u_nfp_relop_comp : redocking_site_nfp_relop_double
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in1 => Initialization_Signal_out1,  -- ufix64
              nfp_in2 => Switch_threshold,  -- ufix64
              nfp_out1 => Switch_control
              );

  u_nfp_add_comp : redocking_site_nfp_add_single
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in1 => current_release_times,  -- ufix32
              nfp_in2 => Tref,  -- ufix32
              nfp_out => Add_out1  -- ufix32
              );

  Switch_threshold <= X"0000000000000000";

  recalculate_1 <= recalculate;

  Constant_out1 <= X"00000000";

  Delay_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_bypass_reg <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_1 = '1' THEN
        Delay_bypass_reg <= Switch_out1;
      END IF;
    END IF;
  END PROCESS Delay_bypass_process;

  
  Switch_out1_1 <= Switch_out1 WHEN enb_1_2048_1 = '1' ELSE
      Delay_bypass_reg;

  Delay_out1 <= Switch_out1_1;

  
  Switch1_out1 <= Delay_out1 WHEN recalculate_1 = '0' ELSE
      Add_out1;

  
  Switch_out1_2 <= Switch1_out1 WHEN Switch_control = '0' ELSE
      Constant_out1;

  reduced_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Switch_out1 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Switch_out1 <= Switch_out1_2;
      END IF;
    END IF;
  END PROCESS reduced_process;


  Delay2_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay2_bypass_reg <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_1 = '1' THEN
        Delay2_bypass_reg <= Switch_out1;
      END IF;
    END IF;
  END PROCESS Delay2_bypass_process;

  
  Switch_out1_3 <= Switch_out1 WHEN enb_1_2048_1 = '1' ELSE
      Delay2_bypass_reg;

  current_refactory_period <= Switch_out1_3;

END rtl;

