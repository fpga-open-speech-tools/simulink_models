-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\wickh\Documents\NIH\Review\simulink_models\models\fft_filters\hdlsrc\fft_filters\fft_filters_Filter_ROM_Choice.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: fft_filters_Filter_ROM_Choice
-- Source Path: fft_filters/dataplane/FFT_Analysis_Synthesis_Left/Frequency_Domain_Processing/Apply_Complex_Gains/FFT_Filter_Coefficients/Filter_ROM_Choice
-- Hierarchy Level: 5
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY fft_filters_Filter_ROM_Choice IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        enb_1_16_1                        :   IN    std_logic;
        select_rsvd                       :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        Index                             :   IN    std_logic_vector(6 DOWNTO 0);  -- ufix7
        filter_gains_re                   :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En23
        filter_gains_im                   :   OUT   std_logic_vector(23 DOWNTO 0)  -- sfix24_En23
        );
END fft_filters_Filter_ROM_Choice;


ARCHITECTURE rtl OF fft_filters_Filter_ROM_Choice IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT fft_filters_Complex_Gains_1_ROM
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_16_1                      :   IN    std_logic;
          Index                           :   IN    std_logic_vector(6 DOWNTO 0);  -- ufix7
          gains_re                        :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En23
          gains_im                        :   OUT   std_logic_vector(23 DOWNTO 0)  -- sfix24_En23
          );
  END COMPONENT;

  COMPONENT fft_filters_Complex_Gains_2_ROM
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_16_1                      :   IN    std_logic;
          Index                           :   IN    std_logic_vector(6 DOWNTO 0);  -- ufix7
          gains_re                        :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En23
          gains_im                        :   OUT   std_logic_vector(23 DOWNTO 0)  -- sfix24_En23
          );
  END COMPONENT;

  COMPONENT fft_filters_Complex_Gains_3_ROM
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_16_1                      :   IN    std_logic;
          Index                           :   IN    std_logic_vector(6 DOWNTO 0);  -- ufix7
          gains_re                        :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En23
          gains_im                        :   OUT   std_logic_vector(23 DOWNTO 0)  -- sfix24_En23
          );
  END COMPONENT;

  COMPONENT fft_filters_Complex_Gains_4_ROM
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_16_1                      :   IN    std_logic;
          Index                           :   IN    std_logic_vector(6 DOWNTO 0);  -- ufix7
          gains_re                        :   OUT   std_logic_vector(23 DOWNTO 0);  -- sfix24_En23
          gains_im                        :   OUT   std_logic_vector(23 DOWNTO 0)  -- sfix24_En23
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : fft_filters_Complex_Gains_1_ROM
    USE ENTITY work.fft_filters_Complex_Gains_1_ROM(rtl);

  FOR ALL : fft_filters_Complex_Gains_2_ROM
    USE ENTITY work.fft_filters_Complex_Gains_2_ROM(rtl);

  FOR ALL : fft_filters_Complex_Gains_3_ROM
    USE ENTITY work.fft_filters_Complex_Gains_3_ROM(rtl);

  FOR ALL : fft_filters_Complex_Gains_4_ROM
    USE ENTITY work.fft_filters_Complex_Gains_4_ROM(rtl);

  -- Signals
  SIGNAL select_rsvd_1                    : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL Complex_Gains_1_ROM_out1_re      : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL Complex_Gains_1_ROM_out1_im      : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL Complex_Gains_1_ROM_out1_re_signed : signed(23 DOWNTO 0);  -- sfix24_En23
  SIGNAL Complex_Gains_1_ROM_out1_im_signed : signed(23 DOWNTO 0);  -- sfix24_En23
  SIGNAL Complex_Gains_2_ROM_out1_re      : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL Complex_Gains_2_ROM_out1_im      : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL Complex_Gains_2_ROM_out1_re_signed : signed(23 DOWNTO 0);  -- sfix24_En23
  SIGNAL Complex_Gains_2_ROM_out1_im_signed : signed(23 DOWNTO 0);  -- sfix24_En23
  SIGNAL Complex_Gains_3_ROM_out1_re      : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL Complex_Gains_3_ROM_out1_im      : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL Complex_Gains_3_ROM_out1_re_signed : signed(23 DOWNTO 0);  -- sfix24_En23
  SIGNAL Complex_Gains_3_ROM_out1_im_signed : signed(23 DOWNTO 0);  -- sfix24_En23
  SIGNAL Complex_Gains_4_ROM_out1_re      : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL Complex_Gains_4_ROM_out1_im      : std_logic_vector(23 DOWNTO 0);  -- ufix24
  SIGNAL Complex_Gains_4_ROM_out1_re_signed : signed(23 DOWNTO 0);  -- sfix24_En23
  SIGNAL Complex_Gains_4_ROM_out1_im_signed : signed(23 DOWNTO 0);  -- sfix24_En23
  SIGNAL Multiport_Switch_out1_re         : signed(23 DOWNTO 0);  -- sfix24_En23
  SIGNAL Multiport_Switch_out1_im         : signed(23 DOWNTO 0);  -- sfix24_En23

BEGIN
  u_Complex_Gains_1_ROM : fft_filters_Complex_Gains_1_ROM
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              enb_1_16_1 => enb_1_16_1,
              Index => Index,  -- ufix7
              gains_re => Complex_Gains_1_ROM_out1_re,  -- sfix24_En23
              gains_im => Complex_Gains_1_ROM_out1_im  -- sfix24_En23
              );

  u_Complex_Gains_2_ROM : fft_filters_Complex_Gains_2_ROM
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              enb_1_16_1 => enb_1_16_1,
              Index => Index,  -- ufix7
              gains_re => Complex_Gains_2_ROM_out1_re,  -- sfix24_En23
              gains_im => Complex_Gains_2_ROM_out1_im  -- sfix24_En23
              );

  u_Complex_Gains_3_ROM : fft_filters_Complex_Gains_3_ROM
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              enb_1_16_1 => enb_1_16_1,
              Index => Index,  -- ufix7
              gains_re => Complex_Gains_3_ROM_out1_re,  -- sfix24_En23
              gains_im => Complex_Gains_3_ROM_out1_im  -- sfix24_En23
              );

  u_Complex_Gains_4_ROM : fft_filters_Complex_Gains_4_ROM
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              enb_1_16_1 => enb_1_16_1,
              Index => Index,  -- ufix7
              gains_re => Complex_Gains_4_ROM_out1_re,  -- sfix24_En23
              gains_im => Complex_Gains_4_ROM_out1_im  -- sfix24_En23
              );

  select_rsvd_1 <= unsigned(select_rsvd);

  Complex_Gains_1_ROM_out1_re_signed <= signed(Complex_Gains_1_ROM_out1_re);

  Complex_Gains_1_ROM_out1_im_signed <= signed(Complex_Gains_1_ROM_out1_im);

  Complex_Gains_2_ROM_out1_re_signed <= signed(Complex_Gains_2_ROM_out1_re);

  Complex_Gains_2_ROM_out1_im_signed <= signed(Complex_Gains_2_ROM_out1_im);

  Complex_Gains_3_ROM_out1_re_signed <= signed(Complex_Gains_3_ROM_out1_re);

  Complex_Gains_3_ROM_out1_im_signed <= signed(Complex_Gains_3_ROM_out1_im);

  Complex_Gains_4_ROM_out1_re_signed <= signed(Complex_Gains_4_ROM_out1_re);

  Complex_Gains_4_ROM_out1_im_signed <= signed(Complex_Gains_4_ROM_out1_im);

  
  Multiport_Switch_out1_re <= Complex_Gains_1_ROM_out1_re_signed WHEN select_rsvd_1 = to_unsigned(16#0#, 2) ELSE
      Complex_Gains_2_ROM_out1_re_signed WHEN select_rsvd_1 = to_unsigned(16#1#, 2) ELSE
      Complex_Gains_3_ROM_out1_re_signed WHEN select_rsvd_1 = to_unsigned(16#2#, 2) ELSE
      Complex_Gains_4_ROM_out1_re_signed;
  
  Multiport_Switch_out1_im <= Complex_Gains_1_ROM_out1_im_signed WHEN select_rsvd_1 = to_unsigned(16#0#, 2) ELSE
      Complex_Gains_2_ROM_out1_im_signed WHEN select_rsvd_1 = to_unsigned(16#1#, 2) ELSE
      Complex_Gains_3_ROM_out1_im_signed WHEN select_rsvd_1 = to_unsigned(16#2#, 2) ELSE
      Complex_Gains_4_ROM_out1_im_signed;

  filter_gains_re <= std_logic_vector(Multiport_Switch_out1_re);

  filter_gains_im <= std_logic_vector(Multiport_Switch_out1_im);

END rtl;

