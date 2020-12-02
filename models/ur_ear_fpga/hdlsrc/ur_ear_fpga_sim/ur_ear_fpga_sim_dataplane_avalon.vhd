library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fixed_resize_pkg.all;

entity ur_ear_fpga_sim_dataplane_avalon is 
  port (
    clk                              : in  std_logic;
    reset                            : in  std_logic;
    avalon_sink_valid                : in  std_logic;
    avalon_sink_data                 : in  std_logic_vector(31 downto 0);
    avalon_sink_channel              : in  std_logic;
    avalon_sink_error                : in  std_logic_vector(1 downto 0);
    avalon_source_valid              : out std_logic;
    avalon_source_data               : out std_logic_vector(31 downto 0);
    avalon_source_channel            : out std_logic;
    avalon_source_error              : out std_logic_vector(1 downto 0);
    avalon_slave_address             : in  std_logic_vector(1 downto 0);
    avalon_slave_read                : in  std_logic;
    avalon_slave_readdata            : out std_logic_vector(31 downto 0);
    avalon_slave_write               : in  std_logic;
    avalon_slave_writedata           : in  std_logic_vector(31 downto 0)
  );
end entity ur_ear_fpga_sim_dataplane_avalon;

architecture ur_ear_fpga_sim_dataplane_avalon_arch of ur_ear_fpga_sim_dataplane_avalon is

component ur_ear_fpga_sim_dataplane is 
  port (
    register_control_Gain            : in  std_logic_vector(15 downto 0);
    register_control_Attack_and_Decay_Coefficients : in  std_logic_vector(15 downto 0);
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
end component ur_ear_fpga_sim_dataplane;

  signal Gain                             : std_logic_vector(15 downto 0) := "0000000110000000";
  signal Attack_and_Decay_Coefficients    : std_logic_vector(15 downto 0) := "1111111110111110";
  signal Enable                           : std_logic := '1';
  signal dataplane_sink_data              : std_logic_vector(31 downto 0);
  signal dataplane_source_data            : std_logic_vector(31 downto 0);

begin

u_ur_ear_fpga_sim_dataplane : ur_ear_fpga_sim_dataplane
  port map(
    register_control_Gain            => Gain, 
    register_control_Attack_and_Decay_Coefficients => Attack_and_Decay_Coefficients, 
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
      when "00" => avalon_slave_readdata <= std_logic_vector(resize(unsigned(Gain), 32));
      when "01" => avalon_slave_readdata <= std_logic_vector(resize(unsigned(Attack_and_Decay_Coefficients), 32));
      when "10" => avalon_slave_readdata <= (0 => Enable, others => '0');
      when others => avalon_slave_readdata <= (others => '0');
    end case;
  end if;
end process;

bus_write : process(clk, reset)
begin
  if reset = '1' then 
    Gain                     <= "0000000110000000";              -- 1.5
    Attack_and_Decay_Coefficients <= "1111111110111110";              -- 0.999
    Enable                   <= '1';                             -- 1
  elsif rising_edge(clk) and avalon_slave_write = '1' then
    case avalon_slave_address is
      when "00" => Gain <= std_logic_vector(resize(unsigned(avalon_slave_writedata), 16));
      when "01" => Attack_and_Decay_Coefficients <= std_logic_vector(resize(unsigned(avalon_slave_writedata), 16));
      when "10" => Enable <= avalon_slave_writedata(0);
      when others => null;
    end case;
  end if;
end process;

end architecture;
