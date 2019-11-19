-- -------------------------------------------------------------
-- 
-- File Name: /mnt/data/trevor/research/NIH_SBIR_R44_DC015443/simulink_models/models/wiener_noise_reduction/hdlsrc/wiener/wiener_Left_Channel_Processing.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: wiener_Left_Channel_Processing
-- Source Path: wiener/dataplane/Adaptive_Wiener_Filter Sample Based Filtering/Left Channel Processing
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY wiener_Left_Channel_Processing IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        Left_Data_Sink                    :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Enable                            :   IN    std_logic;
        Left_Data_Out                     :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END wiener_Left_Channel_Processing;


ARCHITECTURE rtl OF wiener_Left_Channel_Processing IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT wiener_Grab_the_Look_behind_Window_and_Calculate_the_Mean
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          left_data_sink                  :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Enable_out3                     :   IN    std_logic;
          win_mean                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          startup                         :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT wiener_Subsystem
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          win_mean                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Enable                          :   IN    std_logic;
          left_data_source                :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : wiener_Grab_the_Look_behind_Window_and_Calculate_the_Mean
    USE ENTITY work.wiener_Grab_the_Look_behind_Window_and_Calculate_the_Mean(rtl);

  FOR ALL : wiener_Subsystem
    USE ENTITY work.wiener_Subsystem(rtl);

  -- Signals
  SIGNAL Enable_out3                      : std_logic;
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL Enable_out3_1                    : std_logic;
  SIGNAL win_mean                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL startup                          : std_logic;
  SIGNAL startup_1                        : std_logic;
  SIGNAL Subsystem_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Subsystem_out1_signed            : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Subsystem_out1_bypass            : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Subsystem_out1_last_value        : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- An enabled subsystem
  -- This subsystem only runs when the data valid signal is enabled (asserted)
  -- 

  u_Grab_the_Look_behind_Window_and_Calculate_the_Mean : wiener_Grab_the_Look_behind_Window_and_Calculate_the_Mean
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              left_data_sink => Left_Data_Sink,  -- sfix32_En28
              Enable_out3 => Enable_out3,
              win_mean => win_mean,  -- sfix32_En28
              startup => startup
              );

  u_Subsystem : wiener_Subsystem
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              win_mean => win_mean,  -- sfix32_En28
              Enable => startup_1,
              left_data_source => Subsystem_out1  -- sfix32_En28
              );

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

  startup_1 <= startup AND Enable_out3;

  Subsystem_out1_signed <= signed(Subsystem_out1);

  Left_Data_Out_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Subsystem_out1_last_value <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Subsystem_out1_last_value <= Subsystem_out1_bypass;
      END IF;
    END IF;
  END PROCESS Left_Data_Out_bypass_process;


  
  Subsystem_out1_bypass <= Subsystem_out1_last_value WHEN Enable_out3_1 = '0' ELSE
      Subsystem_out1_signed;

  Left_Data_Out <= std_logic_vector(Subsystem_out1_bypass);

END rtl;

