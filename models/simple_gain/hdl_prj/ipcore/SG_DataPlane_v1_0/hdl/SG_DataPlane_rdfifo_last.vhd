-- -------------------------------------------------------------
-- 
-- File Name: hdl_prj\hdlsrc\SG\SG_DataPlane_rdfifo_last.vhd
-- Created: 2019-08-01 13:14:28
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: SG_DataPlane_rdfifo_last
-- Source Path: SG_DataPlane/SG_DataPlane_axi4/SG_DataPlane_axi4_module/SG_DataPlane_rdfifo_last
-- Hierarchy Level: 3
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SG_DataPlane_rdfifo_last IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        In_rsvd                           :   IN    std_logic;  -- ufix1
        Push                              :   IN    std_logic;  -- ufix1
        Pop                               :   IN    std_logic;  -- ufix1
        Out_rsvd                          :   OUT   std_logic  -- ufix1
        );
END SG_DataPlane_rdfifo_last;


ARCHITECTURE rtl OF SG_DataPlane_rdfifo_last IS

  -- Component Declarations
  COMPONENT SG_DataPlane_rdfifo_last_classic
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          In_rsvd                         :   IN    std_logic;  -- ufix1
          Push                            :   IN    std_logic;  -- ufix1
          Pop                             :   IN    std_logic;  -- ufix1
          Out_rsvd                        :   OUT   std_logic;  -- ufix1
          Empty                           :   OUT   std_logic;  -- ufix1
          Full                            :   OUT   std_logic;  -- ufix1
          Num                             :   OUT   std_logic_vector(4 DOWNTO 0)  -- ufix5
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : SG_DataPlane_rdfifo_last_classic
    USE ENTITY work.SG_DataPlane_rdfifo_last_classic(rtl);

  -- Signals
  SIGNAL R_x                              : std_logic;  -- ufix1
  SIGNAL cache_wr_en                      : std_logic;  -- ufix1
  SIGNAL out_wr_en                        : std_logic;  -- ufix1
  SIGNAL fwft_wr_en                       : std_logic;  -- ufix1
  SIGNAL R_x_1                            : std_logic;  -- ufix1
  SIGNAL fifo_valid                       : std_logic;  -- ufix1
  SIGNAL Q_keep                           : std_logic;  -- ufix1
  SIGNAL out_valid                        : std_logic;  -- ufix1
  SIGNAL fifo_and_out_valid               : std_logic;  -- ufix1
  SIGNAL R_x_2                            : std_logic;  -- ufix1
  SIGNAL cache_valid                      : std_logic;  -- ufix1
  SIGNAL Q_keep_1                         : std_logic;  -- ufix1
  SIGNAL relop_relop1                     : std_logic;
  SIGNAL Q_next                           : std_logic;  -- ufix1
  SIGNAL all_valid                        : std_logic;  -- ufix1
  SIGNAL fifo_full                        : std_logic;  -- ufix1
  SIGNAL fifo_nfull                       : std_logic;  -- ufix1
  SIGNAL fifo_push                        : std_logic;  -- ufix1
  SIGNAL fifo_pop                         : std_logic;  -- ufix1
  SIGNAL fifo_data_out                    : std_logic;  -- ufix1
  SIGNAL fifo_empty                       : std_logic;  -- ufix1
  SIGNAL fifo_num                         : std_logic_vector(4 DOWNTO 0);  -- ufix5
  SIGNAL Q_next_1                         : std_logic;  -- ufix1
  SIGNAL int_valid                        : std_logic;  -- ufix1
  SIGNAL Q_keep_2                         : std_logic;  -- ufix1
  SIGNAL Q_next_2                         : std_logic;  -- ufix1
  SIGNAL fwft_empty                       : std_logic;  -- ufix1
  SIGNAL data_flow                        : std_logic;  -- ufix1
  SIGNAL cache_data                       : std_logic;  -- ufix1
  SIGNAL data_out_next                    : std_logic;  -- ufix1

BEGIN
  u_SG_DataPlane_rdfifo_last_classic_inst : SG_DataPlane_rdfifo_last_classic
    PORT MAP( clk => clk,
              reset => reset,
              enb => enb,
              In_rsvd => In_rsvd,  -- ufix1
              Push => fifo_push,  -- ufix1
              Pop => fifo_pop,  -- ufix1
              Out_rsvd => fifo_data_out,  -- ufix1
              Empty => fifo_empty,  -- ufix1
              Full => fifo_full,  -- ufix1
              Num => fifo_num  -- ufix5
              );

  R_x <=  NOT Pop;

  fwft_wr_en <= cache_wr_en OR out_wr_en;

  R_x_1 <=  NOT fwft_wr_en;

  Q_keep <= R_x_1 AND fifo_valid;

  fifo_and_out_valid <= fifo_valid AND out_valid;

  R_x_2 <=  NOT out_wr_en;

  Q_keep_1 <= R_x_2 AND cache_valid;

  
  relop_relop1 <= '1' WHEN cache_valid = out_wr_en ELSE
      '0';

  cache_wr_en <= relop_relop1 AND fifo_valid;

  Q_next <= cache_wr_en OR Q_keep_1;

  Q_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      cache_valid <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        cache_valid <= Q_next;
      END IF;
    END IF;
  END PROCESS Q_reg_process;


  all_valid <= cache_valid AND fifo_and_out_valid;

  fifo_nfull <=  NOT fifo_full;

  fifo_push <= Push AND fifo_nfull;

  fifo_pop <=  NOT (fifo_empty OR all_valid);

  Q_next_1 <= fifo_pop OR Q_keep;

  Q_reg_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      fifo_valid <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        fifo_valid <= Q_next_1;
      END IF;
    END IF;
  END PROCESS Q_reg_1_process;


  int_valid <= fifo_valid OR cache_valid;

  Q_keep_2 <= R_x AND out_valid;

  Q_next_2 <= out_wr_en OR Q_keep_2;

  Q_reg_2_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      out_valid <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        out_valid <= Q_next_2;
      END IF;
    END IF;
  END PROCESS Q_reg_2_process;


  fwft_empty <=  NOT out_valid;

  data_flow <= Pop OR fwft_empty;

  out_wr_en <= data_flow AND int_valid;

  cache_data_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      cache_data <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND cache_wr_en = '1' THEN
        cache_data <= fifo_data_out;
      END IF;
    END IF;
  END PROCESS cache_data_reg_process;


  
  data_out_next <= fifo_data_out WHEN cache_valid = '0' ELSE
      cache_data;

  out_data_reg_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Out_rsvd <= '0';
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' AND out_wr_en = '1' THEN
        Out_rsvd <= data_out_next;
      END IF;
    END IF;
  END PROCESS out_data_reg_process;


END rtl;

