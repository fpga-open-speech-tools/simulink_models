-- -------------------------------------------------------------
-- 
-- File Name: C:\Flat Earth\fpga-open-speech-tools\simulink_models\models\pFIR_Testing\hdlsrc\pFIR_Testing\pFIR_Testing_Right_Channel_Processing.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: pFIR_Testing_Right_Channel_Processing
-- Source Path: pFIR_Testing/dataplane/Test FIR with Custom FIR Libraries Sample Based Filtering/Right Channel Processing
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.pFIR_Testing_dataplane_pkg.ALL;

ENTITY pFIR_Testing_Right_Channel_Processing IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        enb_1_4_0                         :   IN    std_logic;
        enb_1_4_1                         :   IN    std_logic;
        enb_1_2048_0                      :   IN    std_logic;
        Right_Data_Sink                   :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        register_control_enable           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        right_data_valid                  :   IN    std_logic;
        register_control_Wr_Data          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        register_control_RW_Addr          :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
        register_control_Wr_En            :   IN    std_logic_vector(31 DOWNTO 0);  -- int32
        Right_Data_Source                 :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Right_Data_Valid_Source           :   OUT   std_logic;
        Right_RW_Dout                     :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END pFIR_Testing_Right_Channel_Processing;


ARCHITECTURE rtl OF pFIR_Testing_Right_Channel_Processing IS

  -- Component Declarations
  COMPONENT pFIR_Testing_Programmable_Upclocked_FIR_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_4_0                       :   IN    std_logic;
          enb_1_4_1                       :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          Data_in                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Valid_in                        :   IN    std_logic;
          Wr_Data                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Wr_Addr                         :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
          Wr_En                           :   IN    std_logic_vector(31 DOWNTO 0);  -- int32
          Data_out                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Valid_out                       :   OUT   std_logic;
          RW_Dout                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : pFIR_Testing_Programmable_Upclocked_FIR_block
    USE ENTITY work.pFIR_Testing_Programmable_Upclocked_FIR_block(rtl);

  -- Signals
  SIGNAL register_control_enable_signed   : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL delayMatch_reg                   : vector_of_signed32(0 TO 3);  -- sfix32 [4]
  SIGNAL register_control_enable_1        : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL switch_compare_1                 : std_logic;
  SIGNAL Right_Data_Sink_signed           : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL delayMatch1_reg                  : vector_of_signed32(0 TO 3);  -- sfix32 [4]
  SIGNAL right_data_sinksource_passthrough : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL filter_data                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Programmable_Upclocked_FIR_out2  : std_logic;
  SIGNAL RW_Dout                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL filter_data_signed               : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Right_Data_Source_1              : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- An enabled subsystem
  -- This subsystem only runs when the data valid signal is enabled (asserted)

  u_Programmable_Upclocked_FIR : pFIR_Testing_Programmable_Upclocked_FIR_block
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_4_0 => enb_1_4_0,
              enb_1_4_1 => enb_1_4_1,
              enb_1_2048_0 => enb_1_2048_0,
              Data_in => Right_Data_Sink,  -- sfix32_En28
              Valid_in => right_data_valid,
              Wr_Data => register_control_Wr_Data,  -- sfix32_En28
              Wr_Addr => register_control_RW_Addr,  -- uint32
              Wr_En => register_control_Wr_En,  -- int32
              Data_out => filter_data,  -- sfix32_En28
              Valid_out => Programmable_Upclocked_FIR_out2,
              RW_Dout => RW_Dout  -- sfix32_En28
              );

  register_control_enable_signed <= signed(register_control_enable);

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= register_control_enable_signed;
        delayMatch_reg(1 TO 3) <= delayMatch_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  register_control_enable_1 <= delayMatch_reg(3);

  
  switch_compare_1 <= '1' WHEN register_control_enable_1 >= to_signed(268435456, 32) ELSE
      '0';

  Right_Data_Sink_signed <= signed(Right_Data_Sink);

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch1_reg(0) <= Right_Data_Sink_signed;
        delayMatch1_reg(1 TO 3) <= delayMatch1_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  right_data_sinksource_passthrough <= delayMatch1_reg(3);

  filter_data_signed <= signed(filter_data);

  
  Right_Data_Source_1 <= right_data_sinksource_passthrough WHEN switch_compare_1 = '0' ELSE
      filter_data_signed;

  Right_Data_Source <= std_logic_vector(Right_Data_Source_1);

  Right_Data_Valid_Source <= Programmable_Upclocked_FIR_out2;

  Right_RW_Dout <= RW_Dout;

END rtl;

