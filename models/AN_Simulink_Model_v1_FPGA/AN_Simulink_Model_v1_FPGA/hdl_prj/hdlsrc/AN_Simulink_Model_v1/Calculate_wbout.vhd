-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\AN_Simulink_Model_v1\Calculate_wbout.vhd
-- Created: 2020-04-16 16:05:25
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Calculate_wbout
-- Source Path: AN_Simulink_Model_v1/Auditory Nerve Model/CP Wideband Gammatone Filter/Calculate wbout
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Calculate_wbout IS
  PORT( In1                               :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        In2                               :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        Out1                              :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
        );
END Calculate_wbout;


ARCHITECTURE rtl OF Calculate_wbout IS

  -- Component Declarations
  COMPONENT nfp_div_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT nfp_pow_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT nfp_mul_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT nfp_relop_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out1                        :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : nfp_div_single
    USE ENTITY work.nfp_div_single(rtl);

  FOR ALL : nfp_pow_single
    USE ENTITY work.nfp_pow_single(rtl);

  FOR ALL : nfp_mul_single
    USE ENTITY work.nfp_mul_single(rtl);

  FOR ALL : nfp_relop_single
    USE ENTITY work.nfp_relop_single(rtl);

  -- Signals
  SIGNAL kconst                           : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Divide_out1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant1_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Pow_out1                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product_out1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Gain_out1                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant3_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Divide1_out1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL MinMax_stage1_sel                : std_logic;
  SIGNAL MinMax_stage1_val                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product1_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  u_nfp_div_comp : nfp_div_single
    PORT MAP( nfp_in1 => In2,  -- single
              nfp_in2 => Constant_out1,  -- single
              nfp_out => Divide_out1  -- single
              );

  u_nfp_pow_comp : nfp_pow_single
    PORT MAP( nfp_in1 => Divide_out1,  -- single
              nfp_in2 => Constant1_out1,  -- single
              nfp_out => Pow_out1  -- single
              );

  u_nfp_mul_comp : nfp_mul_single
    PORT MAP( nfp_in1 => In1,  -- single
              nfp_in2 => Pow_out1,  -- single
              nfp_out => Product_out1  -- single
              );

  u_nfp_mul_comp_1 : nfp_mul_single
    PORT MAP( nfp_in1 => kconst,  -- single
              nfp_in2 => Product_out1,  -- single
              nfp_out => Gain_out1  -- single
              );

  u_nfp_relop_comp : nfp_relop_single
    PORT MAP( nfp_in1 => Constant3_out1,  -- single
              nfp_in2 => Divide1_out1,  -- single
              nfp_out1 => MinMax_stage1_sel
              );

  u_nfp_mul_comp_2 : nfp_mul_single
    PORT MAP( nfp_in1 => Gain_out1,  -- single
              nfp_in2 => MinMax_stage1_val,  -- single
              nfp_out => Product1_out1  -- single
              );

  kconst <= X"461c4000";

  Constant_out1 <= X"3a4b640d";

  Constant1_out1 <= X"40400000";

  Constant3_out1 <= X"3f800000";

  Divide1_out1 <= X"3e4ccccd";

  
  MinMax_stage1_val <= Constant3_out1 WHEN MinMax_stage1_sel = '0' ELSE
      Divide1_out1;

  Out1 <= Product1_out1;

END rtl;
