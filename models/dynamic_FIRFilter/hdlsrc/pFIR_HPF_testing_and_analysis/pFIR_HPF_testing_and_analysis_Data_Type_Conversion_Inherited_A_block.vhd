-- -------------------------------------------------------------
-- 
-- File Name: /home/justin/Documents/FEI/simulink_models/models/dynamic_FIRFilter/hdlsrc/pFIR_HPF_testing_and_analysis/pFIR_HPF_testing_and_analysis_Data_Type_Conversion_Inherited_A_block.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: pFIR_HPF_testing_and_analysis_Data_Type_Conversion_Inherited_A_block
-- Source Path: pFIR_HPF_testing_and_analysis/dataplane/Test FIR with Custom FIR Libraries Sample Based Filtering/Right 
-- Channel Processing/Static Upclocked FIR/B_k_Memory_Block/Data Type Conversion Inherited 
-- Hierarchy Level: 5
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pFIR_HPF_testing_and_analysis_Data_Type_Conversion_Inherited_A_block IS
  PORT( u                                 :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        y                                 :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END pFIR_HPF_testing_and_analysis_Data_Type_Conversion_Inherited_A_block;


ARCHITECTURE rtl OF pFIR_HPF_testing_and_analysis_Data_Type_Conversion_Inherited_A_block IS

BEGIN

  y <= u;

END rtl;

