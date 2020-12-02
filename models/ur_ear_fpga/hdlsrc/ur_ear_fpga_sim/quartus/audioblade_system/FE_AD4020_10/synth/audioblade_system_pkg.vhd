library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package audioblade_system_pkg is
	component FE_AD4020_v1 is
		generic (
			input_clk_freq : integer := 71000000
		);
		port (
			AD4020_data_out    : out std_logic_vector(31 downto 0);        -- data
			AD4020_error_out   : out std_logic_vector(1 downto 0);         -- error
			AD4020_valid_out   : out std_logic;                            -- valid
			AD4020_channel_out : out std_logic_vector(1 downto 0);         -- channel
			AD4020_CONV_out    : out std_logic;                            -- cnv
			AD4020_MISO_in     : in  std_logic                     := 'X'; -- miso
			AD4020_MOSI_out    : out std_logic;                            -- mosi
			AD4020_SCLK_out    : out std_logic;                            -- sclk
			sys_reset_n        : in  std_logic                     := 'X'; -- reset_n
			sys_clk            : in  std_logic                     := 'X'; -- clk
			spi_clk            : in  std_logic                     := 'X'  -- clk
		);
	end component FE_AD4020_v1;

end audioblade_system_pkg;
