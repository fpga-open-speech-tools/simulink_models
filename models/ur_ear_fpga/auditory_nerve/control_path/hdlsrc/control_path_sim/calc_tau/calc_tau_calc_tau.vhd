-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\control_path_sim\calc_tau\calc_tau_calc_tau.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: calc_tau_calc_tau
-- Source Path: calc_tau
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.dataplane_pkg.ALL;

ENTITY calc_tau_calc_tau IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_1024_0                      :   IN    std_logic;
        Calc_Tau_In                       :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        rsigma                            :   OUT   std_logic_vector(31 DOWNTO 0);  -- single
        wbgain                            :   OUT   std_logic_vector(31 DOWNTO 0);  -- single
        tauwb                             :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
        );
END calc_tau_calc_tau;


ARCHITECTURE rtl OF calc_tau_calc_tau IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT calc_tau_Calculate_tauc1
    PORT( Calc_Tau_In                     :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          Source_Data                     :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT calc_tau_nfp_recip_single
    PORT( nfp_in                          :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  COMPONENT calc_tau_nfp_sub_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  COMPONENT calc_tau_Calculate_tauwb
    PORT( In1                             :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          tauwb                           :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT calc_tau_gain_groupdelay
    PORT( tdres                           :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          centerfreq                      :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          cf                              :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          tau                             :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          wb_gain                         :   OUT   std_logic_vector(31 DOWNTO 0);  -- single
          grdelay                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT calc_tau_write_address_generator
    PORT( read_addr                       :   IN    std_logic_vector(5 DOWNTO 0);  -- ufix6
          delay                           :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          write_addr                      :   OUT   std_logic_vector(5 DOWNTO 0)  -- ufix6
          );
  END COMPONENT;

  COMPONENT calc_tau_SimpleDualPortRAM_generic
    GENERIC( AddrWidth                    : integer;
             DataWidth                    : integer
             );
    PORT( clk                             :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          wr_din                          :   IN    std_logic_vector(DataWidth - 1 DOWNTO 0);  -- generic width
          wr_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          wr_en                           :   IN    std_logic;
          rd_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          rd_dout                         :   OUT   std_logic_vector(DataWidth - 1 DOWNTO 0)  -- generic width
          );
  END COMPONENT;

  COMPONENT calc_tau_nfp_relop_single
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out1                        :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : calc_tau_Calculate_tauc1
    USE ENTITY work.calc_tau_Calculate_tauc1(rtl);

  FOR ALL : calc_tau_nfp_recip_single
    USE ENTITY work.calc_tau_nfp_recip_single(rtl);

  FOR ALL : calc_tau_nfp_sub_single
    USE ENTITY work.calc_tau_nfp_sub_single(rtl);

  FOR ALL : calc_tau_Calculate_tauwb
    USE ENTITY work.calc_tau_Calculate_tauwb(rtl);

  FOR ALL : calc_tau_gain_groupdelay
    USE ENTITY work.calc_tau_gain_groupdelay(rtl);

  FOR ALL : calc_tau_write_address_generator
    USE ENTITY work.calc_tau_write_address_generator(rtl);

  FOR ALL : calc_tau_SimpleDualPortRAM_generic
    USE ENTITY work.calc_tau_SimpleDualPortRAM_generic(rtl);

  FOR ALL : calc_tau_nfp_relop_single
    USE ENTITY work.calc_tau_nfp_relop_single(rtl);

  -- Signals
  SIGNAL tauc1                            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Reciprocal_out1                  : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant6_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Subtract_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant1_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Constant2_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL tauwb_1                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL wbgain_1                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL gain_groupdelay_out2             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL read_address_generator_out1      : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL write_address_generator_out1     : std_logic_vector(5 DOWNTO 0);  -- ufix6
  SIGNAL Constant7_out1                   : std_logic;
  SIGNAL integer_delay_DPRAM_out1         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Delay1_reg                       : vector_of_std_logic_vector32(0 TO 63);  -- ufix32 [64]
  SIGNAL Delay1_reg_next                  : vector_of_std_logic_vector32(0 TO 63);  -- ufix32 [64]
  SIGNAL Delay1_out1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Subtract1_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL const                            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Compare_To_Zero_out1             : std_logic;
  SIGNAL const_1                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Compare_To_Constant_out1         : std_logic;
  SIGNAL OR_out1                          : std_logic;
  SIGNAL Delay_ctrl_const_out             : std_logic;
  SIGNAL Delay_ctrl_const_out_1           : std_logic;
  SIGNAL Delay_Initial_Val_out            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch2_out1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch2_out1_1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Delay_out1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  -- Calculate rsigma
  -- 
  -- If the DPRAM returns a 0 or is the same value from the last time that address was read, hold the last value for 
  -- wbgai
  -- 
  -- Integer delay

  u_Calculate_tauc1 : calc_tau_Calculate_tauc1
    PORT MAP( Calc_Tau_In => Calc_Tau_In,  -- single
              Source_Data => tauc1  -- single
              );

  u_nfp_recip_comp : calc_tau_nfp_recip_single
    PORT MAP( nfp_in => tauc1,  -- ufix32
              nfp_out => Reciprocal_out1  -- ufix32
              );

  u_nfp_sub_comp : calc_tau_nfp_sub_single
    PORT MAP( nfp_in1 => Reciprocal_out1,  -- ufix32
              nfp_in2 => Constant6_out1,  -- ufix32
              nfp_out => Subtract_out1  -- ufix32
              );

  u_Calculate_tauwb : calc_tau_Calculate_tauwb
    PORT MAP( In1 => tauc1,  -- single
              tauwb => tauwb_1  -- single
              );

  u_gain_groupdelay : calc_tau_gain_groupdelay
    PORT MAP( tdres => Constant_out1,  -- single
              centerfreq => Constant1_out1,  -- single
              cf => Constant2_out1,  -- single
              tau => tauwb_1,  -- single
              wb_gain => wbgain_1,  -- single
              grdelay => gain_groupdelay_out2  -- single
              );

  u_write_address_generator : calc_tau_write_address_generator
    PORT MAP( read_addr => std_logic_vector(read_address_generator_out1),  -- ufix6
              delay => gain_groupdelay_out2,  -- single
              write_addr => write_address_generator_out1  -- ufix6
              );

  u_integer_delay_DPRAM : calc_tau_SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 6,
                 DataWidth => 32
                 )
    PORT MAP( clk => clk,
              enb_1_1024_0 => enb_1_1024_0,
              wr_din => wbgain_1,
              wr_addr => write_address_generator_out1,
              wr_en => Constant7_out1,
              rd_addr => std_logic_vector(read_address_generator_out1),
              rd_dout => integer_delay_DPRAM_out1
              );

  u_nfp_sub_comp_1 : calc_tau_nfp_sub_single
    PORT MAP( nfp_in1 => Delay1_out1,  -- ufix32
              nfp_in2 => integer_delay_DPRAM_out1,  -- ufix32
              nfp_out => Subtract1_out1  -- ufix32
              );

  u_nfp_relop_comp : calc_tau_nfp_relop_single
    PORT MAP( nfp_in1 => Subtract1_out1,  -- ufix32
              nfp_in2 => const,  -- ufix32
              nfp_out1 => Compare_To_Zero_out1
              );

  u_nfp_relop_comp_1 : calc_tau_nfp_relop_single
    PORT MAP( nfp_in1 => integer_delay_DPRAM_out1,  -- ufix32
              nfp_in2 => const_1,  -- ufix32
              nfp_out1 => Compare_To_Constant_out1
              );

  Constant6_out1 <= X"43a60bcf";

  Constant_out1 <= X"37aec33e";

  Constant1_out1 <= X"449744a9";

  Constant2_out1 <= X"447a0000";

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 63
  read_address_generator_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      read_address_generator_out1 <= to_unsigned(16#00#, 6);
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        read_address_generator_out1 <= read_address_generator_out1 + to_unsigned(16#01#, 6);
      END IF;
    END IF;
  END PROCESS read_address_generator_process;


  Constant7_out1 <= '1';

  Delay1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay1_reg(0) <= X"00000000";
      Delay1_reg(1) <= X"00000000";
      Delay1_reg(2) <= X"00000000";
      Delay1_reg(3) <= X"00000000";
      Delay1_reg(4) <= X"00000000";
      Delay1_reg(5) <= X"00000000";
      Delay1_reg(6) <= X"00000000";
      Delay1_reg(7) <= X"00000000";
      Delay1_reg(8) <= X"00000000";
      Delay1_reg(9) <= X"00000000";
      Delay1_reg(10) <= X"00000000";
      Delay1_reg(11) <= X"00000000";
      Delay1_reg(12) <= X"00000000";
      Delay1_reg(13) <= X"00000000";
      Delay1_reg(14) <= X"00000000";
      Delay1_reg(15) <= X"00000000";
      Delay1_reg(16) <= X"00000000";
      Delay1_reg(17) <= X"00000000";
      Delay1_reg(18) <= X"00000000";
      Delay1_reg(19) <= X"00000000";
      Delay1_reg(20) <= X"00000000";
      Delay1_reg(21) <= X"00000000";
      Delay1_reg(22) <= X"00000000";
      Delay1_reg(23) <= X"00000000";
      Delay1_reg(24) <= X"00000000";
      Delay1_reg(25) <= X"00000000";
      Delay1_reg(26) <= X"00000000";
      Delay1_reg(27) <= X"00000000";
      Delay1_reg(28) <= X"00000000";
      Delay1_reg(29) <= X"00000000";
      Delay1_reg(30) <= X"00000000";
      Delay1_reg(31) <= X"00000000";
      Delay1_reg(32) <= X"00000000";
      Delay1_reg(33) <= X"00000000";
      Delay1_reg(34) <= X"00000000";
      Delay1_reg(35) <= X"00000000";
      Delay1_reg(36) <= X"00000000";
      Delay1_reg(37) <= X"00000000";
      Delay1_reg(38) <= X"00000000";
      Delay1_reg(39) <= X"00000000";
      Delay1_reg(40) <= X"00000000";
      Delay1_reg(41) <= X"00000000";
      Delay1_reg(42) <= X"00000000";
      Delay1_reg(43) <= X"00000000";
      Delay1_reg(44) <= X"00000000";
      Delay1_reg(45) <= X"00000000";
      Delay1_reg(46) <= X"00000000";
      Delay1_reg(47) <= X"00000000";
      Delay1_reg(48) <= X"00000000";
      Delay1_reg(49) <= X"00000000";
      Delay1_reg(50) <= X"00000000";
      Delay1_reg(51) <= X"00000000";
      Delay1_reg(52) <= X"00000000";
      Delay1_reg(53) <= X"00000000";
      Delay1_reg(54) <= X"00000000";
      Delay1_reg(55) <= X"00000000";
      Delay1_reg(56) <= X"00000000";
      Delay1_reg(57) <= X"00000000";
      Delay1_reg(58) <= X"00000000";
      Delay1_reg(59) <= X"00000000";
      Delay1_reg(60) <= X"00000000";
      Delay1_reg(61) <= X"00000000";
      Delay1_reg(62) <= X"00000000";
      Delay1_reg(63) <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Delay1_reg(0) <= Delay1_reg_next(0);
        Delay1_reg(1) <= Delay1_reg_next(1);
        Delay1_reg(2) <= Delay1_reg_next(2);
        Delay1_reg(3) <= Delay1_reg_next(3);
        Delay1_reg(4) <= Delay1_reg_next(4);
        Delay1_reg(5) <= Delay1_reg_next(5);
        Delay1_reg(6) <= Delay1_reg_next(6);
        Delay1_reg(7) <= Delay1_reg_next(7);
        Delay1_reg(8) <= Delay1_reg_next(8);
        Delay1_reg(9) <= Delay1_reg_next(9);
        Delay1_reg(10) <= Delay1_reg_next(10);
        Delay1_reg(11) <= Delay1_reg_next(11);
        Delay1_reg(12) <= Delay1_reg_next(12);
        Delay1_reg(13) <= Delay1_reg_next(13);
        Delay1_reg(14) <= Delay1_reg_next(14);
        Delay1_reg(15) <= Delay1_reg_next(15);
        Delay1_reg(16) <= Delay1_reg_next(16);
        Delay1_reg(17) <= Delay1_reg_next(17);
        Delay1_reg(18) <= Delay1_reg_next(18);
        Delay1_reg(19) <= Delay1_reg_next(19);
        Delay1_reg(20) <= Delay1_reg_next(20);
        Delay1_reg(21) <= Delay1_reg_next(21);
        Delay1_reg(22) <= Delay1_reg_next(22);
        Delay1_reg(23) <= Delay1_reg_next(23);
        Delay1_reg(24) <= Delay1_reg_next(24);
        Delay1_reg(25) <= Delay1_reg_next(25);
        Delay1_reg(26) <= Delay1_reg_next(26);
        Delay1_reg(27) <= Delay1_reg_next(27);
        Delay1_reg(28) <= Delay1_reg_next(28);
        Delay1_reg(29) <= Delay1_reg_next(29);
        Delay1_reg(30) <= Delay1_reg_next(30);
        Delay1_reg(31) <= Delay1_reg_next(31);
        Delay1_reg(32) <= Delay1_reg_next(32);
        Delay1_reg(33) <= Delay1_reg_next(33);
        Delay1_reg(34) <= Delay1_reg_next(34);
        Delay1_reg(35) <= Delay1_reg_next(35);
        Delay1_reg(36) <= Delay1_reg_next(36);
        Delay1_reg(37) <= Delay1_reg_next(37);
        Delay1_reg(38) <= Delay1_reg_next(38);
        Delay1_reg(39) <= Delay1_reg_next(39);
        Delay1_reg(40) <= Delay1_reg_next(40);
        Delay1_reg(41) <= Delay1_reg_next(41);
        Delay1_reg(42) <= Delay1_reg_next(42);
        Delay1_reg(43) <= Delay1_reg_next(43);
        Delay1_reg(44) <= Delay1_reg_next(44);
        Delay1_reg(45) <= Delay1_reg_next(45);
        Delay1_reg(46) <= Delay1_reg_next(46);
        Delay1_reg(47) <= Delay1_reg_next(47);
        Delay1_reg(48) <= Delay1_reg_next(48);
        Delay1_reg(49) <= Delay1_reg_next(49);
        Delay1_reg(50) <= Delay1_reg_next(50);
        Delay1_reg(51) <= Delay1_reg_next(51);
        Delay1_reg(52) <= Delay1_reg_next(52);
        Delay1_reg(53) <= Delay1_reg_next(53);
        Delay1_reg(54) <= Delay1_reg_next(54);
        Delay1_reg(55) <= Delay1_reg_next(55);
        Delay1_reg(56) <= Delay1_reg_next(56);
        Delay1_reg(57) <= Delay1_reg_next(57);
        Delay1_reg(58) <= Delay1_reg_next(58);
        Delay1_reg(59) <= Delay1_reg_next(59);
        Delay1_reg(60) <= Delay1_reg_next(60);
        Delay1_reg(61) <= Delay1_reg_next(61);
        Delay1_reg(62) <= Delay1_reg_next(62);
        Delay1_reg(63) <= Delay1_reg_next(63);
      END IF;
    END IF;
  END PROCESS Delay1_process;

  Delay1_out1 <= Delay1_reg(63);
  Delay1_reg_next(0) <= integer_delay_DPRAM_out1;
  Delay1_reg_next(1) <= Delay1_reg(0);
  Delay1_reg_next(2) <= Delay1_reg(1);
  Delay1_reg_next(3) <= Delay1_reg(2);
  Delay1_reg_next(4) <= Delay1_reg(3);
  Delay1_reg_next(5) <= Delay1_reg(4);
  Delay1_reg_next(6) <= Delay1_reg(5);
  Delay1_reg_next(7) <= Delay1_reg(6);
  Delay1_reg_next(8) <= Delay1_reg(7);
  Delay1_reg_next(9) <= Delay1_reg(8);
  Delay1_reg_next(10) <= Delay1_reg(9);
  Delay1_reg_next(11) <= Delay1_reg(10);
  Delay1_reg_next(12) <= Delay1_reg(11);
  Delay1_reg_next(13) <= Delay1_reg(12);
  Delay1_reg_next(14) <= Delay1_reg(13);
  Delay1_reg_next(15) <= Delay1_reg(14);
  Delay1_reg_next(16) <= Delay1_reg(15);
  Delay1_reg_next(17) <= Delay1_reg(16);
  Delay1_reg_next(18) <= Delay1_reg(17);
  Delay1_reg_next(19) <= Delay1_reg(18);
  Delay1_reg_next(20) <= Delay1_reg(19);
  Delay1_reg_next(21) <= Delay1_reg(20);
  Delay1_reg_next(22) <= Delay1_reg(21);
  Delay1_reg_next(23) <= Delay1_reg(22);
  Delay1_reg_next(24) <= Delay1_reg(23);
  Delay1_reg_next(25) <= Delay1_reg(24);
  Delay1_reg_next(26) <= Delay1_reg(25);
  Delay1_reg_next(27) <= Delay1_reg(26);
  Delay1_reg_next(28) <= Delay1_reg(27);
  Delay1_reg_next(29) <= Delay1_reg(28);
  Delay1_reg_next(30) <= Delay1_reg(29);
  Delay1_reg_next(31) <= Delay1_reg(30);
  Delay1_reg_next(32) <= Delay1_reg(31);
  Delay1_reg_next(33) <= Delay1_reg(32);
  Delay1_reg_next(34) <= Delay1_reg(33);
  Delay1_reg_next(35) <= Delay1_reg(34);
  Delay1_reg_next(36) <= Delay1_reg(35);
  Delay1_reg_next(37) <= Delay1_reg(36);
  Delay1_reg_next(38) <= Delay1_reg(37);
  Delay1_reg_next(39) <= Delay1_reg(38);
  Delay1_reg_next(40) <= Delay1_reg(39);
  Delay1_reg_next(41) <= Delay1_reg(40);
  Delay1_reg_next(42) <= Delay1_reg(41);
  Delay1_reg_next(43) <= Delay1_reg(42);
  Delay1_reg_next(44) <= Delay1_reg(43);
  Delay1_reg_next(45) <= Delay1_reg(44);
  Delay1_reg_next(46) <= Delay1_reg(45);
  Delay1_reg_next(47) <= Delay1_reg(46);
  Delay1_reg_next(48) <= Delay1_reg(47);
  Delay1_reg_next(49) <= Delay1_reg(48);
  Delay1_reg_next(50) <= Delay1_reg(49);
  Delay1_reg_next(51) <= Delay1_reg(50);
  Delay1_reg_next(52) <= Delay1_reg(51);
  Delay1_reg_next(53) <= Delay1_reg(52);
  Delay1_reg_next(54) <= Delay1_reg(53);
  Delay1_reg_next(55) <= Delay1_reg(54);
  Delay1_reg_next(56) <= Delay1_reg(55);
  Delay1_reg_next(57) <= Delay1_reg(56);
  Delay1_reg_next(58) <= Delay1_reg(57);
  Delay1_reg_next(59) <= Delay1_reg(58);
  Delay1_reg_next(60) <= Delay1_reg(59);
  Delay1_reg_next(61) <= Delay1_reg(60);
  Delay1_reg_next(62) <= Delay1_reg(61);
  Delay1_reg_next(63) <= Delay1_reg(62);

  const <= X"00000000";

  const_1 <= X"00000000";

  OR_out1 <= Compare_To_Zero_out1 OR Compare_To_Constant_out1;

  Delay_ctrl_const_out <= '1';

  delayMatch_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay_ctrl_const_out_1 <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Delay_ctrl_const_out_1 <= Delay_ctrl_const_out;
      END IF;
    END IF;
  END PROCESS delayMatch_process;


  Delay_Initial_Val_out <= X"3fb74075";

  delayMatch1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Switch2_out1_1 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb_1_1024_0 = '1' THEN
        Switch2_out1_1 <= Switch2_out1;
      END IF;
    END IF;
  END PROCESS delayMatch1_process;


  
  Delay_out1 <= Delay_Initial_Val_out WHEN Delay_ctrl_const_out_1 = '0' ELSE
      Switch2_out1_1;

  
  Switch2_out1 <= integer_delay_DPRAM_out1 WHEN OR_out1 = '0' ELSE
      Delay_out1;

  rsigma <= Subtract_out1;

  wbgain <= Switch2_out1;

  tauwb <= tauwb_1;

END rtl;
