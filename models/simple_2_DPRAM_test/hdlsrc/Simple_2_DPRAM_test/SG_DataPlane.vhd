-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\Simple_2_DPRAM_test\SG_DataPlane.vhd
-- Created: 2019-10-21 10:42:05
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 2e-08
-- Target subsystem base rate: 2e-08
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        2e-08
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- avalon_source_valid           ce_out        2e-08
-- avalon_source_data            ce_out        2e-08
-- avalon_source_channel         ce_out        2e-08
-- avalon_source_error           ce_out        2e-08
-- register_wr_dout              ce_out        2e-08
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: SG_DataPlane
-- Source Path: Simple_2_DPRAM_test/SG_DataPlane
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SG_DataPlane IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        avalon_sink_valid                 :   IN    std_logic;
        avalon_sink_data                  :   IN    std_logic_vector(31 DOWNTO 0);  -- int32
        avalon_sink_channel               :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        avalon_sink_error                 :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        register_control_data             :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
        register_control_addr             :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
        register_control_wr_en            :   IN    std_logic;
        ce_out                            :   OUT   std_logic;
        avalon_source_valid               :   OUT   std_logic;
        avalon_source_data                :   OUT   std_logic_vector(31 DOWNTO 0);  -- int32
        avalon_source_channel             :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
        avalon_source_error               :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
        register_wr_dout                  :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
        );
END SG_DataPlane;


ARCHITECTURE rtl OF SG_DataPlane IS

  -- Component Declarations
  COMPONENT Avalon_Data_Processing
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Sink_Data                       :   IN    std_logic_vector(31 DOWNTO 0);  -- int32
          Sink_Channel                    :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          Register_Data                   :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
          Register_Addr                   :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
          Register_wr_en                  :   IN    std_logic;
          Enable                          :   IN    std_logic;
          Source_Data                     :   OUT   std_logic_vector(31 DOWNTO 0);  -- int32
          Source_Channel                  :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
          Register_wr_dout                :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Avalon_Data_Processing
    USE ENTITY work.Avalon_Data_Processing(rtl);

  -- Signals
  SIGNAL Avalon_Data_Processing_out1      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Avalon_Data_Processing_out2      : std_logic_vector(1 DOWNTO 0);  -- ufix2
  SIGNAL Avalon_Data_Processing_out3      : std_logic_vector(7 DOWNTO 0);  -- ufix8

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

  u_Avalon_Data_Processing : Avalon_Data_Processing
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              Sink_Data => avalon_sink_data,  -- int32
              Sink_Channel => avalon_sink_channel,  -- ufix2
              Register_Data => register_control_data,  -- uint32
              Register_Addr => register_control_addr,  -- uint32
              Register_wr_en => register_control_wr_en,
              Enable => avalon_sink_valid,
              Source_Data => Avalon_Data_Processing_out1,  -- int32
              Source_Channel => Avalon_Data_Processing_out2,  -- ufix2
              Register_wr_dout => Avalon_Data_Processing_out3  -- uint8
              );

  ce_out <= clk_enable;

  avalon_source_valid <= avalon_sink_valid;

  avalon_source_data <= Avalon_Data_Processing_out1;

  avalon_source_channel <= Avalon_Data_Processing_out2;

  avalon_source_error <= avalon_sink_error;

  register_wr_dout <= Avalon_Data_Processing_out3;

END rtl;

