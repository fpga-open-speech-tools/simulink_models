library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.noise_suppression_dataplane_pkg.all;

entity noise_suppression_dataplane_avalon is
  port (
    clk                       : in  std_logic;
    reset                     : in  std_logic;
    avalon_sink_data          : in  std_logic_vector(31  downto 0); --sfix32_En28
    avalon_sink_channel       : in  std_logic;
    avalon_sink_valid         : in  std_logic;
    avalon_source_data        : out std_logic_vector(31  downto 0); --sfix32_En28
    avalon_source_channel     : out std_logic;
    avalon_source_valid       : out std_logic;
    avalon_slave_address      : in  std_logic_vector(0   downto 0);            
    avalon_slave_read         : in  std_logic;
    avalon_slave_readdata     : out std_logic_vector(31  downto 0);
    avalon_slave_write        : in  std_logic;
    avalon_slave_writedata    : in  std_logic_vector(31  downto 0)
  );
end entity noise_suppression_dataplane_avalon;

architecture noise_suppression_dataplane_avalon_arch of noise_suppression_dataplane_avalon is

  signal enable                    : std_logic :=  '1'; -- 1 (boolean)
  signal noise_variance            : std_logic_vector(23  downto 0) :=  "000000000000100100011010"; -- 0.0002777777777777778 (ufix24_En23)

  signal sink_data : vector_of_std_logic_vector32(0 to 1) := (others => (others => '0'));
  signal sink_data_tmp : vector_of_std_logic_vector32(0 to 1) := (others => (others => '0'));
  signal source_data_prev : vector_of_std_logic_vector32(0 to 1) := (others => (others => '0'));
  signal source_data : vector_of_std_logic_vector32(0 to 1) := (others => (others => '0'));

  signal source_counter_enable : boolean := false;
  signal source_counter : natural := 0;

  constant CLOCK_RATIO : positive := 2048;

component noise_suppression_dataplane
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        avalon_sink_data                  :   IN    vector_of_std_logic_vector32(0 TO 1);  -- sfix32_En28 [2]
        register_control_enable           :   IN    std_logic;
        register_control_noise_variance   :   IN    std_logic_vector(23 DOWNTO 0);  -- ufix24_En23
        ce_out                            :   OUT   std_logic;
        avalon_source_data                :   OUT   vector_of_std_logic_vector32(0 TO 1)  -- sfix32_En28 [2]
  );
end component;

begin

u_noise_suppression_dataplane : noise_suppression_dataplane
  port map(
    clk                         =>  clk,
    reset                       =>  reset,
    clk_enable                  =>  '1',
    avalon_sink_data            =>  sink_data,                -- sfix32_En28
    register_control_enable     =>  enable,                          -- boolean
    register_control_noise_variance=>  noise_variance,                  -- ufix24_En23
    ce_out => open,
    avalon_source_data          =>  source_data               -- sfix32_En28
  );

  bus_read : process(clk)
  begin
    if rising_edge(clk) and avalon_slave_read = '1' then
      case avalon_slave_address is
        when "0" => avalon_slave_readdata <= (31 downto 1 => '0') & enable;
        when "1" => avalon_slave_readdata <= (31 downto 24 => '0') & noise_variance;
        when others => avalon_slave_readdata <= (others => '0');
      end case;
    end if;
  end process;

  bus_write : process(clk, reset)
  begin
    if reset = '1' then
      enable                    <=  '1'; -- 1 (boolean)
      noise_variance            <=  "000000000000100100011010"; -- 0.0002777777777777778 (ufix24_En23)
    elsif rising_edge(clk) and avalon_slave_write = '1' then
      case avalon_slave_address is
        when "0" => enable <= avalon_slave_writedata(0);
        when "1" => noise_variance <= avalon_slave_writedata(23 downto 0);
        when others => null;
      end case;
    end if;
  end process;

  buffer_sink_data : process(clk, reset)
  begin
	 if rising_edge(clk) then
		 if avalon_sink_valid = '1' then
			if avalon_sink_channel = '0' then
			  sink_data_tmp(0) <= avalon_sink_data;
			elsif avalon_sink_channel = '1' then
			  sink_data_tmp(1) <= avalon_sink_data;
			  sink_data <= sink_data_tmp;
			end if;
		 end if;
	end if;
  end process;

  enable_source_tdm_counter : process(clk, reset)
  begin
	 if rising_edge(clk) then
		 if source_data_prev /= source_data then
			source_counter <= 0;
			source_data_prev <= source_data;
		 else
			source_counter <= source_counter + 1;
		 end if;
	 end if;
  end process;

  -- TODO: I could make source_counter roll over automatically by choosing a restricted data type
  generate_avalon_source : process(clk, reset)
  begin
    if rising_edge(clk) then
      if source_counter = 0 then
        avalon_source_data <= source_data(0);
        avalon_source_valid <= '1';
        avalon_source_channel <= '0';
      elsif source_counter = CLOCK_RATIO/2 - 1 then
        avalon_source_data <= source_data(1);
        avalon_source_valid <= '1';
        avalon_source_channel <= '1';
      else
        avalon_source_valid <= '0';
      end if;
	end if;
  end process;
        
end architecture;