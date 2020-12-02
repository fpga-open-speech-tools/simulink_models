library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package audioblade_system_pkg is
	component audioblade_system_altera_avalon_pio_180_4xcd3ea is
		port (
			clk      : in  std_logic                     := 'X';             -- clk
			reset_n  : in  std_logic                     := 'X';             -- reset_n
			address  : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			readdata : out std_logic_vector(31 downto 0);                    -- readdata
			in_port  : in  std_logic_vector(4 downto 0)  := (others => 'X')  -- export
		);
	end component audioblade_system_altera_avalon_pio_180_4xcd3ea;

end audioblade_system_pkg;
