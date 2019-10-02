-- -------------------------------------------------------------
-- 
-- File Name: /mnt/data/NIH/simulink_models/models/flanger/hdlsrc/flanger/Right_Channel_Processing.vhd
-- Created: 2019-10-02 17:07:54
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Right_Channel_Processing
-- Source Path: flanger/flanger_dataplane/Avalon Data Processing/Right Channel Processing
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.flanger_dataplane_pkg.ALL;

ENTITY Right_Channel_Processing IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        right_data_in                     :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        bypass                            :   IN    std_logic;
        rate                              :   IN    std_logic_vector(7 DOWNTO 0);  -- ufix8_En5
        regen                             :   IN    std_logic_vector(7 DOWNTO 0);  -- ufix8_En7
        Enable                            :   IN    std_logic;
        right_data_out                    :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END Right_Channel_Processing;


ARCHITECTURE rtl OF Right_Channel_Processing IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT LFO_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          rate                            :   IN    std_logic_vector(7 DOWNTO 0);  -- ufix8_En5
          Enable_out5                     :   IN    std_logic;
          sin                             :   OUT   std_logic_vector(8 DOWNTO 0)  -- ufix9
          );
  END COMPONENT;

  COMPONENT variable_delay_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          data_in                         :   IN    std_logic_vector(39 DOWNTO 0);  -- sfix40_En32
          delay                           :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix9
          Enable_out5                     :   IN    std_logic;
          data_out                        :   OUT   std_logic_vector(39 DOWNTO 0)  -- sfix40_En32
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : LFO_block
    USE ENTITY work.LFO_block(rtl);

  FOR ALL : variable_delay_block
    USE ENTITY work.variable_delay_block(rtl);

  -- Signals
  SIGNAL Enable_out5                      : std_logic;
  SIGNAL reduced_reg                      : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL Enable_out5_1                    : std_logic;
  SIGNAL delayMatch5_reg                  : std_logic_vector(0 TO 1);  -- ufix1 [2]
  SIGNAL bypass_1                         : std_logic;
  SIGNAL right_data_in_signed             : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL reduced_reg_1                    : vector_of_signed32(0 TO 1);  -- sfix32 [2]
  SIGNAL original_signal                  : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL regen_unsigned                   : unsigned(7 DOWNTO 0);  -- ufix8_En7
  SIGNAL delayMatch1_reg                  : vector_of_unsigned8(0 TO 1);  -- ufix8 [2]
  SIGNAL regen_1                          : unsigned(7 DOWNTO 0);  -- ufix8_En7
  SIGNAL enb_gated                        : std_logic;
  SIGNAL LFO_out1                         : std_logic_vector(8 DOWNTO 0);  -- ufix9
  SIGNAL variable_delay_out1_signed       : signed(39 DOWNTO 0);  -- sfix40_En32
  SIGNAL Product_cast                     : signed(8 DOWNTO 0);  -- sfix9_En7
  SIGNAL Product_mul_temp                 : signed(48 DOWNTO 0);  -- sfix49_En39
  SIGNAL Product_cast_1                   : signed(47 DOWNTO 0);  -- sfix48_En39
  SIGNAL Product_out1                     : signed(39 DOWNTO 0);  -- sfix40_En32
  SIGNAL Unit_Delay_out1                  : signed(39 DOWNTO 0);  -- sfix40_En32
  SIGNAL Add1_add_cast                    : signed(40 DOWNTO 0);  -- sfix41_En32
  SIGNAL Add1_add_cast_1                  : signed(40 DOWNTO 0);  -- sfix41_En32
  SIGNAL Add1_add_temp                    : signed(40 DOWNTO 0);  -- sfix41_En32
  SIGNAL Add1_out1                        : signed(39 DOWNTO 0);  -- sfix40_En32
  SIGNAL variable_delay_out1              : std_logic_vector(39 DOWNTO 0);  -- ufix40
  SIGNAL Add_add_cast                     : signed(40 DOWNTO 0);  -- sfix41_En32
  SIGNAL Add_add_cast_1                   : signed(40 DOWNTO 0);  -- sfix41_En32
  SIGNAL Add_add_temp                     : signed(40 DOWNTO 0);  -- sfix41_En32
  SIGNAL Add_out1                         : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Switch_out1                      : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Switch_out1_bypass               : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Switch_out1_last_value           : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- feedforward delay line
  -- 
  -- feedback path
  -- 
  -- add original and delayed signals
  -- 
  -- if bypass is true, pass the original signal 
  -- through without any effects
  -- 
  -- An enabled subsystem
  -- This subsystem only runs when the data valid signal is enabled (asserted)
  -- 

  u_LFO : LFO_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              rate => rate,  -- ufix8_En5
              Enable_out5 => Enable_out5,
              sin => LFO_out1  -- ufix9
              );

  u_variable_delay : variable_delay_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              data_in => std_logic_vector(Add1_out1),  -- sfix40_En32
              delay => LFO_out1,  -- ufix9
              Enable_out5 => Enable_out5_1,
              data_out => variable_delay_out1  -- sfix40_En32
              );

  Enable_out5 <= Enable;

  reduced_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      reduced_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        reduced_reg(0) <= Enable_out5;
        reduced_reg(1) <= reduced_reg(0);
      END IF;
    END IF;
  END PROCESS reduced_process;

  Enable_out5_1 <= reduced_reg(1);

  delayMatch5_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch5_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch5_reg(0) <= bypass;
        delayMatch5_reg(1) <= delayMatch5_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch5_process;

  bypass_1 <= delayMatch5_reg(1);

  right_data_in_signed <= signed(right_data_in);

  reduced_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      reduced_reg_1 <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        reduced_reg_1(0) <= right_data_in_signed;
        reduced_reg_1(1) <= reduced_reg_1(0);
      END IF;
    END IF;
  END PROCESS reduced_1_process;

  original_signal <= reduced_reg_1(1);

  regen_unsigned <= unsigned(regen);

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => to_unsigned(16#00#, 8));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch1_reg(0) <= regen_unsigned;
        delayMatch1_reg(1) <= delayMatch1_reg(0);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  regen_1 <= delayMatch1_reg(1);

  enb_gated <= Enable_out5_1 AND enb;

  Product_cast <= signed(resize(regen_1, 9));
  Product_mul_temp <= Product_cast * variable_delay_out1_signed;
  Product_cast_1 <= Product_mul_temp(47 DOWNTO 0);
  Product_out1 <= Product_cast_1(46 DOWNTO 7);

  Unit_Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Unit_Delay_out1 <= to_signed(0, 40);
    ELSIF rising_edge(clk) THEN
      IF enb_gated = '1' THEN
        Unit_Delay_out1 <= Product_out1;
      END IF;
    END IF;
  END PROCESS Unit_Delay_process;


  Add1_add_cast <= resize(original_signal & '0' & '0' & '0' & '0', 41);
  Add1_add_cast_1 <= resize(Unit_Delay_out1, 41);
  Add1_add_temp <= Add1_add_cast + Add1_add_cast_1;
  Add1_out1 <= Add1_add_temp(39 DOWNTO 0);

  variable_delay_out1_signed <= signed(variable_delay_out1);

  Add_add_cast <= resize(original_signal & '0' & '0' & '0' & '0', 41);
  Add_add_cast_1 <= resize(variable_delay_out1_signed, 41);
  Add_add_temp <= Add_add_cast + Add_add_cast_1;
  Add_out1 <= Add_add_temp(35 DOWNTO 4);

  
  Switch_out1 <= Add_out1 WHEN bypass_1 = '0' ELSE
      original_signal;

  right_data_out_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Switch_out1_last_value <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Switch_out1_last_value <= Switch_out1_bypass;
      END IF;
    END IF;
  END PROCESS right_data_out_bypass_process;


  
  Switch_out1_bypass <= Switch_out1_last_value WHEN Enable_out5_1 = '0' ELSE
      Switch_out1;

  right_data_out <= std_logic_vector(Switch_out1_bypass);

END rtl;

