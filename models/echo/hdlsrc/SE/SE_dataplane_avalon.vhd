library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SE_dataplane_avalon is
  port (
    clk                       : in  std_logic;
    reset                     : in  std_logic;
    avalon_sink_valid         : in  std_logic; --boolean
    avalon_sink_data          : in  std_logic_vector(31  downto 0); --sfix32_En28
    avalon_sink_channel       : in  std_logic_vector(1   downto 0); --ufix2
    avalon_sink_error         : in  std_logic_vector(1   downto 0); --ufix2
    avalon_source_valid       : out std_logic; --boolean
    avalon_source_data        : out std_logic_vector(31  downto 0); --sfix32_En28
    avalon_source_channel     : out std_logic_vector(1   downto 0); --ufix2
    avalon_source_error       : out std_logic_vector(1   downto 0); --ufix2
    avalon_slave_address      : in  std_logic_vector(1   downto 0);            
    avalon_slave_read         : in  std_logic;
    avalon_slave_readdata     : out std_logic_vector(31  downto 0);
    avalon_slave_write        : in  std_logic;
    avalon_slave_writedata    : in  std_logic_vector(31  downto 0)
  );
end entity SE_dataplane_avalon;

architecture SE_dataplane_avalon_arch of SE_dataplane_avalon is

  signal bypass                    : std_logic :=  '0'; -- 0
  signal delay                     : std_logic_vector(15  downto 0) :=  std_logic_vector(to_unsigned(24000, 16)); -- 24000
  signal decay                     : std_logic_vector(4  downto 0) :=  "01101"; -- 0.8
  signal wet_dry_mix               : std_logic_vector(4  downto 0) :=  "01000"; -- 0.5

component SE_dataplane
  port(
    clk                         : in  std_logic; -- clk_freq = 1 Hz, period = 0.1
    reset                       : in  std_logic;
    clk_enable                  : in  std_logic;
    avalon_sink_valid           : in  std_logic;                              -- boolean
    avalon_sink_data            : in  std_logic_vector(31  downto 0);         -- sfix32_En28
    avalon_sink_channel         : in  std_logic_vector(1   downto 0);         -- ufix2
    avalon_sink_error           : in  std_logic_vector(1   downto 0);         -- ufix2
    register_control_bypass     : in  std_logic;                              -- boolean
    register_control_delay      : in  std_logic_vector(15  downto 0);         -- uint16
    register_control_decay      : in  std_logic_vector(4   downto 0);         -- ufix5_En4
    register_control_wet_dry_mix: in  std_logic_vector(4   downto 0);         -- ufix5_En4
    ce_out                      : out std_logic;
    avalon_source_valid         : out std_logic;                              -- boolean
    avalon_source_data          : out std_logic_vector(31  downto 0);         -- sfix32_En28
    avalon_source_channel       : out std_logic_vector(1   downto 0);         -- ufix2
    avalon_source_error         : out std_logic_vector(1   downto 0)          -- ufix2
  );
end component;

begin

u_SE_dataplane : SE_dataplane
  port map(
    clk                         =>  clk,
    reset                       =>  reset,
    clk_enable                  =>  '1',
    avalon_sink_valid           =>  avalon_sink_valid,               -- boolean
    avalon_sink_data            =>  avalon_sink_data,                -- sfix32_En28
    avalon_sink_channel         =>  avalon_sink_channel,             -- ufix2
    avalon_sink_error           =>  avalon_sink_error,               -- ufix2
    register_control_bypass     =>  bypass,                          -- boolean
    register_control_delay      =>  delay,                           -- sfix32_En28
    register_control_decay      =>  decay,                           -- ufix2
    register_control_wet_dry_mix=>  wet_dry_mix,                     -- ufix2
    avalon_source_valid         =>  avalon_source_valid,             -- boolean
    avalon_source_data          =>  avalon_source_data,              -- sfix32_En28
    avalon_source_channel       =>  avalon_source_channel,           -- ufix2
    avalon_source_error         =>  avalon_source_error              -- ufix2
  );

  bus_read : process(clk)
  begin
    if rising_edge(clk) and avalon_slave_read = '1' then
      case avalon_slave_address is
        when "00" => avalon_slave_readdata <= (31 downto 1 => '0') & bypass;
        when "01" => avalon_slave_readdata <= (31 downto 16 => '0') & delay;
        when "10" => avalon_slave_readdata <= (31 downto 5 => '0') & decay;
        when "11" => avalon_slave_readdata <= (31 downto 5 => '0') & wet_dry_mix;
        when others => avalon_slave_readdata <= (others => '0');
      end case;
    end if;
  end process;

  bus_write : process(clk, reset)
  begin
    if reset = '1' then
      bypass                    <=  '0'; -- 0
      delay                     <=  std_logic_vector(to_unsigned(24000, 16)); -- 24000
      decay                     <=  "01101"; -- 0.8
      wet_dry_mix               <=  "01000"; -- 0.5
    elsif rising_edge(clk) and avalon_slave_write = '1' then
      case avalon_slave_address is
        when "00" => bypass <= avalon_slave_writedata(0);
        when "01" => delay <= avalon_slave_writedata(15 downto 0);
        when "10" => decay <= avalon_slave_writedata(4 downto 0);
        when "11" => wet_dry_mix <= avalon_slave_writedata(4 downto 0);
        when others => null;
      end case;
    end if;
  end process;

end architecture;