-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\wickh\Documents\NIH\Review\simulink_models\models\fft_filters\hdlsrc\fft_filters\fft_filters_Complex4Multiply_block.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: fft_filters_Complex4Multiply_block
-- Source Path: fft_filters/dataplane/FFT_Analysis_Synthesis_Left/Synthesis/iFFT/MINRESRX2_BUTTERFLY/Complex4Multiply
-- Hierarchy Level: 5
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY fft_filters_Complex4Multiply_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_16_0                        :   IN    std_logic;
        btfIn2_re                         :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En23
        btfIn2_im                         :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En23
        din2Dly_vld                       :   IN    std_logic;
        twdl_re                           :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En29
        twdl_im                           :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En29
        dinXTwdl_re                       :   OUT   std_logic_vector(62 DOWNTO 0);  -- sfix63_En52
        dinXTwdl_im                       :   OUT   std_logic_vector(62 DOWNTO 0);  -- sfix63_En52
        dinXTwdl_vld                      :   OUT   std_logic
        );
END fft_filters_Complex4Multiply_block;


ARCHITECTURE rtl OF fft_filters_Complex4Multiply_block IS

  -- Signals
  SIGNAL btfIn2_re_signed                 : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL din_re_reg                       : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL btfIn2_im_signed                 : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL din_im_reg                       : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL twdl_re_signed                   : signed(30 DOWNTO 0);  -- sfix31_En29
  SIGNAL twdl_re_reg                      : signed(30 DOWNTO 0);  -- sfix31_En29
  SIGNAL twdl_im_signed                   : signed(30 DOWNTO 0);  -- sfix31_En29
  SIGNAL twdl_im_reg                      : signed(30 DOWNTO 0);  -- sfix31_En29
  SIGNAL Complex4Multiply_din1_re_pipe1   : signed(30 DOWNTO 0) := to_signed(16#00000000#, 31);  -- sfix31
  SIGNAL Complex4Multiply_din1_im_pipe1   : signed(30 DOWNTO 0) := to_signed(16#00000000#, 31);  -- sfix31
  SIGNAL Complex4Multiply_mult1_re_pipe1  : signed(61 DOWNTO 0) := to_signed(0, 62);  -- sfix62
  SIGNAL Complex4Multiply_mult2_re_pipe1  : signed(61 DOWNTO 0) := to_signed(0, 62);  -- sfix62
  SIGNAL Complex4Multiply_mult1_im_pipe1  : signed(61 DOWNTO 0) := to_signed(0, 62);  -- sfix62
  SIGNAL Complex4Multiply_mult2_im_pipe1  : signed(61 DOWNTO 0) := to_signed(0, 62);  -- sfix62
  SIGNAL Complex4Multiply_twiddle_re_pipe1 : signed(30 DOWNTO 0) := to_signed(16#00000000#, 31);  -- sfix31
  SIGNAL Complex4Multiply_twiddle_im_pipe1 : signed(30 DOWNTO 0) := to_signed(16#00000000#, 31);  -- sfix31
  SIGNAL prod1_re                         : signed(61 DOWNTO 0) := to_signed(0, 62);  -- sfix62_En52
  SIGNAL prod1_im                         : signed(61 DOWNTO 0) := to_signed(0, 62);  -- sfix62_En52
  SIGNAL prod2_re                         : signed(61 DOWNTO 0) := to_signed(0, 62);  -- sfix62_En52
  SIGNAL prod2_im                         : signed(61 DOWNTO 0) := to_signed(0, 62);  -- sfix62_En52
  SIGNAL din_vld_dly1                     : std_logic;
  SIGNAL din_vld_dly2                     : std_logic;
  SIGNAL din_vld_dly3                     : std_logic;
  SIGNAL prod_vld                         : std_logic;
  SIGNAL Complex4Add_multRes_re_reg       : signed(62 DOWNTO 0);  -- sfix63
  SIGNAL Complex4Add_multRes_im_reg       : signed(62 DOWNTO 0);  -- sfix63
  SIGNAL Complex4Add_prod_vld_reg1        : std_logic;
  SIGNAL Complex4Add_prod1_re_reg         : signed(61 DOWNTO 0);  -- sfix62
  SIGNAL Complex4Add_prod1_im_reg         : signed(61 DOWNTO 0);  -- sfix62
  SIGNAL Complex4Add_prod2_re_reg         : signed(61 DOWNTO 0);  -- sfix62
  SIGNAL Complex4Add_prod2_im_reg         : signed(61 DOWNTO 0);  -- sfix62
  SIGNAL Complex4Add_multRes_re_reg_next  : signed(62 DOWNTO 0);  -- sfix63_En52
  SIGNAL Complex4Add_multRes_im_reg_next  : signed(62 DOWNTO 0);  -- sfix63_En52
  SIGNAL Complex4Add_sub_cast             : signed(62 DOWNTO 0);  -- sfix63_En52
  SIGNAL Complex4Add_sub_cast_1           : signed(62 DOWNTO 0);  -- sfix63_En52
  SIGNAL Complex4Add_add_cast             : signed(62 DOWNTO 0);  -- sfix63_En52
  SIGNAL Complex4Add_add_cast_1           : signed(62 DOWNTO 0);  -- sfix63_En52
  SIGNAL mulResFP_re                      : signed(62 DOWNTO 0);  -- sfix63_En52
  SIGNAL mulResFP_im                      : signed(62 DOWNTO 0);  -- sfix63_En52

BEGIN
  btfIn2_re_signed <= signed(btfIn2_re);

  intdelay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      din_re_reg <= to_signed(16#00000000#, 31);
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        din_re_reg <= btfIn2_re_signed;
      END IF;
    END IF;
  END PROCESS intdelay_process;


  btfIn2_im_signed <= signed(btfIn2_im);

  intdelay_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      din_im_reg <= to_signed(16#00000000#, 31);
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        din_im_reg <= btfIn2_im_signed;
      END IF;
    END IF;
  END PROCESS intdelay_1_process;


  twdl_re_signed <= signed(twdl_re);

  intdelay_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      twdl_re_reg <= to_signed(16#00000000#, 31);
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        twdl_re_reg <= twdl_re_signed;
      END IF;
    END IF;
  END PROCESS intdelay_2_process;


  twdl_im_signed <= signed(twdl_im);

  intdelay_3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      twdl_im_reg <= to_signed(16#00000000#, 31);
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        twdl_im_reg <= twdl_im_signed;
      END IF;
    END IF;
  END PROCESS intdelay_3_process;


  -- Complex4Multiply
  Complex4Multiply_process : PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        prod1_re <= Complex4Multiply_mult1_re_pipe1;
        prod2_re <= Complex4Multiply_mult2_re_pipe1;
        prod1_im <= Complex4Multiply_mult1_im_pipe1;
        prod2_im <= Complex4Multiply_mult2_im_pipe1;
        Complex4Multiply_mult1_re_pipe1 <= Complex4Multiply_din1_re_pipe1 * Complex4Multiply_twiddle_re_pipe1;
        Complex4Multiply_mult2_re_pipe1 <= Complex4Multiply_din1_im_pipe1 * Complex4Multiply_twiddle_im_pipe1;
        Complex4Multiply_mult1_im_pipe1 <= Complex4Multiply_din1_re_pipe1 * Complex4Multiply_twiddle_im_pipe1;
        Complex4Multiply_mult2_im_pipe1 <= Complex4Multiply_din1_im_pipe1 * Complex4Multiply_twiddle_re_pipe1;
        Complex4Multiply_twiddle_re_pipe1 <= twdl_re_reg;
        Complex4Multiply_twiddle_im_pipe1 <= twdl_im_reg;
        Complex4Multiply_din1_re_pipe1 <= din_re_reg;
        Complex4Multiply_din1_im_pipe1 <= din_im_reg;
      END IF;
    END IF;
  END PROCESS Complex4Multiply_process;


  intdelay_4_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      din_vld_dly1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        din_vld_dly1 <= din2Dly_vld;
      END IF;
    END IF;
  END PROCESS intdelay_4_process;


  intdelay_5_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      din_vld_dly2 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        din_vld_dly2 <= din_vld_dly1;
      END IF;
    END IF;
  END PROCESS intdelay_5_process;


  intdelay_6_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      din_vld_dly3 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        din_vld_dly3 <= din_vld_dly2;
      END IF;
    END IF;
  END PROCESS intdelay_6_process;


  intdelay_7_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      prod_vld <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        prod_vld <= din_vld_dly3;
      END IF;
    END IF;
  END PROCESS intdelay_7_process;


  -- Complex4Add
  Complex4Add_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Complex4Add_multRes_re_reg <= to_signed(0, 63);
      Complex4Add_multRes_im_reg <= to_signed(0, 63);
      Complex4Add_prod1_re_reg <= to_signed(0, 62);
      Complex4Add_prod1_im_reg <= to_signed(0, 62);
      Complex4Add_prod2_re_reg <= to_signed(0, 62);
      Complex4Add_prod2_im_reg <= to_signed(0, 62);
      Complex4Add_prod_vld_reg1 <= '0';
      dinXTwdl_vld <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        Complex4Add_multRes_re_reg <= Complex4Add_multRes_re_reg_next;
        Complex4Add_multRes_im_reg <= Complex4Add_multRes_im_reg_next;
        Complex4Add_prod1_re_reg <= prod1_re;
        Complex4Add_prod1_im_reg <= prod1_im;
        Complex4Add_prod2_re_reg <= prod2_re;
        Complex4Add_prod2_im_reg <= prod2_im;
        dinXTwdl_vld <= Complex4Add_prod_vld_reg1;
        Complex4Add_prod_vld_reg1 <= prod_vld;
      END IF;
    END IF;
  END PROCESS Complex4Add_process;

  Complex4Add_sub_cast <= resize(Complex4Add_prod1_re_reg, 63);
  Complex4Add_sub_cast_1 <= resize(Complex4Add_prod2_re_reg, 63);
  Complex4Add_multRes_re_reg_next <= Complex4Add_sub_cast - Complex4Add_sub_cast_1;
  Complex4Add_add_cast <= resize(Complex4Add_prod1_im_reg, 63);
  Complex4Add_add_cast_1 <= resize(Complex4Add_prod2_im_reg, 63);
  Complex4Add_multRes_im_reg_next <= Complex4Add_add_cast + Complex4Add_add_cast_1;
  mulResFP_re <= Complex4Add_multRes_re_reg;
  mulResFP_im <= Complex4Add_multRes_im_reg;

  dinXTwdl_re <= std_logic_vector(mulResFP_re);

  dinXTwdl_im <= std_logic_vector(mulResFP_im);

END rtl;

