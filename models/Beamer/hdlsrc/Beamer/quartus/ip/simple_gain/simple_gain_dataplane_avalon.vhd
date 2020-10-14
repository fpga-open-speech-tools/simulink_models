library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fixed_resize_pkg.all;

entity simple_gain_dataplane_avalon is 
  port (
    clk                              : in  std_logic;
    reset                            : in  std_logic;
    avalon_sink_valid                : in  std_logic;
    avalon_sink_data                 : in  std_logic_vector(31 downto 0);
    avalon_sink_channel              : in  std_logic_vector(0 downto 0);
    avalon_sink_error                : in  std_logic_vector(1 downto 0);
    avalon_source_valid              : out std_logic;
    avalon_source_data               : out std_logic_vector(31 downto 0);
    avalon_source_channel            : out std_logic_vector(0 downto 0);
    avalon_source_error              : out std_logic_vector(1 downto 0);
    avalon_slave_address             : in  std_logic_vector(0 downto 0);
    avalon_slave_read                : in  std_logic;
    avalon_slave_readdata            : out std_logic_vector(31 downto 0);
    avalon_slave_write               : in  std_logic;
    avalon_slave_writedata           : in  std_logic_vector(31 downto 0)
  );
end entity simple_gain_dataplane_avalon;

architecture simple_gain_dataplane_avalon_arch of simple_gain_dataplane_avalon is

component simple_gain_dataplane is 
  port (
    register_control_gain            : in  std_logic_vector(31 downto 0);
    register_control_Enable          : in  std_logic;
    clk                              : in  std_logic;
    reset                            : in  std_logic;
    clk_enable                       : in  std_logic;
    avalon_sink_valid                : in  std_logic;
    avalon_sink_data                 : in  std_logic_vector(31 downto 0);
    avalon_sink_channel              : in  std_logic_vector(0 downto 0);
    avalon_sink_error                : in  std_logic_vector(1 downto 0);
    ce_out                           : out std_logic;
    avalon_source_valid              : out std_logic;
    avalon_source_data               : out std_logic_vector(31 downto 0);
    avalon_source_channel            : out std_logic_vector(0 downto 0);
    avalon_source_error              : out std_logic_vector(1 downto 0)
  );
end component simple_gain_dataplane;

  signal gain                             : std_logic_vector(31 downto 0) := "00000001000000000000000000000000";
  signal Enable                           : std_logic := '1';
  signal dataplane_sink_data              : std_logic_vector(31 downto 0);
  signal dataplane_source_data            : std_logic_vector(31 downto 0);

begin

u_simple_gain_dataplane : simple_gain_dataplane
  port map(
    register_control_gain            => gain, 
    register_control_Enable          => Enable, 
    clk                              => clk, 
    reset                            => reset, 
    clk_enable                       => '1', 
    avalon_sink_valid                => avalon_sink_valid, 
    avalon_sink_data                 => dataplane_sink_data, 
    avalon_sink_channel              => avalon_sink_channel, 
    avalon_sink_error                => avalon_sink_error, 
    ce_out                           => open, 
    avalon_source_valid              => avalon_source_valid, 
    avalon_source_data               => dataplane_source_data, 
    avalon_source_channel            => avalon_source_channel, 
    avalon_source_error              => avalon_source_error
);

dataplane_sink_data <= avalon_sink_data;
avalon_source_data <= dataplane_source_data;

bus_read : process(clk)
begin
  if rising_edge(clk) and avalon_slave_read = '1' then 
    case avalon_slave_address is
      when "0" => avalon_slave_readdata <= gain;
      when "1" => avalon_slave_readdata <= (0 => Enable, others => '0');
      when others => avalon_slave_readdata <= (others => '0');
    end case;
  end if;
end process;

bus_write : process(clk, reset)
begin
  if reset = '1' then 
    gain                     <= "00000001000000000000000000000000"; -- 1
    Enable                   <= '1';                             -- 1
  elsif rising_edge(clk) and avalon_slave_write = '1' then
    case avalon_slave_address is
      when "0" => gain <= avalon_slave_writedata;
      when "1" => Enable <= avalon_slave_writedata(0);
      when others => null;
    end case;
  end if;
end process;

end architecture;
