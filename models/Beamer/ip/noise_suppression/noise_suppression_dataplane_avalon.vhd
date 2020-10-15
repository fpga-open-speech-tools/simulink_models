library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fixed_resize_pkg.all;
use work.noise_suppression_dataplane_pkg.all;

entity noise_suppression_dataplane_avalon is 
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
end entity noise_suppression_dataplane_avalon;

architecture noise_suppression_dataplane_avalon_arch of noise_suppression_dataplane_avalon is

component noise_suppression_dataplane is 
  port (
    register_control_enable          : in  std_logic;
    register_control_noise_variance  : in  std_logic_vector(15 downto 0);
    clk                              : in  std_logic;
    reset                            : in  std_logic;
    clk_enable                       : in  std_logic;
    avalon_sink_data                 : in  vector_of_std_logic_vector32(1 downto 0);
    ce_out                           : out std_logic;
    avalon_source_data               : out vector_of_std_logic_vector32(1 downto 0)
  );
end component noise_suppression_dataplane;

  signal enable                           : std_logic := '1';
  signal noise_variance                   : std_logic_vector(15 downto 0) := "0000000000100001";
  signal dataplane_sink_data              : vector_of_std_logic_vector32(1 downto 0);
  signal dataplane_sink_data_tmp          : vector_of_std_logic_vector32(1 downto 0);
  signal dataplane_source_data            : vector_of_std_logic_vector32(1 downto 0);
  signal dataplane_source_data_prev       : vector_of_std_logic_vector32(1 downto 0);
  signal counter                          : natural := 0;
  signal sample_valid                     : std_logic := '0';

begin

u_noise_suppression_dataplane : noise_suppression_dataplane
  port map(
    register_control_enable          => enable, 
    register_control_noise_variance  => noise_variance, 
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

                when "0" =>
                    dataplane_sink_data_tmp(0) <= avalon_sink_data;

                when "1" =>
                    dataplane_sink_data_tmp(1) <= avalon_sink_data;

                    sample_valid <= '1';
                when others => null;
            end case;
        elsif sample_valid = '1' then
            dataplane_sink_data <= dataplane_sink_data_tmp;

            sample_valid <= '0';
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
      when "0" => avalon_slave_readdata <= (0 => enable, others => '0');
      when "1" => avalon_slave_readdata <= std_logic_vector(resize(unsigned(noise_variance), 32));
      when others => avalon_slave_readdata <= (others => '0');
    end case;
  end if;
end process;

bus_write : process(clk, reset)
begin
  if reset = '1' then 
    enable                   <= '1';                             -- 1
    noise_variance           <= "0000000000100001";              -- 0.001
  elsif rising_edge(clk) and avalon_slave_write = '1' then
    case avalon_slave_address is
      when "0" => enable <= avalon_slave_writedata(0);
      when "1" => noise_variance <= std_logic_vector(resize(unsigned(avalon_slave_writedata), 16));
      when others => null;
    end case;
  end if;
end process;

end architecture;
