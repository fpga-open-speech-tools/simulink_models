
-- ----------------------------------------------
-- File Name: Auditory_Nerve_Model_wrapper.vhd
-- Created:   16-Apr-2020 11:45:42
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;


ENTITY Auditory_Nerve_Model_wrapper IS 
PORT (
      clk                             : IN  std_logic;
      enb                             : IN  std_logic;
      reset                           : IN  std_logic;
      din                             : IN  std_logic_vector(31 DOWNTO 0);
      dout                            : OUT std_logic_vector(31 DOWNTO 0)
);
END Auditory_Nerve_Model_wrapper;

ARCHITECTURE rtl of Auditory_Nerve_Model_wrapper IS

COMPONENT Auditory_Nerve_Model IS 
PORT (
      clk                             : IN  std_logic;
      clk_enable                      : IN  std_logic;
      reset                           : IN  std_logic;
      stimulus                        : IN  std_logic_vector(31 DOWNTO 0);
      ihcout                          : OUT std_logic_vector(31 DOWNTO 0)
);
END COMPONENT;

  SIGNAL dut_reset                        : std_logic; -- boolean
  SIGNAL stimulus                         : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL stimulus_tmp                     : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL ihcout                           : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL ihcout_tmp                       : std_logic_vector(31 DOWNTO 0); -- std32
  SIGNAL tmpconcat                        : std_logic_vector(31 DOWNTO 0); -- std32

BEGIN

u_Auditory_Nerve_Model: Auditory_Nerve_Model 
PORT MAP(
        clk                  => clk,
        clk_enable           => enb,
        ihcout               => ihcout,
        reset                => dut_reset,
        stimulus             => stimulus
);

dut_reset <= reset;

stimulus <= stimulus_tmp;
stimulus_tmp <= din(31 DOWNTO 0);
ihcout_tmp <= ihcout;
ihcout_tmp <= ihcout;
dout <= ihcout_tmp;

END;
