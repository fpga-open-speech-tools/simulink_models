library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pFIR_Testing_dataplane_avalon is
  port (
    clk                       : in  std_logic;
    reset                     : in  std_logic;
    avalon_sink_valid         : in  std_logic; --boolean
    avalon_sink_data          : in  std_logic_vector(31  downto 0); --sfix32_En28
    avalon_sink_channel       : in  std_logic_vector(1   downto 0); --ufix2
    avalon_sink_error         : in  std_logic_vector(1   downto 0); --ufix2
    avalon_source_valid       : out std_logic; --ufix1
    avalon_source_data        : out std_logic_vector(31  downto 0); --sfix32_En28
    avalon_source_channel     : out std_logic_vector(1   downto 0); --ufix2
    avalon_source_error       : out std_logic_vector(1   downto 0); --ufix2
    avalon_slave_address      : in  std_logic_vector(2   downto 0);            
    avalon_slave_read         : in  std_logic;
    avalon_slave_readdata     : out std_logic_vector(31  downto 0);
    avalon_slave_write        : in  std_logic;
    avalon_slave_writedata    : in  std_logic_vector(31  downto 0)
  );
end entity pFIR_Testing_dataplane_avalon;

architecture pFIR_Testing_dataplane_avalon_arch of pFIR_Testing_dataplane_avalon is

  signal enable                    : std_logic_vector(31  downto 0) :=  "00010000000000000000000000000000"; -- 1 (sfix32_En28)
  signal Wr_Data                   : std_logic_vector(31  downto 0) :=  "00000000000000000000000000000000"; -- 0 (sfix32_En28)
  signal RW_Addr                   : std_logic_vector(31  downto 0) :=  "00000000000000000000000000000000"; -- 0 (uint32)
  signal Wr_En                     : std_logic_vector(31  downto 0) :=  "00000000000000000000000000000000"; -- 0 (int32)
  signal RW_dout     			   : std_logic_vector(31  downto 0) :=  "00000000000000000000000000000000"; --sfix32_En28

component pFIR_Testing_dataplane
  port(
    clk                         : in  std_logic; -- clk_freq = 1 Hz, period = 0.1
    reset                       : in  std_logic;
    clk_enable                  : in  std_logic;
    avalon_sink_valid           : in  std_logic;                              -- boolean
    avalon_sink_data            : in  std_logic_vector(31  downto 0);         -- sfix32_En28
    avalon_sink_channel         : in  std_logic_vector(1   downto 0);         -- ufix2
    avalon_sink_error           : in  std_logic_vector(1   downto 0);         -- ufix2
    register_control_enable     : in  std_logic_vector(31  downto 0);         -- sfix32_En28
    register_control_Wr_Data    : in  std_logic_vector(31  downto 0);         -- sfix32_En28
    register_control_RW_Addr    : in  std_logic_vector(31  downto 0);         -- uint32
    register_control_Wr_En      : in  std_logic_vector(31  downto 0);         -- int32
    ce_out                      : out std_logic;
    avalon_source_valid         : out std_logic;                              -- ufix1
    avalon_source_data          : out std_logic_vector(31  downto 0);         -- sfix32_En28
    avalon_source_channel       : out std_logic_vector(1   downto 0);         -- ufix2
    avalon_source_rw_dout       : out std_logic_vector(31  downto 0);         -- sfix32_En28
    avalon_source_error         : out std_logic_vector(1   downto 0)          -- ufix2
  );
end component;

begin

u_pFIR_Testing_dataplane : pFIR_Testing_dataplane
  port map(
    clk                         =>  clk,
    reset                       =>  reset,
    clk_enable                  =>  '1',
    avalon_sink_valid           =>  avalon_sink_valid,               -- boolean
    avalon_sink_data            =>  avalon_sink_data,                -- sfix32_En28
    avalon_sink_channel         =>  avalon_sink_channel,             -- ufix2
    avalon_sink_error           =>  avalon_sink_error,               -- ufix2
    register_control_enable     =>  enable,                          -- sfix32_En28
    register_control_Wr_Data    =>  Wr_Data,                         -- sfix32_En28
    register_control_RW_Addr    =>  RW_Addr,                         -- uint32
    register_control_Wr_En      =>  Wr_En,                           -- int32
    avalon_source_valid         =>  avalon_source_valid,             -- ufix1
    avalon_source_data          =>  avalon_source_data,              -- sfix32_En28
    avalon_source_channel       =>  avalon_source_channel,           -- ufix2
    avalon_source_rw_dout       =>  avalon_source_rw_dout,           -- sfix32_En28
    avalon_source_error         =>  avalon_source_error              -- ufix2
  );

  bus_read : process(clk)
  begin
    if rising_edge(clk) and avalon_slave_read = '1' then
      case avalon_slave_address is
        when "000" => avalon_slave_readdata <= enable;
        when "001" => avalon_slave_readdata <= Wr_Data;
        when "010" => avalon_slave_readdata <= RW_Addr;
        when "011" => avalon_slave_readdata <= Wr_En;
        when others => avalon_slave_readdata <= (others => '0');
      end case;
    end if;
  end process;

  bus_write : process(clk, reset)
  begin
    if reset = '1' then
      enable                    <=  "00010000000000000000000000000000"; -- 1 (sfix32_En28)
      Wr_Data                   <=  "00000000000000000000000000000000"; -- 0 (sfix32_En28)
      RW_Addr                   <=  "00000000000000000000000000000000"; -- 0 (uint32)
      Wr_En                     <=  "00000000000000000000000000000000"; -- 0 (int32)
	  RW_dout     				<=  "00000000000000000000000000000000"; -- 0 (sfix32_En28)
    elsif rising_edge(clk) and avalon_slave_write = '1' then
      case avalon_slave_address is
        when "000" => enable <= avalon_slave_writedata(31 downto 0);
        when "001" => Wr_Data <= avalon_slave_writedata(31 downto 0);
        when "010" => RW_Addr <= avalon_slave_writedata(31 downto 0);
        when "011" => Wr_En <= avalon_slave_writedata(31 downto 0);
		when "100" => RW_dout <= avalon_slave_writedata(31 downto 0);
        when others => null;
      end case;
    end if;
  end process;

end architecture;