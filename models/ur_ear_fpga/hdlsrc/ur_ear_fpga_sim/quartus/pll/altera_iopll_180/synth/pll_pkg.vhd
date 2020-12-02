library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package pll_pkg is
	component pll_altera_iopll_180_di77tzi is
		port (
			rst      : in  std_logic := 'X'; -- reset
			refclk   : in  std_logic := 'X'; -- clk
			locked   : out std_logic;        -- export
			outclk_0 : out std_logic;        -- clk
			outclk_1 : out std_logic;        -- clk
			outclk_2 : out std_logic         -- clk
		);
	end component pll_altera_iopll_180_di77tzi;

end pll_pkg;
