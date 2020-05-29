-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\bugsbunny\research\NIH\simulink_models\models\flanger\hdlsrc\flanger\flanger_NCO_HDL_Optimized.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: flanger_NCO_HDL_Optimized
-- Source Path: flanger/dataplane/Avalon Data Processing/Left Channel Processing/LFO/NCO HDL Optimized
-- Hierarchy Level: 4
-- 
-- NCO HDL Optimized
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY flanger_NCO_HDL_Optimized IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        inc                               :   IN    std_logic_vector(23 DOWNTO 0);  -- ufix24_En17
        sine                              :   OUT   std_logic_vector(15 DOWNTO 0);  -- sfix16_En14
        validOut                          :   OUT   std_logic
        );
END flanger_NCO_HDL_Optimized;


ARCHITECTURE rtl OF flanger_NCO_HDL_Optimized IS

  -- Component Declarations
  COMPONENT flanger_DitherGen
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          validIn                         :   IN    std_logic;
          dither                          :   OUT   std_logic_vector(3 DOWNTO 0)  -- ufix4
          );
  END COMPONENT;

  COMPONENT flanger_WaveformGen
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          phaseIdx                        :   IN    std_logic_vector(11 DOWNTO 0);  -- ufix12_E7
          sine                            :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En14
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : flanger_DitherGen
    USE ENTITY work.flanger_DitherGen(rtl);

  FOR ALL : flanger_WaveformGen
    USE ENTITY work.flanger_WaveformGen(rtl);

  -- Signals
  SIGNAL validInbk                        : std_logic;
  SIGNAL outsel_reg_reg                   : std_logic_vector(0 TO 4);  -- ufix1 [5]
  SIGNAL outsel                           : std_logic;
  SIGNAL outzero                          : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL const0                           : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL inc_unsigned                     : unsigned(23 DOWNTO 0);  -- ufix24_En17
  SIGNAL pInc                             : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL validPInc                        : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL accphase_reg                     : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL addpInc                          : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL pOffset                          : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL accoffset                        : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL accoffsete_reg                   : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL dither                           : std_logic_vector(3 DOWNTO 0);  -- ufix4
  SIGNAL dither_unsigned                  : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL casteddither                     : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL dither_reg                       : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL accumulator                      : signed(18 DOWNTO 0);  -- sfix19
  SIGNAL accQuantized                     : unsigned(11 DOWNTO 0);  -- ufix12_E7
  SIGNAL outs                             : std_logic_vector(15 DOWNTO 0);  -- ufix16
  SIGNAL outs_signed                      : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL validouts                        : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL sine_tmp                         : signed(15 DOWNTO 0);  -- sfix16_En14

BEGIN
  u_dither_inst : flanger_DitherGen
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              validIn => validInbk,
              dither => dither  -- ufix4
              );

  u_Wave_inst : flanger_WaveformGen
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              phaseIdx => std_logic_vector(accQuantized),  -- ufix12_E7
              sine => outs  -- sfix16_En14
              );

  validInbk <= '1';

  outsel_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      outsel_reg_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        outsel_reg_reg(0) <= validInbk;
        outsel_reg_reg(1 TO 4) <= outsel_reg_reg(0 TO 3);
      END IF;
    END IF;
  END PROCESS outsel_reg_process;

  outsel <= outsel_reg_reg(4);

  outzero <= to_signed(16#0000#, 16);

  -- Constant Zero
  const0 <= to_signed(16#00000#, 19);

  inc_unsigned <= unsigned(inc);

  pInc <= signed(resize(inc_unsigned(23 DOWNTO 17), 19));

  
  validPInc <= const0 WHEN validInbk = '0' ELSE
      pInc;

  -- Add phase increment
  addpInc <= accphase_reg + validPInc;

  -- Phase increment accumulator register
  AccPhaseRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      accphase_reg <= to_signed(16#00000#, 19);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        accphase_reg <= addpInc;
      END IF;
    END IF;
  END PROCESS AccPhaseRegister_process;


  pOffset <= to_signed(16#00000#, 19);

  -- Add phase offset
  accoffset <= accphase_reg + pOffset;

  -- Phase offset accumulator register
  AccOffsetRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      accoffsete_reg <= to_signed(16#00000#, 19);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        accoffsete_reg <= accoffset;
      END IF;
    END IF;
  END PROCESS AccOffsetRegister_process;


  dither_unsigned <= unsigned(dither);

  casteddither <= signed(resize(dither_unsigned, 19));

  -- Dither input register
  DitherRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dither_reg <= to_signed(16#00000#, 19);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        dither_reg <= casteddither;
      END IF;
    END IF;
  END PROCESS DitherRegister_process;


  -- Add dither
  accumulator <= accoffsete_reg + dither_reg;

  -- Phase quantization
  accQuantized <= unsigned(accumulator(18 DOWNTO 7));

  outs_signed <= signed(outs);

  
  validouts <= outzero WHEN outsel = '0' ELSE
      outs_signed;

  -- Output register
  OutputRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      sine_tmp <= to_signed(16#0000#, 16);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        sine_tmp <= validouts;
      END IF;
    END IF;
  END PROCESS OutputRegister_process;


  sine <= std_logic_vector(sine_tmp);

  -- validOut register
  validOut_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      validOut <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        validOut <= outsel;
      END IF;
    END IF;
  END PROCESS validOut_reg_process;


END rtl;

