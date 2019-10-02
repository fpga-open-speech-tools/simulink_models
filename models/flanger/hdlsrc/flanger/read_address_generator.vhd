-- -------------------------------------------------------------
-- 
-- File Name: /mnt/data/NIH/simulink_models/models/flanger/hdlsrc/flanger/read_address_generator.vhd
-- Created: 2019-10-02 17:07:54
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: read_address_generator
-- Source Path: flanger/flanger_dataplane/Avalon Data Processing/Left Channel Processing/variable delay/read address 
-- generato
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY read_address_generator IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        delay                             :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix9
        write_addr                        :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix9
        Enable_out5                       :   IN    std_logic;
        read_addr                         :   OUT   std_logic_vector(8 DOWNTO 0)  -- ufix9
        );
END read_address_generator;


ARCHITECTURE rtl OF read_address_generator IS

  ATTRIBUTE multstyle : string;

  -- Signals
  SIGNAL delay_unsigned                   : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL enb_gated                        : std_logic;
  SIGNAL Memory_out1                      : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL write_addr_unsigned              : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Subtract_stage2_sub_cast         : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL Subtract_stage2_sub_cast_1       : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL Subtract_op_stage2               : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL Relational_Operator_relop1       : std_logic;
  SIGNAL delay_changed                    : std_logic;
  SIGNAL Constant_out1                    : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL Subtract_stage3_add_cast         : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL Subtract_stage3_add_temp         : signed(10 DOWNTO 0);  -- sfix11
  SIGNAL Subtract_out1                    : unsigned(8 DOWNTO 0);  -- ufix9
  SIGNAL enb_gated_1                      : std_logic;
  SIGNAL read_address_counter_out1        : unsigned(8 DOWNTO 0);  -- ufix9

BEGIN
  -- read address should trail the write address by "delay" number of samples.
  -- 
  -- wrap on overflow is the desired behavior
  -- 
  -- When the delay value changes, we reload the counter with the new read address value
  -- 
  -- check if delay changed

  delay_unsigned <= unsigned(delay);

  enb_gated <= Enable_out5 AND enb;

  Memory_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      Memory_out1 <= to_unsigned(16#000#, 9);
    ELSIF rising_edge(clk) THEN
      IF enb_gated = '1' THEN
        Memory_out1 <= delay_unsigned;
      END IF;
    END IF;
  END PROCESS Memory_process;


  write_addr_unsigned <= unsigned(write_addr);

  Subtract_stage2_sub_cast <= signed(resize(write_addr_unsigned, 11));
  Subtract_stage2_sub_cast_1 <= signed(resize(delay_unsigned, 11));
  Subtract_op_stage2 <= Subtract_stage2_sub_cast - Subtract_stage2_sub_cast_1;

  
  Relational_Operator_relop1 <= '1' WHEN Memory_out1 /= delay_unsigned ELSE
      '0';

  delay_changed <= Relational_Operator_relop1;

  Constant_out1 <= to_unsigned(16#002#, 9);

  Subtract_stage3_add_cast <= signed(resize(Constant_out1, 11));
  Subtract_stage3_add_temp <= Subtract_op_stage2 + Subtract_stage3_add_cast;
  Subtract_out1 <= unsigned(Subtract_stage3_add_temp(8 DOWNTO 0));

  enb_gated_1 <= Enable_out5 AND enb;

  -- Count limited, Unsigned Counter
  --  initial value   = 0
  --  step value      = 1
  --  count to value  = 511
  -- 
  read_address_counter_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      read_address_counter_out1 <= to_unsigned(16#000#, 9);
    ELSIF rising_edge(clk) THEN
      IF enb_gated_1 = '1' THEN
        IF delay_changed = '1' THEN 
          read_address_counter_out1 <= Subtract_out1;
        ELSE 
          read_address_counter_out1 <= read_address_counter_out1 + to_unsigned(16#001#, 9);
        END IF;
      END IF;
    END IF;
  END PROCESS read_address_counter_process;


  read_addr <= std_logic_vector(read_address_counter_out1);

END rtl;

