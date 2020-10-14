library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fixed_resize_pkg.all;
use work.DSBF_dataplane_pkg.all;

entity DSBF_dataplane_avalon is 
  port (
    clk                              : in  std_logic;
    reset                            : in  std_logic;
    avalon_sink_valid                : in  std_logic;
    avalon_sink_data                 : in  std_logic_vector(31 downto 0);
    avalon_sink_channel              : in  std_logic_vector(3 downto 0);
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
end entity DSBF_dataplane_avalon;

architecture DSBF_dataplane_avalon_arch of DSBF_dataplane_avalon is

component DSBF_dataplane is 
  port (
    register_control_azimuth         : in  std_logic_vector(15 downto 0);
    register_control_elevation       : in  std_logic_vector(15 downto 0);
    clk                              : in  std_logic;
    reset                            : in  std_logic;
    clk_enable                       : in  std_logic;
    avalon_sink_data                 : in  vector_of_std_logic_vector32(15 downto 0);
    ce_out                           : out std_logic;
    avalon_source_data               : out vector_of_std_logic_vector32(1 downto 0)
  );
end component DSBF_dataplane;

  signal azimuth                          : std_logic_vector(15 downto 0) := "0000000000000000";
  signal elevation                        : std_logic_vector(15 downto 0) := "0000000000000000";
  signal dataplane_sink_data              : vector_of_std_logic_vector32(15 downto 0);
  signal dataplane_sink_data_tmp          : vector_of_std_logic_vector32(15 downto 0);
  signal dataplane_source_data            : vector_of_std_logic_vector32(1 downto 0);
  signal dataplane_source_data_prev       : vector_of_std_logic_vector32(1 downto 0);
  signal counter                          : natural := 0;

begin

u_DSBF_dataplane : DSBF_dataplane
  port map(
    register_control_azimuth         => azimuth, 
    register_control_elevation       => elevation, 
    clk                              => clk, 
    reset                            => reset, 
    clk_enable                       => '1', 
    avalon_sink_data                 => dataplane_sink_data, 
    ce_out                           => open, 
    avalon_source_data               => dataplane_source_data
);


channel_to_sample : process(clk)
begin

    if rising_edge(clk) then
        if avalon_sink_valid = '1' then
            case avalon_sink_channel is

                when "0000" =>
                    dataplane_sink_data_tmp(0) <= avalon_sink_data;

                when "0001" =>
                    dataplane_sink_data_tmp(1) <= avalon_sink_data;

                when "0010" =>
                    dataplane_sink_data_tmp(2) <= avalon_sink_data;

                when "0011" =>
                    dataplane_sink_data_tmp(3) <= avalon_sink_data;

                when "0100" =>
                    dataplane_sink_data_tmp(4) <= avalon_sink_data;

                when "0101" =>
                    dataplane_sink_data_tmp(5) <= avalon_sink_data;

                when "0110" =>
                    dataplane_sink_data_tmp(6) <= avalon_sink_data;

                when "0111" =>
                    dataplane_sink_data_tmp(7) <= avalon_sink_data;

                when "1000" =>
                    dataplane_sink_data_tmp(8) <= avalon_sink_data;

                when "1001" =>
                    dataplane_sink_data_tmp(9) <= avalon_sink_data;

                when "1010" =>
                    dataplane_sink_data_tmp(10) <= avalon_sink_data;

                when "1011" =>
                    dataplane_sink_data_tmp(11) <= avalon_sink_data;

                when "1100" =>
                    dataplane_sink_data_tmp(12) <= avalon_sink_data;

                when "1101" =>
                    dataplane_sink_data_tmp(13) <= avalon_sink_data;

                when "1110" =>
                    dataplane_sink_data_tmp(14) <= avalon_sink_data;

                when "1111" =>
                    dataplane_sink_data_tmp(15) <= avalon_sink_data;

                    dataplane_sink_data <= dataplane_sink_data_tmp;

                when others => null;
            end case;
        end if;
    end if; 
end process;

sample_to_channel : process(clk)
begin
  if rising_edge(clk) then
    if counter = 2048 then
      counter <= 1;
    else
      case counter is
        when 1 =>
          avalon_source_data <= dataplane_source_data(0);
          avalon_source_valid <= '1';
          avalon_source_channel <= "0";
        when 2 =>
          avalon_source_data <= dataplane_source_data(1);
          avalon_source_valid <= '1';
          avalon_source_channel <= "1";
        when others =>
          avalon_source_valid <= '0';
      end case;
      counter <= counter + 1;
    end if;
  end if;
end process;

bus_read : process(clk)
begin
  if rising_edge(clk) and avalon_slave_read = '1' then 
    case avalon_slave_address is
      when "0" => avalon_slave_readdata <= std_logic_vector(resize(signed(azimuth), 32));
      when "1" => avalon_slave_readdata <= std_logic_vector(resize(signed(elevation), 32));
      when others => avalon_slave_readdata <= (others => '0');
    end case;
  end if;
end process;

bus_write : process(clk, reset)
begin
  if reset = '1' then 
    azimuth                  <= "0000000000000000";              -- 0
    elevation                <= "0000000000000000";              -- 0
  elsif rising_edge(clk) and avalon_slave_write = '1' then
    case avalon_slave_address is
      when "0" => azimuth <= std_logic_vector(resize(signed(avalon_slave_writedata), 16));
      when "1" => elevation <= std_logic_vector(resize(signed(avalon_slave_writedata), 16));
      when others => null;
    end case;
  end if;
end process;

end architecture;
