-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\control_path_sim\ohc_lowpass_filter\ohc_lowpass_filter_ohc_lowpass_filter.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: ohc_lowpass_filter_ohc_lowpass_filter
-- Source Path: ohc_lowpass_filter
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ohc_lowpass_filter_ohc_lowpass_filter IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_1024_0                      :   IN    std_logic;
        ohc_lpf_in                        :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        ohc_lpf_out                       :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
        );
END ohc_lowpass_filter_ohc_lowpass_filter;


ARCHITECTURE rtl OF ohc_lowpass_filter_ohc_lowpass_filter IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT ohc_lowpass_filter_nfp_mul_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  COMPONENT ohc_lowpass_filter_nfp_add_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  COMPONENT ohc_lowpass_filter_nfp_uminus_single
    PORT( nfp_in                          :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : ohc_lowpass_filter_nfp_mul_single
    USE ENTITY work.ohc_lowpass_filter_nfp_mul_single(rtl);

  FOR ALL : ohc_lowpass_filter_nfp_add_single
    USE ENTITY work.ohc_lowpass_filter_nfp_add_single(rtl);

  FOR ALL : ohc_lowpass_filter_nfp_uminus_single
    USE ENTITY work.ohc_lowpass_filter_nfp_uminus_single(rtl);

  -- Signals
  SIGNAL Constant3_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant1_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Unit_Delay_out1                  : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant2_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product3_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product2_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Unit_Delay1_out1                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product_out1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum1_out1                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum2_out1                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant9_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant10_out1                  : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum3_out1                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Unit_Delay3_out1                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Gain2_out1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product1_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum3_out1_1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Gain1_out1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product4_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum_out1                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant4_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product7_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant5_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant11_out1                  : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product8_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product5_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum5_out1                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum6_out1                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant13_out1                  : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum7_out1                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Unit_Delay5_out1                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Gain5_out1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product6_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum7_out1_1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Gain3_out1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product9_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum4_out1                        : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  u_nfp_mul_comp : ohc_lowpass_filter_nfp_mul_single
    PORT MAP( nfp_in1 => Constant_out1,  -- ufix32
              nfp_in2 => ohc_lpf_in,  -- ufix32
              nfp_out => Product3_out1  -- ufix32
              );

  u_nfp_mul_comp_1 : ohc_lowpass_filter_nfp_mul_single
    PORT MAP( nfp_in1 => Constant1_out1,  -- ufix32
              nfp_in2 => Unit_Delay_out1,  -- ufix32
              nfp_out => Product2_out1  -- ufix32
              );

  u_nfp_mul_comp_2 : ohc_lowpass_filter_nfp_mul_single
    PORT MAP( nfp_in1 => Constant2_out1,  -- ufix32
              nfp_in2 => Unit_Delay1_out1,  -- ufix32
              nfp_out => Product_out1  -- ufix32
              );

  u_nfp_add_comp : ohc_lowpass_filter_nfp_add_single
    PORT MAP( nfp_in1 => Product2_out1,  -- ufix32
              nfp_in2 => Product_out1,  -- ufix32
              nfp_out => Sum1_out1  -- ufix32
              );

  u_nfp_add_comp_1 : ohc_lowpass_filter_nfp_add_single
    PORT MAP( nfp_in1 => Product3_out1,  -- ufix32
              nfp_in2 => Sum1_out1,  -- ufix32
              nfp_out => Sum2_out1  -- ufix32
              );

  u_nfp_uminus_comp : ohc_lowpass_filter_nfp_uminus_single
    PORT MAP( nfp_in => Unit_Delay3_out1,  -- ufix32
              nfp_out => Gain2_out1  -- ufix32
              );

  u_nfp_mul_comp_3 : ohc_lowpass_filter_nfp_mul_single
    PORT MAP( nfp_in1 => Constant10_out1,  -- ufix32
              nfp_in2 => Gain2_out1,  -- ufix32
              nfp_out => Product1_out1  -- ufix32
              );

  u_nfp_uminus_comp_1 : ohc_lowpass_filter_nfp_uminus_single
    PORT MAP( nfp_in => Sum3_out1,  -- ufix32
              nfp_out => Gain1_out1  -- ufix32
              );

  u_nfp_mul_comp_4 : ohc_lowpass_filter_nfp_mul_single
    PORT MAP( nfp_in1 => Constant9_out1,  -- ufix32
              nfp_in2 => Gain1_out1,  -- ufix32
              nfp_out => Product4_out1  -- ufix32
              );

  u_nfp_add_comp_2 : ohc_lowpass_filter_nfp_add_single
    PORT MAP( nfp_in1 => Product4_out1,  -- ufix32
              nfp_in2 => Product1_out1,  -- ufix32
              nfp_out => Sum_out1  -- ufix32
              );

  u_nfp_add_comp_3 : ohc_lowpass_filter_nfp_add_single
    PORT MAP( nfp_in1 => Sum2_out1,  -- ufix32
              nfp_in2 => Sum_out1,  -- ufix32
              nfp_out => Sum3_out1_1  -- ufix32
              );

  u_nfp_mul_comp_5 : ohc_lowpass_filter_nfp_mul_single
    PORT MAP( nfp_in1 => Constant4_out1,  -- ufix32
              nfp_in2 => Sum3_out1,  -- ufix32
              nfp_out => Product7_out1  -- ufix32
              );

  u_nfp_mul_comp_6 : ohc_lowpass_filter_nfp_mul_single
    PORT MAP( nfp_in1 => Constant3_out1,  -- ufix32
              nfp_in2 => Sum3_out1_1,  -- ufix32
              nfp_out => Product8_out1  -- ufix32
              );

  u_nfp_mul_comp_7 : ohc_lowpass_filter_nfp_mul_single
    PORT MAP( nfp_in1 => Constant5_out1,  -- ufix32
              nfp_in2 => Unit_Delay3_out1,  -- ufix32
              nfp_out => Product5_out1  -- ufix32
              );

  u_nfp_add_comp_4 : ohc_lowpass_filter_nfp_add_single
    PORT MAP( nfp_in1 => Product7_out1,  -- ufix32
              nfp_in2 => Product5_out1,  -- ufix32
              nfp_out => Sum5_out1  -- ufix32
              );

  u_nfp_add_comp_5 : ohc_lowpass_filter_nfp_add_single
    PORT MAP( nfp_in1 => Product8_out1,  -- ufix32
              nfp_in2 => Sum5_out1,  -- ufix32
              nfp_out => Sum6_out1  -- ufix32
              );

  u_nfp_uminus_comp_2 : ohc_lowpass_filter_nfp_uminus_single
    PORT MAP( nfp_in => Unit_Delay5_out1,  -- ufix32
              nfp_out => Gain5_out1  -- ufix32
              );

  u_nfp_mul_comp_8 : ohc_lowpass_filter_nfp_mul_single
    PORT MAP( nfp_in1 => Constant13_out1,  -- ufix32
              nfp_in2 => Gain5_out1,  -- ufix32
              nfp_out => Product6_out1  -- ufix32
              );

  u_nfp_uminus_comp_3 : ohc_lowpass_filter_nfp_uminus_single
    PORT MAP( nfp_in => Sum7_out1,  -- ufix32
              nfp_out => Gain3_out1  -- ufix32
              );

  u_nfp_mul_comp_9 : ohc_lowpass_filter_nfp_mul_single
    PORT MAP( nfp_in1 => Constant11_out1,  -- ufix32
              nfp_in2 => Gain3_out1,  -- ufix32
              nfp_out => Product9_out1  -- ufix32
              );

  u_nfp_add_comp_6 : ohc_lowpass_filter_nfp_add_single
    PORT MAP( nfp_in1 => Product9_out1,  -- ufix32
              nfp_in2 => Product6_out1,  -- ufix32
              nfp_out => Sum4_out1  -- ufix32
              );

  u_nfp_add_comp_7 : ohc_lowpass_filter_nfp_add_single
    PORT MAP( nfp_in1 => Sum6_out1,  -- ufix32
              nfp_in2 => Sum4_out1,  -- ufix32
              nfp_out => Sum7_out1_1  -- ufix32
              );

  Constant3_out1 <= X"3d1ac58c";

  Constant1_out1 <= X"3d1ac58c";

  Unit_Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Unit_Delay_out1 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Unit_Delay_out1 <= ohc_lpf_in;
      END IF;
    END IF;
  END PROCESS Unit_Delay_process;


  Constant2_out1 <= X"00000000";

  Constant_out1 <= X"3d1ac58c";

  Unit_Delay1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Unit_Delay1_out1 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Unit_Delay1_out1 <= Unit_Delay_out1;
      END IF;
    END IF;
  END PROCESS Unit_Delay1_process;


  Constant9_out1 <= X"bf6ca74e";

  Constant10_out1 <= X"00000000";

  Unit_Delay3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Unit_Delay3_out1 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Unit_Delay3_out1 <= Sum3_out1;
      END IF;
    END IF;
  END PROCESS Unit_Delay3_process;


  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Sum3_out1 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Sum3_out1 <= Sum3_out1_1;
      END IF;
    END IF;
  END PROCESS delayMatch_process;


  Constant4_out1 <= X"3d1ac58c";

  Constant5_out1 <= X"00000000";

  Constant11_out1 <= X"bf6ca74e";

  Constant13_out1 <= X"00000000";

  Unit_Delay5_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Unit_Delay5_out1 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Unit_Delay5_out1 <= Sum7_out1;
      END IF;
    END IF;
  END PROCESS Unit_Delay5_process;


  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Sum7_out1 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Sum7_out1 <= Sum7_out1_1;
      END IF;
    END IF;
  END PROCESS delayMatch1_process;


  ohc_lpf_out <= Sum7_out1_1;

END rtl;
