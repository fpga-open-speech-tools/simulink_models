library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package audioblade_system_pkg is
	component mux_ddr is
		port (
			reset                                : in  std_logic                     := 'X';             -- reset
			clock                                : in  std_logic                     := 'X';             -- clk
			hps_master_araddr                    : out std_logic_vector(31 downto 0);                    -- araddr
			hps_master_arburst                   : out std_logic_vector(1 downto 0);                     -- arburst
			hps_master_arcache                   : out std_logic_vector(3 downto 0);                     -- arcache
			hps_master_arid                      : out std_logic_vector(3 downto 0);                     -- arid
			hps_master_arlen                     : out std_logic_vector(3 downto 0);                     -- arlen
			hps_master_arlock                    : out std_logic_vector(1 downto 0);                     -- arlock
			hps_master_arprot                    : out std_logic_vector(2 downto 0);                     -- arprot
			hps_master_arready                   : in  std_logic                     := 'X';             -- arready
			hps_master_arsize                    : out std_logic_vector(2 downto 0);                     -- arsize
			hps_master_aruser                    : out std_logic_vector(4 downto 0);                     -- aruser
			hps_master_arvalid                   : out std_logic;                                        -- arvalid
			hps_master_awaddr                    : out std_logic_vector(31 downto 0);                    -- awaddr
			hps_master_awburst                   : out std_logic_vector(1 downto 0);                     -- awburst
			hps_master_awcache                   : out std_logic_vector(3 downto 0);                     -- awcache
			hps_master_awid                      : out std_logic_vector(3 downto 0);                     -- awid
			hps_master_awlen                     : out std_logic_vector(3 downto 0);                     -- awlen
			hps_master_awlock                    : out std_logic_vector(1 downto 0);                     -- awlock
			hps_master_awprot                    : out std_logic_vector(2 downto 0);                     -- awprot
			hps_master_awready                   : in  std_logic                     := 'X';             -- awready
			hps_master_awsize                    : out std_logic_vector(2 downto 0);                     -- awsize
			hps_master_awuser                    : out std_logic_vector(4 downto 0);                     -- awuser
			hps_master_awvalid                   : out std_logic;                                        -- awvalid
			hps_master_bid                       : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- bid
			hps_master_bready                    : out std_logic;                                        -- bready
			hps_master_bresp                     : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- bresp
			hps_master_bvalid                    : in  std_logic                     := 'X';             -- bvalid
			hps_master_rdata                     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- rdata
			hps_master_rid                       : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- rid
			hps_master_rlast                     : in  std_logic                     := 'X';             -- rlast
			hps_master_rready                    : out std_logic;                                        -- rready
			hps_master_rresp                     : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- rresp
			hps_master_rvalid                    : in  std_logic                     := 'X';             -- rvalid
			hps_master_wdata                     : out std_logic_vector(31 downto 0);                    -- wdata
			hps_master_wid                       : out std_logic_vector(3 downto 0);                     -- wid
			hps_master_wlast                     : out std_logic;                                        -- wlast
			hps_master_wready                    : in  std_logic                     := 'X';             -- wready
			hps_master_wstrb                     : out std_logic_vector(3 downto 0);                     -- wstrb
			hps_master_wvalid                    : out std_logic;                                        -- wvalid
			arria10_hps_0_h2f_axi_master_awid    : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- awid
			arria10_hps_0_h2f_axi_master_awaddr  : in  std_logic_vector(28 downto 0) := (others => 'X'); -- awaddr
			arria10_hps_0_h2f_axi_master_awlen   : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- awlen
			arria10_hps_0_h2f_axi_master_awsize  : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- awsize
			arria10_hps_0_h2f_axi_master_awburst : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- awburst
			arria10_hps_0_h2f_axi_master_awlock  : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- awlock
			arria10_hps_0_h2f_axi_master_awcache : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- awcache
			arria10_hps_0_h2f_axi_master_awprot  : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- awprot
			arria10_hps_0_h2f_axi_master_awvalid : in  std_logic                     := 'X';             -- awvalid
			arria10_hps_0_h2f_axi_master_awready : out std_logic;                                        -- awready
			arria10_hps_0_h2f_axi_master_awuser  : in  std_logic_vector(4 downto 0)  := (others => 'X'); -- awuser
			arria10_hps_0_h2f_axi_master_wid     : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- wid
			arria10_hps_0_h2f_axi_master_wdata   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- wdata
			arria10_hps_0_h2f_axi_master_wstrb   : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- wstrb
			arria10_hps_0_h2f_axi_master_wlast   : in  std_logic                     := 'X';             -- wlast
			arria10_hps_0_h2f_axi_master_wvalid  : in  std_logic                     := 'X';             -- wvalid
			arria10_hps_0_h2f_axi_master_wready  : out std_logic;                                        -- wready
			arria10_hps_0_h2f_axi_master_bid     : out std_logic_vector(3 downto 0);                     -- bid
			arria10_hps_0_h2f_axi_master_bresp   : out std_logic_vector(1 downto 0);                     -- bresp
			arria10_hps_0_h2f_axi_master_bvalid  : out std_logic;                                        -- bvalid
			arria10_hps_0_h2f_axi_master_bready  : in  std_logic                     := 'X';             -- bready
			arria10_hps_0_h2f_axi_master_arid    : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- arid
			arria10_hps_0_h2f_axi_master_araddr  : in  std_logic_vector(28 downto 0) := (others => 'X'); -- araddr
			arria10_hps_0_h2f_axi_master_arlen   : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- arlen
			arria10_hps_0_h2f_axi_master_arsize  : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- arsize
			arria10_hps_0_h2f_axi_master_arburst : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- arburst
			arria10_hps_0_h2f_axi_master_arlock  : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- arlock
			arria10_hps_0_h2f_axi_master_arcache : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- arcache
			arria10_hps_0_h2f_axi_master_arprot  : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- arprot
			arria10_hps_0_h2f_axi_master_arvalid : in  std_logic                     := 'X';             -- arvalid
			arria10_hps_0_h2f_axi_master_arready : out std_logic;                                        -- arready
			arria10_hps_0_h2f_axi_master_aruser  : in  std_logic_vector(4 downto 0)  := (others => 'X'); -- aruser
			arria10_hps_0_h2f_axi_master_rid     : out std_logic_vector(3 downto 0);                     -- rid
			arria10_hps_0_h2f_axi_master_rdata   : out std_logic_vector(31 downto 0);                    -- rdata
			arria10_hps_0_h2f_axi_master_rresp   : out std_logic_vector(1 downto 0);                     -- rresp
			arria10_hps_0_h2f_axi_master_rlast   : out std_logic;                                        -- rlast
			arria10_hps_0_h2f_axi_master_rvalid  : out std_logic;                                        -- rvalid
			arria10_hps_0_h2f_axi_master_rready  : in  std_logic                     := 'X';             -- rready
			add_sel                              : in  std_logic_vector(2 downto 0)  := (others => 'X')  -- add_sel
		);
	end component mux_ddr;

end audioblade_system_pkg;
