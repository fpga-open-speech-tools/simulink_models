-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\spike_generator_sim\redocking_site\redocking_site_nfp_relop_single_block.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: redocking_site_nfp_relop_single_block
-- Source Path: redocking_site/nfp_relop_single
-- Hierarchy Level: 4
-- 
-- {Latency Strategy = "Max"}
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY redocking_site_nfp_relop_single_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        nfp_in1                           :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
        nfp_in2                           :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
        nfp_out1                          :   OUT   std_logic  -- ufix1
        );
END redocking_site_nfp_relop_single_block;


ARCHITECTURE rtl OF redocking_site_nfp_relop_single_block IS

  ATTRIBUTE multstyle : string;

  -- Signals
  SIGNAL Constant8_out1                   : std_logic;  -- ufix1
  SIGNAL Constant7_out1                   : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL Relational_Operator_relop1       : std_logic;
  SIGNAL Delay13_out1                     : std_logic;
  SIGNAL Logical_Operator2_out1           : std_logic;
  SIGNAL Logical_Operator_out1            : std_logic;  -- ufix1
  SIGNAL Add_out1                         : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL Delay12_out1                     : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL Add_add_cast                     : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL Logical_Operator2_out1_1         : std_logic;
  SIGNAL nfp_in1_unsigned                 : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL AS                               : std_logic;  -- ufix1
  SIGNAL AE                               : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL AM                               : unsigned(22 DOWNTO 0);  -- ufix23
  SIGNAL Delay2_out1                      : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Constant2_out1                   : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Relational_Operator5_relop1      : std_logic;
  SIGNAL Delay5_out1                      : std_logic;
  SIGNAL Constant1_out1                   : unsigned(22 DOWNTO 0);  -- ufix23
  SIGNAL Delay3_out1                      : unsigned(22 DOWNTO 0);  -- ufix23
  SIGNAL Relational_Operator4_relop1      : std_logic;
  SIGNAL Delay3_out1_1                    : std_logic;
  SIGNAL nfp_in2_unsigned                 : unsigned(31 DOWNTO 0);  -- ufix32
  SIGNAL BS                               : std_logic;  -- ufix1
  SIGNAL BE                               : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL BM                               : unsigned(22 DOWNTO 0);  -- ufix23
  SIGNAL Delay4_out1                      : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Relational_Operator6_relop1      : std_logic;
  SIGNAL Delay6_out1                      : std_logic;
  SIGNAL Delay5_out1_1                    : unsigned(22 DOWNTO 0);  -- ufix23
  SIGNAL Relational_Operator2_relop1      : std_logic;
  SIGNAL Delay2_out1_1                    : std_logic;
  SIGNAL Logical_Operator4_out1           : std_logic;
  SIGNAL Logical_Operator1_out1           : std_logic;
  SIGNAL Logical_Operator5_out1           : std_logic;
  SIGNAL Logical_Operator2_out1_2         : std_logic;
  SIGNAL Logical_Operator3_out1           : std_logic;
  SIGNAL Delay1_out1                      : std_logic;
  SIGNAL Logical_Operator1_out1_1         : std_logic;
  SIGNAL Constant_out1                    : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL Relational_Operator3_relop1      : std_logic;
  SIGNAL Delay1_out1_1                    : std_logic;
  SIGNAL Relational_Operator1_relop1      : std_logic;
  SIGNAL Delay4_out1_1                    : std_logic;
  SIGNAL Logical_Operator_out1_1          : std_logic;
  SIGNAL Delay_out1                       : std_logic;  -- ufix1
  SIGNAL Delay1_out1_2                    : std_logic;  -- ufix1
  SIGNAL Relational_Operator2_relop1_1    : std_logic;
  SIGNAL Delay3_out1_2                    : std_logic;
  SIGNAL Relational_Operator4_relop1_1    : std_logic;
  SIGNAL Delay5_out1_2                    : std_logic;
  SIGNAL Relational_Operator6_relop1_1    : std_logic;
  SIGNAL Delay7_out1                      : std_logic;
  SIGNAL Relational_Operator5_relop1_1    : std_logic;
  SIGNAL Delay6_out1_1                    : std_logic;
  SIGNAL Compare_To_Constant_out1         : std_logic;
  SIGNAL Delay2_out1_2                    : std_logic;
  SIGNAL Logical_Operator3_out1_1         : std_logic;
  SIGNAL switch_compare_1                 : std_logic;
  SIGNAL Relational_Operator1_relop1_1    : std_logic;
  SIGNAL Delay4_out1_2                    : std_logic;
  SIGNAL Relational_Operator3_relop1_1    : std_logic;
  SIGNAL Delay1_out1_3                    : std_logic;
  SIGNAL Logical_Operator1_out1_2         : std_logic;
  SIGNAL Logical_Operator2_out1_3         : std_logic;
  SIGNAL Logical_Operator7_out1           : std_logic;
  SIGNAL Logical_Operator5_out1_1         : std_logic;
  SIGNAL Logical_Operator6_out1           : std_logic;
  SIGNAL Logical_Operator4_out1_1         : std_logic;
  SIGNAL Switch_out1                      : std_logic;
  SIGNAL Logical_Operator4_out1_2         : std_logic;
  SIGNAL Logical_Operator3_out1_2         : std_logic;
  SIGNAL Delay10_out1                     : std_logic;
  SIGNAL Constant1_out1_1                 : std_logic;
  SIGNAL Switch6_out1                     : std_logic;

BEGIN
  Constant8_out1 <= '1';

  Constant7_out1 <= to_unsigned(16#3#, 3);

  Delay13_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay13_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay13_out1 <= Relational_Operator_relop1;
      END IF;
    END IF;
  END PROCESS Delay13_process;


  Logical_Operator2_out1 <=  NOT Delay13_out1;

  Logical_Operator_out1 <= Constant8_out1 AND Logical_Operator2_out1;

  Delay12_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay12_out1 <= to_unsigned(16#0#, 3);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay12_out1 <= Add_out1;
      END IF;
    END IF;
  END PROCESS Delay12_process;


  Add_add_cast <= '0' & '0' & Logical_Operator_out1;
  Add_out1 <= Delay12_out1 + Add_add_cast;

  
  Relational_Operator_relop1 <= '1' WHEN Add_out1 > Constant7_out1 ELSE
      '0';

  Logical_Operator2_out1_1 <=  NOT Relational_Operator_relop1;

  nfp_in1_unsigned <= unsigned(nfp_in1);

  -- Split 32 bit word into FP sign, exponent, mantissa
  AS <= nfp_in1_unsigned(31);
  AE <= nfp_in1_unsigned(30 DOWNTO 23);
  AM <= nfp_in1_unsigned(22 DOWNTO 0);

  Delay2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay2_out1 <= to_unsigned(16#00#, 8);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay2_out1 <= AE;
      END IF;
    END IF;
  END PROCESS Delay2_process;


  Constant2_out1 <= to_unsigned(16#FF#, 8);

  
  Relational_Operator5_relop1 <= '1' WHEN Delay2_out1 = Constant2_out1 ELSE
      '0';

  Delay5_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay5_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay5_out1 <= Relational_Operator5_relop1;
      END IF;
    END IF;
  END PROCESS Delay5_process;


  Constant1_out1 <= to_unsigned(16#000000#, 23);

  Delay3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay3_out1 <= to_unsigned(16#000000#, 23);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay3_out1 <= AM;
      END IF;
    END IF;
  END PROCESS Delay3_process;


  
  Relational_Operator4_relop1 <= '1' WHEN Constant1_out1 = Delay3_out1 ELSE
      '0';

  Delay3_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay3_out1_1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay3_out1_1 <= Relational_Operator4_relop1;
      END IF;
    END IF;
  END PROCESS Delay3_1_process;


  nfp_in2_unsigned <= unsigned(nfp_in2);

  -- Split 32 bit word into FP sign, exponent, mantissa
  BS <= nfp_in2_unsigned(31);
  BE <= nfp_in2_unsigned(30 DOWNTO 23);
  BM <= nfp_in2_unsigned(22 DOWNTO 0);

  Delay4_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay4_out1 <= to_unsigned(16#00#, 8);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay4_out1 <= BE;
      END IF;
    END IF;
  END PROCESS Delay4_process;


  
  Relational_Operator6_relop1 <= '1' WHEN Delay4_out1 = Constant2_out1 ELSE
      '0';

  Delay6_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay6_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay6_out1 <= Relational_Operator6_relop1;
      END IF;
    END IF;
  END PROCESS Delay6_process;


  Delay5_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay5_out1_1 <= to_unsigned(16#000000#, 23);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay5_out1_1 <= BM;
      END IF;
    END IF;
  END PROCESS Delay5_1_process;


  
  Relational_Operator2_relop1 <= '1' WHEN Constant1_out1 = Delay5_out1_1 ELSE
      '0';

  Delay2_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay2_out1_1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay2_out1_1 <= Relational_Operator2_relop1;
      END IF;
    END IF;
  END PROCESS Delay2_1_process;


  Logical_Operator4_out1 <=  NOT Delay3_out1_1;

  Logical_Operator1_out1 <= Delay5_out1 AND Logical_Operator4_out1;

  Logical_Operator5_out1 <=  NOT Delay2_out1_1;

  Logical_Operator2_out1_2 <= Delay6_out1 AND Logical_Operator5_out1;

  Logical_Operator3_out1 <= Logical_Operator1_out1 OR Logical_Operator2_out1_2;

  Delay1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay1_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay1_out1 <= Logical_Operator3_out1;
      END IF;
    END IF;
  END PROCESS Delay1_process;


  Logical_Operator1_out1_1 <= Logical_Operator2_out1_1 OR Delay1_out1;

  Constant_out1 <= to_unsigned(16#00#, 8);

  
  Relational_Operator3_relop1 <= '1' WHEN Constant_out1 = Delay4_out1 ELSE
      '0';

  Delay1_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay1_out1_1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay1_out1_1 <= Relational_Operator3_relop1;
      END IF;
    END IF;
  END PROCESS Delay1_1_process;


  
  Relational_Operator1_relop1 <= '1' WHEN Constant_out1 = Delay2_out1 ELSE
      '0';

  Delay4_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay4_out1_1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay4_out1_1 <= Relational_Operator1_relop1;
      END IF;
    END IF;
  END PROCESS Delay4_1_process;


  Logical_Operator_out1_1 <= Delay3_out1_1 AND (Delay4_out1_1 AND (Delay2_out1_1 AND Delay1_out1_1));

  Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay_out1 <= AS;
      END IF;
    END IF;
  END PROCESS Delay_process;


  Delay1_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay1_out1_2 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay1_out1_2 <= BS;
      END IF;
    END IF;
  END PROCESS Delay1_2_process;


  
  Relational_Operator2_relop1_1 <= '1' WHEN Delay_out1 = Delay1_out1_2 ELSE
      '0';

  Delay3_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay3_out1_2 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay3_out1_2 <= Relational_Operator2_relop1_1;
      END IF;
    END IF;
  END PROCESS Delay3_2_process;


  
  Relational_Operator4_relop1_1 <= '1' WHEN Delay2_out1 = Delay4_out1 ELSE
      '0';

  Delay5_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay5_out1_2 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay5_out1_2 <= Relational_Operator4_relop1_1;
      END IF;
    END IF;
  END PROCESS Delay5_2_process;


  
  Relational_Operator6_relop1_1 <= '1' WHEN Delay3_out1 = Delay5_out1_1 ELSE
      '0';

  Delay7_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay7_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay7_out1 <= Relational_Operator6_relop1_1;
      END IF;
    END IF;
  END PROCESS Delay7_process;


  
  Relational_Operator5_relop1_1 <= '1' WHEN Delay_out1 < Delay1_out1_2 ELSE
      '0';

  Delay6_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay6_out1_1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay6_out1_1 <= Relational_Operator5_relop1_1;
      END IF;
    END IF;
  END PROCESS Delay6_1_process;


  
  Compare_To_Constant_out1 <= '1' WHEN Delay1_out1_2 = '1' ELSE
      '0';

  Delay2_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay2_out1_2 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay2_out1_2 <= Compare_To_Constant_out1;
      END IF;
    END IF;
  END PROCESS Delay2_2_process;


  Logical_Operator3_out1_1 <= Delay2_out1_2 AND Delay3_out1_2;

  
  switch_compare_1 <= '1' WHEN Logical_Operator3_out1_1 > '0' ELSE
      '0';

  
  Relational_Operator1_relop1_1 <= '1' WHEN Delay2_out1 > Delay4_out1 ELSE
      '0';

  Delay4_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay4_out1_2 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay4_out1_2 <= Relational_Operator1_relop1_1;
      END IF;
    END IF;
  END PROCESS Delay4_2_process;


  
  Relational_Operator3_relop1_1 <= '1' WHEN Delay3_out1 > Delay5_out1_1 ELSE
      '0';

  Delay1_3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay1_out1_3 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay1_out1_3 <= Relational_Operator3_relop1_1;
      END IF;
    END IF;
  END PROCESS Delay1_3_process;


  Logical_Operator1_out1_2 <= Delay5_out1_2 AND Delay1_out1_3;

  Logical_Operator2_out1_3 <= Delay4_out1_2 OR Logical_Operator1_out1_2;

  Logical_Operator7_out1 <= Delay3_out1_2 AND Logical_Operator2_out1_3;

  Logical_Operator5_out1_1 <=  NOT Logical_Operator7_out1;

  Logical_Operator6_out1 <= Delay7_out1 AND (Delay3_out1_2 AND Delay5_out1_2);

  Logical_Operator4_out1_1 <= Logical_Operator_out1_1 OR Logical_Operator6_out1;

  
  Switch_out1 <= Logical_Operator7_out1 WHEN switch_compare_1 = '0' ELSE
      Logical_Operator5_out1_1;

  Logical_Operator4_out1_2 <= Delay6_out1_1 OR Switch_out1;

  Logical_Operator3_out1_2 <= Logical_Operator4_out1_1 OR Logical_Operator4_out1_2;

  Delay10_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay10_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Delay10_out1 <= Logical_Operator3_out1_2;
      END IF;
    END IF;
  END PROCESS Delay10_process;


  Constant1_out1_1 <= '0';

  
  Switch6_out1 <= Delay10_out1 WHEN Logical_Operator1_out1_1 = '0' ELSE
      Constant1_out1_1;

  nfp_out1 <= Switch6_out1;

END rtl;

