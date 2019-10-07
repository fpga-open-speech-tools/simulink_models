-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\bugsbunny\NIH\simulink_models\models\bitcrusher\hdlsrc\BC\BC_mixer_block.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: BC_mixer_block
-- Source Path: BC/dataplane/Avalon Data Processing/Right Channel Processing/mixer
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.BC_dataplane_pkg.ALL;

ENTITY BC_mixer_block IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        dry_signal                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        wet_signal                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        wet_dry_mix                       :   IN    std_logic_vector(4 DOWNTO 0);  -- ufix5_En4
        output                            :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END BC_mixer_block;


ARCHITECTURE rtl OF BC_mixer_block IS

  -- Signals
  SIGNAL dry_signal_signed                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL dry_signal_1                     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Constant_out1                    : unsigned(4 DOWNTO 0);  -- ufix5_En4
  SIGNAL wet_dry_mix_unsigned             : unsigned(4 DOWNTO 0);  -- ufix5_En4
  SIGNAL Subtract_sub_cast                : signed(5 DOWNTO 0);  -- sfix6_En4
  SIGNAL Subtract_sub_cast_1              : signed(5 DOWNTO 0);  -- sfix6_En4
  SIGNAL Subtract_sub_temp                : signed(5 DOWNTO 0);  -- sfix6_En4
  SIGNAL dry_gain                         : unsigned(4 DOWNTO 0);  -- ufix5_En4
  SIGNAL dry_gain_1                       : unsigned(4 DOWNTO 0);  -- ufix5_En4
  SIGNAL Product_cast                     : signed(5 DOWNTO 0);  -- sfix6_En4
  SIGNAL Product_mul_temp                 : signed(37 DOWNTO 0);  -- sfix38_En32
  SIGNAL Product_out1                     : signed(36 DOWNTO 0);  -- sfix37_En32
  SIGNAL delayMatch1_reg                  : vector_of_signed37(0 TO 2);  -- sfix37 [3]
  SIGNAL Product_out1_1                   : signed(36 DOWNTO 0);  -- sfix37_En32
  SIGNAL HwModeRegister2_reg              : vector_of_unsigned5(0 TO 2);  -- ufix5 [3]
  SIGNAL wet_gain                         : unsigned(4 DOWNTO 0);  -- ufix5_En4
  SIGNAL wet_signal_signed                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL wet_signal_1                     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Product1_cast                    : signed(5 DOWNTO 0);  -- sfix6_En4
  SIGNAL Product1_mul_temp                : signed(37 DOWNTO 0);  -- sfix38_En32
  SIGNAL Product1_out1                    : signed(36 DOWNTO 0);  -- sfix37_En32
  SIGNAL Product1_out1_1                  : signed(36 DOWNTO 0);  -- sfix37_En32
  SIGNAL Add_add_cast                     : signed(37 DOWNTO 0);  -- sfix38_En32
  SIGNAL Add_add_cast_1                   : signed(37 DOWNTO 0);  -- sfix38_En32
  SIGNAL Add_add_temp                     : signed(37 DOWNTO 0);  -- sfix38_En32
  SIGNAL Add_out1                         : signed(31 DOWNTO 0);  -- sfix32_En28

  ATTRIBUTE multstyle : string;

BEGIN
  -- wet/dry mix:
  -- The wet/dry mix is the percentage of the signal that is wet (i.e. effected).
  -- 
  -- 
  -- Since $\text{wet_dry_mix} \in [0,1]$, we then have the following relations:
  -- $\text{wet_gain} = \text{wet_dry_mix} \\\text{dry_gain} = 1 - \text{wet_dry_mix}$

  dry_signal_signed <= signed(dry_signal);

  HwModeRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dry_signal_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        dry_signal_1 <= dry_signal_signed;
      END IF;
    END IF;
  END PROCESS HwModeRegister_process;


  Constant_out1 <= to_unsigned(16#10#, 5);

  wet_dry_mix_unsigned <= unsigned(wet_dry_mix);

  Subtract_sub_cast <= signed(resize(Constant_out1, 6));
  Subtract_sub_cast_1 <= signed(resize(wet_dry_mix_unsigned, 6));
  Subtract_sub_temp <= Subtract_sub_cast - Subtract_sub_cast_1;
  dry_gain <= unsigned(Subtract_sub_temp(4 DOWNTO 0));

  HwModeRegister1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dry_gain_1 <= to_unsigned(16#00#, 5);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        dry_gain_1 <= dry_gain;
      END IF;
    END IF;
  END PROCESS HwModeRegister1_process;


  Product_cast <= signed(resize(dry_gain_1, 6));
  Product_mul_temp <= dry_signal_1 * Product_cast;
  Product_out1 <= Product_mul_temp(36 DOWNTO 0);

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => to_signed(0, 37));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch1_reg(0) <= Product_out1;
        delayMatch1_reg(1 TO 2) <= delayMatch1_reg(0 TO 1);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  Product_out1_1 <= delayMatch1_reg(2);

  HwModeRegister2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      HwModeRegister2_reg <= (OTHERS => to_unsigned(16#00#, 5));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        HwModeRegister2_reg(0) <= wet_dry_mix_unsigned;
        HwModeRegister2_reg(1 TO 2) <= HwModeRegister2_reg(0 TO 1);
      END IF;
    END IF;
  END PROCESS HwModeRegister2_process;

  wet_gain <= HwModeRegister2_reg(2);

  wet_signal_signed <= signed(wet_signal);

  HwModeRegister3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      wet_signal_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        wet_signal_1 <= wet_signal_signed;
      END IF;
    END IF;
  END PROCESS HwModeRegister3_process;


  Product1_cast <= signed(resize(wet_gain, 6));
  Product1_mul_temp <= Product1_cast * wet_signal_1;
  Product1_out1 <= Product1_mul_temp(36 DOWNTO 0);

  PipelineRegister1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Product1_out1_1 <= to_signed(0, 37);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Product1_out1_1 <= Product1_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister1_process;


  Add_add_cast <= resize(Product_out1_1, 38);
  Add_add_cast_1 <= resize(Product1_out1_1, 38);
  Add_add_temp <= Add_add_cast + Add_add_cast_1;
  Add_out1 <= Add_add_temp(35 DOWNTO 4);

  output <= std_logic_vector(Add_out1);

END rtl;

