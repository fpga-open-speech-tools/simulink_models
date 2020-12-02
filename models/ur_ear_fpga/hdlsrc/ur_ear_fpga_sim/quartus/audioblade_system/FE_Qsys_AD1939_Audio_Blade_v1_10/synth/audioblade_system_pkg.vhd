library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package audioblade_system_pkg is
	component AD1939_hps_audio_blade is
		port (
			AD1939_ADC2_data    : out std_logic_vector(31 downto 0);                    -- data
			AD1939_ADC2_channel : out std_logic_vector(1 downto 0);                     -- channel
			AD1939_ADC2_valid   : out std_logic;                                        -- valid
			AD1939_ADC2_error   : out std_logic_vector(1 downto 0);                     -- error
			AD1939_ADC1_channel : out std_logic_vector(1 downto 0);                     -- channel
			AD1939_ADC1_data    : out std_logic_vector(31 downto 0);                    -- data
			AD1939_ADC1_error   : out std_logic_vector(1 downto 0);                     -- error
			AD1939_ADC1_valid   : out std_logic;                                        -- valid
			AD1939_DAC2_channel : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- channel
			AD1939_DAC2_data    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- data
			AD1939_DAC2_error   : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- error
			AD1939_DAC2_valid   : in  std_logic                     := 'X';             -- valid
			AD1939_DAC1_channel : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- channel
			AD1939_DAC1_data    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- data
			AD1939_DAC1_error   : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- error
			AD1939_DAC1_valid   : in  std_logic                     := 'X';             -- valid
			sys_clk             : in  std_logic                     := 'X';             -- clk
			sys_reset           : in  std_logic                     := 'X';             -- reset
			AD1939_ADC_ASDATA1  : in  std_logic                     := 'X';             -- ad1939_adc_asdata1
			AD1939_ADC_ASDATA2  : in  std_logic                     := 'X';             -- ad1939_adc_asdata2
			AD1939_DAC_DSDATA1  : out std_logic;                                        -- ad1939_dac_dsdata1
			AD1939_DAC_DSDATA2  : out std_logic;                                        -- ad1939_dac_dsdata2
			AD1939_DAC_DBCLK    : out std_logic;                                        -- ad1939_dac_dbclk
			AD1939_DAC_DLRCLK   : out std_logic;                                        -- ad1939_dac_dlrclk
			AD1939_ADC_ALRCLK   : in  std_logic                     := 'X';             -- clk
			AD1939_ADC_ABCLK    : in  std_logic                     := 'X'              -- clk
		);
	end component AD1939_hps_audio_blade;

end audioblade_system_pkg;
