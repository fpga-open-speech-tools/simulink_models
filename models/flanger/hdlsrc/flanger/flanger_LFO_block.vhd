-- -------------------------------------------------------------
-- 
-- File Name: /mnt/data/NIH/simulink_models/models/flanger/hdlsrc/flanger/flanger_LFO_block.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: flanger_LFO_block
-- Source Path: flanger/dataplane/Avalon Data Processing/Right Channel Processing/LFO
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY flanger_LFO_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        rate                              :   IN    std_logic_vector(7 DOWNTO 0);  -- ufix8_En5
        Enable_out5                       :   IN    std_logic;
        sin                               :   OUT   std_logic_vector(8 DOWNTO 0)  -- ufix9
        );
END flanger_LFO_block;


ARCHITECTURE rtl OF flanger_LFO_block IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT flanger_NCO_HDL_Optimized_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          inc                             :   IN    std_logic_vector(23 DOWNTO 0);  -- ufix24_En17
          sine                            :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En14
          validOut                        :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : flanger_NCO_HDL_Optimized_block
    USE ENTITY work.flanger_NCO_HDL_Optimized_block(rtl);

  -- Signals
  SIGNAL offset_out1                      : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL accumulator_resolution_out1      : unsigned(15 DOWNTO 0);  -- ufix16_En12
  SIGNAL accumulator_resolution_out1_1    : unsigned(15 DOWNTO 0);  -- ufix16_En12
  SIGNAL rate_unsigned                    : unsigned(7 DOWNTO 0);  -- ufix8_En5
  SIGNAL rate_1                           : unsigned(7 DOWNTO 0);  -- ufix8_En5
  SIGNAL Product_out1                     : unsigned(23 DOWNTO 0);  -- ufix24_En17
  SIGNAL Product_out1_1                   : unsigned(23 DOWNTO 0);  -- ufix24_En17
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL Enable_out5_1                    : std_logic;
  SIGNAL enb_gated                        : std_logic;
  SIGNAL NCO_HDL_Optimized_out1           : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL NCO_HDL_Optimized_out2           : std_logic;
  SIGNAL NCO_HDL_Optimized_out1_signed    : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL NCO_HDL_Optimized_out1_1         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL kconst                           : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL kconst_1                         : unsigned(7 DOWNTO 0);  -- ufix8
  SIGNAL amplitude_cast                   : signed(8 DOWNTO 0);  -- sfix9
  SIGNAL amplitude_mul_temp               : signed(24 DOWNTO 0);  -- sfix25_En14
  SIGNAL amplitude_out1                   : signed(23 DOWNTO 0);  -- sfix24_En14
  SIGNAL amplitude_out1_1                 : signed(23 DOWNTO 0);  -- sfix24_En14
  SIGNAL Add_add_cast                     : signed(24 DOWNTO 0);  -- sfix25_En14
  SIGNAL Add_add_cast_1                   : signed(24 DOWNTO 0);  -- sfix25_En14
  SIGNAL Add_add_temp                     : signed(24 DOWNTO 0);  -- sfix25_En14
  SIGNAL Add_out1                         : unsigned(8 DOWNTO 0);  -- ufix9

BEGIN
  -- $\text{phase increment} = rate \times \frac{2^\text{accumulator bits}}{f_s}$
  -- The number of accumulator bits is chosen to guarantee that the minumum rate results in a phase increment of 1
  -- 
  -- make sine wave go from [a,b] 
  -- instead of [0,1]

  u_NCO_HDL_Optimized : flanger_NCO_HDL_Optimized_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb_gated,
              inc => std_logic_vector(Product_out1_1),  -- ufix24_En17
              sine => NCO_HDL_Optimized_out1,  -- sfix16_En14
              validOut => NCO_HDL_Optimized_out2
              );

  offset_out1 <= to_unsigned(16#FC#, 8);

  accumulator_resolution_out1 <= to_unsigned(16#AEC3#, 16);

  HwModeRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      accumulator_resolution_out1_1 <= to_unsigned(16#0000#, 16);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        accumulator_resolution_out1_1 <= accumulator_resolution_out1;
      END IF;
    END IF;
  END PROCESS HwModeRegister_process;


  rate_unsigned <= unsigned(rate);

  HwModeRegister1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      rate_1 <= to_unsigned(16#00#, 8);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        rate_1 <= rate_unsigned;
      END IF;
    END IF;
  END PROCESS HwModeRegister1_process;


  Product_out1 <= accumulator_resolution_out1_1 * rate_1;

  PipelineRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Product_out1_1 <= to_unsigned(16#000000#, 24);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Product_out1_1 <= Product_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister_process;


  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= Enable_out5;
        delayMatch_reg(1) <= delayMatch_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  Enable_out5_1 <= delayMatch_reg(1);

  enb_gated <= Enable_out5_1 AND enb;

  NCO_HDL_Optimized_out1_signed <= signed(NCO_HDL_Optimized_out1);

  HwModeRegister2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      NCO_HDL_Optimized_out1_1 <= to_signed(16#0000#, 16);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        NCO_HDL_Optimized_out1_1 <= NCO_HDL_Optimized_out1_signed;
      END IF;
    END IF;
  END PROCESS HwModeRegister2_process;


  kconst <= to_unsigned(16#E4#, 8);

  HwModeRegister3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      kconst_1 <= to_unsigned(16#00#, 8);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        kconst_1 <= kconst;
      END IF;
    END IF;
  END PROCESS HwModeRegister3_process;


  amplitude_cast <= signed(resize(kconst_1, 9));
  amplitude_mul_temp <= NCO_HDL_Optimized_out1_1 * amplitude_cast;
  amplitude_out1 <= amplitude_mul_temp(23 DOWNTO 0);

  PipelineRegister1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      amplitude_out1_1 <= to_signed(16#000000#, 24);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        amplitude_out1_1 <= amplitude_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister1_process;


  Add_add_cast <= signed(resize(offset_out1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 25));
  Add_add_cast_1 <= resize(amplitude_out1_1, 25);
  Add_add_temp <= Add_add_cast + Add_add_cast_1;
  Add_out1 <= unsigned(Add_add_temp(22 DOWNTO 14));

  sin <= std_logic_vector(Add_out1);

END rtl;

