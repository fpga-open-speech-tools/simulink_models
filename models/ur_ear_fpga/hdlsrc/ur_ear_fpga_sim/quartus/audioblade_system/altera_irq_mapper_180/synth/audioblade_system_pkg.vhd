library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package audioblade_system_pkg is
	component audioblade_system_altera_irq_mapper_180_vrecy4a is
		port (
			clk        : in  std_logic                     := 'X'; -- clk
			reset      : in  std_logic                     := 'X'; -- reset
			sender_irq : out std_logic_vector(31 downto 0)         -- irq
		);
	end component audioblade_system_altera_irq_mapper_180_vrecy4a;

end audioblade_system_pkg;
