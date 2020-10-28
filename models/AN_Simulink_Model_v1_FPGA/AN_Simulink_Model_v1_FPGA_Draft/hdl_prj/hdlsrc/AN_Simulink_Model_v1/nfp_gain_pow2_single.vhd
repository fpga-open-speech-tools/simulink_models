-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\AN_Simulink_Model_v1\nfp_gain_pow2_single.vhd
-- Created: 2020-04-16 11:39:35
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: nfp_gain_pow2_single
-- Source Path: AN_Simulink_Model_v1/Auditory Nerve Model/C1 Chirp Filter/C1 FIlter/nfp_gain_pow2_single
-- Hierarchy Level: 2
-- 
-- {Latency Strategy = "Zero", Denormal Handling = "off"}
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY nfp_gain_pow2_single IS
  PORT( nfp_in1                           :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
        nfp_in2                           :   IN    std_logic;  -- ufix1
        nfp_in3                           :   IN    std_logic_vector(8 DOWNTO 0);  -- sfix9
        nfp_out                           :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
        );
END nfp_gain_pow2_single;


ARCHITECTURE rtl OF nfp_gain_pow2_single IS

  ATTRIBUTE multstyle : string;

  -- Signals
  SIGNAL nfp_in1_unsigned                 : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL aSign                            : std_logic;  -- ufix1
  SIGNAL aExponent                        : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL aMantissa                        : unsigned(22 DOWNTO 0);  -- ufix23
  SIGNAL Logical_Operator1_out1           : std_logic;  -- ufix1
  SIGNAL Bit_Reduce_out1                  : std_logic;  -- ufix1
  SIGNAL Bit_Reduce1_out1                 : std_logic;  -- ufix1
  SIGNAL Logical_Operator6_out1           : std_logic;  -- ufix1
  SIGNAL Constant_out1                    : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL nfp_in3_signed                   : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL Bit_Slice_out1                   : std_logic;  -- ufix1
  SIGNAL Bit_Concat_out1                  : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Data_Type_Conversion_out1        : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL Bit_Concat1_out1                 : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Data_Type_Conversion1_out1       : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL Add_out1                         : signed(9 DOWNTO 0);  -- sfix10
  SIGNAL Bit_Slice3_out1                  : std_logic;  -- ufix1
  SIGNAL Bit_Slice2_out1                  : std_logic;  -- ufix1
  SIGNAL Logical_Operator_out1            : std_logic;  -- ufix1
  SIGNAL Bit_Slice1_out1                  : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL Logical_Operator4_out1           : std_logic;  -- ufix1
  SIGNAL Logical_Operator7_out1           : std_logic;  -- ufix1
  SIGNAL Logical_Operator5_out1           : std_logic;  -- ufix1
  SIGNAL Bit_Concat4_out1                 : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL Bit_Concat5_out1                 : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL Bit_Concat6_out1                 : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL Switch1_out1                     : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL Bit_Reduce2_out1                 : std_logic;  -- ufix1
  SIGNAL Bit_Reduce3_out1                 : std_logic;  -- ufix1
  SIGNAL Logical_Operator8_out1           : std_logic;  -- ufix1
  SIGNAL Logical_Operator2_out1           : std_logic;  -- ufix1
  SIGNAL Logical_Operator3_out1           : std_logic;  -- ufix1
  SIGNAL Constant1_out1                   : unsigned(22 DOWNTO 0);  -- ufix23
  SIGNAL Switch_out1                      : unsigned(22 DOWNTO 0);  -- ufix23
  SIGNAL nfp_out_pack                     : unsigned(31 DOWNTO 0);  -- ufix32

BEGIN
  nfp_in1_unsigned <= unsigned(nfp_in1);

  -- Split 32 bit word into FP sign, exponent, mantissa
  aSign <= nfp_in1_unsigned(31);
  aExponent <= nfp_in1_unsigned(30 DOWNTO 23);
  aMantissa <= nfp_in1_unsigned(22 DOWNTO 0);

  Logical_Operator1_out1 <= aSign XOR nfp_in2;

  Bit_Reduce_out1 <= (aExponent(7) AND aExponent(6) AND aExponent(5) AND aExponent(4) AND aExponent(3) AND aExponent(2) AND aExponent(1) AND aExponent(0));

  Bit_Reduce1_out1 <= (aExponent(7) OR aExponent(6) OR aExponent(5) OR aExponent(4) OR aExponent(3) OR aExponent(2) OR aExponent(1) OR aExponent(0));

  Logical_Operator6_out1 <=  NOT Bit_Reduce1_out1;

  Constant_out1 <= to_unsigned(16#0#, 2);

  nfp_in3_signed <= signed(nfp_in3);

  Bit_Slice_out1 <= nfp_in3_signed(8);

  Bit_Concat_out1 <= Constant_out1 & aExponent;

  Data_Type_Conversion_out1 <= signed(Bit_Concat_out1);

  Bit_Concat1_out1 <= Bit_Slice_out1 & unsigned(nfp_in3_signed);

  Data_Type_Conversion1_out1 <= signed(Bit_Concat1_out1);

  Add_out1 <= Data_Type_Conversion_out1 + Data_Type_Conversion1_out1;

  Bit_Slice3_out1 <= Add_out1(9);

  Bit_Slice2_out1 <= Add_out1(8);

  Logical_Operator_out1 <= Bit_Slice2_out1 OR (Bit_Slice3_out1 OR (Bit_Reduce_out1 OR Logical_Operator6_out1));

  Bit_Slice1_out1 <= unsigned(Add_out1(7 DOWNTO 0));

  Logical_Operator4_out1 <=  NOT Bit_Slice3_out1;

  Logical_Operator7_out1 <= Bit_Reduce1_out1 AND Logical_Operator4_out1;

  Logical_Operator5_out1 <= Bit_Reduce_out1 OR Logical_Operator7_out1;

  Bit_Concat4_out1 <= unsigned'(Logical_Operator5_out1 & Logical_Operator5_out1);

  Bit_Concat5_out1 <= Bit_Concat4_out1 & Bit_Concat4_out1;

  Bit_Concat6_out1 <= Bit_Concat5_out1 & Bit_Concat5_out1;

  
  Switch1_out1 <= Bit_Slice1_out1 WHEN Logical_Operator_out1 = '0' ELSE
      Bit_Concat6_out1;

  Bit_Reduce2_out1 <= (Bit_Slice1_out1(7) AND Bit_Slice1_out1(6) AND Bit_Slice1_out1(5) AND Bit_Slice1_out1(4) AND Bit_Slice1_out1(3) AND Bit_Slice1_out1(2) AND Bit_Slice1_out1(1) AND Bit_Slice1_out1(0));

  Bit_Reduce3_out1 <= (Bit_Slice1_out1(7) OR Bit_Slice1_out1(6) OR Bit_Slice1_out1(5) OR Bit_Slice1_out1(4) OR Bit_Slice1_out1(3) OR Bit_Slice1_out1(2) OR Bit_Slice1_out1(1) OR Bit_Slice1_out1(0));

  Logical_Operator8_out1 <=  NOT Bit_Reduce3_out1;

  Logical_Operator2_out1 <=  NOT (Logical_Operator8_out1 OR (Logical_Operator6_out1 OR (Bit_Reduce2_out1 OR (Bit_Slice3_out1 OR Bit_Slice2_out1))));

  Logical_Operator3_out1 <= Bit_Reduce_out1 OR Logical_Operator2_out1;

  Constant1_out1 <= to_unsigned(16#000000#, 23);

  
  Switch_out1 <= Constant1_out1 WHEN Logical_Operator3_out1 = '0' ELSE
      aMantissa;

  -- Combine FP sign, exponent, mantissa into 32 bit word
  nfp_out_pack <= Logical_Operator1_out1 & Switch1_out1 & Switch_out1;

  nfp_out <= std_logic_vector(nfp_out_pack);

END rtl;
