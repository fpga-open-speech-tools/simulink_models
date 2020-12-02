library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package audioblade_system_pkg is
	component FE_AD7768_v1 is
		generic (
			n_channels : integer := 8
		);
		port (
			sys_clk            : in  std_logic                     := 'X';             -- clk
			AD7768_DOUT_in     : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- ad7768_dout_in
			AD7768_DRDY_in     : in  std_logic                     := 'X';             -- ad7768_drdy_in
			AD7768_DCLK_in     : in  std_logic                     := 'X';             -- ad7768_dclk_in
			AD7768_data_out    : out std_logic_vector(31 downto 0);                    -- data
			AD7768_valid_out   : out std_logic;                                        -- valid
			AD7768_error_out   : out std_logic_vector(1 downto 0);                     -- error
			AD7768_channel_out : out std_logic_vector(2 downto 0);                     -- channel
			sys_reset_n        : in  std_logic                     := 'X'              -- reset_n
		);
	end component FE_AD7768_v1;

end audioblade_system_pkg;
