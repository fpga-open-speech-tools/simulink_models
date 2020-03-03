-- -------------------------------------------------------------
-- 
-- File Name: /home/justin/Documents/FEI/simulink_models/models/dynamic_FIRFilter/hdlsrc/pFIR_HPF_testing_and_analysis/pFIR_HPF_testing_and_analysis_dataplane_tc.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: pFIR_HPF_testing_and_analysis_dataplane_tc
-- Source Path: dataplane_tc
-- Hierarchy Level: 1
-- 
-- Master clock enable input: clk_enable
-- 
-- enb         : identical to clk_enable
-- enb_1_1_1   : identical to clk_enable
-- enb_1_2_0   : 2x slower than clk with last phase
-- enb_1_2_1   : 2x slower than clk with phase 1
-- enb_1_2048_0: 2048x slower than clk with last phase
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pFIR_HPF_testing_and_analysis_dataplane_tc IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        enb                               :   OUT   std_logic;
        enb_1_1_1                         :   OUT   std_logic;
        enb_1_2_0                         :   OUT   std_logic;
        enb_1_2_1                         :   OUT   std_logic;
        enb_1_2048_0                      :   OUT   std_logic
        );
END pFIR_HPF_testing_and_analysis_dataplane_tc;


ARCHITECTURE rtl OF pFIR_HPF_testing_and_analysis_dataplane_tc IS

  -- Signals
  SIGNAL count2                           : std_logic;
  SIGNAL phase_0                          : std_logic;
  SIGNAL phase_0_tmp                      : std_logic;
  SIGNAL phase_1                          : std_logic;
  SIGNAL phase_1_tmp                      : std_logic;
  SIGNAL count2048                        : unsigned(10 DOWNTO 0);  -- ufix11
  SIGNAL phase_all                        : std_logic;
  SIGNAL phase_0_1                        : std_logic;
  SIGNAL phase_0_tmp_1                    : std_logic;

BEGIN
  Counter2 : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      count2 <= '1';
    ELSIF rising_edge(clk) THEN
      IF clk_enable = '1' THEN
          count2 <= NOT count2;
      END IF;
    END IF; 
  END PROCESS Counter2;

  temp_process1 : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      phase_0 <= '0';
    ELSIF rising_edge(clk) THEN
      IF clk_enable = '1' THEN
        phase_0 <= phase_0_tmp;
      END IF;
    END IF; 
  END PROCESS temp_process1;

  phase_0_tmp <= '1' WHEN count2 = '1' AND clk_enable = '1' ELSE '0';

  temp_process2 : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      phase_1 <= '1';
    ELSIF rising_edge(clk) THEN
      IF clk_enable = '1' THEN
        phase_1 <= phase_1_tmp;
      END IF;
    END IF; 
  END PROCESS temp_process2;

  phase_1_tmp <= '1' WHEN count2 = '0' AND clk_enable = '1' ELSE '0';

  Counter2048 : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      count2048 <= to_unsigned(1, 11);
    ELSIF rising_edge(clk) THEN
      IF clk_enable = '1' THEN
        IF count2048 >= to_unsigned(2047, 11) THEN
          count2048 <= to_unsigned(0, 11);
        ELSE
          count2048 <= count2048 + to_unsigned(1, 11);
        END IF;
      END IF;
    END IF; 
  END PROCESS Counter2048;

  phase_all <= '1' WHEN clk_enable = '1' ELSE '0';

  temp_process3 : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      phase_0_1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF clk_enable = '1' THEN
        phase_0_1 <= phase_0_tmp_1;
      END IF;
    END IF; 
  END PROCESS temp_process3;

  phase_0_tmp_1 <= '1' WHEN count2048 = to_unsigned(2047, 11) AND clk_enable = '1' ELSE '0';

  enb <=  phase_all AND clk_enable;

  enb_1_1_1 <=  phase_all AND clk_enable;

  enb_1_2_0 <=  phase_0 AND clk_enable;

  enb_1_2_1 <=  phase_1 AND clk_enable;

  enb_1_2048_0 <=  phase_0_1 AND clk_enable;


END rtl;

