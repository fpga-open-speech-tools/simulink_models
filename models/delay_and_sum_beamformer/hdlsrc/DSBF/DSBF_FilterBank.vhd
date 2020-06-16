-- -------------------------------------------------------------
-- 
-- File Name: /mnt/data/NIH/simulink_models/models/delay_and_sum_beamformer/hdlsrc/DSBF/DSBF_FilterBank.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: DSBF_FilterBank
-- Source Path: DSBF/dataplane/Avalon Data Processing/delay signals/delay signal/CIC interpolation compensator/FilterBank
-- Hierarchy Level: 5
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.DSBF_dataplane_pkg.ALL;

ENTITY DSBF_FilterBank IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_2048_0                      :   IN    std_logic;
        dataIn                            :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        validIn                           :   IN    std_logic;
        syncReset                         :   IN    std_logic;
        dataOut                           :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En26
        validOut                          :   OUT   std_logic
        );
END DSBF_FilterBank;


ARCHITECTURE rtl OF DSBF_FilterBank IS

  -- Component Declarations
  COMPONENT DSBF_FilterCoef
    PORT( clk                             :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          validIn                         :   IN    std_logic;
          syncReset                       :   IN    std_logic;
          CoefOut                         :   OUT   vector_of_std_logic_vector16(0 TO 18)  -- sfix16_En15 [19]
          );
  END COMPONENT;

  COMPONENT DSBF_subFilter
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          dinReg_0_re                     :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          coefIn                          :   IN    vector_of_std_logic_vector16(0 TO 18);  -- sfix16_En15 [19]
          dinRegVld                       :   IN    std_logic;
          syncReset                       :   IN    std_logic;
          dout_1_re                       :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En26
          doutVld                         :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : DSBF_FilterCoef
    USE ENTITY work.DSBF_FilterCoef(rtl);

  FOR ALL : DSBF_subFilter
    USE ENTITY work.DSBF_subFilter(rtl);

  -- Signals
  SIGNAL syncReset_1                      : std_logic;
  SIGNAL dinRegVld                        : std_logic;
  SIGNAL dataIn_signed                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL dinReg_0_re                      : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL dinReg2_0_re                     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL CoefOut                          : vector_of_std_logic_vector16(0 TO 18);  -- ufix16 [19]
  SIGNAL dinReg2Vld                       : std_logic;
  SIGNAL dout_1_re                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL doutVld                          : std_logic;

BEGIN
  u_CoefTable_1 : DSBF_FilterCoef
    PORT MAP( clk => clk,
              enb_1_2048_0 => enb_1_2048_0,
              validIn => validIn,
              syncReset => syncReset_1,
              CoefOut => CoefOut  -- sfix16_En15 [19]
              );

  u_subFilter_1_re : DSBF_subFilter
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2048_0 => enb_1_2048_0,
              dinReg_0_re => std_logic_vector(dinReg2_0_re),  -- sfix32_En28
              coefIn => CoefOut,  -- sfix16_En15 [19]
              dinRegVld => dinReg2Vld,
              syncReset => syncReset_1,
              dout_1_re => dout_1_re,  -- sfix32_En26
              doutVld => doutVld
              );

  syncReset_1 <= '0';

  intdelay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dinRegVld <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' THEN
        IF syncReset_1 = '1' THEN
          dinRegVld <= '0';
        ELSE 
          dinRegVld <= validIn;
        END IF;
      END IF;
    END IF;
  END PROCESS intdelay_process;


  dataIn_signed <= signed(dataIn);

  intdelay_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dinReg_0_re <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' THEN
        IF syncReset_1 = '1' THEN
          dinReg_0_re <= to_signed(0, 32);
        ELSIF validIn = '1' THEN
          dinReg_0_re <= dataIn_signed;
        END IF;
      END IF;
    END IF;
  END PROCESS intdelay_1_process;


  intdelay_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dinReg2_0_re <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' THEN
        IF syncReset_1 = '1' THEN
          dinReg2_0_re <= to_signed(0, 32);
        ELSIF dinRegVld = '1' THEN
          dinReg2_0_re <= dinReg_0_re;
        END IF;
      END IF;
    END IF;
  END PROCESS intdelay_2_process;


  intdelay_3_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      dinReg2Vld <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_0 = '1' THEN
        IF syncReset_1 = '1' THEN
          dinReg2Vld <= '0';
        ELSE 
          dinReg2Vld <= dinRegVld;
        END IF;
      END IF;
    END IF;
  END PROCESS intdelay_3_process;


  dataOut <= dout_1_re;

  validOut <= doutVld;

END rtl;
