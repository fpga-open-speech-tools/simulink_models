-- -------------------------------------------------------------
-- 
-- File Name: /mnt/data/trevor/research/NIH_SBIR_R44_DC015443/simulink_models/models/wiener_noise_reduction/hdlsrc/wiener/wiener_dataplane_pkg.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE wiener_dataplane_pkg IS
  TYPE vector_of_signed32 IS ARRAY (NATURAL RANGE <>) OF signed(31 DOWNTO 0);
  TYPE vector_of_unsigned2 IS ARRAY (NATURAL RANGE <>) OF unsigned(1 DOWNTO 0);
END wiener_dataplane_pkg;
