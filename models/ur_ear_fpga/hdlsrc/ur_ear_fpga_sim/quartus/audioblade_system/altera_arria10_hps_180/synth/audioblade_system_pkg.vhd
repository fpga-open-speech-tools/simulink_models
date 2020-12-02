library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package audioblade_system_pkg is
	component audioblade_system_altera_arria10_hps_180_zmlrihi is
		generic (
			F2S_Width : integer := 5;
			S2F_Width : integer := 5
		);
		port (
			h2f_rst_n                 : out   std_logic;                                          -- reset_n
			h2f_cold_rst_n            : out   std_logic;                                          -- reset_n
			s2f_user0_clk             : out   std_logic;                                          -- clk
			emif_emif_to_hps          : in    std_logic_vector(4095 downto 0) := (others => 'X'); -- emif_to_hps
			emif_hps_to_emif          : out   std_logic_vector(4095 downto 0);                    -- hps_to_emif
			emif_emif_to_gp           : in    std_logic                       := 'X';             -- emif_to_gp
			emif_gp_to_emif           : out   std_logic_vector(1 downto 0);                       -- gp_to_emif
			f2h_axi_clk               : in    std_logic                       := 'X';             -- clk
			f2h_axi_rst               : in    std_logic                       := 'X';             -- reset_n
			f2h_AWID                  : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- awid
			f2h_AWADDR                : in    std_logic_vector(31 downto 0)   := (others => 'X'); -- awaddr
			f2h_AWLEN                 : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- awlen
			f2h_AWSIZE                : in    std_logic_vector(2 downto 0)    := (others => 'X'); -- awsize
			f2h_AWBURST               : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- awburst
			f2h_AWLOCK                : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- awlock
			f2h_AWCACHE               : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- awcache
			f2h_AWPROT                : in    std_logic_vector(2 downto 0)    := (others => 'X'); -- awprot
			f2h_AWVALID               : in    std_logic                       := 'X';             -- awvalid
			f2h_AWREADY               : out   std_logic;                                          -- awready
			f2h_AWUSER                : in    std_logic_vector(4 downto 0)    := (others => 'X'); -- awuser
			f2h_WID                   : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- wid
			f2h_WDATA                 : in    std_logic_vector(127 downto 0)  := (others => 'X'); -- wdata
			f2h_WSTRB                 : in    std_logic_vector(15 downto 0)   := (others => 'X'); -- wstrb
			f2h_WLAST                 : in    std_logic                       := 'X';             -- wlast
			f2h_WVALID                : in    std_logic                       := 'X';             -- wvalid
			f2h_WREADY                : out   std_logic;                                          -- wready
			f2h_BID                   : out   std_logic_vector(3 downto 0);                       -- bid
			f2h_BRESP                 : out   std_logic_vector(1 downto 0);                       -- bresp
			f2h_BVALID                : out   std_logic;                                          -- bvalid
			f2h_BREADY                : in    std_logic                       := 'X';             -- bready
			f2h_ARID                  : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- arid
			f2h_ARADDR                : in    std_logic_vector(31 downto 0)   := (others => 'X'); -- araddr
			f2h_ARLEN                 : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- arlen
			f2h_ARSIZE                : in    std_logic_vector(2 downto 0)    := (others => 'X'); -- arsize
			f2h_ARBURST               : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- arburst
			f2h_ARLOCK                : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- arlock
			f2h_ARCACHE               : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- arcache
			f2h_ARPROT                : in    std_logic_vector(2 downto 0)    := (others => 'X'); -- arprot
			f2h_ARVALID               : in    std_logic                       := 'X';             -- arvalid
			f2h_ARREADY               : out   std_logic;                                          -- arready
			f2h_ARUSER                : in    std_logic_vector(4 downto 0)    := (others => 'X'); -- aruser
			f2h_RID                   : out   std_logic_vector(3 downto 0);                       -- rid
			f2h_RDATA                 : out   std_logic_vector(127 downto 0);                     -- rdata
			f2h_RRESP                 : out   std_logic_vector(1 downto 0);                       -- rresp
			f2h_RLAST                 : out   std_logic;                                          -- rlast
			f2h_RVALID                : out   std_logic;                                          -- rvalid
			f2h_RREADY                : in    std_logic                       := 'X';             -- rready
			h2f_lw_axi_clk            : in    std_logic                       := 'X';             -- clk
			h2f_lw_axi_rst            : in    std_logic                       := 'X';             -- reset_n
			h2f_lw_AWID               : out   std_logic_vector(3 downto 0);                       -- awid
			h2f_lw_AWADDR             : out   std_logic_vector(20 downto 0);                      -- awaddr
			h2f_lw_AWLEN              : out   std_logic_vector(3 downto 0);                       -- awlen
			h2f_lw_AWSIZE             : out   std_logic_vector(2 downto 0);                       -- awsize
			h2f_lw_AWBURST            : out   std_logic_vector(1 downto 0);                       -- awburst
			h2f_lw_AWLOCK             : out   std_logic_vector(1 downto 0);                       -- awlock
			h2f_lw_AWCACHE            : out   std_logic_vector(3 downto 0);                       -- awcache
			h2f_lw_AWPROT             : out   std_logic_vector(2 downto 0);                       -- awprot
			h2f_lw_AWVALID            : out   std_logic;                                          -- awvalid
			h2f_lw_AWREADY            : in    std_logic                       := 'X';             -- awready
			h2f_lw_AWUSER             : out   std_logic_vector(4 downto 0);                       -- awuser
			h2f_lw_WID                : out   std_logic_vector(3 downto 0);                       -- wid
			h2f_lw_WDATA              : out   std_logic_vector(31 downto 0);                      -- wdata
			h2f_lw_WSTRB              : out   std_logic_vector(3 downto 0);                       -- wstrb
			h2f_lw_WLAST              : out   std_logic;                                          -- wlast
			h2f_lw_WVALID             : out   std_logic;                                          -- wvalid
			h2f_lw_WREADY             : in    std_logic                       := 'X';             -- wready
			h2f_lw_BID                : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- bid
			h2f_lw_BRESP              : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- bresp
			h2f_lw_BVALID             : in    std_logic                       := 'X';             -- bvalid
			h2f_lw_BREADY             : out   std_logic;                                          -- bready
			h2f_lw_ARID               : out   std_logic_vector(3 downto 0);                       -- arid
			h2f_lw_ARADDR             : out   std_logic_vector(20 downto 0);                      -- araddr
			h2f_lw_ARLEN              : out   std_logic_vector(3 downto 0);                       -- arlen
			h2f_lw_ARSIZE             : out   std_logic_vector(2 downto 0);                       -- arsize
			h2f_lw_ARBURST            : out   std_logic_vector(1 downto 0);                       -- arburst
			h2f_lw_ARLOCK             : out   std_logic_vector(1 downto 0);                       -- arlock
			h2f_lw_ARCACHE            : out   std_logic_vector(3 downto 0);                       -- arcache
			h2f_lw_ARPROT             : out   std_logic_vector(2 downto 0);                       -- arprot
			h2f_lw_ARVALID            : out   std_logic;                                          -- arvalid
			h2f_lw_ARREADY            : in    std_logic                       := 'X';             -- arready
			h2f_lw_ARUSER             : out   std_logic_vector(4 downto 0);                       -- aruser
			h2f_lw_RID                : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- rid
			h2f_lw_RDATA              : in    std_logic_vector(31 downto 0)   := (others => 'X'); -- rdata
			h2f_lw_RRESP              : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- rresp
			h2f_lw_RLAST              : in    std_logic                       := 'X';             -- rlast
			h2f_lw_RVALID             : in    std_logic                       := 'X';             -- rvalid
			h2f_lw_RREADY             : out   std_logic;                                          -- rready
			h2f_axi_clk               : in    std_logic                       := 'X';             -- clk
			h2f_axi_rst               : in    std_logic                       := 'X';             -- reset_n
			h2f_AWID                  : out   std_logic_vector(3 downto 0);                       -- awid
			h2f_AWADDR                : out   std_logic_vector(31 downto 0);                      -- awaddr
			h2f_AWLEN                 : out   std_logic_vector(3 downto 0);                       -- awlen
			h2f_AWSIZE                : out   std_logic_vector(2 downto 0);                       -- awsize
			h2f_AWBURST               : out   std_logic_vector(1 downto 0);                       -- awburst
			h2f_AWLOCK                : out   std_logic_vector(1 downto 0);                       -- awlock
			h2f_AWCACHE               : out   std_logic_vector(3 downto 0);                       -- awcache
			h2f_AWPROT                : out   std_logic_vector(2 downto 0);                       -- awprot
			h2f_AWVALID               : out   std_logic;                                          -- awvalid
			h2f_AWREADY               : in    std_logic                       := 'X';             -- awready
			h2f_AWUSER                : out   std_logic_vector(4 downto 0);                       -- awuser
			h2f_WID                   : out   std_logic_vector(3 downto 0);                       -- wid
			h2f_WDATA                 : out   std_logic_vector(127 downto 0);                     -- wdata
			h2f_WSTRB                 : out   std_logic_vector(15 downto 0);                      -- wstrb
			h2f_WLAST                 : out   std_logic;                                          -- wlast
			h2f_WVALID                : out   std_logic;                                          -- wvalid
			h2f_WREADY                : in    std_logic                       := 'X';             -- wready
			h2f_BID                   : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- bid
			h2f_BRESP                 : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- bresp
			h2f_BVALID                : in    std_logic                       := 'X';             -- bvalid
			h2f_BREADY                : out   std_logic;                                          -- bready
			h2f_ARID                  : out   std_logic_vector(3 downto 0);                       -- arid
			h2f_ARADDR                : out   std_logic_vector(31 downto 0);                      -- araddr
			h2f_ARLEN                 : out   std_logic_vector(3 downto 0);                       -- arlen
			h2f_ARSIZE                : out   std_logic_vector(2 downto 0);                       -- arsize
			h2f_ARBURST               : out   std_logic_vector(1 downto 0);                       -- arburst
			h2f_ARLOCK                : out   std_logic_vector(1 downto 0);                       -- arlock
			h2f_ARCACHE               : out   std_logic_vector(3 downto 0);                       -- arcache
			h2f_ARPROT                : out   std_logic_vector(2 downto 0);                       -- arprot
			h2f_ARVALID               : out   std_logic;                                          -- arvalid
			h2f_ARREADY               : in    std_logic                       := 'X';             -- arready
			h2f_ARUSER                : out   std_logic_vector(4 downto 0);                       -- aruser
			h2f_RID                   : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- rid
			h2f_RDATA                 : in    std_logic_vector(127 downto 0)  := (others => 'X'); -- rdata
			h2f_RRESP                 : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- rresp
			h2f_RLAST                 : in    std_logic                       := 'X';             -- rlast
			h2f_RVALID                : in    std_logic                       := 'X';             -- rvalid
			h2f_RREADY                : out   std_logic;                                          -- rready
			f2sdram0_clk              : in    std_logic                       := 'X';             -- clk
			f2s_sdram0_rst            : in    std_logic                       := 'X';             -- reset_n
			f2sdram0_ARADDR           : in    std_logic_vector(31 downto 0)   := (others => 'X'); -- araddr
			f2sdram0_ARBURST          : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- arburst
			f2sdram0_ARCACHE          : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- arcache
			f2sdram0_ARID             : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- arid
			f2sdram0_ARLEN            : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- arlen
			f2sdram0_ARLOCK           : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- arlock
			f2sdram0_ARPROT           : in    std_logic_vector(2 downto 0)    := (others => 'X'); -- arprot
			f2sdram0_ARREADY          : out   std_logic;                                          -- arready
			f2sdram0_ARSIZE           : in    std_logic_vector(2 downto 0)    := (others => 'X'); -- arsize
			f2sdram0_ARUSER           : in    std_logic_vector(4 downto 0)    := (others => 'X'); -- aruser
			f2sdram0_ARVALID          : in    std_logic                       := 'X';             -- arvalid
			f2sdram0_AWADDR           : in    std_logic_vector(31 downto 0)   := (others => 'X'); -- awaddr
			f2sdram0_AWBURST          : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- awburst
			f2sdram0_AWCACHE          : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- awcache
			f2sdram0_AWID             : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- awid
			f2sdram0_AWLEN            : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- awlen
			f2sdram0_AWLOCK           : in    std_logic_vector(1 downto 0)    := (others => 'X'); -- awlock
			f2sdram0_AWPROT           : in    std_logic_vector(2 downto 0)    := (others => 'X'); -- awprot
			f2sdram0_AWREADY          : out   std_logic;                                          -- awready
			f2sdram0_AWSIZE           : in    std_logic_vector(2 downto 0)    := (others => 'X'); -- awsize
			f2sdram0_AWUSER           : in    std_logic_vector(4 downto 0)    := (others => 'X'); -- awuser
			f2sdram0_AWVALID          : in    std_logic                       := 'X';             -- awvalid
			f2sdram0_WDATA            : in    std_logic_vector(127 downto 0)  := (others => 'X'); -- wdata
			f2sdram0_WID              : in    std_logic_vector(3 downto 0)    := (others => 'X'); -- wid
			f2sdram0_WLAST            : in    std_logic                       := 'X';             -- wlast
			f2sdram0_WREADY           : out   std_logic;                                          -- wready
			f2sdram0_WSTRB            : in    std_logic_vector(15 downto 0)   := (others => 'X'); -- wstrb
			f2sdram0_WVALID           : in    std_logic                       := 'X';             -- wvalid
			f2sdram0_BID              : out   std_logic_vector(3 downto 0);                       -- bid
			f2sdram0_BREADY           : in    std_logic                       := 'X';             -- bready
			f2sdram0_BRESP            : out   std_logic_vector(1 downto 0);                       -- bresp
			f2sdram0_BVALID           : out   std_logic;                                          -- bvalid
			f2sdram0_RDATA            : out   std_logic_vector(127 downto 0);                     -- rdata
			f2sdram0_RID              : out   std_logic_vector(3 downto 0);                       -- rid
			f2sdram0_RLAST            : out   std_logic;                                          -- rlast
			f2sdram0_RREADY           : in    std_logic                       := 'X';             -- rready
			f2sdram0_RRESP            : out   std_logic_vector(1 downto 0);                       -- rresp
			f2sdram0_RVALID           : out   std_logic;                                          -- rvalid
			f2h_irq_p0                : in    std_logic_vector(31 downto 0)   := (others => 'X'); -- irq
			f2h_irq_p1                : in    std_logic_vector(31 downto 0)   := (others => 'X'); -- irq
			spim0_mosi_o              : out   std_logic;                                          -- mosi_o
			spim0_miso_i              : in    std_logic                       := 'X';             -- miso_i
			spim0_ss_in_n             : in    std_logic                       := 'X';             -- ss_in_n
			spim0_mosi_oe             : out   std_logic;                                          -- mosi_oe
			spim0_ss0_n_o             : out   std_logic;                                          -- ss0_n_o
			spim0_ss1_n_o             : out   std_logic;                                          -- ss1_n_o
			spim0_ss2_n_o             : out   std_logic;                                          -- ss2_n_o
			spim0_ss3_n_o             : out   std_logic;                                          -- ss3_n_o
			spim0_sclk_out            : out   std_logic;                                          -- clk
			i2c1_scl_i                : in    std_logic                       := 'X';             -- clk
			i2c1_scl_oe               : out   std_logic;                                          -- clk
			i2c1_sda_i                : in    std_logic                       := 'X';             -- sda_i
			i2c1_sda_oe               : out   std_logic;                                          -- sda_oe
			hps_io_phery_emac1_TX_CLK : out   std_logic;                                          -- hps_io_phery_emac1_TX_CLK
			hps_io_phery_emac1_TXD0   : out   std_logic;                                          -- hps_io_phery_emac1_TXD0
			hps_io_phery_emac1_TXD1   : out   std_logic;                                          -- hps_io_phery_emac1_TXD1
			hps_io_phery_emac1_TXD2   : out   std_logic;                                          -- hps_io_phery_emac1_TXD2
			hps_io_phery_emac1_TXD3   : out   std_logic;                                          -- hps_io_phery_emac1_TXD3
			hps_io_phery_emac1_RX_CTL : in    std_logic                       := 'X';             -- hps_io_phery_emac1_RX_CTL
			hps_io_phery_emac1_TX_CTL : out   std_logic;                                          -- hps_io_phery_emac1_TX_CTL
			hps_io_phery_emac1_RX_CLK : in    std_logic                       := 'X';             -- hps_io_phery_emac1_RX_CLK
			hps_io_phery_emac1_RXD0   : in    std_logic                       := 'X';             -- hps_io_phery_emac1_RXD0
			hps_io_phery_emac1_RXD1   : in    std_logic                       := 'X';             -- hps_io_phery_emac1_RXD1
			hps_io_phery_emac1_RXD2   : in    std_logic                       := 'X';             -- hps_io_phery_emac1_RXD2
			hps_io_phery_emac1_RXD3   : in    std_logic                       := 'X';             -- hps_io_phery_emac1_RXD3
			hps_io_phery_emac1_MDIO   : inout std_logic                       := 'X';             -- hps_io_phery_emac1_MDIO
			hps_io_phery_emac1_MDC    : out   std_logic;                                          -- hps_io_phery_emac1_MDC
			hps_io_phery_sdmmc_CMD    : inout std_logic                       := 'X';             -- hps_io_phery_sdmmc_CMD
			hps_io_phery_sdmmc_D0     : inout std_logic                       := 'X';             -- hps_io_phery_sdmmc_D0
			hps_io_phery_sdmmc_D1     : inout std_logic                       := 'X';             -- hps_io_phery_sdmmc_D1
			hps_io_phery_sdmmc_D2     : inout std_logic                       := 'X';             -- hps_io_phery_sdmmc_D2
			hps_io_phery_sdmmc_D3     : inout std_logic                       := 'X';             -- hps_io_phery_sdmmc_D3
			hps_io_phery_sdmmc_CCLK   : out   std_logic;                                          -- hps_io_phery_sdmmc_CCLK
			hps_io_phery_usb1_DATA0   : inout std_logic                       := 'X';             -- hps_io_phery_usb1_DATA0
			hps_io_phery_usb1_DATA1   : inout std_logic                       := 'X';             -- hps_io_phery_usb1_DATA1
			hps_io_phery_usb1_DATA2   : inout std_logic                       := 'X';             -- hps_io_phery_usb1_DATA2
			hps_io_phery_usb1_DATA3   : inout std_logic                       := 'X';             -- hps_io_phery_usb1_DATA3
			hps_io_phery_usb1_DATA4   : inout std_logic                       := 'X';             -- hps_io_phery_usb1_DATA4
			hps_io_phery_usb1_DATA5   : inout std_logic                       := 'X';             -- hps_io_phery_usb1_DATA5
			hps_io_phery_usb1_DATA6   : inout std_logic                       := 'X';             -- hps_io_phery_usb1_DATA6
			hps_io_phery_usb1_DATA7   : inout std_logic                       := 'X';             -- hps_io_phery_usb1_DATA7
			hps_io_phery_usb1_CLK     : in    std_logic                       := 'X';             -- hps_io_phery_usb1_CLK
			hps_io_phery_usb1_STP     : out   std_logic;                                          -- hps_io_phery_usb1_STP
			hps_io_phery_usb1_DIR     : in    std_logic                       := 'X';             -- hps_io_phery_usb1_DIR
			hps_io_phery_usb1_NXT     : in    std_logic                       := 'X';             -- hps_io_phery_usb1_NXT
			hps_io_phery_uart1_RX     : in    std_logic                       := 'X';             -- hps_io_phery_uart1_RX
			hps_io_phery_uart1_TX     : out   std_logic;                                          -- hps_io_phery_uart1_TX
			hps_io_phery_i2c0_SDA     : inout std_logic                       := 'X';             -- hps_io_phery_i2c0_SDA
			hps_io_phery_i2c0_SCL     : inout std_logic                       := 'X';             -- hps_io_phery_i2c0_SCL
			hps_io_gpio_gpio2_io6     : inout std_logic                       := 'X';             -- hps_io_gpio_gpio2_io6
			hps_io_gpio_gpio2_io8     : inout std_logic                       := 'X';             -- hps_io_gpio_gpio2_io8
			hps_io_gpio_gpio0_io0     : inout std_logic                       := 'X';             -- hps_io_gpio_gpio0_io0
			hps_io_gpio_gpio0_io1     : inout std_logic                       := 'X';             -- hps_io_gpio_gpio0_io1
			hps_io_gpio_gpio0_io6     : inout std_logic                       := 'X';             -- hps_io_gpio_gpio0_io6
			hps_io_gpio_gpio0_io11    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio0_io11
			hps_io_gpio_gpio1_io12    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io12
			hps_io_gpio_gpio1_io13    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io13
			hps_io_gpio_gpio1_io14    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io14
			hps_io_gpio_gpio1_io15    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io15
			hps_io_gpio_gpio1_io16    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io16
			hps_io_gpio_gpio1_io17    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io17
			hps_io_gpio_gpio1_io18    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io18
			hps_io_gpio_gpio1_io19    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io19
			hps_io_gpio_gpio1_io20    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io20
			hps_io_gpio_gpio1_io21    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io21
			hps_io_gpio_gpio1_io22    : inout std_logic                       := 'X';             -- hps_io_gpio_gpio1_io22
			hps_io_gpio_gpio1_io23    : inout std_logic                       := 'X'              -- hps_io_gpio_gpio1_io23
		);
	end component audioblade_system_altera_arria10_hps_180_zmlrihi;

end audioblade_system_pkg;
