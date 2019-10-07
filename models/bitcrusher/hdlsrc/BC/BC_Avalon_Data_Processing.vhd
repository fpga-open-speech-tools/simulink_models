-- -------------------------------------------------------------
-- 
-- File Name: C:\Users\bugsbunny\NIH\simulink_models\models\bitcrusher\hdlsrc\BC\BC_Avalon_Data_Processing.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: BC_Avalon_Data_Processing
-- Source Path: BC/dataplane/Avalon Data Processing
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.BC_dataplane_pkg.ALL;

ENTITY BC_Avalon_Data_Processing IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        Sink_Data                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Sink_Channel                      :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        Left_Bypass                       :   IN    std_logic;
        Left_Bits                         :   IN    std_logic_vector(4 DOWNTO 0);  -- ufix5
        Left_Wet_Dry_Mix                  :   IN    std_logic_vector(4 DOWNTO 0);  -- ufix5_En4
        Right_Bypass                      :   IN    std_logic;
        Right_Bits                        :   IN    std_logic_vector(4 DOWNTO 0);  -- ufix5
        Right_Wet_Dry_Mix                 :   IN    std_logic_vector(4 DOWNTO 0);  -- ufix5_En4
        Enable                            :   IN    std_logic;
        Source_Data                       :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Source_Channel                    :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
        );
END BC_Avalon_Data_Processing;


ARCHITECTURE rtl OF BC_Avalon_Data_Processing IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT BC_Left_Channel_Processing
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Left_Data_In                    :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Left_Bypass                     :   IN    std_logic;
          Left_Bits                       :   IN    std_logic_vector(4 DOWNTO 0);  -- ufix5
          Left_Wet_Dry_Mix                :   IN    std_logic_vector(4 DOWNTO 0);  -- ufix5_En4
          Enable                          :   IN    std_logic;
          Left_Data_Out                   :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT BC_Right_Channel_Processing
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Right_Data_In                   :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Right_Bypass                    :   IN    std_logic;
          Right_Bits                      :   IN    std_logic_vector(4 DOWNTO 0);  -- ufix5
          Right_Wet_Dry_Mix               :   IN    std_logic_vector(4 DOWNTO 0);  -- ufix5_En4
          Enable                          :   IN    std_logic;
          Right_Data_Out                  :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : BC_Left_Channel_Processing
    USE ENTITY work.BC_Left_Channel_Processing(rtl);

  FOR ALL : BC_Right_Channel_Processing
    USE ENTITY work.BC_Right_Channel_Processing(rtl);

  -- Signals
  SIGNAL Enable_out9                      : std_logic;
  SIGNAL delayMatch2_reg                  : std_logic_vector(0 TO 3);  -- ufix1 [4]
  SIGNAL Enable_out9_1                    : std_logic;
  SIGNAL Sink_Channel_unsigned            : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL Compare_To_Constant2_out1        : std_logic;
  SIGNAL Compare_To_Constant2_out1_1      : std_logic;
  SIGNAL Compare_To_Constant1_out1        : std_logic;
  SIGNAL Compare_To_Constant1_out1_1      : std_logic;
  SIGNAL delayMatch_reg                   : vector_of_unsigned2(0 TO 3);  -- ufix2 [4]
  SIGNAL Sink_Channel_1                   : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL Left_Channel_Processing_out1     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Left_Channel_Processing_out1_signed : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Right_Channel_Processing_out1    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Right_Channel_Processing_out1_signed : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Sink_Data_signed                 : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL delayMatch1_reg                  : vector_of_signed32(0 TO 3);  -- sfix32 [4]
  SIGNAL Sink_Data_1                      : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Multiport_Switch_out1            : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Multiport_Switch_out1_bypass     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Multiport_Switch_out1_last_value : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Sink_Channel_bypass              : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL Sink_Channel_last_value          : unsigned(1 DOWNTO 0);  -- ufix2

BEGIN
  -- Select output data
  -- based on channel number
  -- 
  -- Check if Channel 0 
  -- (Left Channel)
  -- 
  -- The Left Channel Processing block 
  -- only executes when channel 0
  -- is detected
  -- 
  -- The Right Channel Processing block 
  -- only executes when channel 1
  -- is detected
  -- 
  -- Check if Channel 1 
  -- (Right Channel)
  -- 
  -- An enabled subsystem
  -- This subsystem only runs when the data valid signal is enabled (asserted)
  -- 

  u_Left_Channel_Processing : BC_Left_Channel_Processing
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              Left_Data_In => Sink_Data,  -- sfix32_En28
              Left_Bypass => Left_Bypass,
              Left_Bits => Left_Bits,  -- ufix5
              Left_Wet_Dry_Mix => Left_Wet_Dry_Mix,  -- ufix5_En4
              Enable => Compare_To_Constant2_out1_1,
              Left_Data_Out => Left_Channel_Processing_out1  -- sfix32_En28
              );

  u_Right_Channel_Processing : BC_Right_Channel_Processing
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              Right_Data_In => Sink_Data,  -- sfix32_En28
              Right_Bypass => Right_Bypass,
              Right_Bits => Right_Bits,  -- ufix5
              Right_Wet_Dry_Mix => Right_Wet_Dry_Mix,  -- ufix5_En4
              Enable => Compare_To_Constant1_out1_1,
              Right_Data_Out => Right_Channel_Processing_out1  -- sfix32_En28
              );

  Enable_out9 <= Enable;

  delayMatch2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch2_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch2_reg(0) <= Enable_out9;
        delayMatch2_reg(1 TO 3) <= delayMatch2_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS delayMatch2_process;

  Enable_out9_1 <= delayMatch2_reg(3);

  Sink_Channel_unsigned <= unsigned(Sink_Channel);

  
  Compare_To_Constant2_out1 <= '1' WHEN Sink_Channel_unsigned = to_unsigned(16#0#, 2) ELSE
      '0';

  Compare_To_Constant2_out1_1 <= Compare_To_Constant2_out1 AND Enable_out9;

  
  Compare_To_Constant1_out1 <= '1' WHEN Sink_Channel_unsigned = to_unsigned(16#1#, 2) ELSE
      '0';

  Compare_To_Constant1_out1_1 <= Compare_To_Constant1_out1 AND Enable_out9;

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_reg <= (OTHERS => to_unsigned(16#0#, 2));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_reg(0) <= Sink_Channel_unsigned;
        delayMatch_reg(1 TO 3) <= delayMatch_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS delayMatch_process;

  Sink_Channel_1 <= delayMatch_reg(3);

  Left_Channel_Processing_out1_signed <= signed(Left_Channel_Processing_out1);

  Right_Channel_Processing_out1_signed <= signed(Right_Channel_Processing_out1);

  Sink_Data_signed <= signed(Sink_Data);

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch1_reg(0) <= Sink_Data_signed;
        delayMatch1_reg(1 TO 3) <= delayMatch1_reg(0 TO 2);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  Sink_Data_1 <= delayMatch1_reg(3);

  
  Multiport_Switch_out1 <= Left_Channel_Processing_out1_signed WHEN Sink_Channel_1 = to_unsigned(16#0#, 2) ELSE
      Right_Channel_Processing_out1_signed WHEN Sink_Channel_1 = to_unsigned(16#1#, 2) ELSE
      Sink_Data_1;

  Source_Data_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Multiport_Switch_out1_last_value <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Multiport_Switch_out1_last_value <= Multiport_Switch_out1_bypass;
      END IF;
    END IF;
  END PROCESS Source_Data_bypass_process;


  
  Multiport_Switch_out1_bypass <= Multiport_Switch_out1_last_value WHEN Enable_out9_1 = '0' ELSE
      Multiport_Switch_out1;

  Source_Data <= std_logic_vector(Multiport_Switch_out1_bypass);

  Source_Channel_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Sink_Channel_last_value <= to_unsigned(16#0#, 2);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Sink_Channel_last_value <= Sink_Channel_bypass;
      END IF;
    END IF;
  END PROCESS Source_Channel_bypass_process;


  
  Sink_Channel_bypass <= Sink_Channel_last_value WHEN Enable_out9 = '0' ELSE
      Sink_Channel_unsigned;

  Source_Channel <= std_logic_vector(Sink_Channel_bypass);

END rtl;

