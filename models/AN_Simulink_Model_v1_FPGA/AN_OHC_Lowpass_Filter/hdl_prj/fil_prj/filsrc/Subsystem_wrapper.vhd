
-- ----------------------------------------------
-- File Name: Subsystem_wrapper.vhd
-- Created:   17-Apr-2020 13:26:06
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;


ENTITY Subsystem_wrapper IS 
PORT (
      clk                             : IN  std_logic;
      enb                             : IN  std_logic;
      reset                           : IN  std_logic;
      din                             : IN  std_logic_vector(31 DOWNTO 0);
      dout                            : OUT std_logic_vector(31 DOWNTO 0)
);
END Subsystem_wrapper;

ARCHITECTURE rtl of Subsystem_wrapper IS

COMPONENT Subsystem IS 
PORT (
      In1                             : IN  std_logic_vector(31 DOWNTO 0);
      clk                             : IN  std_logic;
      clk_enable                      : IN  std_logic;
      reset                           : IN  std_logic;
      Out1                            : OUT std_logic_vector(31 DOWNTO 0)
);
END COMPONENT;

  SIGNAL dut_reset                        : std_logic; -- boolean
  SIGNAL In1                              : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL In1_tmp                          : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL Out1                             : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL Out1_tmp                         : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL tmpconcat                        : std_logic_vector(31 DOWNTO 0); -- std32

BEGIN

u_Subsystem: Subsystem 
PORT MAP(
        Out1                 => Out1,
        In1                  => In1,
        clk                  => clk,
        clk_enable           => enb,
        reset                => dut_reset
);

dut_reset <= reset;

In1 <= In1_tmp;
In1_tmp <= din(31 DOWNTO 0);
Out1_tmp <= Out1;
Out1_tmp <= Out1;
dout <= Out1_tmp;

END;
