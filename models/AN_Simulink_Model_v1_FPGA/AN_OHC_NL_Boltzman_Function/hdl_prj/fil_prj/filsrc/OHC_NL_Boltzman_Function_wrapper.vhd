
-- ----------------------------------------------
-- File Name: OHC_NL_Boltzman_Function_wrapper.vhd
-- Created:   15-Apr-2020 17:35:04
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;


ENTITY OHC_NL_Boltzman_Function_wrapper IS 
PORT (
      clk                             : IN  std_logic;
      enb                             : IN  std_logic;
      reset                           : IN  std_logic;
      din                             : IN  std_logic_vector(31 DOWNTO 0);
      dout                            : OUT std_logic_vector(31 DOWNTO 0)
);
END OHC_NL_Boltzman_Function_wrapper;

ARCHITECTURE rtl of OHC_NL_Boltzman_Function_wrapper IS

COMPONENT OHC_NL_Boltzman_Function IS 
PORT (
      stimulus                        : IN  std_logic_vector(31 DOWNTO 0);
      reset                           : IN  std_logic;
      clk                             : IN  std_logic;
      clk_enable                      : IN  std_logic;
      output                          : OUT std_logic_vector(31 DOWNTO 0)
);
END COMPONENT;

  SIGNAL dut_reset                        : std_logic; -- boolean
  SIGNAL stimulus                         : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL stimulus_tmp                     : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL output                           : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL output_tmp                       : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL tmpconcat                        : std_logic_vector(31 DOWNTO 0); -- std32

BEGIN

u_OHC_NL_Boltzman_Function: OHC_NL_Boltzman_Function 
PORT MAP(
        stimulus             => stimulus,
        reset                => dut_reset,
        clk                  => clk,
        clk_enable           => enb,
        output               => output
);

dut_reset <= reset;

stimulus <= stimulus_tmp;
stimulus_tmp <= din(31 DOWNTO 0);
output_tmp <= output;
output_tmp <= output;
dout <= output_tmp;

END;
