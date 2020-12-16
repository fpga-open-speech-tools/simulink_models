-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\spike_generator_sim\redocking_site\redocking_site_redocking_site.vhd
-- 
-- Generated by MATLAB 9.9 and HDL Coder 3.17
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: redocking_site_redocking_site
-- Source Path: redocking_site
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY redocking_site_redocking_site IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_2048_1                      :   IN    std_logic;
        enb                               :   IN    std_logic;
        enb_1_2048_0                      :   IN    std_logic;
        synout                            :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        uriRandNum                        :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        redockRandNum                     :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        TrefRandNum                       :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        t_rel                             :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        tabs                              :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        nSites                            :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        tdres                             :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        t_rd_init                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        tau_rd                            :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        spout                             :   OUT   std_logic;
        sptime                            :   OUT   std_logic_vector(31 DOWNTO 0);  -- single
        recalculate_redocking             :   OUT   std_logic
        );
END redocking_site_redocking_site;


ARCHITECTURE rtl OF redocking_site_redocking_site IS

  ATTRIBUTE multstyle : string;

  -- Component Declarations
  COMPONENT redocking_site_Redock_Component
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2048_1                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          randNum                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          recalculate                     :   IN    std_logic;
          current_redocking_period        :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          oneSiteRedock                   :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT redocking_site_Elapsed_Time_Component
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2048_1                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          tdres                           :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          reset_1                         :   IN    std_logic;
          elapsed_time                    :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT redocking_site_nfp_relop_single_block
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out1                        :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT redocking_site_Xsum_Component
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2048_1                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          synout                          :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nSites                          :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          reset_1                         :   IN    std_logic;
          increment                       :   IN    std_logic;
          Xsum                            :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT redocking_site_unitRateInterval_Component
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2048_1                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          randNum                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          tdres                           :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          recalculate                     :   IN    std_logic;
          unitRateInterval                :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT redocking_site_nfp_relop_single_block1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out1                        :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT redocking_site_Current_Release_Component
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2048_1                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          recalculate                     :   IN    std_logic;
          elapsed_time                    :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          t_rd_init                       :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          current_release_times           :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT redocking_site_cal_trel_k
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          synout                          :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          trel                            :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          trel_k                          :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT redocking_site_SimpleDualPortRAM_generic
    GENERIC( AddrWidth                    : integer;
             DataWidth                    : integer
             );
    PORT( clk                             :   IN    std_logic;
          enb                             :   IN    std_logic;
          wr_din                          :   IN    std_logic_vector(DataWidth - 1 DOWNTO 0);  -- generic width
          wr_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          wr_en                           :   IN    std_logic;  -- ufix1
          rd_addr                         :   IN    std_logic_vector(AddrWidth - 1 DOWNTO 0);  -- generic width
          rd_dout                         :   OUT   std_logic_vector(DataWidth - 1 DOWNTO 0)  -- generic width
          );
  END COMPONENT;

  COMPONENT redocking_site_calc_Tref
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          trel_k                          :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          randData                        :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          tabs                            :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          Tref                            :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT redocking_site_Current_Refactory_Component
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_2048_1                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_2048_0                    :   IN    std_logic;
          current_release_times           :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          Tref                            :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          recalculate                     :   IN    std_logic;
          current_refactory_period        :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT redocking_site_nfp_recip_single
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          nfp_in                          :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  COMPONENT redocking_site_nfp_mul_single
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  COMPONENT redocking_site_nfp_round_single
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          nfp_in                          :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  COMPONENT redocking_site_nfp_convert_single_to_fix_32_En0
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          nfp_in                          :   IN    std_logic_vector(31 DOWNTO 0);  -- ufix32
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- ufix32
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : redocking_site_Redock_Component
    USE ENTITY work.redocking_site_Redock_Component(rtl);

  FOR ALL : redocking_site_Elapsed_Time_Component
    USE ENTITY work.redocking_site_Elapsed_Time_Component(rtl);

  FOR ALL : redocking_site_nfp_relop_single_block
    USE ENTITY work.redocking_site_nfp_relop_single_block(rtl);

  FOR ALL : redocking_site_Xsum_Component
    USE ENTITY work.redocking_site_Xsum_Component(rtl);

  FOR ALL : redocking_site_unitRateInterval_Component
    USE ENTITY work.redocking_site_unitRateInterval_Component(rtl);

  FOR ALL : redocking_site_nfp_relop_single_block1
    USE ENTITY work.redocking_site_nfp_relop_single_block1(rtl);

  FOR ALL : redocking_site_Current_Release_Component
    USE ENTITY work.redocking_site_Current_Release_Component(rtl);

  FOR ALL : redocking_site_cal_trel_k
    USE ENTITY work.redocking_site_cal_trel_k(rtl);

  FOR ALL : redocking_site_SimpleDualPortRAM_generic
    USE ENTITY work.redocking_site_SimpleDualPortRAM_generic(rtl);

  FOR ALL : redocking_site_calc_Tref
    USE ENTITY work.redocking_site_calc_Tref(rtl);

  FOR ALL : redocking_site_Current_Refactory_Component
    USE ENTITY work.redocking_site_Current_Refactory_Component(rtl);

  FOR ALL : redocking_site_nfp_recip_single
    USE ENTITY work.redocking_site_nfp_recip_single(rtl);

  FOR ALL : redocking_site_nfp_mul_single
    USE ENTITY work.redocking_site_nfp_mul_single(rtl);

  FOR ALL : redocking_site_nfp_round_single
    USE ENTITY work.redocking_site_nfp_round_single(rtl);

  FOR ALL : redocking_site_nfp_convert_single_to_fix_32_En0
    USE ENTITY work.redocking_site_nfp_convert_single_to_fix_32_En0(rtl);

  -- Signals
  SIGNAL Less_Than_out1                   : std_logic;
  SIGNAL Redock_Component_out1            : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Elapsed_Time_Component_out1      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL GreaterThan_out1                 : std_logic;
  SIGNAL Delay4_bypass_reg                : std_logic;  -- ufix1
  SIGNAL GreaterThan_out1_1               : std_logic;
  SIGNAL Xsum_Component_out1              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL unitRateInterval_Component_out1  : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Less_Than_out1_1                 : std_logic;
  SIGNAL Delay1_bypass_reg                : std_logic;  -- ufix1
  SIGNAL Current_Release_Component_out1   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL cal_trel_k_out1                  : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL TrefRandNum_1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL delayMatch_regin                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL delayMatch_waddr                 : unsigned(4 DOWNTO 0);  -- ufix5
  SIGNAL delayMatch_wrenb                 : std_logic;  -- ufix1
  SIGNAL delayMatch_raddr                 : unsigned(4 DOWNTO 0);  -- ufix5
  SIGNAL delayMatch_regout                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL TrefRandNum_2                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL tabs_1                           : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL delayMatch1_regin                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL delayMatch1_waddr                : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL delayMatch1_wrenb                : std_logic;  -- ufix1
  SIGNAL delayMatch1_raddr                : unsigned(5 DOWNTO 0);  -- ufix6
  SIGNAL delayMatch1_regout               : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL tabs_2                           : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL calc_Tref_out1                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL AND_out1                         : std_logic;
  SIGNAL Current_Refactory_Component_out1 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL GreaterThanOrEqual1_out1         : std_logic;
  SIGNAL Delay3_bypass_reg                : std_logic;  -- ufix1
  SIGNAL GreaterThanOrEqual1_out1_1       : std_logic;
  SIGNAL Constant_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch_out1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL tdres_1                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Divide_recip_out                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Divide_out1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Round_out1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Divide1_recip_out                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Divide1_out1                     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Round1_out1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Data_Type_Conversion_out1        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Data_Type_Conversion_out1_unsigned : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Data_Type_Conversion1_out1       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Data_Type_Conversion1_out1_unsigned : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL Equal_relop1                     : std_logic;
  SIGNAL t_bypass_reg                     : std_logic;  -- ufix1
  SIGNAL Equal_out1                       : std_logic;

BEGIN
  -- Change from GTEQ to LT for formatting
  -- 
  -- Line 606
  -- 
  -- Lines 570 - 572
  -- 
  -- Line 599

  u_Redock_Component : redocking_site_Redock_Component
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2048_1 => enb_1_2048_1,
              enb => enb,
              enb_1_2048_0 => enb_1_2048_0,
              randNum => redockRandNum,  -- single
              recalculate => Less_Than_out1,
              current_redocking_period => tau_rd,  -- single
              oneSiteRedock => Redock_Component_out1  -- single
              );

  u_Elapsed_Time_Component : redocking_site_Elapsed_Time_Component
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2048_1 => enb_1_2048_1,
              enb => enb,
              enb_1_2048_0 => enb_1_2048_0,
              tdres => tdres,  -- single
              reset_1 => Less_Than_out1,
              elapsed_time => Elapsed_Time_Component_out1  -- single
              );

  u_nfp_relop_comp : redocking_site_nfp_relop_single_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in1 => Elapsed_Time_Component_out1,  -- ufix32
              nfp_in2 => Redock_Component_out1,  -- ufix32
              nfp_out1 => GreaterThan_out1
              );

  u_Xsum_Component : redocking_site_Xsum_Component
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2048_1 => enb_1_2048_1,
              enb => enb,
              synout => synout,  -- single
              nSites => nSites,  -- single
              reset_1 => Less_Than_out1,
              increment => GreaterThan_out1_1,
              Xsum => Xsum_Component_out1  -- single
              );

  u_unitRateInterval_Component : redocking_site_unitRateInterval_Component
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2048_1 => enb_1_2048_1,
              enb => enb,
              enb_1_2048_0 => enb_1_2048_0,
              randNum => uriRandNum,  -- single
              tdres => tdres,  -- single
              recalculate => Less_Than_out1,
              unitRateInterval => unitRateInterval_Component_out1  -- single
              );

  u_nfp_relop_comp_1 : redocking_site_nfp_relop_single_block1
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in1 => unitRateInterval_Component_out1,  -- ufix32
              nfp_in2 => Xsum_Component_out1,  -- ufix32
              nfp_out1 => Less_Than_out1_1
              );

  u_Current_Release_Component : redocking_site_Current_Release_Component
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2048_1 => enb_1_2048_1,
              enb => enb,
              enb_1_2048_0 => enb_1_2048_0,
              recalculate => Less_Than_out1,
              elapsed_time => Elapsed_Time_Component_out1,  -- single
              t_rd_init => t_rd_init,  -- single
              current_release_times => Current_Release_Component_out1  -- single
              );

  u_cal_trel_k : redocking_site_cal_trel_k
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              synout => synout,  -- single
              trel => t_rel,  -- single
              trel_k => cal_trel_k_out1  -- single
              );

  u_ShiftRegisterRAM_generic : redocking_site_SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 5,
                 DataWidth => 32
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => delayMatch_regin,
              wr_addr => std_logic_vector(delayMatch_waddr),
              wr_en => delayMatch_wrenb,  -- ufix1
              rd_addr => std_logic_vector(delayMatch_raddr),
              rd_dout => delayMatch_regout
              );

  u_ShiftRegisterRAM : redocking_site_SimpleDualPortRAM_generic
    GENERIC MAP( AddrWidth => 6,
                 DataWidth => 32
                 )
    PORT MAP( clk => clk,
              enb => enb,
              wr_din => delayMatch1_regin,
              wr_addr => std_logic_vector(delayMatch1_waddr),
              wr_en => delayMatch1_wrenb,  -- ufix1
              rd_addr => std_logic_vector(delayMatch1_raddr),
              rd_dout => delayMatch1_regout
              );

  u_calc_Tref : redocking_site_calc_Tref
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              trel_k => cal_trel_k_out1,  -- single
              randData => TrefRandNum_2,  -- single
              tabs => tabs_2,  -- single
              Tref => calc_Tref_out1  -- single
              );

  u_Current_Refactory_Component : redocking_site_Current_Refactory_Component
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_2048_1 => enb_1_2048_1,
              enb => enb,
              enb_1_2048_0 => enb_1_2048_0,
              current_release_times => Current_Release_Component_out1,  -- single
              Tref => calc_Tref_out1,  -- single
              recalculate => AND_out1,
              current_refactory_period => Current_Refactory_Component_out1  -- single
              );

  u_nfp_relop_comp_2 : redocking_site_nfp_relop_single_block
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in1 => Current_Release_Component_out1,  -- ufix32
              nfp_in2 => Current_Refactory_Component_out1,  -- ufix32
              nfp_out1 => GreaterThanOrEqual1_out1
              );

  u_nfp_recip_comp : redocking_site_nfp_recip_single
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in => tdres_1,  -- ufix32
              nfp_out => Divide_recip_out  -- ufix32
              );

  u_nfp_mul_comp : redocking_site_nfp_mul_single
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in1 => Redock_Component_out1,  -- ufix32
              nfp_in2 => Divide_recip_out,  -- ufix32
              nfp_out => Divide_out1  -- ufix32
              );

  u_nfp_round_comp : redocking_site_nfp_round_single
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in => Divide_out1,  -- ufix32
              nfp_out => Round_out1  -- ufix32
              );

  u_nfp_recip_comp_1 : redocking_site_nfp_recip_single
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in => tdres_1,  -- ufix32
              nfp_out => Divide1_recip_out  -- ufix32
              );

  u_nfp_mul_comp_1 : redocking_site_nfp_mul_single
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in1 => Elapsed_Time_Component_out1,  -- ufix32
              nfp_in2 => Divide1_recip_out,  -- ufix32
              nfp_out => Divide1_out1  -- ufix32
              );

  u_nfp_round_comp_1 : redocking_site_nfp_round_single
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in => Divide1_out1,  -- ufix32
              nfp_out => Round1_out1  -- ufix32
              );

  u_redocking_site_nfp_convert_single_to_fix_32_En0 : redocking_site_nfp_convert_single_to_fix_32_En0
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in => Round_out1,  -- ufix32
              nfp_out => Data_Type_Conversion_out1  -- ufix32
              );

  u_redocking_site_nfp_convert_single_to_fix_32_En0_1 : redocking_site_nfp_convert_single_to_fix_32_En0
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              nfp_in => Round1_out1,  -- ufix32
              nfp_out => Data_Type_Conversion1_out1  -- ufix32
              );

  Delay4_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay4_bypass_reg <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_1 = '1' THEN
        Delay4_bypass_reg <= GreaterThan_out1;
      END IF;
    END IF;
  END PROCESS Delay4_bypass_process;

  
  GreaterThan_out1_1 <= GreaterThan_out1 WHEN enb_1_2048_1 = '1' ELSE
      Delay4_bypass_reg;

  Delay1_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay1_bypass_reg <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_1 = '1' THEN
        Delay1_bypass_reg <= Less_Than_out1_1;
      END IF;
    END IF;
  END PROCESS Delay1_bypass_process;

  
  Less_Than_out1 <= Less_Than_out1_1 WHEN enb_1_2048_1 = '1' ELSE
      Delay1_bypass_reg;

  TrefRandNum_1 <= TrefRandNum;

  -- Input register for RAM-based shift register delayMatch
  delayMatch_reginc_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_regin <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch_regin <= TrefRandNum_1;
      END IF;
    END IF;
  END PROCESS delayMatch_reginc_process;


  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 29
  -- 
  -- Write address counter for RAM-based shift register delayMatch
  delayMatch_wr_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_waddr <= to_unsigned(16#00#, 5);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        IF delayMatch_waddr >= to_unsigned(16#1D#, 5) THEN 
          delayMatch_waddr <= to_unsigned(16#00#, 5);
        ELSE 
          delayMatch_waddr <= delayMatch_waddr + to_unsigned(16#01#, 5);
        END IF;
      END IF;
    END IF;
  END PROCESS delayMatch_wr_process;


  delayMatch_wrenb <= '1';

  -- Count limited, Unsigned Counter
  --  initial value   = 1
  --  step value      = 1
  --  count to value  = 29
  -- 
  -- Read address counter for RAM-based shift register delayMatch
  delayMatch_rd_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch_raddr <= to_unsigned(16#01#, 5);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        IF delayMatch_raddr >= to_unsigned(16#1D#, 5) THEN 
          delayMatch_raddr <= to_unsigned(16#00#, 5);
        ELSE 
          delayMatch_raddr <= delayMatch_raddr + to_unsigned(16#01#, 5);
        END IF;
      END IF;
    END IF;
  END PROCESS delayMatch_rd_process;


  -- Output register for RAM-based shift register delayMatch
  delayMatch_regoutc_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      TrefRandNum_2 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        TrefRandNum_2 <= delayMatch_regout;
      END IF;
    END IF;
  END PROCESS delayMatch_regoutc_process;


  tabs_1 <= tabs;

  -- Input register for RAM-based shift register delayMatch1
  delayMatch1_reginc_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_regin <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        delayMatch1_regin <= tabs_1;
      END IF;
    END IF;
  END PROCESS delayMatch1_reginc_process;


  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 40
  -- 
  -- Write address counter for RAM-based shift register delayMatch1
  delayMatch1_wr_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_waddr <= to_unsigned(16#00#, 6);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        IF delayMatch1_waddr >= to_unsigned(16#28#, 6) THEN 
          delayMatch1_waddr <= to_unsigned(16#00#, 6);
        ELSE 
          delayMatch1_waddr <= delayMatch1_waddr + to_unsigned(16#01#, 6);
        END IF;
      END IF;
    END IF;
  END PROCESS delayMatch1_wr_process;


  delayMatch1_wrenb <= '1';

  -- Count limited, Unsigned Counter
  --  initial value   = 1
  --  step value      = 1
  --  count to value  = 40
  -- 
  -- Read address counter for RAM-based shift register delayMatch1
  delayMatch1_rd_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      delayMatch1_raddr <= to_unsigned(16#01#, 6);
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        IF delayMatch1_raddr >= to_unsigned(16#28#, 6) THEN 
          delayMatch1_raddr <= to_unsigned(16#00#, 6);
        ELSE 
          delayMatch1_raddr <= delayMatch1_raddr + to_unsigned(16#01#, 6);
        END IF;
      END IF;
    END IF;
  END PROCESS delayMatch1_rd_process;


  -- Output register for RAM-based shift register delayMatch1
  delayMatch1_regoutc_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      tabs_2 <= X"00000000";
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        tabs_2 <= delayMatch1_regout;
      END IF;
    END IF;
  END PROCESS delayMatch1_regoutc_process;


  Delay3_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Delay3_bypass_reg <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_1 = '1' THEN
        Delay3_bypass_reg <= GreaterThanOrEqual1_out1;
      END IF;
    END IF;
  END PROCESS Delay3_bypass_process;

  
  GreaterThanOrEqual1_out1_1 <= GreaterThanOrEqual1_out1 WHEN enb_1_2048_1 = '1' ELSE
      Delay3_bypass_reg;

  AND_out1 <= GreaterThanOrEqual1_out1_1 AND Less_Than_out1;

  spout <= AND_out1;

  Constant_out1 <= X"00000000";

  
  Switch_out1 <= Constant_out1 WHEN AND_out1 = '0' ELSE
      Current_Release_Component_out1;

  tdres_1 <= tdres;

  Data_Type_Conversion_out1_unsigned <= unsigned(Data_Type_Conversion_out1);

  Data_Type_Conversion1_out1_unsigned <= unsigned(Data_Type_Conversion1_out1);

  
  Equal_relop1 <= '1' WHEN Data_Type_Conversion_out1_unsigned = Data_Type_Conversion1_out1_unsigned ELSE
      '0';

  t_bypass_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      t_bypass_reg <= '0';
    ELSIF rising_edge(clk) THEN
      IF enb_1_2048_1 = '1' THEN
        t_bypass_reg <= Equal_relop1;
      END IF;
    END IF;
  END PROCESS t_bypass_process;

  
  Equal_out1 <= Equal_relop1 WHEN enb_1_2048_1 = '1' ELSE
      t_bypass_reg;

  recalculate_redocking <= Equal_out1;

  sptime <= Switch_out1;

END rtl;

