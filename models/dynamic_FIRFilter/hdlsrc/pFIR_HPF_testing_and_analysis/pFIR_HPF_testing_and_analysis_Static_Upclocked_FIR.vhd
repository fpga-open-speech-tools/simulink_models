-- -------------------------------------------------------------
-- 
-- File Name: /home/justin/Documents/FEI/simulink_models/models/dynamic_FIRFilter/hdlsrc/pFIR_HPF_testing_and_analysis/pFIR_HPF_testing_and_analysis_Static_Upclocked_FIR.vhd
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: pFIR_HPF_testing_and_analysis_Static_Upclocked_FIR
-- Source Path: pFIR_HPF_testing_and_analysis/dataplane/Test FIR with Custom FIR Libraries Sample Based Filtering/Left 
-- Channel Processing/Static Upclocked FI
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY pFIR_HPF_testing_and_analysis_Static_Upclocked_FIR IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_2_0                         :   IN    std_logic;
        enb_1_2_1                         :   IN    std_logic;
        enb_1_2048_0                      :   IN    std_logic;
        Data_In                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Valid_in                          :   IN    std_logic;
        Data_out                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
        );
END pFIR_HPF_testing_and_analysis_Static_Upclocked_FIR;


ARCHITECTURE rtl OF pFIR_HPF_testing_and_analysis_Static_Upclocked_FIR IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT pFIR_HPF_testing_and_analysis_Addr_Gen
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2_0                       :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          Input_Addr                      :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          Data_History_Rd_addr            :   OUT   std_logic_vector(9 DOWNTO 0);  -- ufix10
          End_of_sample_calc              :   OUT   std_logic;
          b_k_addr                        :   OUT   std_logic_vector(9 DOWNTO 0)  -- ufix10
          );
  END COMPONENT;

  COMPONENT pFIR_HPF_testing_and_analysis_SimpleDualPortRAM_generic
    GENERIC( AddrWidth                    : integer;
             DataWidth                    : integer
             );
    PORT( clk                             :   IN    std_logic;
          enb_1_2_0                       :   IN    std_logic;
          wr_din                          :   IN    std_logic_vector(DataWidth - 1 DOWNTO 0);  -- generic width
          wr_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          wr_en                           :   IN    std_logic;
          rd_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          rd_dout                         :   OUT   std_logic_vector(DataWidth - 1 DOWNTO 0)  -- generic width
          );
  END COMPONENT;

  COMPONENT pFIR_HPF_testing_and_analysis_B_k_Memory_Block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2_0                       :   IN    std_logic;
          din_A                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          addr_A                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          we_A                            :   IN    std_logic;
          din_B                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          addr_B                          :   IN    std_logic_vector(9 DOWNTO 0);  -- ufix10
          we_B                            :   IN    std_logic;
          dout_A                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          dout_B                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT pFIR_HPF_testing_and_analysis_Multiply_And_Sum
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2_0                       :   IN    std_logic;
          x_n_i                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          End_of_sample_calc              :   IN    std_logic;
          b_i                             :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Filtered_Output                 :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Output_Valid                    :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : pFIR_HPF_testing_and_analysis_Addr_Gen
    USE ENTITY work.pFIR_HPF_testing_and_analysis_Addr_Gen(rtl);

  FOR ALL : pFIR_HPF_testing_and_analysis_SimpleDualPortRAM_generic
    USE ENTITY work.pFIR_HPF_testing_and_analysis_SimpleDualPortRAM_generic(rtl);

  FOR ALL : pFIR_HPF_testing_and_analysis_B_k_Memory_Block
    USE ENTITY work.pFIR_HPF_testing_and_analysis_B_k_Memory_Block(rtl);

  FOR ALL : pFIR_HPF_testing_and_analysis_Multiply_And_Sum
    USE ENTITY work.pFIR_HPF_testing_and_analysis_Multiply_And_Sum(rtl);

  -- Signals
  SIGNAL Data_In_signed                   : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Rate_Transition1_out1            : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Addr_Gen_out1                    : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL Addr_Gen_out2                    : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL Addr_Gen_out3                    : std_logic;
  SIGNAL Addr_Gen_out4                    : std_logic_vector(9 DOWNTO 0);  -- ufix10
  SIGNAL Addr_Gen_out1_unsigned           : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Rate_Transition2_out1            : std_logic;
  SIGNAL Addr_Gen_out2_unsigned           : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Rate_Transition1_out1_1          : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Addr_Gen_out1_1                  : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL Rate_Transition2_out1_1          : std_logic;
  SIGNAL Data_Type_Conversion1_out1       : std_logic;
  SIGNAL Addr_Gen_out2_1                  : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL x_n_i                            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Alignment_Delay_out1             : std_logic;
  SIGNAL READ_ONLY_1_out1                 : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL READ_ONLY_2_out1                 : unsigned(9 DOWNTO 0);  -- ufix10
  SIGNAL READ_ONLY_3_out1                 : std_logic;
  SIGNAL Never_write_B2_out1              : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Always_read_B2_out1              : std_logic;
  SIGNAL B_k_Memory_Block_out1            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL b_i                              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Multiply_And_Sum_out1            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Multiply_And_Sum_out2            : std_logic;
  SIGNAL Multiply_And_Sum_out2_1          : std_logic;
  SIGNAL Multiply_And_Sum_out1_signed     : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Output_memory_out1               : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Reset_Switch_out1                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Rate_Transition_out1             : signed(31 DOWNTO 0);  -- sfix32_En28

BEGIN
  -- B_ks will be programmable eventually.
  -- For the Conference, they will be preset.
  -- 
  -- consider desired output rate

  u_Addr_Gen : pFIR_HPF_testing_and_analysis_Addr_Gen
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2_0 => enb_1_2_0,
              enb_1_2048_0 => enb_1_2048_0,
              Input_Addr => Addr_Gen_out1,  -- ufix10
              Data_History_Rd_addr => Addr_Gen_out2,  -- ufix10
              End_of_sample_calc => Addr_Gen_out3,
              b_k_addr => Addr_Gen_out4  -- ufix10
              );

  u_Input_Data_Circular_Buffer : pFIR_HPF_testing_and_analysis_SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 10,
                 DataWidth => 32
                 )
    PORT MAP( clk => clk,
              enb_1_2_0 => enb_1_2_0,
              wr_din => std_logic_vector(Rate_Transition1_out1_1),
              wr_addr => std_logic_vector(Addr_Gen_out1_1),
              wr_en => Data_Type_Conversion1_out1,
              rd_addr => std_logic_vector(Addr_Gen_out2_1),
              rd_dout => x_n_i
              );

  u_B_k_Memory_Block : pFIR_HPF_testing_and_analysis_B_k_Memory_Block
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2_0 => enb_1_2_0,
              din_A => std_logic_vector(READ_ONLY_1_out1),  -- sfix32_En28
              addr_A => std_logic_vector(READ_ONLY_2_out1),  -- ufix10
              we_A => READ_ONLY_3_out1,
              din_B => std_logic_vector(Never_write_B2_out1),  -- sfix32_En28
              addr_B => Addr_Gen_out4,  -- ufix10
              we_B => Always_read_B2_out1,
              dout_A => B_k_Memory_Block_out1,  -- sfix32_En28
              dout_B => b_i  -- sfix32_En28
              );

  -- 
  u_Multiply_And_Sum : pFIR_HPF_testing_and_analysis_Multiply_And_Sum
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2_0 => enb_1_2_0,
              x_n_i => x_n_i,  -- sfix32_En28
              End_of_sample_calc => Alignment_Delay_out1,
              b_i => b_i,  -- sfix32_En28
              Filtered_Output => Multiply_And_Sum_out1,  -- sfix32_En28
              Output_Valid => Multiply_And_Sum_out2
              );

  Data_In_signed <= signed(Data_In);

  Rate_Transition1_output_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition1_out1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_1 = '1' THEN
        Rate_Transition1_out1 <= Data_In_signed;
      END IF;
    END IF;
  END PROCESS Rate_Transition1_output_process;


  Addr_Gen_out1_unsigned <= unsigned(Addr_Gen_out1);

  Rate_Transition2_output_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition2_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_1 = '1' THEN
        Rate_Transition2_out1 <= Valid_in;
      END IF;
    END IF;
  END PROCESS Rate_Transition2_output_process;


  Addr_Gen_out2_unsigned <= unsigned(Addr_Gen_out2);

  PipelineRegister_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition1_out1_1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        Rate_Transition1_out1_1 <= Rate_Transition1_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister_process;


  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Addr_Gen_out1_1 <= to_unsigned(16#000#, 10);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        Addr_Gen_out1_1 <= Addr_Gen_out1_unsigned;
      END IF;
    END IF;
  END PROCESS delayMatch_process;


  PipelineRegister1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition2_out1_1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        Rate_Transition2_out1_1 <= Rate_Transition2_out1;
      END IF;
    END IF;
  END PROCESS PipelineRegister1_process;


  
  Data_Type_Conversion1_out1 <= '1' WHEN Rate_Transition2_out1_1 /= '0' ELSE
      '0';

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Addr_Gen_out2_1 <= to_unsigned(16#000#, 10);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        Addr_Gen_out2_1 <= Addr_Gen_out2_unsigned;
      END IF;
    END IF;
  END PROCESS delayMatch1_process;


  Alignment_Delay_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Alignment_Delay_out1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        Alignment_Delay_out1 <= Addr_Gen_out3;
      END IF;
    END IF;
  END PROCESS Alignment_Delay_process;


  READ_ONLY_1_out1 <= to_signed(0, 32);

  READ_ONLY_2_out1 <= to_unsigned(16#000#, 10);

  READ_ONLY_3_out1 <= '0';

  Never_write_B2_out1 <= to_signed(0, 32);

  Always_read_B2_out1 <= '0';

  delayMatch2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Multiply_And_Sum_out2_1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        Multiply_And_Sum_out2_1 <= Multiply_And_Sum_out2;
      END IF;
    END IF;
  END PROCESS delayMatch2_process;


  Multiply_And_Sum_out1_signed <= signed(Multiply_And_Sum_out1);

  
  Reset_Switch_out1 <= Output_memory_out1 WHEN Multiply_And_Sum_out2_1 = '0' ELSE
      Multiply_And_Sum_out1_signed;

  Output_memory_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Output_memory_out1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        Output_memory_out1 <= Reset_Switch_out1;
      END IF;
    END IF;
  END PROCESS Output_memory_process;


  Rate_Transition_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Rate_Transition_out1 <= to_signed(0, 32);
    ELSIF rising_edge(clk) THEN
      IF enb_1_2_0 = '1' THEN
        Rate_Transition_out1 <= Output_memory_out1;
      END IF;
    END IF;
  END PROCESS Rate_Transition_process;


  Data_out <= std_logic_vector(Rate_Transition_out1);


END rtl;
