library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataPlane_avalon is
  port (
    clk                       : in  std_logic;
    reset                     : in  std_logic;
    Avalon_Sink_Valid         : in  std_logic; --boolean
    Avalon_Sink_Data          : in  std_logic_vector(31  downto 0); --sfix32_En28
    Avalon_Sink_Channel       : in  std_logic_vector(1   downto 0); --ufix2
    Avalon_Sink_Error         : in  std_logic_vector(1   downto 0); --ufix2
    Avalon_Source_Valid       : out std_logic; --boolean
    Avalon_Source_Data        : out std_logic_vector(31  downto 0); --sfix32_En28
    Avalon_Source_Channel     : out std_logic_vector(1   downto 0); --ufix2
    Avalon_Source_Error       : out std_logic_vector(1   downto 0); --ufix2
    s1_address                : in  std_logic_vector(1   downto 0);            
    s1_read                   : in  std_logic;
    s1_readdata               : out std_logic_vector(31  downto 0);
    s1_write                  : in  std_logic;
    s1_writedata              : in  std_logic_vector(31  downto 0);
    LED                       : out std_logic_vector(7   downto 0) --uint8
  );
end entity DataPlane_avalon;

architecture DataPlane_avalon_arch of DataPlane_avalon is

  signal Left_Gain                 : std_logic_vector(31  downto 0) :=  "00000000000000010000000000000000";
  signal Right_Gain                : std_logic_vector(31  downto 0) :=  "00000000000000010000000000000000";
  signal Reset_Threshold           : std_logic_vector(31  downto 0) :=  "00000000000000000010010110000000";
  signal LED_Persistence           : std_logic_vector(31  downto 0) :=  "00000000000000000000100101100000";

ComPoNeNt DataPlane_src_DataPlane
  port(
    clk                       : in  std_logic; -- clk_freq = 1 Hz, period = 0.1
    clk_enable                : in  std_logic;
    reset                     : in  std_logic;
    Avalon_Sink_Valid         : in  std_logic;                              -- boolean
    Avalon_Sink_Data          : in  std_logic_vector(31  downto 0);         -- sfix32_En28
    Avalon_Sink_Channel       : in  std_logic_vector(1   downto 0);         -- ufix2
    Avalon_Sink_Error         : in  std_logic_vector(1   downto 0);         -- ufix2
    Left_Gain                 : in  std_logic_vector(31  downto 0);         -- ufix32_En16
    Right_Gain                : in  std_logic_vector(31  downto 0);         -- ufix32_En16
    Reset_Threshold           : in  std_logic_vector(31  downto 0);         -- uint32
    LED_Persistence           : in  std_logic_vector(31  downto 0);         -- uint32
    ce_out                    : out std_logic;
    Avalon_Source_Valid       : out std_logic;                              -- boolean
    Avalon_Source_Data        : out std_logic_vector(31  downto 0);         -- sfix32_En28
    Avalon_Source_Channel     : out std_logic_vector(1   downto 0);         -- ufix2
    Avalon_Source_Error       : out std_logic_vector(1   downto 0);         -- ufix2
    Export_LED                : out std_logic_vector(7   downto 0)          -- uint8
  );

begin

u_DataPlane_src_DataPlane : DataPlane_src_DataPlane
  port map(
    clk                       =>  clk,
    clk_enable                =>  '1',
    reset                     =>  reset,
    Avalon_Sink_Valid         =>  Avalon_Sink_Valid,             -- boolean
    Avalon_Sink_Data          =>  Avalon_Sink_Data,              -- sfix32_En28
    Avalon_Sink_Channel       =>  Avalon_Sink_Channel,           -- ufix2
    Avalon_Sink_Error         =>  Avalon_Sink_Error,             -- ufix2
    Left_Gain                 =>  Left_Gain,                     -- boolean
    Right_Gain                =>  Right_Gain,                    -- sfix32_En28
    Reset_Threshold           =>  Reset_Threshold,               -- ufix2
    LED_Persistence           =>  LED_Persistence,               -- ufix2
    Avalon_Source_Valid       =>  Avalon_Source_Valid,           -- boolean
    Avalon_Source_Data        =>  Avalon_Source_Data,            -- sfix32_En28
    Avalon_Source_Channel     =>  Avalon_Source_Channel,         -- ufix2
    Avalon_Source_Error       =>  Avalon_Source_Error,           -- ufix2
    Export_LED                =>  LED                            -- boolean
  );
  bus_read : process(clk)
  begin
    if rising_edge(clk) and s1_read = '1' then
      case s1_address is
        when "00" => s1_readdata <= Left_Gain;
        when "01" => s1_readdata <= Right_Gain;
        when "10" => s1_readdata <= Reset_Threshold;
        when "11" => s1_readdata <= LED_Persistence;
        when others => s1_readdata <= (others => '0');
      end case;
    end if;
  end process;

  bus_write : process(clk, reset)
  begin
    if reset = '1' then
      Left_Gain                 <=  "00000000000000010000000000000000";
      Right_Gain                <=  "00000000000000010000000000000000";
      Reset_Threshold           <=  "00000000000000000010010110000000";
      LED_Persistence           <=  "00000000000000000000100101100000";
    elsif rising_edge(clk) and s1_write = '1' then
      case s1_address is
        when "00" => Left_Gain <= s1_writedata;
        when "01" => Right_Gain <= s1_writedata;
        when "10" => Reset_Threshold <= s1_writedata;
        when "11" => LED_Persistence <= s1_writedata;
        when others => null;
      end case;
    end if;
  end process;

end architecture;