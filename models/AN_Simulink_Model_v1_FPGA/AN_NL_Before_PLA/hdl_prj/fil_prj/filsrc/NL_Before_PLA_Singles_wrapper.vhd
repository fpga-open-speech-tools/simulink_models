
-- ----------------------------------------------
-- File Name: NL_Before_PLA_Singles_wrapper.vhd
-- Created:   14-Apr-2020 17:27:02
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;


ENTITY NL_Before_PLA_Singles_wrapper IS 
PORT (
      clk                             : IN  std_logic;
      enb                             : IN  std_logic;
      reset                           : IN  std_logic;
      din                             : IN  std_logic_vector(31 DOWNTO 0);
      dout                            : OUT std_logic_vector(31 DOWNTO 0)
);
END NL_Before_PLA_Singles_wrapper;

ARCHITECTURE rtl of NL_Before_PLA_Singles_wrapper IS

COMPONENT NL_Before_PLA_Singles IS 
PORT (
      ihcout                          : IN  std_logic_vector(31 DOWNTO 0);
      reset                           : IN  std_logic;
      clk                             : IN  std_logic;
      clk_enable                      : IN  std_logic;
      powerLawIn                      : OUT std_logic_vector(31 DOWNTO 0)
);
END COMPONENT;

  SIGNAL dut_reset                        : std_logic; -- boolean
  SIGNAL ihcout                           : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL ihcout_tmp                       : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL powerLawIn                       : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL powerLawIn_tmp                   : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL tmpconcat                        : std_logic_vector(31 DOWNTO 0); -- std32

BEGIN

u_NL_Before_PLA_Singles: NL_Before_PLA_Singles 
PORT MAP(
        ihcout               => ihcout,
        reset                => dut_reset,
        clk                  => clk,
        powerLawIn           => powerLawIn,
        clk_enable           => enb
);

dut_reset <= reset;

ihcout <= ihcout_tmp;
ihcout_tmp <= din(31 DOWNTO 0);
powerLawIn_tmp <= powerLawIn;
powerLawIn_tmp <= powerLawIn;
dout <= powerLawIn_tmp;

END;
