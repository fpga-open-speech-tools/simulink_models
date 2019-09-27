library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SG_dataplane_with_DPRAM_avalon is
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
    avalon_slave_address      : in  std_logic_vector(9   downto 0); -- DPRAM size 512          
    avalon_slave_read         : in  std_logic;
    avalon_slave_readdata     : out std_logic_vector(31  downto 0);
    avalon_slave_write        : in  std_logic;
    avalon_slave_writedata    : in  std_logic_vector(31  downto 0)
  );
end entity SG_dataplane_with_DPRAM_avalon;

architecture SG_dataplane_with_DPRAM_avalon_arch of SG_dataplane_with_DPRAM_avalon is

  signal left_gain                 : std_logic_vector(31  downto 0) :=  "00010000000000000000000000000000"; -- 1
  signal right_gain                : std_logic_vector(31  downto 0) :=  "00010000000000000000000000000000"; -- 1
  signal DPRAM_data					  : std_logic_vector(31	 downto 0) :=  "00000000000000000000000000000000"; -- default data to 0
  signal DPRAM_address				  : std_logic_vector(8	 downto 0) :=	"000000000"									-- default address to 0
	
component SG_dataplane_with_DPRAM	-- DPRAM size 512
  port(
    clk                         : in  std_logic; -- clk_freq = 1 Hz, period = 0.1
    reset                       : in  std_logic;
    clk_enable                  : in  std_logic;
    avalon_sink_valid           : in  std_logic;                              -- boolean
    avalon_sink_data            : in  std_logic_vector(31  downto 0);         -- sfix32_En28
    avalon_sink_channel         : in  std_logic_vector(1   downto 0);         -- ufix2
    avalon_sink_error           : in  std_logic_vector(1   downto 0);         -- ufix2
    register_control_left_gain  : in  std_logic_vector(31  downto 0);         -- sfix32_En28
    register_control_right_gain : in  std_logic_vector(31  downto 0);         -- sfix32_En28
    register_control_data		  : in  std_logic_vector(31 DOWNTO 0);	-- data sent only to DPRAM
	 register_control_address	  : in  std_logic_vector(8 DOWNTO 0);	-- address to write DPRAM_data to 
	 ce_out                      : out std_logic;
    avalon_source_valid         : out std_logic;                              -- boolean
    avalon_source_data          : out std_logic_vector(31  downto 0);         -- sfix32_En28
    avalon_source_channel       : out std_logic_vector(1   downto 0);         -- ufix2
    avalon_source_error         : out std_logic_vector(1   downto 0)          -- ufix2
  );
end component;

begin

u_SG_dataplane_with_DPRAM : SG_dataplane_with_DPRAM
  port map(
    clk                         =>  clk,
    reset                       =>  reset,
    clk_enable                  =>  '1',
    avalon_sink_valid           =>  avalon_sink_valid,               -- boolean
    avalon_sink_data            =>  avalon_sink_data,                -- sfix32_En28
    avalon_sink_channel         =>  avalon_sink_channel,             -- ufix2
    avalon_sink_error           =>  avalon_sink_error,               -- ufix2
    register_control_left_gain  =>  left_gain,                       -- boolean
    register_control_right_gain =>  right_gain,                      -- sfix32_En28
	 register_control_data		  =>  DPRAM_data,								-- data sent only to DPRAM
	 register_control_address	  =>	DPRAM_address,							-- address to write DPRAM_data to 
    avalon_source_valid         =>  avalon_source_valid,             -- boolean
    avalon_source_data          =>  avalon_source_data,              -- sfix32_En28
    avalon_source_channel       =>  avalon_source_channel,           -- ufix2
    avalon_source_error         =>  avalon_source_error              -- ufix2
  );

  bus_read : process(clk)
  begin
    if rising_edge(clk) and avalon_slave_read = '1' then
      case avalon_slave_address(avalon_slave_address'left) is
		  -- read from DPRAM, but this takes a clock cycle and requires a write to
		  --  some read address that goes into the DPRAM block. Maybe set this up to 
		  --  read just from last used DPRAM_data or DPRAM_address?
		  -- also, identify if DPRAM block has a different port for reading or writing with port A
		  
		  -- Another option is to disable the write on the DPRAM block, read instead,
		  --  from the given address, then next clock cycle push that data to readdata
		  
        -- WIP, needs testing and likely fixing or adding extra ports to dataplane component
		  when "0" => -- read from DPRAM
						  DPRAM_address <= avalon_slave_address(avalon_slave_address'left-1 downto 0)	-- get all but MSB
						  --DPRAM_RW_bit <= '0';
						  avalon_slave_readdata <= DPRAM_data;		-- read from 
						  
		  when "1" => -- read from registers instead
			  case avalon_slaveaddress(avalon_slave_address'left-1 downto 0)
				  when "0" => avalon_slave_readdata <= left_gain;
				  when "1" => avalon_slave_readdata <= right_gain;
			  end case;
			  
        when others => avalon_slave_readdata <= (others => '0');
      end case;
    end if;
  end process;

  bus_write : process(clk, reset)
  begin
    if reset = '1' then
      left_gain                 <=  "00010000000000000000000000000000"; -- 1
      right_gain                <=  "00010000000000000000000000000000"; -- 1
    elsif rising_edge(clk) and avalon_slave_write = '1' then
      case avalon_slave_address(avalon_slave_address'left) is
        when "0" => left_gain <= avalon_slave_writedata;
        when "1" => right_gain <= avalon_slave_writedata;
        when others => null;
      end case;
    end if;
  end process;

end architecture;