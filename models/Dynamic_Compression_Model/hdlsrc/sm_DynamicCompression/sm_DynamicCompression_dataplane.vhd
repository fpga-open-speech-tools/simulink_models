-- -------------------------------------------------------------
-- 
-- File Name: /home/cb54103/Documents/fpga-open-speech-tools/simulink_models/models/Dynamic_Compression_Model/hdlsrc/sm_DynamicCompression/sm_DynamicCompression_dataplane.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 2.03451e-08
-- Target subsystem base rate: 2.03451e-08
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        2.03451e-08
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- avalon_source_valid           ce_out        2.03451e-08
-- avalon_source_data            ce_out        2.03451e-08
-- avalon_source_channel         ce_out        2.03451e-08
-- avalon_source_error           ce_out        2.03451e-08
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: sm_DynamicCompression_dataplane
-- Source Path: sm_DynamicCompression/dataplane
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.sm_DynamicCompression_dataplane_pkg.ALL;

ENTITY sm_DynamicCompression_dataplane IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        avalon_sink_valid                 :   IN    std_logic;
        avalon_sink_data                  :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        avalon_sink_channel               :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        avalon_sink_error                 :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        register_control_system_enable    :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        register_control_preset_sel       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        ce_out                            :   OUT   std_logic;
        avalon_source_valid               :   OUT   std_logic;
        avalon_source_data                :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        avalon_source_channel             :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
        avalon_source_error               :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
        );
END sm_DynamicCompression_dataplane;


ARCHITECTURE rtl OF sm_DynamicCompression_dataplane IS

  -- Component Declarations
  COMPONENT sm_DynamicCompression_dataplane_tc
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          clk_enable                      :   IN    std_logic;
          enb                             :   OUT   std_logic;
          enb_1_1_1                       :   OUT   std_logic;
          enb_1_1024_0                    :   OUT   std_logic;
          enb_1_1024_5                    :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Avalon_Data_Processing
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_1024_5                    :   IN    std_logic;
          Sink_Valid                      :   IN    std_logic;
          Sink_Data                       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Sink_Channel                    :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          Register_System_Enable          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Register_Preset_Sel             :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Source_Data                     :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Source_Channel                  :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : sm_DynamicCompression_dataplane_tc
    USE ENTITY work.sm_DynamicCompression_dataplane_tc(rtl);

  FOR ALL : sm_DynamicCompression_Avalon_Data_Processing
    USE ENTITY work.sm_DynamicCompression_Avalon_Data_Processing(rtl);

  -- Signals
  SIGNAL enb_1_1024_0                     : std_logic;
  SIGNAL enb                              : std_logic;
  SIGNAL enb_1_1024_5                     : std_logic;
  SIGNAL enb_1_1_1                        : std_logic;
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 2049);  -- ufix1 [2050]
  SIGNAL avalon_sink_valid_1              : std_logic;
  SIGNAL Avalon_Data_Processing_out1      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Avalon_Data_Processing_out2      : std_logic_vector(1 DOWNTO 0);  -- ufix2
  SIGNAL Avalon_Data_Processing_out2_unsigned : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL delayMatch1_reg                  : vector_of_unsigned2(0 TO 2049);  -- ufix2 [2050]
  SIGNAL Avalon_Data_Processing_out2_1    : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL avalon_sink_error_unsigned       : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL delayMatch2_reg                  : vector_of_unsigned2(0 TO 2049);  -- ufix2 [2050]
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

  u_dataplane_tc : sm_DynamicCompression_dataplane_tc
    PORT MAP( clk => clk,
              reset => reset,
              clk_enable => clk_enable,
              enb => enb,
              enb_1_1_1 => enb_1_1_1,
              enb_1_1024_0 => enb_1_1024_0,
              enb_1_1024_5 => enb_1_1024_5
              );

  u_Avalon_Data_Processing : sm_DynamicCompression_Avalon_Data_Processing
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              enb_1_1024_5 => enb_1_1024_5,
              Sink_Valid => avalon_sink_valid,
              Sink_Data => avalon_sink_data,  -- sfix32_En28
              Sink_Channel => avalon_sink_channel,  -- ufix2
              Register_System_Enable => register_control_system_enable,  -- sfix32_En28
              Register_Preset_Sel => register_control_preset_sel,  -- sfix32_En28
              Source_Data => Avalon_Data_Processing_out1,  -- sfix32_En28
              Source_Channel => Avalon_Data_Processing_out2  -- ufix2
              );

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= avalon_sink_valid;
        delayMatch_reg(1 TO 2049) <= delayMatch_reg(0 TO 2048);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  avalon_sink_valid_1 <= delayMatch_reg(2049);

  Avalon_Data_Processing_out2_unsigned <= unsigned(Avalon_Data_Processing_out2);

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => to_unsigned(16#0#, 2));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch1_reg(0) <= Avalon_Data_Processing_out2_unsigned;
        delayMatch1_reg(1 TO 2049) <= delayMatch1_reg(0 TO 2048);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  Avalon_Data_Processing_out2_1 <= delayMatch1_reg(2049);

  avalon_source_channel <= std_logic_vector(Avalon_Data_Processing_out2_1);

  avalon_sink_error_unsigned <= unsigned(avalon_sink_error);

  delayMatch2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch2_reg <= (OTHERS => to_unsigned(16#0#, 2));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch2_reg(0) <= avalon_sink_error_unsigned;
        delayMatch2_reg(1 TO 2049) <= delayMatch2_reg(0 TO 2048);
      END IF;
    END IF;
  END PROCESS delayMatch2_process;

  avalon_sink_error_1 <= delayMatch2_reg(2049);

  avalon_source_error <= std_logic_vector(avalon_sink_error_1);

  ce_out <= enb_1_1_1;

  avalon_source_valid <= avalon_sink_valid_1;

  avalon_source_data <= Avalon_Data_Processing_out1;

END rtl;

