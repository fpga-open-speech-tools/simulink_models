-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\control_path_sim\calc_tau\calc_tau_Calculate_tauwb.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: calc_tau_Calculate_tauwb
-- Source Path: calc_tau/Calculate tauwb
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY calc_tau_Calculate_tauwb IS
  PORT( In1                               :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        tauwb                             :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
        );
END calc_tau_Calculate_tauwb;


ARCHITECTURE rtl OF calc_tau_Calculate_tauwb IS

  -- Component Declarations
  COMPONENT calc_tau_nfp_sub_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  COMPONENT calc_tau_nfp_mul_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  COMPONENT calc_tau_nfp_add_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : calc_tau_nfp_sub_single
    USE ENTITY work.calc_tau_nfp_sub_single(rtl);

  FOR ALL : calc_tau_nfp_mul_single
    USE ENTITY work.calc_tau_nfp_mul_single(rtl);

  FOR ALL : calc_tau_nfp_add_single
    USE ENTITY work.calc_tau_nfp_add_single(rtl);

  -- Signals
  SIGNAL Constant1_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Subtract_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Divide_out1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product_out1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant2_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Add_out1                         : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  u_nfp_sub_comp : calc_tau_nfp_sub_single
    PORT MAP( nfp_in1 => In1,  -- ufix32
              nfp_in2 => Constant1_out1,  -- ufix32
              nfp_out => Subtract_out1  -- ufix32
              );

  u_nfp_mul_comp : calc_tau_nfp_mul_single
    PORT MAP( nfp_in1 => Subtract_out1,  -- ufix32
              nfp_in2 => Divide_out1,  -- ufix32
              nfp_out => Product_out1  -- ufix32
              );

  u_nfp_add_comp : calc_tau_nfp_add_single
    PORT MAP( nfp_in1 => Product_out1,  -- ufix32
              nfp_in2 => Constant2_out1,  -- ufix32
              nfp_out => Add_out1  -- ufix32
              );

  Constant1_out1 <= X"3b4557bf";

  Divide_out1 <= X"3e764942";

  Constant2_out1 <= X"3a4b640d";

  tauwb <= Add_out1;

END rtl;
