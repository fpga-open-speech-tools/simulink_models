-- -------------------------------------------------------------
-- 
-- File Name: /home/cb54103/Documents/fpga-open-speech-tools/simulink_models/models/Dynamic_Compression_Model/hdlsrc/sm_DynamicCompression/sm_DynamicCompression_Compression_3.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: sm_DynamicCompression_Compression_3
-- Source Path: sm_DynamicCompression/dataplane/Avalon Data Processing/Left Channel Processing/recalculate/Nchan_FbankAGC_AID/Compression_3
-- Hierarchy Level: 5
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.sm_DynamicCompression_dataplane_pkg.ALL;

ENTITY sm_DynamicCompression_Compression_3 IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_1024_0                      :   IN    std_logic;
        enb                               :   IN    std_logic;
        enb_1_1024_5                      :   IN    std_logic;
        Sig_Band_1                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Table_In                          :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Table_Sel                         :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
        Write_Addr                        :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix9
        Sig_out                           :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END sm_DynamicCompression_Compression_3;


ARCHITECTURE rtl OF sm_DynamicCompression_Compression_3 IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT sm_DynamicCompression_Compression_Gain_Calc_block1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          Table_Fill                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Write_Addr                      :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix9
          Table_Fill_Valid                :   IN    std_logic;
          Data_In                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Gain_C_out                      :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Compression_Envelope_block1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          Desired_Gain                    :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Curr_Gain                       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Gain_Out                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : sm_DynamicCompression_Compression_Gain_Calc_block1
    USE ENTITY work.sm_DynamicCompression_Compression_Gain_Calc_block1(rtl);

  FOR ALL : sm_DynamicCompression_Compression_Envelope_block1
    USE ENTITY work.sm_DynamicCompression_Compression_Envelope_block1(rtl);

  -- Signals
  SIGNAL Table_Sel_unsigned               : unsigned(2 DOWNTO 0);  -- ufix3
  SIGNAL Compare_To_Constant_out1         : std_logic;
  SIGNAL Compression_Gain_Calc_out1       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Compression_Gain_Calc_out1_signed : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Rate_Transition1_ds_out          : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Rate_Transition1_out1            : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Rate_Transition1_out1_1          : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Unit_Delay_ctrl_const_out        : std_logic;
  SIGNAL delayMatch1_reg                  : std_logic_vector(0 TO 2);  -- ufix1 [3]
  SIGNAL Unit_Delay_ctrl_const_out_1      : std_logic;
  SIGNAL Unit_Delay_Initial_Val_out       : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Compression_Envelope_out1_signed : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Unit_Delay_out                   : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Unit_Delay_out1                  : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Compression_Envelope_out1        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Rate_Transition2_out1            : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Rate_Transition2_out1_1          : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL switch_compare_1                 : std_logic;
  SIGNAL Constant_out1                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Sig_Band_1_signed                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Switch_out1                      : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL HwModeRegister1_reg              : vector_of_signed32(0 TO 2051);  -- sfix32 [2052]
  SIGNAL Delay_out1                       : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Product_out1                     : signed(63 DOWNTO 0);  -- sfix64_En56
  SIGNAL Product_out1_1                   : signed(63 DOWNTO 0);  -- sfix64_En56
  SIGNAL Data_Type_Conversion1_out1       : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- Calculate Compression Gain Needed
  -- 
  -- Apply to the Envelope

  u_Compression_Gain_Calc : sm_DynamicCompression_Compression_Gain_Calc_block1
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              Table_Fill => Table_In,  -- sfix32_En28
              Write_Addr => Write_Addr,  -- ufix9
              Table_Fill_Valid => Compare_To_Constant_out1,
              Data_In => Sig_Band_1,  -- sfix32_En28
              Gain_C_out => Compression_Gain_Calc_out1  -- sfix32_En28
              );

  u_Compression_Envelope : sm_DynamicCompression_Compression_Envelope_block1
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              Desired_Gain => std_logic_vector(Rate_Transition1_out1_1),  -- sfix32_En28
              Curr_Gain => std_logic_vector(Unit_Delay_out1),  -- sfix32_En28
              Gain_Out => Compression_Envelope_out1  -- sfix32_En28
              );

  Table_Sel_unsigned <= unsigned(Table_Sel);

  
  Compare_To_Constant_out1 <= '1' WHEN Table_Sel_unsigned = to_unsigned(16#2#, 3) ELSE
      '0';

  Compression_Gain_Calc_out1_signed <= signed(Compression_Gain_Calc_out1);

  -- Downsample register
  Rate_Transition1_ds_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition1_ds_out <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_5 = '1' THEN
        Rate_Transition1_ds_out <= Compression_Gain_Calc_out1_signed;
      END IF;
    END IF;
  END PROCESS Rate_Transition1_ds_process;


  -- Downsample output register
  Rate_Transition1_output_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition1_out1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Rate_Transition1_out1 <= Rate_Transition1_ds_out;
      END IF;
    END IF;
  END PROCESS Rate_Transition1_output_process;


  PipelineRegister1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition1_out1_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Rate_Transition1_out1_1 <= Rate_Transition1_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister1_process;


  Unit_Delay_ctrl_const_out <= '1';

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        delayMatch1_reg(0) <= Unit_Delay_ctrl_const_out;
        delayMatch1_reg(1 TO 2) <= delayMatch1_reg(0 TO 1);
      END IF;
    END IF;
  END PROCESS delayMatch1_process;

  Unit_Delay_ctrl_const_out_1 <= delayMatch1_reg(2);

  Unit_Delay_Initial_Val_out <= to_signed(268435456, 32);

  Unit_Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Unit_Delay_out <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Unit_Delay_out <= Compression_Envelope_out1_signed;
      END IF;
    END IF;
  END PROCESS Unit_Delay_process;


  
  Unit_Delay_out1 <= Unit_Delay_Initial_Val_out WHEN Unit_Delay_ctrl_const_out_1 = '0' ELSE
      Unit_Delay_out;

  Compression_Envelope_out1_signed <= signed(Compression_Envelope_out1);

  Rate_Transition2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition2_out1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Rate_Transition2_out1 <= Compression_Envelope_out1_signed;
      END IF;
    END IF;
  END PROCESS Rate_Transition2_process;


  HwModeRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition2_out1_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Rate_Transition2_out1_1 <= Rate_Transition2_out1;
      END IF;
    END IF;
  END PROCESS HwModeRegister_process;


  
  switch_compare_1 <= '1' WHEN Table_Sel_unsigned > to_unsigned(16#4#, 3) ELSE
      '0';

  Constant_out1 <= to_signed(0, 32);

  Sig_Band_1_signed <= signed(Sig_Band_1);

  
  Switch_out1 <= Constant_out1 WHEN switch_compare_1 = '0' ELSE
      Sig_Band_1_signed;

  HwModeRegister1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      HwModeRegister1_reg <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        HwModeRegister1_reg(0) <= Switch_out1;
        HwModeRegister1_reg(1 TO 2051) <= HwModeRegister1_reg(0 TO 2050);
      END IF;
    END IF;
  END PROCESS HwModeRegister1_process;

  Delay_out1 <= HwModeRegister1_reg(2051);

  Product_out1 <= Rate_Transition2_out1_1 * Delay_out1;

  PipelineRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Product_out1_1 <= to_signed(0, 64);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        Product_out1_1 <= Product_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister_process;


  Data_Type_Conversion1_out1 <= Product_out1_1(59 DOWNTO 28);

  Sig_out <= std_logic_vector(Data_Type_Conversion1_out1);

END rtl;

