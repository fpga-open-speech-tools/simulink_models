-- -------------------------------------------------------------
-- 
-- File Name: /home/justin/Documents/FEI/simulink_models/models/short_window_mean_reduction/hdlsrc/MNR/MNR_Right_Channel_Processing.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: MNR_Right_Channel_Processing
-- Source Path: MNR/dataplane/Adaptive_Wiener_Filter Sample Based Filtering/Right Channel Processing
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MNR_dataplane_pkg.ALL;

ENTITY MNR_Right_Channel_Processing IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        Right_Data_Sink                   :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        register_control_bypass           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Enable                            :   IN    std_logic;
        Right_Data_Source                 :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END MNR_Right_Channel_Processing;


ARCHITECTURE rtl OF MNR_Right_Channel_Processing IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT MNR_Grab_the_Look_behind_Window_and_Calculate_the_Mean
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          right_data_sink                 :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          rightEnable                     :   IN    std_logic;
          right_channel_source            :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : MNR_Grab_the_Look_behind_Window_and_Calculate_the_Mean
    USE ENTITY work.MNR_Grab_the_Look_behind_Window_and_Calculate_the_Mean(rtl);

  -- Signals
  SIGNAL rightEnable                      : std_logic;
  SIGNAL delayMatch2_reg                  : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL rightEnable_1                    : std_logic;
  SIGNAL register_control_bypass_signed   : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL delayMatch_reg                   : vector_of_signed32(0 TO 1);  -- sfix32 [2]
  SIGNAL register_control_bypass_1        : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL switch_compare_1                 : std_logic;
  SIGNAL Right_Data_Sink_signed           : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL delayMatch1_reg                  : vector_of_signed32(0 TO 1);  -- sfix32 [2]
  SIGNAL right_data_sinksource_passthrough : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL win_mean                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL win_mean_signed                  : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Right_Data_Source_1              : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Right_Data_Source_bypass         : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Right_Data_Source_last_value     : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- An enabled subsystem
  -- This subsystem only runs when the data valid signal is enabled (asserted)
  -- 

  u_Grab_the_Look_behind_Window_and_Calculate_the_Mean : MNR_Grab_the_Look_behind_Window_and_Calculate_the_Mean
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              right_data_sink => Right_Data_Sink,  -- sfix32_En28
              rightEnable => rightEnable,
              right_channel_source => win_mean  -- sfix32_En28
              );

  rightEnable <= Enable;

  delayMatch2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch2_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch2_reg(0) <= rightEnable;
        delayMatch2_reg(1) <= delayMatch2_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch2_process;

  rightEnable_1 <= delayMatch2_reg(1);

  register_control_bypass_signed <= signed(register_control_bypass);

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= register_control_bypass_signed;
        delayMatch_reg(1) <= delayMatch_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  register_control_bypass_1 <= delayMatch_reg(1);

  
  switch_compare_1 <= '1' WHEN register_control_bypass_1 >= to_signed(268435456, 32) ELSE
      '0';

  Right_Data_Sink_signed <= signed(Right_Data_Sink);

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch1_reg(0) <= Right_Data_Sink_signed;
        delayMatch1_reg(1) <= delayMatch1_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  right_data_sinksource_passthrough <= delayMatch1_reg(1);

  win_mean_signed <= signed(win_mean);

  
  Right_Data_Source_1 <= right_data_sinksource_passthrough WHEN switch_compare_1 = '0' ELSE
      win_mean_signed;

  Right_Data_Source_bypass_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Right_Data_Source_last_value <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Right_Data_Source_last_value <= Right_Data_Source_bypass;
      END IF;
    END IF;
  END PROCESS Right_Data_Source_bypass_1_process;


  
  Right_Data_Source_bypass <= Right_Data_Source_last_value WHEN rightEnable_1 = '0' ELSE
      Right_Data_Source_1;

  Right_Data_Source <= std_logic_vector(Right_Data_Source_bypass);

END rtl;
