-- -------------------------------------------------------------
-- 
-- File Name: /home/justin/Documents/FEI/simulink_models/models/dynamic_FIRFilter/hdlsrc/pFIR_HPF_testing_and_analysis/pFIR_HPF_testing_and_analysis_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: pFIR_HPF_testing_and_analysis_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering
-- Source Path: pFIR_HPF_testing_and_analysis/dataplane/Test FIR with Custom FIR Libraries Sample Based Filtering
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.pFIR_HPF_testing_and_analysis_dataplane_pkg.ALL;

ENTITY pFIR_HPF_testing_and_analysis_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        enb_1_2_0                         :   IN    std_logic;
        enb_1_2_1                         :   IN    std_logic;
        enb_1_2048_0                      :   IN    std_logic;
        Sink_Valid                        :   IN    std_logic;
        Sink_Data                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Sink_Channel                      :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        register_control_enable           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Source_Data                       :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Source_Channel                    :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
        );
END pFIR_HPF_testing_and_analysis_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering;


ARCHITECTURE rtl OF pFIR_HPF_testing_and_analysis_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering IS

  -- Component Declarations
  COMPONENT pFIR_HPF_testing_and_analysis_Left_Channel_Processing
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_2_0                       :   IN    std_logic;
          enb_1_2_1                       :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          Left_Data_Sink                  :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          register_control_enable         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          left_data_valid                 :   IN    std_logic;
          Left_Data_Source                :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT pFIR_HPF_testing_and_analysis_Right_Channel_Processing
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_2_0                       :   IN    std_logic;
          enb_1_2_1                       :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          Right_Data_Sink                 :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          register_control_enable         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          right_data_valid                :   IN    std_logic;
          Right_Data_Source               :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : pFIR_HPF_testing_and_analysis_Left_Channel_Processing
    USE ENTITY work.pFIR_HPF_testing_and_analysis_Left_Channel_Processing(rtl);

  FOR ALL : pFIR_HPF_testing_and_analysis_Right_Channel_Processing
    USE ENTITY work.pFIR_HPF_testing_and_analysis_Right_Channel_Processing(rtl);

  -- Signals
  SIGNAL Sink_Channel_unsigned            : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL leftEnable                       : std_logic;
  SIGNAL Logical_Operator_out1            : std_logic;
  SIGNAL rightEnable                      : std_logic;
  SIGNAL Logical_Operator1_out1           : std_logic;
  SIGNAL delayMatch_reg                   : vector_of_unsigned2(0 TO 1);  -- ufix2 [2]
  SIGNAL Sink_Channel_1                   : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL Left_Channel_Processing_out1     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Left_Channel_Processing_out1_signed : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Right_Channel_Processing_out1    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Right_Channel_Processing_out1_signed : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Sink_Data_signed                 : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL delayMatch1_reg                  : vector_of_signed32(0 TO 1);  -- sfix32 [2]
  SIGNAL Sink_Data_1                      : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Multiport_Switch_out1            : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- The Left Channel Processing block 
  -- only writes when channel 0
  -- is detected
  -- 
  -- The Right Channel Processing block 
  -- only writes when channel 1
  -- is detected
  -- 
  -- Check if Channel 0 
  -- (Left Channel)
  -- 
  -- Select output data
  -- based on channel number
  -- 
  -- Check if Channel 1 
  -- (Right Channel)

  u_Left_Channel_Processing : pFIR_HPF_testing_and_analysis_Left_Channel_Processing
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              enb_1_2_0 => enb_1_2_0,
              enb_1_2_1 => enb_1_2_1,
              enb_1_2048_0 => enb_1_2048_0,
              Left_Data_Sink => Sink_Data,  -- sfix32_En28
              register_control_enable => register_control_enable,  -- sfix32_En28
              left_data_valid => Logical_Operator_out1,
              Left_Data_Source => Left_Channel_Processing_out1  -- sfix32_En28
              );

  u_Right_Channel_Processing : pFIR_HPF_testing_and_analysis_Right_Channel_Processing
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              enb_1_2_0 => enb_1_2_0,
              enb_1_2_1 => enb_1_2_1,
              enb_1_2048_0 => enb_1_2048_0,
              Right_Data_Sink => Sink_Data,  -- sfix32_En28
              register_control_enable => register_control_enable,  -- sfix32_En28
              right_data_valid => Logical_Operator1_out1,
              Right_Data_Source => Right_Channel_Processing_out1  -- sfix32_En28
              );

  Sink_Channel_unsigned <= unsigned(Sink_Channel);

  
  leftEnable <= '1' WHEN Sink_Channel_unsigned = to_unsigned(16#0#, 2) ELSE
      '0';

  Logical_Operator_out1 <= leftEnable AND Sink_Valid;

  
  rightEnable <= '1' WHEN Sink_Channel_unsigned = to_unsigned(16#1#, 2) ELSE
      '0';

  Logical_Operator1_out1 <= rightEnable AND Sink_Valid;

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => to_unsigned(16#0#, 2));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= Sink_Channel_unsigned;
        delayMatch_reg(1) <= delayMatch_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  Sink_Channel_1 <= delayMatch_reg(1);

  Left_Channel_Processing_out1_signed <= signed(Left_Channel_Processing_out1);

  Right_Channel_Processing_out1_signed <= signed(Right_Channel_Processing_out1);

  Sink_Data_signed <= signed(Sink_Data);

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch1_reg(0) <= Sink_Data_signed;
        delayMatch1_reg(1) <= delayMatch1_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  Sink_Data_1 <= delayMatch1_reg(1);

  
  Multiport_Switch_out1 <= Left_Channel_Processing_out1_signed WHEN Sink_Channel_1 = to_unsigned(16#0#, 2) ELSE
      Right_Channel_Processing_out1_signed WHEN Sink_Channel_1 = to_unsigned(16#1#, 2) ELSE
      Sink_Data_1;

  Source_Data <= std_logic_vector(Multiport_Switch_out1);

  Source_Channel <= Sink_Channel;

END rtl;
