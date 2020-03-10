-- -------------------------------------------------------------
-- 
-- File Name: C:\Flat Earth\fpga-open-speech-tools\simulink_models\models\pFIR_Testing\hdlsrc\pFIR_Testing\pFIR_Testing_dataplane.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
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
-- avalon_source_rw_dout         ce_out        1.01725e-08
-- avalon_source_error           ce_out        1.01725e-08
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: pFIR_Testing_dataplane
-- Source Path: pFIR_Testing/dataplane
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.pFIR_Testing_dataplane_pkg.ALL;

ENTITY pFIR_Testing_dataplane IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        avalon_sink_valid                 :   IN    std_logic;
        avalon_sink_data                  :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        avalon_sink_channel               :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        avalon_sink_error                 :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        register_control_enable           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        register_control_Wr_Data          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        register_control_RW_Addr          :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
        register_control_Wr_En            :   IN    std_logic_vector(31 DOWNTO 0);  -- int32
        ce_out                            :   OUT   std_logic;
        avalon_source_valid               :   OUT   std_logic;  -- ufix1
        avalon_source_data                :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        avalon_source_channel             :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
        avalon_source_rw_dout             :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        avalon_source_error               :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
        );
END pFIR_Testing_dataplane;


ARCHITECTURE rtl OF pFIR_Testing_dataplane IS

  -- Component Declarations
  COMPONENT pFIR_Testing_dataplane_tc
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          clk_enable                      :   IN    std_logic;
          enb                             :   OUT   std_logic;
          enb_1_1_1                       :   OUT   std_logic;
          enb_1_4_0                       :   OUT   std_logic;
          enb_1_4_1                       :   OUT   std_logic;
          enb_1_2048_0                    :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT pFIR_Testing_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_4_0                       :   IN    std_logic;
          enb_1_4_1                       :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          Sink_Valid                      :   IN    std_logic;
          Sink_Data                       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Sink_Channel                    :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          register_control_enable         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          register_control_Wr_Data        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          register_control_RW_Addr        :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
          register_control_Wr_En          :   IN    std_logic_vector(31 DOWNTO 0);  -- int32
          Source_Data                     :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Source_Channel                  :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
          Source_RW_Dout                  :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Source_Valid                    :   OUT   std_logic  -- ufix1
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : pFIR_Testing_dataplane_tc
    USE ENTITY work.pFIR_Testing_dataplane_tc(rtl);

  FOR ALL : pFIR_Testing_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering
    USE ENTITY work.pFIR_Testing_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering(rtl);

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL enb_1_4_0                        : std_logic;
  SIGNAL enb_1_4_1                        : std_logic;
  SIGNAL enb_1_2048_0                     : std_logic;
  SIGNAL enb_1_1_1                        : std_logic;
  SIGNAL sourceData                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL sourceChannel                    : std_logic_vector(1 DOWNTO 0);  -- ufix2
  SIGNAL Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering_out3 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL sourceValid                      : std_logic;  -- ufix1
  SIGNAL avalon_sink_error_unsigned       : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL delayMatch_reg                   : vector_of_unsigned2(0 TO 3);  -- ufix2 [4]
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
  -- Avalon streaming interface signals need to have the
  -- names containing the prefix "avalon_" 
  -- (all lower case)

  u_dataplane_tc : pFIR_Testing_dataplane_tc
    PORT MAP( clk => clk,
              reset => reset,
              clk_enable => clk_enable,
              enb => enb,
              enb_1_1_1 => enb_1_1_1,
              enb_1_4_0 => enb_1_4_0,
              enb_1_4_1 => enb_1_4_1,
              enb_1_2048_0 => enb_1_2048_0
              );

  u_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering : pFIR_Testing_Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              enb_1_4_0 => enb_1_4_0,
              enb_1_4_1 => enb_1_4_1,
              enb_1_2048_0 => enb_1_2048_0,
              Sink_Valid => avalon_sink_valid,
              Sink_Data => avalon_sink_data,  -- sfix32_En28
              Sink_Channel => avalon_sink_channel,  -- ufix2
              register_control_enable => register_control_enable,  -- sfix32_En28
              register_control_Wr_Data => register_control_Wr_Data,  -- sfix32_En28
              register_control_RW_Addr => register_control_RW_Addr,  -- uint32
              register_control_Wr_En => register_control_Wr_En,  -- int32
              Source_Data => sourceData,  -- sfix32_En28
              Source_Channel => sourceChannel,  -- ufix2
              Source_RW_Dout => Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering_out3,  -- sfix32_En28
              Source_Valid => sourceValid  -- ufix1
              );

  avalon_sink_error_unsigned <= unsigned(avalon_sink_error);

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => to_unsigned(16#0#, 2));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= avalon_sink_error_unsigned;
        delayMatch_reg(1 TO 3) <= delayMatch_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  avalon_sink_error_1 <= delayMatch_reg(3);

  avalon_source_error <= std_logic_vector(avalon_sink_error_1);

  ce_out <= enb_1_1_1;

  avalon_source_valid <= sourceValid;

  avalon_source_data <= sourceData;

  avalon_source_channel <= sourceChannel;

  avalon_source_rw_dout <= Test_FIR_with_Custom_FIR_Libraries_Sample_Based_Filtering_out3;

END rtl;

