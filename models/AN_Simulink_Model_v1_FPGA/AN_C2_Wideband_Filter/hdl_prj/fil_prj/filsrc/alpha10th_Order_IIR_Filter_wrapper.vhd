
-- ----------------------------------------------
-- File Name: alpha10th_Order_IIR_Filter_wrapper.vhd
-- Created:   15-Apr-2020 23:52:11
-- Copyright  2020 MathWorks, Inc.
-- ----------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.ALL;


ENTITY alpha10th_Order_IIR_Filter_wrapper IS 
PORT (
      clk                             : IN  std_logic;
      enb                             : IN  std_logic;
      reset                           : IN  std_logic;
      din                             : IN  std_logic_vector(31 DOWNTO 0);
      dout                            : OUT std_logic_vector(31 DOWNTO 0)
);
END alpha10th_Order_IIR_Filter_wrapper;

ARCHITECTURE rtl of alpha10th_Order_IIR_Filter_wrapper IS

COMPONENT alpha10th_Order_IIR_Filter IS 
PORT (
      clk_enable                      : IN  std_logic;
      clk                             : IN  std_logic;
      In1                             : IN  std_logic_vector(31 DOWNTO 0);
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

u_alpha10th_Order_IIR_Filter: alpha10th_Order_IIR_Filter 
PORT MAP(
        clk_enable           => enb,
        Out1                 => Out1,
        clk                  => clk,
        In1                  => In1,
        reset                => dut_reset
);

dut_reset <= reset;

In1 <= In1_tmp;
In1_tmp <= din(31 DOWNTO 0);
Out1_tmp <= Out1;
Out1_tmp <= Out1;
dout <= Out1_tmp;

END;
