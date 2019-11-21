-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj/hdlsrc/RAM_test/Static_pFIR.vhd
-- Created: 2019-11-19 14:31:09
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 2.03451e-08
-- Target subsystem base rate: 2.03451e-08
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        2.03451e-08
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- Data_out                      ce_out        2.03451e-08
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Static_pFIR
-- Source Path: Static_pFIR
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Static_pFIR IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        Left_Data_In                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Valid_in                          :   IN    std_logic;
        ce_out                            :   OUT   std_logic;
        Data_out                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END Static_pFIR;


ARCHITECTURE rtl OF Static_pFIR IS

  -- Component Declarations
  COMPONENT Static_pFIR_tc
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          clk_enable                      :   IN    std_logic;
          enb                             :   OUT   std_logic;
          enb_1_1_1                       :   OUT   std_logic;
          enb_1_1024_0                    :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT Addr_Gen
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          Input_Addr                      :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          Data_History_Rd_addr            :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          End_of_sample_calc              :   OUT   std_logic;
          b_k_addr                        :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT SimpleDualPortRAM_generic
    GENERIC( AddrWidth                    : integer;
             DataWidth                    : integer
             );
    PORT( clk                             :   IN    std_logic;
          enb                             :   IN    std_logic;
          wr_din                          :   IN    std_logic_vector(DataWidth - 1 DOWNTO 0);  -- generic width
          wr_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          wr_en                           :   IN    std_logic;
          rd_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          rd_dout                         :   OUT   std_logic_vector(DataWidth - 1 DOWNTO 0)  -- generic width
          );
  END COMPONENT;

  COMPONENT B_k_Memory_Block2
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          din_A                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          addr_A                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          we_A                            :   IN    std_logic;
          din_B                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          addr_B                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          we_B                            :   IN    std_logic;
          dout_B                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT Multiply_And_Sum
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          x_n_i                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          End_of_sample_calc              :   IN    std_logic;
          b_i                             :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Filtered_Output                 :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Output_Valid                    :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Static_pFIR_tc
    USE ENTITY work.Static_pFIR_tc(rtl);

  FOR ALL : Addr_Gen
    USE ENTITY work.Addr_Gen(rtl);

  FOR ALL : SimpleDualPortRAM_generic
    USE ENTITY work.SimpleDualPortRAM_generic(rtl);

  FOR ALL : B_k_Memory_Block2
    USE ENTITY work.B_k_Memory_Block2(rtl);

  FOR ALL : Multiply_And_Sum
    USE ENTITY work.Multiply_And_Sum(rtl);

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL enb_1_1024_0                     : std_logic;
  SIGNAL enb_1_1_1                        : std_logic;
  SIGNAL Addr_Gen_out1                    : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL Addr_Gen_out2                    : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL Addr_Gen_out3                    : std_logic;
  SIGNAL Addr_Gen_out4                    : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL x_n_i                            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Alignment_Delay_out1             : std_logic;
  SIGNAL READ_ONLY_1_out1                 : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL READ_ONLY_2_out1                 : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL READ_ONLY_3_out1                 : std_logic;
  SIGNAL Never_write_B2_out1              : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Always_read_B2_out1              : std_logic;
  SIGNAL b_i                              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Multiply_And_Sum_out1            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Multiply_And_Sum_out2            : std_logic;
  SIGNAL Multiply_And_Sum_out1_signed     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Output_memory_out1               : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Reset_Switch_out1                : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- consider desired output rate
  -- 
  -- B_ks will be programmable eventually.
  -- For the Conference, they will be preset.

  u_Static_pFIR_tc : Static_pFIR_tc
    PORT MAP( clk => clk,
              reset => reset,
              clk_enable => clk_enable,
              enb => enb,
              enb_1_1_1 => enb_1_1_1,
              enb_1_1024_0 => enb_1_1024_0
              );

  u_Addr_Gen : Addr_Gen
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              enb_1_1024_0 => enb_1_1024_0,
              Input_Addr => Addr_Gen_out1,  -- ufix10
              Data_History_Rd_addr => Addr_Gen_out2,  -- ufix10
              End_of_sample_calc => Addr_Gen_out3,
              b_k_addr => Addr_Gen_out4  -- ufix10
              );

  u_Input_Data_Circular_Buffer : SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 10,
                 DataWidth => 32
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => Left_Data_In,
              wr_addr => Addr_Gen_out1,
              wr_en => Valid_in,
              rd_addr => Addr_Gen_out2,
              rd_dout => x_n_i
              );

  u_B_k_Memory_Block2 : B_k_Memory_Block2
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              din_A => std_logic_vector(READ_ONLY_1_out1),  -- sfix32_En28
              addr_A => std_logic_vector(READ_ONLY_2_out1),  -- ufix10
              we_A => READ_ONLY_3_out1,
              din_B => std_logic_vector(Never_write_B2_out1),  -- sfix32_En28
              addr_B => Addr_Gen_out4,  -- ufix10
              we_B => Always_read_B2_out1,
              dout_B => b_i  -- sfix32_En28
              );

  u_Multiply_And_Sum : Multiply_And_Sum
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              x_n_i => x_n_i,  -- sfix32_En28
              End_of_sample_calc => Alignment_Delay_out1,
              b_i => b_i,  -- sfix32_En28
              Filtered_Output => Multiply_And_Sum_out1,  -- sfix32_En28
              Output_Valid => Multiply_And_Sum_out2
              );

  Alignment_Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Alignment_Delay_out1 <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Alignment_Delay_out1 <= Addr_Gen_out3;
      END IF;
    END IF;
  END PROCESS Alignment_Delay_process;


  READ_ONLY_1_out1 <= to_signed(0, 32);

  READ_ONLY_2_out1 <= to_unsigned(16#000#, 10);

  READ_ONLY_3_out1 <= '0';

  Never_write_B2_out1 <= to_signed(0, 32);

  Always_read_B2_out1 <= '0';

  Multiply_And_Sum_out1_signed <= signed(Multiply_And_Sum_out1);

  
  Reset_Switch_out1 <= Output_memory_out1 WHEN Multiply_And_Sum_out2 = '0' ELSE
      Multiply_And_Sum_out1_signed;

  Output_memory_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Output_memory_out1 <= to_signed(0, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        Output_memory_out1 <= Reset_Switch_out1;
      END IF;
    END IF;
  END PROCESS Output_memory_process;


  Data_out <= std_logic_vector(Output_memory_out1);

  ce_out <= enb_1_1_1;

END rtl;

