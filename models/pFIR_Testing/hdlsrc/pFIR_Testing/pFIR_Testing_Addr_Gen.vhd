-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\mc_gr\Desktop\FPGA Open Speech Tools\simulink_models\models\pFIR_Testing\hdlsrc\pFIR_Testing\pFIR_Testing_Addr_Gen.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: pFIR_Testing_Addr_Gen
-- Source Path: pFIR_Testing/dataplane/Test FIR with Custom FIR Libraries Sample Based Filtering/Left Channel Processing/Programmable 
-- Upclocked FIR/Addr_Gen
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pFIR_Testing_Addr_Gen IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_4_0                         :   IN    std_logic;
        enb_1_2048_0                      :   IN    std_logic;
        Input_Addr                        :   OUT   std_logic_vector(8 DOWNTO 0);  -- ufix9
        Data_History_Rd_addr              :   OUT   std_logic_vector(8 DOWNTO 0);  -- ufix9
        End_of_sample_calc                :   OUT   std_logic;
        b_k_addr                          :   OUT   std_logic_vector(8 DOWNTO 0)  -- ufix9
        );
END pFIR_Testing_Addr_Gen;


ARCHITECTURE rtl OF pFIR_Testing_Addr_Gen IS

  -- Signals
  SIGNAL Input_Addr_Counter_out1          : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Rate_Transition_out1             : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Constant_out1                    : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Add_out1                         : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Counter_0_to_b_k_1_out1          : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Subtract_op_stage2               : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Realignment_delay_out1           : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Subtract_out1                    : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Compare_To_Zero_out1             : std_logic;

BEGIN
  -- Realign Delay here?

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  -- 
  Input_Addr_Counter_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Input_Addr_Counter_out1 <= to_unsigned(16#000#, 9);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' THEN
        Input_Addr_Counter_out1 <= Input_Addr_Counter_out1 + to_unsigned(16#001#, 9);
      END IF;
    END IF;
  END PROCESS Input_Addr_Counter_process;


  Rate_Transition_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition_out1 <= to_unsigned(16#000#, 9);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' THEN
        Rate_Transition_out1 <= Input_Addr_Counter_out1;
      END IF;
    END IF;
  END PROCESS Rate_Transition_process;


  Constant_out1 <= to_unsigned(16#001#, 9);

  Add_out1 <= Rate_Transition_out1 + Constant_out1;

  Input_Addr <= std_logic_vector(Add_out1);

  -- Free running, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  -- 
  Counter_0_to_b_k_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Counter_0_to_b_k_1_out1 <= to_unsigned(16#000#, 9);
    ELSIF rising_edge(clk) THEN
      IF enb_1_4_0 = '1' THEN
        Counter_0_to_b_k_1_out1 <= Counter_0_to_b_k_1_out1 + to_unsigned(16#001#, 9);
      END IF;
    END IF;
  END PROCESS Counter_0_to_b_k_1_process;


  Subtract_op_stage2 <= Rate_Transition_out1 - Counter_0_to_b_k_1_out1;

  Realignment_delay_out1 <= to_unsigned(16#000#, 9);

  Subtract_out1 <= Subtract_op_stage2 - Realignment_delay_out1;

  Data_History_Rd_addr <= std_logic_vector(Subtract_out1);

  
  Compare_To_Zero_out1 <= '1' WHEN Counter_0_to_b_k_1_out1 = to_unsigned(16#000#, 9) ELSE
      '0';

  b_k_addr <= std_logic_vector(Counter_0_to_b_k_1_out1);

  End_of_sample_calc <= Compare_To_Zero_out1;

END rtl;

