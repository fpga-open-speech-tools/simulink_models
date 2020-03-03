-- -------------------------------------------------------------
-- 
-- File Name: /home/justin/Documents/FEI/simulink_models/models/dynamic_FIRFilter/hdlsrc/pFIR_HPF_testing_and_analysis/pFIR_HPF_testing_and_analysis_Multiply_And_Sum.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: pFIR_HPF_testing_and_analysis_Multiply_And_Sum
-- Source Path: pFIR_HPF_testing_and_analysis/dataplane/Test FIR with Custom FIR Libraries Sample Based Filtering/Left 
-- Channel Processing/Static Upclocked FIR/Multiply_And_Su
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pFIR_HPF_testing_and_analysis_Multiply_And_Sum IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_2_0                         :   IN    std_logic;
        x_n_i                             :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        End_of_sample_calc                :   IN    std_logic;
        b_i                               :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Filtered_Output                   :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Output_Valid                      :   OUT   std_logic
        );
END pFIR_HPF_testing_and_analysis_Multiply_And_Sum;


ARCHITECTURE rtl OF pFIR_HPF_testing_and_analysis_Multiply_And_Sum IS

  ATTRIBUTE multstyle : string;

  -- Signals
  SIGNAL Bitwise_Operator_out1            : std_logic;
  SIGNAL Bitwise_Operator_out1_1          : std_logic;
  SIGNAL Constant_out1                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL x_n_i_signed                     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL b_i_signed                       : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL b_i_1                            : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL mulOutput                        : signed(63 DOWNTO 0);  -- sfix64_En56
  SIGNAL Sum_memory_out1                  : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Reset_Switch_out1                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Multiply_Add_add_add_cast        : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Multiply_Add_out1                : signed(31 DOWNTO 0);  -- sfix32_En28

  ATTRIBUTE multstyle OF mulOutput : SIGNAL IS "dsp";

BEGIN
  -- End_of_sample_calc triggers this subsystem to give the FIR output for this sample.
  -- Also, it resets the sum memory back to 0.

  Bitwise_Operator_out1 <=  NOT End_of_sample_calc;

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Bitwise_Operator_out1_1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        Bitwise_Operator_out1_1 <= Bitwise_Operator_out1;
      END IF;
    END IF;
  END PROCESS delayMatch_process;


  Constant_out1 <= to_signed(0, 32);

  x_n_i_signed <= signed(x_n_i);

  b_i_signed <= signed(b_i);

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      b_i_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        b_i_1 <= b_i_signed;
      END IF;
    END IF;
  END PROCESS delayMatch1_process;


  mulOutput <= x_n_i_signed * b_i_1;

  
  Reset_Switch_out1 <= Constant_out1 WHEN Bitwise_Operator_out1_1 = '0' ELSE
      Sum_memory_out1;

  -- 
  Multiply_Add_add_add_cast <= mulOutput(59 DOWNTO 28);
  Multiply_Add_out1 <= Reset_Switch_out1 + Multiply_Add_add_add_cast;

  Sum_memory_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Sum_memory_out1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        Sum_memory_out1 <= Multiply_Add_out1;
      END IF;
    END IF;
  END PROCESS Sum_memory_process;


  Filtered_Output <= std_logic_vector(Sum_memory_out1);

  Output_Valid <= End_of_sample_calc;

END rtl;

