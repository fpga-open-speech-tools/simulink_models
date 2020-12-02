library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package audioblade_system_pkg is
	component FE_AD5791_v1 is
		port (
			AD5791_data_in    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- data
			AD5791_error_in   : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- error
			AD5791_valid_in   : in  std_logic                     := 'X';             -- valid
			AD5791_CLR_n_out  : out std_logic;                                        -- ad5791_clr_n_out
			AD5791_LDAC_n_out : out std_logic;                                        -- ad5791_ldac_n_out
			AD5791_MISO_out   : in  std_logic                     := 'X';             -- ad5791_miso_out
			AD5791_MOSI_in    : out std_logic;                                        -- ad5791_mosi_in
			AD5791_SCLK_out   : out std_logic;                                        -- ad5791_sclk_out
			AD5791_SYNC_n_out : out std_logic;                                        -- ad5791_sync_n_out
			sys_clk           : in  std_logic                     := 'X';             -- clk
			spi_clk           : in  std_logic                     := 'X';             -- clk
			sys_reset_n       : in  std_logic                     := 'X';             -- reset_n
			double_spi_clk_in : in  std_logic                     := 'X'              -- clk
		);
	end component FE_AD5791_v1;

end audioblade_system_pkg;
