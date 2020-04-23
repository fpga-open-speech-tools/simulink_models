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
	-- Interface for register control
	avalon_slave_0_address      : in  std_logic_vector(0   downto 0);         
    avalon_slave_0_read         : in  std_logic;							
    avalon_slave_0_readdata     : out std_logic_vector(31  downto 0);		
    avalon_slave_0_write        : in  std_logic;							
    avalon_slave_0_writedata    : in  std_logic_vector(31  downto 0);
	-- Interface for ram control 
    avalon_slave_1_address      : in  std_logic_vector(8   downto 0);    	-- to addr         
    avalon_slave_1_read         : in  std_logic;							-- case select? nothing? use this to update rw_dout? maybe just use !write? 
    avalon_slave_1_readdata     : out std_logic_vector(31  downto 0);		-- from RW_dout, always? when !write? when read? 
    avalon_slave_1_write        : in  std_logic;							-- wr_en
    avalon_slave_1_writedata    : in  std_logic_vector(31  downto 0)		-- to Wr_Data
  );
end entity pFIR_Testing_dataplane_avalon;

-- setup a second avalon slave interface 

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
    ram_control_Wr_Data    		: in  std_logic_vector(31  downto 0);         -- sfix32_En28
    ram_control_RW_Addr    		: in  std_logic_vector(31  downto 0);         -- uint32
    ram_control_Wr_En      		: in  std_logic_vector(31  downto 0);         -- int32
    ce_out                      : out std_logic;
    avalon_source_valid         : out std_logic;                              -- ufix1
    avalon_source_data          : out std_logic_vector(31  downto 0);         -- sfix32_En28
    avalon_source_channel       : out std_logic_vector(1   downto 0);         -- ufix2
    avalon_source_error         : out std_logic_vector(1   downto 0);         -- ufix2
    ram_control_rw_dout       	: out std_logic_vector(31  downto 0)          -- sfix32_En28
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
    ram_control_Wr_Data    		=>  Wr_Data,                         -- sfix32_En28
    ram_control_RW_Addr    		=>  RW_Addr,                         -- uint32
    ram_control_Wr_En      		=>  Wr_En,                           -- int32
    avalon_source_valid         =>  avalon_source_valid,             -- ufix1
    avalon_source_data          =>  avalon_source_data,              -- sfix32_En28
    avalon_source_channel       =>  avalon_source_channel,           -- ufix2
    avalon_source_rw_dout       =>  RW_dout,           -- sfix32_En28
    avalon_source_error         =>  avalon_source_error              -- ufix2
  );

  bus_read_0 : process(clk)
  begin
    if rising_edge(clk) and avalon_slave_0_read = '1' then
      case avalon_slave_0_address is
        when "0" => avalon_slave_0_readdata <= enable;
        when others => avalon_slave_0_readdata <= (others => '0');
      end case;
    end if;
  end process;
	
  -- bus_read_1 : process(clk)
  -- begin
    -- if rising_edge(clk) then
	  
      -- avalon_slave_1_readdata <= RW_dout;
	-- end if;
  -- end process;
  
  bus_write_0 : process(clk, reset)
  begin
    if reset = '1' then
      enable                    <=  "00010000000000000000000000000000"; -- 1 (sfix32_En28)
    elsif rising_edge(clk) and avalon_slave_0_write = '1' then
      case avalon_slave_0_address is
        when "0" => enable <= avalon_slave_0_writedata(31 downto 0);
		when others => null;
      end case;
    end if;
  end process;

  bus_write_1 : process(clk, reset)
  begin 
  if reset = '1' then
	  Wr_Data	    <=  (others => '0');
      RW_Addr       <=  (others => '0');
	  Wr_En			<= 	(others => '0');
    elsif rising_edge(clk) and (avalon_slave_1_write = '1' or avalon_slave_1_read = '1') then 
	  RW_Addr(8 downto 0) 	<= avalon_slave_1_address(8 downto 0);
	  avalon_slave_1_readdata <= RW_dout;	-- TESTING
	  Wr_En(0)				<= avalon_slave_1_write;
	  if avalon_slave_1_write = '1' then 
	    Wr_Data 				<= avalon_slave_1_writedata; 
	  end if;
    end if;
	
	
  end process;

end architecture;