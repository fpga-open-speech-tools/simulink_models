-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\wickh\Documents\NIH\Review\simulink_models\models\fft_filters\hdlsrc\fft_filters\fft_filters_MINRESRX2FFT_MEMSEL_block.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: fft_filters_MINRESRX2FFT_MEMSEL_block
-- Source Path: fft_filters/dataplane/FFT_Analysis_Synthesis_Left/Synthesis/iFFT/MINRESRX2FFT_MEMSEL
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY fft_filters_MINRESRX2FFT_MEMSEL_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_16_0                        :   IN    std_logic;
        btfOut1_re                        :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En23
        btfOut1_im                        :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En23
        btfOut2_re                        :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En23
        btfOut2_im                        :   IN    std_logic_vector(30 DOWNTO 0);  -- sfix31_En23
        btfOut_vld                        :   IN    std_logic;
        stage                             :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
        initIC                            :   IN    std_logic;
        stgOut1_re                        :   OUT   std_logic_vector(30 DOWNTO 0);  -- sfix31_En23
        stgOut1_im                        :   OUT   std_logic_vector(30 DOWNTO 0);  -- sfix31_En23
        stgOut2_re                        :   OUT   std_logic_vector(30 DOWNTO 0);  -- sfix31_En23
        stgOut2_im                        :   OUT   std_logic_vector(30 DOWNTO 0);  -- sfix31_En23
        stgOut_vld                        :   OUT   std_logic
        );
END fft_filters_MINRESRX2FFT_MEMSEL_block;


ARCHITECTURE rtl OF fft_filters_MINRESRX2FFT_MEMSEL_block IS

  -- Signals
  SIGNAL btfOut1_re_signed                : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL btfOut1_im_signed                : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL btfOut2_re_signed                : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL btfOut2_im_signed                : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL stage_unsigned                   : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL MINRESRX2FFTMEMSEL_stgOut1Reg_re : signed(30 DOWNTO 0);  -- sfix31
  SIGNAL MINRESRX2FFTMEMSEL_stgOut1Reg_im : signed(30 DOWNTO 0);  -- sfix31
  SIGNAL MINRESRX2FFTMEMSEL_stgOut2Reg_re : signed(30 DOWNTO 0);  -- sfix31
  SIGNAL MINRESRX2FFTMEMSEL_stgOut2Reg_im : signed(30 DOWNTO 0);  -- sfix31
  SIGNAL MINRESRX2FFTMEMSEL_stgOutReg_vld : std_logic;
  SIGNAL MINRESRX2FFTMEMSEL_cnt           : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL MINRESRX2FFTMEMSEL_cntMax        : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL MINRESRX2FFTMEMSEL_muxSel        : std_logic;
  SIGNAL MINRESRX2FFTMEMSEL_stgOut1Reg_re_next : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL MINRESRX2FFTMEMSEL_stgOut1Reg_im_next : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL MINRESRX2FFTMEMSEL_stgOut2Reg_re_next : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL MINRESRX2FFTMEMSEL_stgOut2Reg_im_next : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL MINRESRX2FFTMEMSEL_stgOutReg_vld_next : std_logic;
  SIGNAL MINRESRX2FFTMEMSEL_cnt_next      : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL MINRESRX2FFTMEMSEL_cntMax_next   : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL MINRESRX2FFTMEMSEL_muxSel_next   : std_logic;
  SIGNAL stgOut1_re_tmp                   : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL stgOut1_im_tmp                   : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL stgOut2_re_tmp                   : signed(30 DOWNTO 0);  -- sfix31_En23
  SIGNAL stgOut2_im_tmp                   : signed(30 DOWNTO 0);  -- sfix31_En23

BEGIN
  btfOut1_re_signed <= signed(btfOut1_re);

  btfOut1_im_signed <= signed(btfOut1_im);

  btfOut2_re_signed <= signed(btfOut2_re);

  btfOut2_im_signed <= signed(btfOut2_im);

  stage_unsigned <= unsigned(stage);

  -- MINRESRX2FFTMEMSEL
  MINRESRX2FFTMEMSEL_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      MINRESRX2FFTMEMSEL_stgOut1Reg_re <= to_signed(16#00000000#, 31);
      MINRESRX2FFTMEMSEL_stgOut1Reg_im <= to_signed(16#00000000#, 31);
      MINRESRX2FFTMEMSEL_stgOut2Reg_re <= to_signed(16#00000000#, 31);
      MINRESRX2FFTMEMSEL_stgOut2Reg_im <= to_signed(16#00000000#, 31);
      MINRESRX2FFTMEMSEL_cnt <= to_unsigned(16#00#, 6);
      MINRESRX2FFTMEMSEL_cntMax <= to_unsigned(16#00#, 6);
      MINRESRX2FFTMEMSEL_muxSel <= '0';
      MINRESRX2FFTMEMSEL_stgOutReg_vld <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_16_0 = '1' THEN
        MINRESRX2FFTMEMSEL_stgOut1Reg_re <= MINRESRX2FFTMEMSEL_stgOut1Reg_re_next;
        MINRESRX2FFTMEMSEL_stgOut1Reg_im <= MINRESRX2FFTMEMSEL_stgOut1Reg_im_next;
        MINRESRX2FFTMEMSEL_stgOut2Reg_re <= MINRESRX2FFTMEMSEL_stgOut2Reg_re_next;
        MINRESRX2FFTMEMSEL_stgOut2Reg_im <= MINRESRX2FFTMEMSEL_stgOut2Reg_im_next;
        MINRESRX2FFTMEMSEL_stgOutReg_vld <= MINRESRX2FFTMEMSEL_stgOutReg_vld_next;
        MINRESRX2FFTMEMSEL_cnt <= MINRESRX2FFTMEMSEL_cnt_next;
        MINRESRX2FFTMEMSEL_cntMax <= MINRESRX2FFTMEMSEL_cntMax_next;
        MINRESRX2FFTMEMSEL_muxSel <= MINRESRX2FFTMEMSEL_muxSel_next;
      END IF;
    END IF;
  END PROCESS MINRESRX2FFTMEMSEL_process;

  MINRESRX2FFTMEMSEL_output : PROCESS (MINRESRX2FFTMEMSEL_cnt, MINRESRX2FFTMEMSEL_cntMax, MINRESRX2FFTMEMSEL_muxSel,
       MINRESRX2FFTMEMSEL_stgOut1Reg_im, MINRESRX2FFTMEMSEL_stgOut1Reg_re,
       MINRESRX2FFTMEMSEL_stgOut2Reg_im, MINRESRX2FFTMEMSEL_stgOut2Reg_re,
       MINRESRX2FFTMEMSEL_stgOutReg_vld, btfOut1_im_signed, btfOut1_re_signed,
       btfOut2_im_signed, btfOut2_re_signed, btfOut_vld, initIC,
       stage_unsigned)
  BEGIN
    MINRESRX2FFTMEMSEL_stgOut1Reg_re_next <= MINRESRX2FFTMEMSEL_stgOut1Reg_re;
    MINRESRX2FFTMEMSEL_stgOut1Reg_im_next <= MINRESRX2FFTMEMSEL_stgOut1Reg_im;
    MINRESRX2FFTMEMSEL_stgOut2Reg_re_next <= MINRESRX2FFTMEMSEL_stgOut2Reg_re;
    MINRESRX2FFTMEMSEL_stgOut2Reg_im_next <= MINRESRX2FFTMEMSEL_stgOut2Reg_im;
    MINRESRX2FFTMEMSEL_cnt_next <= MINRESRX2FFTMEMSEL_cnt;
    MINRESRX2FFTMEMSEL_cntMax_next <= MINRESRX2FFTMEMSEL_cntMax;
    MINRESRX2FFTMEMSEL_muxSel_next <= MINRESRX2FFTMEMSEL_muxSel;
    IF MINRESRX2FFTMEMSEL_muxSel = '1' THEN 
      MINRESRX2FFTMEMSEL_stgOut1Reg_re_next <= btfOut2_re_signed;
      MINRESRX2FFTMEMSEL_stgOut1Reg_im_next <= btfOut2_im_signed;
      MINRESRX2FFTMEMSEL_stgOut2Reg_re_next <= btfOut1_re_signed;
      MINRESRX2FFTMEMSEL_stgOut2Reg_im_next <= btfOut1_im_signed;
    ELSE 
      MINRESRX2FFTMEMSEL_stgOut1Reg_re_next <= btfOut1_re_signed;
      MINRESRX2FFTMEMSEL_stgOut1Reg_im_next <= btfOut1_im_signed;
      MINRESRX2FFTMEMSEL_stgOut2Reg_re_next <= btfOut2_re_signed;
      MINRESRX2FFTMEMSEL_stgOut2Reg_im_next <= btfOut2_im_signed;
    END IF;
    IF initIC = '1' THEN 
      MINRESRX2FFTMEMSEL_cnt_next <= to_unsigned(16#00#, 6);
      MINRESRX2FFTMEMSEL_muxSel_next <= '0';
      CASE stage_unsigned IS
        WHEN "000" =>
          MINRESRX2FFTMEMSEL_cntMax_next <= to_unsigned(16#1F#, 6);
        WHEN "110" =>
          MINRESRX2FFTMEMSEL_cntMax_next <= to_unsigned(16#3F#, 6);
        WHEN OTHERS => 
          MINRESRX2FFTMEMSEL_cntMax_next <= MINRESRX2FFTMEMSEL_cntMax srl 1;
      END CASE;
    ELSIF btfOut_vld = '1' THEN 
      IF MINRESRX2FFTMEMSEL_cnt = MINRESRX2FFTMEMSEL_cntMax THEN 
        MINRESRX2FFTMEMSEL_cnt_next <= to_unsigned(16#00#, 6);
        MINRESRX2FFTMEMSEL_muxSel_next <=  NOT MINRESRX2FFTMEMSEL_muxSel;
      ELSE 
        MINRESRX2FFTMEMSEL_cnt_next <= MINRESRX2FFTMEMSEL_cnt + to_unsigned(16#01#, 6);
      END IF;
    END IF;
    MINRESRX2FFTMEMSEL_stgOutReg_vld_next <= btfOut_vld;
    stgOut1_re_tmp <= MINRESRX2FFTMEMSEL_stgOut1Reg_re;
    stgOut1_im_tmp <= MINRESRX2FFTMEMSEL_stgOut1Reg_im;
    stgOut2_re_tmp <= MINRESRX2FFTMEMSEL_stgOut2Reg_re;
    stgOut2_im_tmp <= MINRESRX2FFTMEMSEL_stgOut2Reg_im;
    stgOut_vld <= MINRESRX2FFTMEMSEL_stgOutReg_vld;
  END PROCESS MINRESRX2FFTMEMSEL_output;


  stgOut1_re <= std_logic_vector(stgOut1_re_tmp);

  stgOut1_im <= std_logic_vector(stgOut1_im_tmp);

  stgOut2_re <= std_logic_vector(stgOut2_re_tmp);

  stgOut2_im <= std_logic_vector(stgOut2_im_tmp);

END rtl;

