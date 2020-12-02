library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package audioblade_system_pkg is
	component audioblade_system_altera_mm_interconnect_180_d4sniia is
		port (
			mux_ddr_0_altera_axi_master_awid                                : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- awid
			mux_ddr_0_altera_axi_master_awaddr                              : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- awaddr
			mux_ddr_0_altera_axi_master_awlen                               : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- awlen
			mux_ddr_0_altera_axi_master_awsize                              : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- awsize
			mux_ddr_0_altera_axi_master_awburst                             : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- awburst
			mux_ddr_0_altera_axi_master_awlock                              : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- awlock
			mux_ddr_0_altera_axi_master_awcache                             : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- awcache
			mux_ddr_0_altera_axi_master_awprot                              : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- awprot
			mux_ddr_0_altera_axi_master_awuser                              : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- awuser
			mux_ddr_0_altera_axi_master_awvalid                             : in  std_logic                      := 'X';             -- awvalid
			mux_ddr_0_altera_axi_master_awready                             : out std_logic;                                         -- awready
			mux_ddr_0_altera_axi_master_wid                                 : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- wid
			mux_ddr_0_altera_axi_master_wdata                               : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- wdata
			mux_ddr_0_altera_axi_master_wstrb                               : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- wstrb
			mux_ddr_0_altera_axi_master_wlast                               : in  std_logic                      := 'X';             -- wlast
			mux_ddr_0_altera_axi_master_wvalid                              : in  std_logic                      := 'X';             -- wvalid
			mux_ddr_0_altera_axi_master_wready                              : out std_logic;                                         -- wready
			mux_ddr_0_altera_axi_master_bid                                 : out std_logic_vector(3 downto 0);                      -- bid
			mux_ddr_0_altera_axi_master_bresp                               : out std_logic_vector(1 downto 0);                      -- bresp
			mux_ddr_0_altera_axi_master_bvalid                              : out std_logic;                                         -- bvalid
			mux_ddr_0_altera_axi_master_bready                              : in  std_logic                      := 'X';             -- bready
			mux_ddr_0_altera_axi_master_arid                                : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- arid
			mux_ddr_0_altera_axi_master_araddr                              : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- araddr
			mux_ddr_0_altera_axi_master_arlen                               : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- arlen
			mux_ddr_0_altera_axi_master_arsize                              : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- arsize
			mux_ddr_0_altera_axi_master_arburst                             : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- arburst
			mux_ddr_0_altera_axi_master_arlock                              : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- arlock
			mux_ddr_0_altera_axi_master_arcache                             : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- arcache
			mux_ddr_0_altera_axi_master_arprot                              : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- arprot
			mux_ddr_0_altera_axi_master_aruser                              : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- aruser
			mux_ddr_0_altera_axi_master_arvalid                             : in  std_logic                      := 'X';             -- arvalid
			mux_ddr_0_altera_axi_master_arready                             : out std_logic;                                         -- arready
			mux_ddr_0_altera_axi_master_rid                                 : out std_logic_vector(3 downto 0);                      -- rid
			mux_ddr_0_altera_axi_master_rdata                               : out std_logic_vector(31 downto 0);                     -- rdata
			mux_ddr_0_altera_axi_master_rresp                               : out std_logic_vector(1 downto 0);                      -- rresp
			mux_ddr_0_altera_axi_master_rlast                               : out std_logic;                                         -- rlast
			mux_ddr_0_altera_axi_master_rvalid                              : out std_logic;                                         -- rvalid
			mux_ddr_0_altera_axi_master_rready                              : in  std_logic                      := 'X';             -- rready
			axi_clk_bridge_out_clk_clk                                      : in  std_logic                      := 'X';             -- clk
			clk_1_clk_clk                                                   : in  std_logic                      := 'X';             -- clk
			mm_clock_crossing_bridge_0_s0_reset_reset_bridge_in_reset_reset : in  std_logic                      := 'X';             -- reset
			mux_ddr_0_reset_reset_bridge_in_reset_reset                     : in  std_logic                      := 'X';             -- reset
			mm_clock_crossing_bridge_0_s0_address                           : out std_logic_vector(31 downto 0);                     -- address
			mm_clock_crossing_bridge_0_s0_write                             : out std_logic;                                         -- write
			mm_clock_crossing_bridge_0_s0_read                              : out std_logic;                                         -- read
			mm_clock_crossing_bridge_0_s0_readdata                          : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			mm_clock_crossing_bridge_0_s0_writedata                         : out std_logic_vector(511 downto 0);                    -- writedata
			mm_clock_crossing_bridge_0_s0_burstcount                        : out std_logic_vector(6 downto 0);                      -- burstcount
			mm_clock_crossing_bridge_0_s0_byteenable                        : out std_logic_vector(63 downto 0);                     -- byteenable
			mm_clock_crossing_bridge_0_s0_readdatavalid                     : in  std_logic                      := 'X';             -- readdatavalid
			mm_clock_crossing_bridge_0_s0_waitrequest                       : in  std_logic                      := 'X';             -- waitrequest
			mm_clock_crossing_bridge_0_s0_debugaccess                       : out std_logic                                          -- debugaccess
		);
	end component audioblade_system_altera_mm_interconnect_180_d4sniia;

	component audioblade_system_altera_mm_interconnect_180_2zdh4ci is
		port (
			arria10_hps_0_h2f_axi_master_awid                       : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- awid
			arria10_hps_0_h2f_axi_master_awaddr                     : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- awaddr
			arria10_hps_0_h2f_axi_master_awlen                      : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- awlen
			arria10_hps_0_h2f_axi_master_awsize                     : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- awsize
			arria10_hps_0_h2f_axi_master_awburst                    : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- awburst
			arria10_hps_0_h2f_axi_master_awlock                     : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- awlock
			arria10_hps_0_h2f_axi_master_awcache                    : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- awcache
			arria10_hps_0_h2f_axi_master_awprot                     : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- awprot
			arria10_hps_0_h2f_axi_master_awuser                     : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- awuser
			arria10_hps_0_h2f_axi_master_awvalid                    : in  std_logic                      := 'X';             -- awvalid
			arria10_hps_0_h2f_axi_master_awready                    : out std_logic;                                         -- awready
			arria10_hps_0_h2f_axi_master_wid                        : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- wid
			arria10_hps_0_h2f_axi_master_wdata                      : in  std_logic_vector(127 downto 0) := (others => 'X'); -- wdata
			arria10_hps_0_h2f_axi_master_wstrb                      : in  std_logic_vector(15 downto 0)  := (others => 'X'); -- wstrb
			arria10_hps_0_h2f_axi_master_wlast                      : in  std_logic                      := 'X';             -- wlast
			arria10_hps_0_h2f_axi_master_wvalid                     : in  std_logic                      := 'X';             -- wvalid
			arria10_hps_0_h2f_axi_master_wready                     : out std_logic;                                         -- wready
			arria10_hps_0_h2f_axi_master_bid                        : out std_logic_vector(3 downto 0);                      -- bid
			arria10_hps_0_h2f_axi_master_bresp                      : out std_logic_vector(1 downto 0);                      -- bresp
			arria10_hps_0_h2f_axi_master_bvalid                     : out std_logic;                                         -- bvalid
			arria10_hps_0_h2f_axi_master_bready                     : in  std_logic                      := 'X';             -- bready
			arria10_hps_0_h2f_axi_master_arid                       : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- arid
			arria10_hps_0_h2f_axi_master_araddr                     : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- araddr
			arria10_hps_0_h2f_axi_master_arlen                      : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- arlen
			arria10_hps_0_h2f_axi_master_arsize                     : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- arsize
			arria10_hps_0_h2f_axi_master_arburst                    : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- arburst
			arria10_hps_0_h2f_axi_master_arlock                     : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- arlock
			arria10_hps_0_h2f_axi_master_arcache                    : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- arcache
			arria10_hps_0_h2f_axi_master_arprot                     : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- arprot
			arria10_hps_0_h2f_axi_master_aruser                     : in  std_logic_vector(4 downto 0)   := (others => 'X'); -- aruser
			arria10_hps_0_h2f_axi_master_arvalid                    : in  std_logic                      := 'X';             -- arvalid
			arria10_hps_0_h2f_axi_master_arready                    : out std_logic;                                         -- arready
			arria10_hps_0_h2f_axi_master_rid                        : out std_logic_vector(3 downto 0);                      -- rid
			arria10_hps_0_h2f_axi_master_rdata                      : out std_logic_vector(127 downto 0);                    -- rdata
			arria10_hps_0_h2f_axi_master_rresp                      : out std_logic_vector(1 downto 0);                      -- rresp
			arria10_hps_0_h2f_axi_master_rlast                      : out std_logic;                                         -- rlast
			arria10_hps_0_h2f_axi_master_rvalid                     : out std_logic;                                         -- rvalid
			arria10_hps_0_h2f_axi_master_rready                     : in  std_logic                      := 'X';             -- rready
			mux_ddr_0_altera_axi_slave_awid                         : out std_logic_vector(3 downto 0);                      -- awid
			mux_ddr_0_altera_axi_slave_awaddr                       : out std_logic_vector(28 downto 0);                     -- awaddr
			mux_ddr_0_altera_axi_slave_awlen                        : out std_logic_vector(3 downto 0);                      -- awlen
			mux_ddr_0_altera_axi_slave_awsize                       : out std_logic_vector(2 downto 0);                      -- awsize
			mux_ddr_0_altera_axi_slave_awburst                      : out std_logic_vector(1 downto 0);                      -- awburst
			mux_ddr_0_altera_axi_slave_awlock                       : out std_logic_vector(1 downto 0);                      -- awlock
			mux_ddr_0_altera_axi_slave_awcache                      : out std_logic_vector(3 downto 0);                      -- awcache
			mux_ddr_0_altera_axi_slave_awprot                       : out std_logic_vector(2 downto 0);                      -- awprot
			mux_ddr_0_altera_axi_slave_awuser                       : out std_logic_vector(4 downto 0);                      -- awuser
			mux_ddr_0_altera_axi_slave_awvalid                      : out std_logic;                                         -- awvalid
			mux_ddr_0_altera_axi_slave_awready                      : in  std_logic                      := 'X';             -- awready
			mux_ddr_0_altera_axi_slave_wid                          : out std_logic_vector(3 downto 0);                      -- wid
			mux_ddr_0_altera_axi_slave_wdata                        : out std_logic_vector(31 downto 0);                     -- wdata
			mux_ddr_0_altera_axi_slave_wstrb                        : out std_logic_vector(3 downto 0);                      -- wstrb
			mux_ddr_0_altera_axi_slave_wlast                        : out std_logic;                                         -- wlast
			mux_ddr_0_altera_axi_slave_wvalid                       : out std_logic;                                         -- wvalid
			mux_ddr_0_altera_axi_slave_wready                       : in  std_logic                      := 'X';             -- wready
			mux_ddr_0_altera_axi_slave_bid                          : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- bid
			mux_ddr_0_altera_axi_slave_bresp                        : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- bresp
			mux_ddr_0_altera_axi_slave_bvalid                       : in  std_logic                      := 'X';             -- bvalid
			mux_ddr_0_altera_axi_slave_bready                       : out std_logic;                                         -- bready
			mux_ddr_0_altera_axi_slave_arid                         : out std_logic_vector(3 downto 0);                      -- arid
			mux_ddr_0_altera_axi_slave_araddr                       : out std_logic_vector(28 downto 0);                     -- araddr
			mux_ddr_0_altera_axi_slave_arlen                        : out std_logic_vector(3 downto 0);                      -- arlen
			mux_ddr_0_altera_axi_slave_arsize                       : out std_logic_vector(2 downto 0);                      -- arsize
			mux_ddr_0_altera_axi_slave_arburst                      : out std_logic_vector(1 downto 0);                      -- arburst
			mux_ddr_0_altera_axi_slave_arlock                       : out std_logic_vector(1 downto 0);                      -- arlock
			mux_ddr_0_altera_axi_slave_arcache                      : out std_logic_vector(3 downto 0);                      -- arcache
			mux_ddr_0_altera_axi_slave_arprot                       : out std_logic_vector(2 downto 0);                      -- arprot
			mux_ddr_0_altera_axi_slave_aruser                       : out std_logic_vector(4 downto 0);                      -- aruser
			mux_ddr_0_altera_axi_slave_arvalid                      : out std_logic;                                         -- arvalid
			mux_ddr_0_altera_axi_slave_arready                      : in  std_logic                      := 'X';             -- arready
			mux_ddr_0_altera_axi_slave_rid                          : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rid
			mux_ddr_0_altera_axi_slave_rdata                        : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rdata
			mux_ddr_0_altera_axi_slave_rresp                        : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rresp
			mux_ddr_0_altera_axi_slave_rlast                        : in  std_logic                      := 'X';             -- rlast
			mux_ddr_0_altera_axi_slave_rvalid                       : in  std_logic                      := 'X';             -- rvalid
			mux_ddr_0_altera_axi_slave_rready                       : out std_logic;                                         -- rready
			axi_clk_bridge_out_clk_clk                              : in  std_logic                      := 'X';             -- clk
			clk_1_clk_clk                                           : in  std_logic                      := 'X';             -- clk
			arria10_hps_0_h2f_axi_reset_reset_bridge_in_reset_reset : in  std_logic                      := 'X';             -- reset
			mux_ddr_0_reset_reset_bridge_in_reset_reset             : in  std_logic                      := 'X'              -- reset
		);
	end component audioblade_system_altera_mm_interconnect_180_2zdh4ci;

	component audioblade_system_altera_mm_interconnect_180_alyigqi is
		port (
			arria10_hps_0_h2f_lw_axi_master_awid                       : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- awid
			arria10_hps_0_h2f_lw_axi_master_awaddr                     : in  std_logic_vector(20 downto 0) := (others => 'X'); -- awaddr
			arria10_hps_0_h2f_lw_axi_master_awlen                      : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- awlen
			arria10_hps_0_h2f_lw_axi_master_awsize                     : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- awsize
			arria10_hps_0_h2f_lw_axi_master_awburst                    : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- awburst
			arria10_hps_0_h2f_lw_axi_master_awlock                     : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- awlock
			arria10_hps_0_h2f_lw_axi_master_awcache                    : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- awcache
			arria10_hps_0_h2f_lw_axi_master_awprot                     : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- awprot
			arria10_hps_0_h2f_lw_axi_master_awuser                     : in  std_logic_vector(4 downto 0)  := (others => 'X'); -- awuser
			arria10_hps_0_h2f_lw_axi_master_awvalid                    : in  std_logic                     := 'X';             -- awvalid
			arria10_hps_0_h2f_lw_axi_master_awready                    : out std_logic;                                        -- awready
			arria10_hps_0_h2f_lw_axi_master_wid                        : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- wid
			arria10_hps_0_h2f_lw_axi_master_wdata                      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- wdata
			arria10_hps_0_h2f_lw_axi_master_wstrb                      : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- wstrb
			arria10_hps_0_h2f_lw_axi_master_wlast                      : in  std_logic                     := 'X';             -- wlast
			arria10_hps_0_h2f_lw_axi_master_wvalid                     : in  std_logic                     := 'X';             -- wvalid
			arria10_hps_0_h2f_lw_axi_master_wready                     : out std_logic;                                        -- wready
			arria10_hps_0_h2f_lw_axi_master_bid                        : out std_logic_vector(3 downto 0);                     -- bid
			arria10_hps_0_h2f_lw_axi_master_bresp                      : out std_logic_vector(1 downto 0);                     -- bresp
			arria10_hps_0_h2f_lw_axi_master_bvalid                     : out std_logic;                                        -- bvalid
			arria10_hps_0_h2f_lw_axi_master_bready                     : in  std_logic                     := 'X';             -- bready
			arria10_hps_0_h2f_lw_axi_master_arid                       : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- arid
			arria10_hps_0_h2f_lw_axi_master_araddr                     : in  std_logic_vector(20 downto 0) := (others => 'X'); -- araddr
			arria10_hps_0_h2f_lw_axi_master_arlen                      : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- arlen
			arria10_hps_0_h2f_lw_axi_master_arsize                     : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- arsize
			arria10_hps_0_h2f_lw_axi_master_arburst                    : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- arburst
			arria10_hps_0_h2f_lw_axi_master_arlock                     : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- arlock
			arria10_hps_0_h2f_lw_axi_master_arcache                    : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- arcache
			arria10_hps_0_h2f_lw_axi_master_arprot                     : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- arprot
			arria10_hps_0_h2f_lw_axi_master_aruser                     : in  std_logic_vector(4 downto 0)  := (others => 'X'); -- aruser
			arria10_hps_0_h2f_lw_axi_master_arvalid                    : in  std_logic                     := 'X';             -- arvalid
			arria10_hps_0_h2f_lw_axi_master_arready                    : out std_logic;                                        -- arready
			arria10_hps_0_h2f_lw_axi_master_rid                        : out std_logic_vector(3 downto 0);                     -- rid
			arria10_hps_0_h2f_lw_axi_master_rdata                      : out std_logic_vector(31 downto 0);                    -- rdata
			arria10_hps_0_h2f_lw_axi_master_rresp                      : out std_logic_vector(1 downto 0);                     -- rresp
			arria10_hps_0_h2f_lw_axi_master_rlast                      : out std_logic;                                        -- rlast
			arria10_hps_0_h2f_lw_axi_master_rvalid                     : out std_logic;                                        -- rvalid
			arria10_hps_0_h2f_lw_axi_master_rready                     : in  std_logic                     := 'X';             -- rready
			clk_1_clk_clk                                              : in  std_logic                     := 'X';             -- clk
			pll_using_AD1939_MCLK_outclk0_clk                          : in  std_logic                     := 'X';             -- clk
			arria10_hps_0_h2f_lw_axi_reset_reset_bridge_in_reset_reset : in  std_logic                     := 'X';             -- reset
			ur_ear_fpga_sim_0_reset_reset_bridge_in_reset_reset        : in  std_logic                     := 'X';             -- reset
			som_config_s1_address                                      : out std_logic_vector(2 downto 0);                     -- address
			som_config_s1_readdata                                     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			ur_ear_fpga_sim_0_avalon_slave_address                     : out std_logic_vector(1 downto 0);                     -- address
			ur_ear_fpga_sim_0_avalon_slave_write                       : out std_logic;                                        -- write
			ur_ear_fpga_sim_0_avalon_slave_read                        : out std_logic;                                        -- read
			ur_ear_fpga_sim_0_avalon_slave_readdata                    : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			ur_ear_fpga_sim_0_avalon_slave_writedata                   : out std_logic_vector(31 downto 0)                     -- writedata
		);
	end component audioblade_system_altera_mm_interconnect_180_alyigqi;

	component audioblade_system_altera_mm_interconnect_180_nzcyb6q is
		port (
			emif_0_emif_usr_clk_clk                                         : in  std_logic                      := 'X';             -- clk
			mm_clock_crossing_bridge_0_m0_reset_reset_bridge_in_reset_reset : in  std_logic                      := 'X';             -- reset
			mm_clock_crossing_bridge_0_m0_address                           : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- address
			mm_clock_crossing_bridge_0_m0_waitrequest                       : out std_logic;                                         -- waitrequest
			mm_clock_crossing_bridge_0_m0_burstcount                        : in  std_logic_vector(6 downto 0)   := (others => 'X'); -- burstcount
			mm_clock_crossing_bridge_0_m0_byteenable                        : in  std_logic_vector(63 downto 0)  := (others => 'X'); -- byteenable
			mm_clock_crossing_bridge_0_m0_read                              : in  std_logic                      := 'X';             -- read
			mm_clock_crossing_bridge_0_m0_readdata                          : out std_logic_vector(511 downto 0);                    -- readdata
			mm_clock_crossing_bridge_0_m0_readdatavalid                     : out std_logic;                                         -- readdatavalid
			mm_clock_crossing_bridge_0_m0_write                             : in  std_logic                      := 'X';             -- write
			mm_clock_crossing_bridge_0_m0_writedata                         : in  std_logic_vector(511 downto 0) := (others => 'X'); -- writedata
			mm_clock_crossing_bridge_0_m0_debugaccess                       : in  std_logic                      := 'X';             -- debugaccess
			emif_0_ctrl_amm_0_address                                       : out std_logic_vector(25 downto 0);                     -- address
			emif_0_ctrl_amm_0_write                                         : out std_logic;                                         -- write
			emif_0_ctrl_amm_0_read                                          : out std_logic;                                         -- read
			emif_0_ctrl_amm_0_readdata                                      : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			emif_0_ctrl_amm_0_writedata                                     : out std_logic_vector(511 downto 0);                    -- writedata
			emif_0_ctrl_amm_0_burstcount                                    : out std_logic_vector(6 downto 0);                      -- burstcount
			emif_0_ctrl_amm_0_byteenable                                    : out std_logic_vector(63 downto 0);                     -- byteenable
			emif_0_ctrl_amm_0_readdatavalid                                 : in  std_logic                      := 'X';             -- readdatavalid
			emif_0_ctrl_amm_0_waitrequest                                   : in  std_logic                      := 'X'              -- waitrequest
		);
	end component audioblade_system_altera_mm_interconnect_180_nzcyb6q;

end audioblade_system_pkg;
