-- -------------------------------------------------------------
-- 
-- File Name: /home/trevor/research/NIH_SBIR_R44_DC015443/simulink_models/models/noise_suppression/hdlsrc/noise_suppression/noise_suppression_deserializer.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: noise_suppression_deserializer
-- Source Path: noise_suppression/dataplane/Adaptive_Wiener_Filter Sample Based Filtering/deserializer
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.noise_suppression_dataplane_pkg.ALL;

ENTITY noise_suppression_deserializer IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        data_in                           :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        valid_in                          :   IN    std_logic;
        channel_in                        :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        data_out                          :   OUT   vector_of_std_logic_vector32(0 TO 1);  -- sfix32_En28 [2]
        valid_out                         :   OUT   std_logic;
        channel_out                       :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
        );
END noise_suppression_deserializer;


ARCHITECTURE rtl OF noise_suppression_deserializer IS

  ATTRIBUTE multstyle : string;

  -- Signals
  SIGNAL data_in_signed                   : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL channel_in_unsigned              : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL data_out_tmp                     : vector_of_signed32(0 TO 1);  -- sfix32_En28 [2]
  SIGNAL channel_out_tmp                  : unsigned(1 DOWNTO 0);  -- ufix2
  SIGNAL data_out_temp                    : vector_of_signed32(0 TO 1);  -- sfix32 [2]
  SIGNAL data_out_reg                     : vector_of_signed32(0 TO 1);  -- sfix32 [2]
  SIGNAL data_out_temp_next               : vector_of_signed32(0 TO 1);  -- sfix32_En28 [2]
  SIGNAL data_out_reg_next                : vector_of_signed32(0 TO 1);  -- sfix32_En28 [2]

BEGIN
  data_in_signed <= signed(data_in);

  channel_in_unsigned <= unsigned(channel_in);

  deserializer_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      data_out_temp <= (OTHERS => to_signed(0, 32));
      data_out_reg <= (OTHERS => to_signed(0, 32));
    ELSIF rising_edge(clk) THEN
      IF enb = '1' THEN
        data_out_temp <= data_out_temp_next;
        data_out_reg <= data_out_reg_next;
      END IF;
    END IF;
  END PROCESS deserializer_process;

  deserializer_output : PROCESS (channel_in_unsigned, data_in_signed, data_out_reg, data_out_temp, valid_in)
    VARIABLE data_out_temp_temp : vector_of_signed32(0 TO 1);
    VARIABLE add_temp : unsigned(2 DOWNTO 0);
    VARIABLE sub_cast : signed(31 DOWNTO 0);
  BEGIN
    data_out_temp_temp := data_out_temp;
    data_out_reg_next <= data_out_reg;
    --MATLAB Function 'dataplane/Adaptive_Wiener_Filter Sample Based Filtering/deserializer': '<S7>:1'
    -- TODO: make determing the number of channels generic
    --'<S7>:1:14'
    --'<S7>:1:15'
    --'<S7>:1:16'
    IF valid_in = '1' THEN 
      --'<S7>:1:18'
      --'<S7>:1:19'
      add_temp := resize(channel_in_unsigned, 3) + to_unsigned(16#1#, 3);
      sub_cast := signed(resize(add_temp, 32));
      data_out_temp_temp(to_integer(sub_cast - 1)) := data_in_signed;
      IF channel_in_unsigned = to_unsigned(16#1#, 2) THEN 
        --'<S7>:1:20'
        --         valid_out = true;
        --'<S7>:1:22'
        data_out_reg_next <= data_out_temp_temp;
      END IF;
    END IF;
    valid_out <= valid_in;
    channel_out_tmp <= channel_in_unsigned;
    data_out_tmp <= data_out_reg;
    data_out_temp_next <= data_out_temp_temp;
  END PROCESS deserializer_output;


  outputgen: FOR k IN 0 TO 1 GENERATE
    data_out(k) <= std_logic_vector(data_out_tmp(k));
  END GENERATE;

  channel_out <= std_logic_vector(channel_out_tmp);

END rtl;

