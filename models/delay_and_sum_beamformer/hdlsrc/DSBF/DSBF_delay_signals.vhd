-- -------------------------------------------------------------
-- 
-- File Name: /mnt/data/NIH/simulink_models/models/delay_and_sum_beamformer/hdlsrc/DSBF/DSBF_delay_signals.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: DSBF_delay_signals
-- Source Path: DSBF/dataplane/Avalon Data Processing/delay signals
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DSBF_delay_signals IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_128_1                       :   IN    std_logic;
        enb_1_2048_0                      :   IN    std_logic;
        enb_1_128_0                       :   IN    std_logic;
        data_in                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        delays                            :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12_En6
        Out1                              :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END DSBF_delay_signals;


ARCHITECTURE rtl OF DSBF_delay_signals IS

  -- Component Declarations
  COMPONENT DSBF_delay_signal
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_128_1                     :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          enb_1_128_0                     :   IN    std_logic;
          data_in                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          delay                           :   IN    std_logic_vector(11 DOWNTO 0);  -- sfix12_En6
          data_out                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : DSBF_delay_signal
    USE ENTITY work.DSBF_delay_signal(rtl);

  -- Signals
  SIGNAL delay_signal_out1                : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  u_delay_signal : DSBF_delay_signal
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_128_1 => enb_1_128_1,
              enb_1_2048_0 => enb_1_2048_0,
              enb_1_128_0 => enb_1_128_0,
              data_in => data_in,  -- sfix32_En28
              delay => delays,  -- sfix12_En6
              data_out => delay_signal_out1  -- sfix32_En28
              );

  Out1 <= delay_signal_out1;

END rtl;
