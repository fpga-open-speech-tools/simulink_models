library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package audioblade_system_pkg is
	component FE_FPGA_Microphone_Encoder_Decoder is
		generic (
			avalon_data_width : integer := 32;
			mic_data_width    : integer := 24;
			bme_data_width    : integer := 96;
			rgb_data_width    : integer := 16;
			cfg_data_width    : integer := 16;
			ch_width          : integer := 4;
			n_mics            : integer := 16
		);
		port (
			reset_n         : in  std_logic                     := 'X';             -- reset_n
			serial_data_in  : in  std_logic                     := 'X';             -- serial_data_in
			serial_data_out : out std_logic;                                        -- serial_data_out
			serial_clk_out  : out std_logic;                                        -- serial_clk_out
			sys_clk         : in  std_logic                     := 'X';             -- clk
			busy_out        : out std_logic;                                        -- busy_out
			bme_out_data    : out std_logic_vector(95 downto 0);                    -- data
			bme_out_error   : out std_logic_vector(1 downto 0);                     -- error
			bme_out_valid   : out std_logic;                                        -- valid
			mic_out_channel : out std_logic_vector(3 downto 0);                     -- channel
			mic_out_data    : out std_logic_vector(31 downto 0);                    -- data
			mic_out_error   : out std_logic_vector(1 downto 0);                     -- error
			mic_out_valid   : out std_logic;                                        -- valid
			cfg_input_data  : in  std_logic_vector(15 downto 0) := (others => 'X'); -- data
			cfg_input_error : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- error
			cfg_input_valid : in  std_logic                     := 'X';             -- valid
			rgb_input_data  : in  std_logic_vector(15 downto 0) := (others => 'X'); -- data
			rgb_input_error : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- error
			rgb_input_valid : in  std_logic                     := 'X';             -- valid
			serial_clk      : in  std_logic                     := 'X'              -- clk
		);
	end component FE_FPGA_Microphone_Encoder_Decoder;

end audioblade_system_pkg;
