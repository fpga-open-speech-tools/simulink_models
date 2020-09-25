
-- ----------------------------------------------
-- File Name: NL_After_OHC_Function_Singles_wrapper.vhd
-- Created:   15-Apr-2020 13:19:23
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;


ENTITY NL_After_OHC_Function_Singles_wrapper IS 
PORT (
      clk                             : IN  std_logic;
      enb                             : IN  std_logic;
      reset                           : IN  std_logic;
      din                             : IN  std_logic_vector(31 DOWNTO 0);
      dout                            : OUT std_logic_vector(31 DOWNTO 0)
);
END NL_After_OHC_Function_Singles_wrapper;

ARCHITECTURE rtl of NL_After_OHC_Function_Singles_wrapper IS

COMPONENT NL_After_OHC_Function_Singles IS 
PORT (
      stimulus                        : IN  std_logic_vector(31 DOWNTO 0);
      reset                           : IN  std_logic;
      clk                             : IN  std_logic;
      clk_enable                      : IN  std_logic;
      output1                         : OUT std_logic_vector(31 DOWNTO 0)
);
END COMPONENT;

  SIGNAL dut_reset                        : std_logic; -- boolean
  SIGNAL stimulus                         : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL stimulus_tmp                     : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL output1                          : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL output1_tmp                      : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL tmpconcat                        : std_logic_vector(31 DOWNTO 0); -- std32

BEGIN

u_NL_After_OHC_Function_Singles: NL_After_OHC_Function_Singles 
PORT MAP(
        stimulus             => stimulus,
        reset                => dut_reset,
        output1              => output1,
        clk                  => clk,
        clk_enable           => enb
);

dut_reset <= reset;

stimulus <= stimulus_tmp;
stimulus_tmp <= din(31 DOWNTO 0);
output1_tmp <= output1;
output1_tmp <= output1;
dout <= output1_tmp;

END;
