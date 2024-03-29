-- ------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\HA_sys8\FIRDecimator2
-- Created: 2018-12-04 11:17:31
-- Generated by MATLAB 9.4 and HDL Coder 3.12
-- 
-- ------------------------------------------------------------
-- 
-- 
-- ------------------------------------------------------------
-- 
-- Module: FIRDecimator2
-- Source Path: /FIRDecimator2
-- 
-- ------------------------------------------------------------
-- 
-- HDL Implementation    : Fully Serial
-- Folding Factor        : 8
-- Multipliers           : 1


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;

ENTITY FIRDecimator2 IS
   PORT( clk                             :   IN    std_logic; 
         enb_8_4_1                       :   IN    std_logic; 
         reset                           :   IN    std_logic; 
         FIRDecimator2_in                :   IN    std_logic_vector(31 DOWNTO 0); -- sfix32_En28
         FIRDecimator2_out               :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
         );

END FIRDecimator2;


----------------------------------------------------------------
--Module Architecture: FIRDecimator2
----------------------------------------------------------------
ARCHITECTURE rtl OF FIRDecimator2 IS
  -- Local Functions
  -- Type Definitions
  TYPE input_pipeline_type IS ARRAY (NATURAL range <>) OF signed(31 DOWNTO 0); -- sfix32_En28
  -- Constants
  CONSTANT coeffphase1_1                  : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_2                  : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_3                  : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_4                  : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_5                  : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_6                  : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_7                  : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_8                  : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_9                  : signed(31 DOWNTO 0) := to_signed(1073741824, 32); -- sfix32_En31
  CONSTANT coeffphase1_10                 : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_11                 : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_12                 : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_13                 : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_14                 : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_15                 : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase1_16                 : signed(31 DOWNTO 0) := to_signed(0, 32); -- sfix32_En31
  CONSTANT coeffphase2_1                  : signed(31 DOWNTO 0) := to_signed(-481003, 32); -- sfix32_En31
  CONSTANT coeffphase2_2                  : signed(31 DOWNTO 0) := to_signed(2638484, 32); -- sfix32_En31
  CONSTANT coeffphase2_3                  : signed(31 DOWNTO 0) := to_signed(-8546469, 32); -- sfix32_En31
  CONSTANT coeffphase2_4                  : signed(31 DOWNTO 0) := to_signed(21508448, 32); -- sfix32_En31
  CONSTANT coeffphase2_5                  : signed(31 DOWNTO 0) := to_signed(-46752491, 32); -- sfix32_En31
  CONSTANT coeffphase2_6                  : signed(31 DOWNTO 0) := to_signed(94736651, 32); -- sfix32_En31
  CONSTANT coeffphase2_7                  : signed(31 DOWNTO 0) := to_signed(-200068505, 32); -- sfix32_En31
  CONSTANT coeffphase2_8                  : signed(31 DOWNTO 0) := to_signed(673829978, 32); -- sfix32_En31
  CONSTANT coeffphase2_9                  : signed(31 DOWNTO 0) := to_signed(673829978, 32); -- sfix32_En31
  CONSTANT coeffphase2_10                 : signed(31 DOWNTO 0) := to_signed(-200068505, 32); -- sfix32_En31
  CONSTANT coeffphase2_11                 : signed(31 DOWNTO 0) := to_signed(94736651, 32); -- sfix32_En31
  CONSTANT coeffphase2_12                 : signed(31 DOWNTO 0) := to_signed(-46752491, 32); -- sfix32_En31
  CONSTANT coeffphase2_13                 : signed(31 DOWNTO 0) := to_signed(21508448, 32); -- sfix32_En31
  CONSTANT coeffphase2_14                 : signed(31 DOWNTO 0) := to_signed(-8546469, 32); -- sfix32_En31
  CONSTANT coeffphase2_15                 : signed(31 DOWNTO 0) := to_signed(2638484, 32); -- sfix32_En31
  CONSTANT coeffphase2_16                 : signed(31 DOWNTO 0) := to_signed(-481003, 32); -- sfix32_En31

  CONSTANT const_zero                     : signed(64 DOWNTO 0) := to_signed(0, 65); -- sfix65_En59
  CONSTANT const_zero_1                   : signed(63 DOWNTO 0) := to_signed(0, 64); -- sfix64_En59
  -- Signals
  SIGNAL cur_count                        : unsigned(3 DOWNTO 0); -- ufix4
  SIGNAL phase_0                          : std_logic; -- boolean
  SIGNAL phase_15                         : std_logic; -- boolean
  SIGNAL phase_7                          : std_logic; -- boolean
  SIGNAL phase_8                          : std_logic; -- boolean
  SIGNAL phase_1                          : std_logic; -- boolean
  SIGNAL phase_9                          : std_logic; -- boolean
  SIGNAL input_typeconvert                : signed(31 DOWNTO 0); -- sfix32_En28
  SIGNAL input_pipeline_phase0            : input_pipeline_type(0 TO 15); -- sfix32_En28
  SIGNAL input_pipeline_phase1            : input_pipeline_type(0 TO 15); -- sfix32_En28
  SIGNAL tapsum_1_0and1_15                : signed(32 DOWNTO 0); -- sfix33_En28
  SIGNAL tapsum_1_1and1_14                : signed(32 DOWNTO 0); -- sfix33_En28
  SIGNAL tapsum_1_2and1_13                : signed(32 DOWNTO 0); -- sfix33_En28
  SIGNAL tapsum_1_3and1_12                : signed(32 DOWNTO 0); -- sfix33_En28
  SIGNAL tapsum_1_4and1_11                : signed(32 DOWNTO 0); -- sfix33_En28
  SIGNAL tapsum_1_5and1_10                : signed(32 DOWNTO 0); -- sfix33_En28
  SIGNAL tapsum_1_6and1_9                 : signed(32 DOWNTO 0); -- sfix33_En28
  SIGNAL tapsum_1_7and1_8                 : signed(32 DOWNTO 0); -- sfix33_En28
  SIGNAL inputmux                         : signed(32 DOWNTO 0); -- sfix33_En28
  SIGNAL product                          : signed(64 DOWNTO 0); -- sfix65_En59
  SIGNAL product_mux                      : signed(31 DOWNTO 0); -- sfix32_En31
  SIGNAL phasemux                         : signed(64 DOWNTO 0); -- sfix65_En59
  SIGNAL prod_powertwo_1_9                : signed(63 DOWNTO 0); -- sfix64_En59
  SIGNAL powertwo_mux_1_9                 : signed(63 DOWNTO 0); -- sfix64_En59
  SIGNAL sumofproducts                    : signed(65 DOWNTO 0); -- sfix66_En59
  SIGNAL sumofproducts_cast               : signed(72 DOWNTO 0); -- sfix73_En59
  SIGNAL acc_sum                          : signed(72 DOWNTO 0); -- sfix73_En59
  SIGNAL accreg_in                        : signed(72 DOWNTO 0); -- sfix73_En59
  SIGNAL accreg_out                       : signed(72 DOWNTO 0); -- sfix73_En59
  SIGNAL add_cast                         : signed(72 DOWNTO 0); -- sfix73_En59
  SIGNAL add_cast_1                       : signed(72 DOWNTO 0); -- sfix73_En59
  SIGNAL add_temp                         : signed(73 DOWNTO 0); -- sfix74_En59
  SIGNAL accreg_final                     : signed(72 DOWNTO 0); -- sfix73_En59
  SIGNAL output_typeconvert               : signed(31 DOWNTO 0); -- sfix32_En28


BEGIN

  -- Block Statements
  Counter : PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF reset = '1' THEN
        cur_count <= to_unsigned(15, 4);
      ELSIF enb_8_4_1 = '1' THEN
        IF cur_count >= to_unsigned(15, 4) THEN
          cur_count <= to_unsigned(0, 4);
        ELSE
          cur_count <= cur_count + to_unsigned(1, 4);
        END IF;
      END IF;
    END IF; 
  END PROCESS Counter;

  phase_0 <= '1' WHEN cur_count = to_unsigned(0, 4) AND enb_8_4_1 = '1' ELSE '0';

  phase_15 <= '1' WHEN cur_count = to_unsigned(15, 4) AND enb_8_4_1 = '1' ELSE '0';

  phase_7 <= '1' WHEN cur_count = to_unsigned(7, 4) AND enb_8_4_1 = '1' ELSE '0';

  phase_8 <= '1' WHEN cur_count = to_unsigned(8, 4) AND enb_8_4_1 = '1' ELSE '0';

  phase_1 <= '1' WHEN  (((cur_count = to_unsigned(8, 4))  OR
                         (cur_count = to_unsigned(9, 4))  OR
                         (cur_count = to_unsigned(10, 4))  OR
                         (cur_count = to_unsigned(11, 4))  OR
                         (cur_count = to_unsigned(12, 4))  OR
                         (cur_count = to_unsigned(13, 4))  OR
                         (cur_count = to_unsigned(14, 4))  OR
                         (cur_count = to_unsigned(15, 4)))  AND enb_8_4_1 = '1') ELSE '0';

  phase_9 <= '1' WHEN cur_count = to_unsigned(9, 4) AND enb_8_4_1 = '1' ELSE '0';

  input_typeconvert <= signed(FIRDecimator2_in);

  Delay_Pipeline_Phase0_process : PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF reset = '1' THEN
        input_pipeline_phase0(0 TO 15) <= (OTHERS => (OTHERS => '0'));
      ELSIF phase_15 = '1' THEN
        input_pipeline_phase0(0) <= input_typeconvert;
        input_pipeline_phase0(1 TO 15) <= input_pipeline_phase0(0 TO 14);
      END IF;
    END IF; 
  END PROCESS Delay_Pipeline_Phase0_process;

  Delay_Pipeline_Phase1_process : PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF reset = '1' THEN
        input_pipeline_phase1(0 TO 15) <= (OTHERS => (OTHERS => '0'));
      ELSIF phase_7 = '1' THEN
        input_pipeline_phase1(0) <= input_typeconvert;
        input_pipeline_phase1(1 TO 15) <= input_pipeline_phase1(0 TO 14);
      END IF;
    END IF; 
  END PROCESS Delay_Pipeline_Phase1_process;

  -- Adding (or subtracting) the taps based on the symmetry (or asymmetry)

  tapsum_1_0and1_15 <= resize(input_pipeline_phase1(0), 33) + resize(input_pipeline_phase1(15), 33);

  tapsum_1_1and1_14 <= resize(input_pipeline_phase1(1), 33) + resize(input_pipeline_phase1(14), 33);

  tapsum_1_2and1_13 <= resize(input_pipeline_phase1(2), 33) + resize(input_pipeline_phase1(13), 33);

  tapsum_1_3and1_12 <= resize(input_pipeline_phase1(3), 33) + resize(input_pipeline_phase1(12), 33);

  tapsum_1_4and1_11 <= resize(input_pipeline_phase1(4), 33) + resize(input_pipeline_phase1(11), 33);

  tapsum_1_5and1_10 <= resize(input_pipeline_phase1(5), 33) + resize(input_pipeline_phase1(10), 33);

  tapsum_1_6and1_9 <= resize(input_pipeline_phase1(6), 33) + resize(input_pipeline_phase1(9), 33);

  tapsum_1_7and1_8 <= resize(input_pipeline_phase1(7), 33) + resize(input_pipeline_phase1(8), 33);

  -- Mux(es) to select the input taps for multipliers 

  inputmux <= tapsum_1_0and1_15 WHEN ( cur_count = to_unsigned(8, 4) ) ELSE
                   tapsum_1_1and1_14 WHEN ( cur_count = to_unsigned(9, 4) ) ELSE
                   tapsum_1_2and1_13 WHEN ( cur_count = to_unsigned(10, 4) ) ELSE
                   tapsum_1_3and1_12 WHEN ( cur_count = to_unsigned(11, 4) ) ELSE
                   tapsum_1_4and1_11 WHEN ( cur_count = to_unsigned(12, 4) ) ELSE
                   tapsum_1_5and1_10 WHEN ( cur_count = to_unsigned(13, 4) ) ELSE
                   tapsum_1_6and1_9 WHEN ( cur_count = to_unsigned(14, 4) ) ELSE
                   tapsum_1_7and1_8;

  product_mux <= coeffphase2_1 WHEN ( cur_count = to_unsigned(8, 4) ) ELSE
                      coeffphase2_2 WHEN ( cur_count = to_unsigned(9, 4) ) ELSE
                      coeffphase2_3 WHEN ( cur_count = to_unsigned(10, 4) ) ELSE
                      coeffphase2_4 WHEN ( cur_count = to_unsigned(11, 4) ) ELSE
                      coeffphase2_5 WHEN ( cur_count = to_unsigned(12, 4) ) ELSE
                      coeffphase2_6 WHEN ( cur_count = to_unsigned(13, 4) ) ELSE
                      coeffphase2_7 WHEN ( cur_count = to_unsigned(14, 4) ) ELSE
                      coeffphase2_8;
  product <= inputmux * product_mux;

  phasemux <= product WHEN ( phase_1 = '1' ) ELSE
                   const_zero;

  -- Implementing products without a multiplier for coefficients with values equal to a power of 2.

  -- value of 'coeffphase1_9' is 0.5

  prod_powertwo_1_9 <= resize(input_pipeline_phase0(8) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 64);

  -- Mux(es) to select the power of 2 products for the corresponding polyphase

  powertwo_mux_1_9 <= prod_powertwo_1_9 WHEN ( phase_0 = '1' ) ELSE
                           const_zero_1;

  -- Add the products in linear fashion

  sumofproducts <= resize(phasemux, 66) + resize(powertwo_mux_1_9, 66);

  -- Resize the sum of products to the accumulator type for full precision addition

  sumofproducts_cast <= resize(sumofproducts, 73);

  -- Accumulator register with a mux to reset it with the first addend

  add_cast <= sumofproducts_cast;
  add_cast_1 <= accreg_out;
  add_temp <= resize(add_cast, 74) + resize(add_cast_1, 74);
  acc_sum <= (72 => '0', OTHERS => '1') WHEN add_temp(73) = '0' AND add_temp(72) /= '0'
      ELSE (72 => '1', OTHERS => '0') WHEN add_temp(73) = '1' AND add_temp(72) /= '1'
      ELSE (add_temp(72 DOWNTO 0));

  accreg_in <= sumofproducts_cast WHEN ( phase_8 = '1' ) ELSE
                    acc_sum;

  Acc_reg_process : PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF reset = '1' THEN
        accreg_out <= (OTHERS => '0');
      ELSIF enb_8_4_1 = '1' THEN
        accreg_out <= accreg_in;
      END IF;
    END IF; 
  END PROCESS Acc_reg_process;

  -- Register to hold the final value of the accumulated sum

  Acc_finalreg_process : PROCESS (clk)
  BEGIN
    IF clk'event AND clk = '1' THEN
      IF reset = '1' THEN
        accreg_final <= (OTHERS => '0');
      ELSIF phase_8 = '1' THEN
        accreg_final <= accreg_out;
      END IF;
    END IF; 
  END PROCESS Acc_finalreg_process;

  output_typeconvert <= (31 => '0', OTHERS => '1') WHEN accreg_final(72) = '0' AND accreg_final(71 DOWNTO 62) /= "0000000000"
      ELSE (31 => '1', OTHERS => '0') WHEN accreg_final(72) = '1' AND accreg_final(71 DOWNTO 62) /= "1111111111"
      ELSE (accreg_final(62 DOWNTO 31));

  -- Assignment Statements
  FIRDecimator2_out <= std_logic_vector(output_typeconvert);
END rtl;
