-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\bugsbunny\NIH\simulink_models\models\simple_gain\hdlsrc\SG\SG_dataplane.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 1.01725e-08
-- Target subsystem base rate: 1.01725e-08
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        1.01725e-08
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- avalon_source_valid           ce_out        1.01725e-08
-- avalon_source_data            ce_out        1.01725e-08
-- avalon_source_channel         ce_out        1.01725e-08
-- avalon_source_error           ce_out        1.01725e-08
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: SG_dataplane
-- Source Path: SG/dataplane
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.SG_dataplane_pkg.ALL;

ENTITY SG_dataplane IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        avalon_sink_valid                 :   IN    std_logic;
        avalon_sink_data                  :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        avalon_sink_channel               :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        avalon_sink_error                 :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        register_control_left_gain        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        register_control_right_gain       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        ce_out                            :   OUT   std_logic;
        avalon_source_valid               :   OUT   std_logic;
        avalon_source_data                :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        avalon_source_channel             :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
        avalon_source_error               :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
        );
END SG_dataplane;


ARCHITECTURE rtl OF SG_dataplane IS

  -- Component Declarations
  COMPONENT SG_Avalon_Data_Processing
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Sink_Data                       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Sink_Channel                    :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          Left_Gain                       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Right_Gain                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Enable                          :   IN    std_logic;
          Source_Data                     :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Source_Channel                  :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : SG_Avalon_Data_Processing
    USE ENTITY work.SG_Avalon_Data_Processing(rtl);

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL avalon_sink_valid_1              : std_logic;
  SIGNAL Avalon_Data_Processing_out1      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Avalon_Data_Processing_out2      : std_logic_vector(1 DOWNTO 0);  -- ufix2
  SIGNAL Avalon_Data_Processing_out2_unsigned : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL delayMatch1_reg                  : vector_of_unsigned2(0 TO 1);  -- ufix2 [2]
  SIGNAL Avalon_Data_Processing_out2_1    : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL avalon_sink_error_unsigned       : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL delayMatch2_reg                  : vector_of_unsigned2(0 TO 1);  -- ufix2 [2]
  SIGNAL avalon_sink_error_1              : unsigned(1 DOWNTO 0);  -- ufix2

BEGIN
  -- Control Signals that will be coming from Linux via
  -- memory mapped registers need to have names 
  -- containing the prefix "register_control_"
  -- (all lower case)
  -- 
  -- The Avalon Data Processing Block
  -- performs DSP on the left and right channels.
  -- 
  -- The Avalon Data Processing block 
  -- only executes when valid is asserted
  -- 
  -- Ignore Errors.
  -- Assuming no errors coming from the ADC and errors going to DAC will be ignored.
  -- Any Error streaming needs to be done inside Avalon Data Processing block.
  -- 
  -- Avalon streaming interface signals need to have the
  -- names containing the prefix "avalon_" 
  -- (all lower case)

  u_Avalon_Data_Processing : SG_Avalon_Data_Processing
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              Sink_Data => avalon_sink_data,  -- sfix32_En28
              Sink_Channel => avalon_sink_channel,  -- ufix2
              Left_Gain => register_control_left_gain,  -- sfix32_En28
              Right_Gain => register_control_right_gain,  -- sfix32_En28
              Enable => avalon_sink_valid,
              Source_Data => Avalon_Data_Processing_out1,  -- sfix32_En28
              Source_Channel => Avalon_Data_Processing_out2  -- ufix2
              );

  enb <= clk_enable;

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= avalon_sink_valid;
        delayMatch_reg(1) <= delayMatch_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  avalon_sink_valid_1 <= delayMatch_reg(1);

  Avalon_Data_Processing_out2_unsigned <= unsigned(Avalon_Data_Processing_out2);

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => to_unsigned(16#0#, 2));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch1_reg(0) <= Avalon_Data_Processing_out2_unsigned;
        delayMatch1_reg(1) <= delayMatch1_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  Avalon_Data_Processing_out2_1 <= delayMatch1_reg(1);

  avalon_source_channel <= std_logic_vector(Avalon_Data_Processing_out2_1);

  avalon_sink_error_unsigned <= unsigned(avalon_sink_error);

  delayMatch2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch2_reg <= (OTHERS => to_unsigned(16#0#, 2));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch2_reg(0) <= avalon_sink_error_unsigned;
        delayMatch2_reg(1) <= delayMatch2_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch2_process;

  avalon_sink_error_1 <= delayMatch2_reg(1);

  avalon_source_error <= std_logic_vector(avalon_sink_error_1);

  ce_out <= clk_enable;

  avalon_source_valid <= avalon_sink_valid_1;

  avalon_source_data <= Avalon_Data_Processing_out1;

END rtl;
