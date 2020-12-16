-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\spike_generator_sim\pseudo_random_lut\pseudo_random_lut_nfp_wire_single.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: pseudo_random_lut_nfp_wire_single
-- Source Path: pseudo_random_lut/nfp_wire_single
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pseudo_random_lut_nfp_wire_single IS
  PORT( nfp_in                            :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
        nfp_out                           :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
        );
END pseudo_random_lut_nfp_wire_single;


ARCHITECTURE rtl OF pseudo_random_lut_nfp_wire_single IS

BEGIN
  nfp_out <= nfp_in;

END rtl;
