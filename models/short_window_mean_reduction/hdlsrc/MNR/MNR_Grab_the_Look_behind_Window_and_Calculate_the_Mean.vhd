-- -------------------------------------------------------------
-- 
-- File Name: /home/justin/Documents/FEI/simulink_models/models/short_window_mean_reduction/hdlsrc/MNR/MNR_Grab_the_Look_behind_Window_and_Calculate_the_Mean.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: MNR_Grab_the_Look_behind_Window_and_Calculate_the_Mean
-- Source Path: MNR/dataplane/Adaptive_Wiener_Filter Sample Based Filtering/Right Channel Processing/Grab the Look-behind 
-- Window and Calculate the Mea
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.MNR_dataplane_pkg.ALL;

ENTITY MNR_Grab_the_Look_behind_Window_and_Calculate_the_Mean IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        right_data_sink                   :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        rightEnable                       :   IN    std_logic;
        right_channel_source              :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END MNR_Grab_the_Look_behind_Window_and_Calculate_the_Mean;


ARCHITECTURE rtl OF MNR_Grab_the_Look_behind_Window_and_Calculate_the_Mean IS

  ATTRIBUTE multstyle : string;

  -- Signals
  SIGNAL Constant1_out1                   : std_logic;
  SIGNAL enb_gated                        : std_logic;
  SIGNAL Delay32_reg                      : std_logic_vector(0 TO 30);  -- ufix1 [31]
  SIGNAL startup                          : std_logic;
  SIGNAL delayMatch_reg                   : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL startup_1                        : std_logic;
  SIGNAL switch_compare_1                 : std_logic;
  SIGNAL right_data_sink_signed           : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL delayMatch1_reg                  : vector_of_signed32(0 TO 1);  -- sfix32 [2]
  SIGNAL right_data_sink_1                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL enb_gated_1                      : std_logic;
  SIGNAL Tapped_Delay_reg                 : vector_of_signed32(0 TO 30);  -- sfix32 [31]
  SIGNAL Tapped_Delay_out1                : vector_of_signed32(0 TO 31);  -- sfix32_En28 [32]
  SIGNAL Tapped_Delay_out1_1              : vector_of_signed32(0 TO 31);  -- sfix32_En28 [32]
  SIGNAL Tapped_Delay_out1_last_value     : vector_of_signed32(0 TO 31);  -- sfix32_En28 [32]
  SIGNAL Sum_add_cast                     : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_1                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp                     : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_2                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_1                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_3                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_2                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_4                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_3                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_5                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_4                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_6                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_5                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_7                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_6                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_8                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_7                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_9                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_8                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_10                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_9                   : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_11                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_10                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_12                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_11                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_13                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_12                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_14                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_13                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_15                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_14                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_16                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_15                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_17                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_16                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_18                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_17                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_19                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_18                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_20                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_19                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_21                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_20                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_22                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_21                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_23                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_22                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_24                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_23                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_25                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_24                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_26                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_25                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_27                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_26                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_28                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_27                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_29                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_28                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_30                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_29                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_cast_31                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_add_temp_30                  : signed(36 DOWNTO 0);  -- sfix37_En28
  SIGNAL Sum_out1                         : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Sum_out1_1                       : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Constant_out1                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Constant_out1_1                  : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Divide_mul_temp                  : signed(63 DOWNTO 0);  -- sfix64_En56
  SIGNAL Divide_out1                      : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Divide_out1_1                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Switch_out1                      : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  Constant1_out1 <= '1';

  enb_gated <= rightEnable AND enb;

  Delay32_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay32_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb_gated = '1' THEN
        Delay32_reg(0) <= Constant1_out1;
        Delay32_reg(1 TO 30) <= Delay32_reg(0 TO 29);
      END IF;
    END IF;
  END PROCESS Delay32_process;

  startup <= Delay32_reg(30);

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= startup;
        delayMatch_reg(1) <= delayMatch_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  startup_1 <= delayMatch_reg(1);

  
  switch_compare_1 <= '1' WHEN startup_1 > '0' ELSE
      '0';

  right_data_sink_signed <= signed(right_data_sink);

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch1_reg(0) <= right_data_sink_signed;
        delayMatch1_reg(1) <= delayMatch1_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  right_data_sink_1 <= delayMatch1_reg(1);

  enb_gated_1 <= rightEnable AND enb;

  Tapped_Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Tapped_Delay_reg <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb_gated_1 = '1' THEN
        Tapped_Delay_reg(0) <= right_data_sink_signed;
        Tapped_Delay_reg(1 TO 30) <= Tapped_Delay_reg(0 TO 29);
      END IF;
    END IF;
  END PROCESS Tapped_Delay_process;

  Tapped_Delay_out1(0) <= right_data_sink_signed;
  Tapped_Delay_out1(1 TO 31) <= Tapped_Delay_reg(0 TO 30);

  out0_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Tapped_Delay_out1_last_value <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb_gated_1 = '1' THEN
        Tapped_Delay_out1_last_value <= Tapped_Delay_out1_1;
      END IF;
    END IF;
  END PROCESS out0_bypass_process;


  
  Tapped_Delay_out1_1 <= Tapped_Delay_out1_last_value WHEN rightEnable = '0' ELSE
      Tapped_Delay_out1;

  Sum_add_cast <= resize(Tapped_Delay_out1_1(0), 37);
  Sum_add_cast_1 <= resize(Tapped_Delay_out1_1(1), 37);
  Sum_add_temp <= Sum_add_cast + Sum_add_cast_1;
  Sum_add_cast_2 <= resize(Tapped_Delay_out1_1(2), 37);
  Sum_add_temp_1 <= Sum_add_temp + Sum_add_cast_2;
  Sum_add_cast_3 <= resize(Tapped_Delay_out1_1(3), 37);
  Sum_add_temp_2 <= Sum_add_temp_1 + Sum_add_cast_3;
  Sum_add_cast_4 <= resize(Tapped_Delay_out1_1(4), 37);
  Sum_add_temp_3 <= Sum_add_temp_2 + Sum_add_cast_4;
  Sum_add_cast_5 <= resize(Tapped_Delay_out1_1(5), 37);
  Sum_add_temp_4 <= Sum_add_temp_3 + Sum_add_cast_5;
  Sum_add_cast_6 <= resize(Tapped_Delay_out1_1(6), 37);
  Sum_add_temp_5 <= Sum_add_temp_4 + Sum_add_cast_6;
  Sum_add_cast_7 <= resize(Tapped_Delay_out1_1(7), 37);
  Sum_add_temp_6 <= Sum_add_temp_5 + Sum_add_cast_7;
  Sum_add_cast_8 <= resize(Tapped_Delay_out1_1(8), 37);
  Sum_add_temp_7 <= Sum_add_temp_6 + Sum_add_cast_8;
  Sum_add_cast_9 <= resize(Tapped_Delay_out1_1(9), 37);
  Sum_add_temp_8 <= Sum_add_temp_7 + Sum_add_cast_9;
  Sum_add_cast_10 <= resize(Tapped_Delay_out1_1(10), 37);
  Sum_add_temp_9 <= Sum_add_temp_8 + Sum_add_cast_10;
  Sum_add_cast_11 <= resize(Tapped_Delay_out1_1(11), 37);
  Sum_add_temp_10 <= Sum_add_temp_9 + Sum_add_cast_11;
  Sum_add_cast_12 <= resize(Tapped_Delay_out1_1(12), 37);
  Sum_add_temp_11 <= Sum_add_temp_10 + Sum_add_cast_12;
  Sum_add_cast_13 <= resize(Tapped_Delay_out1_1(13), 37);
  Sum_add_temp_12 <= Sum_add_temp_11 + Sum_add_cast_13;
  Sum_add_cast_14 <= resize(Tapped_Delay_out1_1(14), 37);
  Sum_add_temp_13 <= Sum_add_temp_12 + Sum_add_cast_14;
  Sum_add_cast_15 <= resize(Tapped_Delay_out1_1(15), 37);
  Sum_add_temp_14 <= Sum_add_temp_13 + Sum_add_cast_15;
  Sum_add_cast_16 <= resize(Tapped_Delay_out1_1(16), 37);
  Sum_add_temp_15 <= Sum_add_temp_14 + Sum_add_cast_16;
  Sum_add_cast_17 <= resize(Tapped_Delay_out1_1(17), 37);
  Sum_add_temp_16 <= Sum_add_temp_15 + Sum_add_cast_17;
  Sum_add_cast_18 <= resize(Tapped_Delay_out1_1(18), 37);
  Sum_add_temp_17 <= Sum_add_temp_16 + Sum_add_cast_18;
  Sum_add_cast_19 <= resize(Tapped_Delay_out1_1(19), 37);
  Sum_add_temp_18 <= Sum_add_temp_17 + Sum_add_cast_19;
  Sum_add_cast_20 <= resize(Tapped_Delay_out1_1(20), 37);
  Sum_add_temp_19 <= Sum_add_temp_18 + Sum_add_cast_20;
  Sum_add_cast_21 <= resize(Tapped_Delay_out1_1(21), 37);
  Sum_add_temp_20 <= Sum_add_temp_19 + Sum_add_cast_21;
  Sum_add_cast_22 <= resize(Tapped_Delay_out1_1(22), 37);
  Sum_add_temp_21 <= Sum_add_temp_20 + Sum_add_cast_22;
  Sum_add_cast_23 <= resize(Tapped_Delay_out1_1(23), 37);
  Sum_add_temp_22 <= Sum_add_temp_21 + Sum_add_cast_23;
  Sum_add_cast_24 <= resize(Tapped_Delay_out1_1(24), 37);
  Sum_add_temp_23 <= Sum_add_temp_22 + Sum_add_cast_24;
  Sum_add_cast_25 <= resize(Tapped_Delay_out1_1(25), 37);
  Sum_add_temp_24 <= Sum_add_temp_23 + Sum_add_cast_25;
  Sum_add_cast_26 <= resize(Tapped_Delay_out1_1(26), 37);
  Sum_add_temp_25 <= Sum_add_temp_24 + Sum_add_cast_26;
  Sum_add_cast_27 <= resize(Tapped_Delay_out1_1(27), 37);
  Sum_add_temp_26 <= Sum_add_temp_25 + Sum_add_cast_27;
  Sum_add_cast_28 <= resize(Tapped_Delay_out1_1(28), 37);
  Sum_add_temp_27 <= Sum_add_temp_26 + Sum_add_cast_28;
  Sum_add_cast_29 <= resize(Tapped_Delay_out1_1(29), 37);
  Sum_add_temp_28 <= Sum_add_temp_27 + Sum_add_cast_29;
  Sum_add_cast_30 <= resize(Tapped_Delay_out1_1(30), 37);
  Sum_add_temp_29 <= Sum_add_temp_28 + Sum_add_cast_30;
  Sum_add_cast_31 <= resize(Tapped_Delay_out1_1(31), 37);
  Sum_add_temp_30 <= Sum_add_temp_29 + Sum_add_cast_31;
  Sum_out1 <= Sum_add_temp_30(31 DOWNTO 0);

  HwModeRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Sum_out1_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Sum_out1_1 <= Sum_out1;
      END IF;
    END IF;
  END PROCESS HwModeRegister_process;


  Constant_out1 <= to_signed(8388608, 32);

  HwModeRegister1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Constant_out1_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Constant_out1_1 <= Constant_out1;
      END IF;
    END IF;
  END PROCESS HwModeRegister1_process;


  Divide_mul_temp <= Sum_out1_1 * Constant_out1_1;
  Divide_out1 <= Divide_mul_temp(59 DOWNTO 28);

  PipelineRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Divide_out1_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Divide_out1_1 <= Divide_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister_process;


  
  Switch_out1 <= right_data_sink_1 WHEN switch_compare_1 = '0' ELSE
      Divide_out1_1;

  right_channel_source <= std_logic_vector(Switch_out1);

END rtl;

