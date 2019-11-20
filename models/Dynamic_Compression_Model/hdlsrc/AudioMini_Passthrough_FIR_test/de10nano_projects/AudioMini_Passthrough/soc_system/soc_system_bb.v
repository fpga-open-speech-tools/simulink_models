
module soc_system (
	ad1939_abclk_clk,
	ad1939_alrclk_clk,
	ad1939_mclk_clk,
	clk_clk,
	hps_f2h_cold_reset_req_reset_n,
	hps_f2h_debug_reset_req_reset_n,
	hps_f2h_warm_reset_req_reset_n,
	hps_h2f_reset_reset_n,
	hps_hps_io_hps_io_emac1_inst_TX_CLK,
	hps_hps_io_hps_io_emac1_inst_TXD0,
	hps_hps_io_hps_io_emac1_inst_TXD1,
	hps_hps_io_hps_io_emac1_inst_TXD2,
	hps_hps_io_hps_io_emac1_inst_TXD3,
	hps_hps_io_hps_io_emac1_inst_RXD0,
	hps_hps_io_hps_io_emac1_inst_MDIO,
	hps_hps_io_hps_io_emac1_inst_MDC,
	hps_hps_io_hps_io_emac1_inst_RX_CTL,
	hps_hps_io_hps_io_emac1_inst_TX_CTL,
	hps_hps_io_hps_io_emac1_inst_RX_CLK,
	hps_hps_io_hps_io_emac1_inst_RXD1,
	hps_hps_io_hps_io_emac1_inst_RXD2,
	hps_hps_io_hps_io_emac1_inst_RXD3,
	hps_hps_io_hps_io_sdio_inst_CMD,
	hps_hps_io_hps_io_sdio_inst_D0,
	hps_hps_io_hps_io_sdio_inst_D1,
	hps_hps_io_hps_io_sdio_inst_CLK,
	hps_hps_io_hps_io_sdio_inst_D2,
	hps_hps_io_hps_io_sdio_inst_D3,
	hps_hps_io_hps_io_spim1_inst_CLK,
	hps_hps_io_hps_io_spim1_inst_MOSI,
	hps_hps_io_hps_io_spim1_inst_MISO,
	hps_hps_io_hps_io_spim1_inst_SS0,
	hps_hps_io_hps_io_uart0_inst_RX,
	hps_hps_io_hps_io_uart0_inst_TX,
	hps_hps_io_hps_io_i2c1_inst_SDA,
	hps_hps_io_hps_io_i2c1_inst_SCL,
	hps_hps_io_hps_io_gpio_inst_GPIO09,
	hps_hps_io_hps_io_gpio_inst_GPIO35,
	hps_hps_io_hps_io_gpio_inst_GPIO40,
	hps_hps_io_hps_io_gpio_inst_GPIO53,
	hps_hps_io_hps_io_gpio_inst_GPIO54,
	hps_hps_io_hps_io_gpio_inst_GPIO61,
	hps_i2c0_out_data,
	hps_i2c0_sda,
	hps_i2c0_clk_clk,
	hps_i2c0_scl_in_clk,
	hps_spim0_txd,
	hps_spim0_rxd,
	hps_spim0_ss_in_n,
	hps_spim0_ssi_oe_n,
	hps_spim0_ss_0_n,
	hps_spim0_ss_1_n,
	hps_spim0_ss_2_n,
	hps_spim0_ss_3_n,
	hps_spim0_sclk_out_clk,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	reset_reset_n);	

	input		ad1939_abclk_clk;
	input		ad1939_alrclk_clk;
	input		ad1939_mclk_clk;
	input		clk_clk;
	input		hps_f2h_cold_reset_req_reset_n;
	input		hps_f2h_debug_reset_req_reset_n;
	input		hps_f2h_warm_reset_req_reset_n;
	output		hps_h2f_reset_reset_n;
	output		hps_hps_io_hps_io_emac1_inst_TX_CLK;
	output		hps_hps_io_hps_io_emac1_inst_TXD0;
	output		hps_hps_io_hps_io_emac1_inst_TXD1;
	output		hps_hps_io_hps_io_emac1_inst_TXD2;
	output		hps_hps_io_hps_io_emac1_inst_TXD3;
	input		hps_hps_io_hps_io_emac1_inst_RXD0;
	inout		hps_hps_io_hps_io_emac1_inst_MDIO;
	output		hps_hps_io_hps_io_emac1_inst_MDC;
	input		hps_hps_io_hps_io_emac1_inst_RX_CTL;
	output		hps_hps_io_hps_io_emac1_inst_TX_CTL;
	input		hps_hps_io_hps_io_emac1_inst_RX_CLK;
	input		hps_hps_io_hps_io_emac1_inst_RXD1;
	input		hps_hps_io_hps_io_emac1_inst_RXD2;
	input		hps_hps_io_hps_io_emac1_inst_RXD3;
	inout		hps_hps_io_hps_io_sdio_inst_CMD;
	inout		hps_hps_io_hps_io_sdio_inst_D0;
	inout		hps_hps_io_hps_io_sdio_inst_D1;
	output		hps_hps_io_hps_io_sdio_inst_CLK;
	inout		hps_hps_io_hps_io_sdio_inst_D2;
	inout		hps_hps_io_hps_io_sdio_inst_D3;
	output		hps_hps_io_hps_io_spim1_inst_CLK;
	output		hps_hps_io_hps_io_spim1_inst_MOSI;
	input		hps_hps_io_hps_io_spim1_inst_MISO;
	output		hps_hps_io_hps_io_spim1_inst_SS0;
	input		hps_hps_io_hps_io_uart0_inst_RX;
	output		hps_hps_io_hps_io_uart0_inst_TX;
	inout		hps_hps_io_hps_io_i2c1_inst_SDA;
	inout		hps_hps_io_hps_io_i2c1_inst_SCL;
	inout		hps_hps_io_hps_io_gpio_inst_GPIO09;
	inout		hps_hps_io_hps_io_gpio_inst_GPIO35;
	inout		hps_hps_io_hps_io_gpio_inst_GPIO40;
	inout		hps_hps_io_hps_io_gpio_inst_GPIO53;
	inout		hps_hps_io_hps_io_gpio_inst_GPIO54;
	inout		hps_hps_io_hps_io_gpio_inst_GPIO61;
	output		hps_i2c0_out_data;
	input		hps_i2c0_sda;
	output		hps_i2c0_clk_clk;
	input		hps_i2c0_scl_in_clk;
	output		hps_spim0_txd;
	input		hps_spim0_rxd;
	input		hps_spim0_ss_in_n;
	output		hps_spim0_ssi_oe_n;
	output		hps_spim0_ss_0_n;
	output		hps_spim0_ss_1_n;
	output		hps_spim0_ss_2_n;
	output		hps_spim0_ss_3_n;
	output		hps_spim0_sclk_out_clk;
	output	[14:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[31:0]	memory_mem_dq;
	inout	[3:0]	memory_mem_dqs;
	inout	[3:0]	memory_mem_dqs_n;
	output		memory_mem_odt;
	output	[3:0]	memory_mem_dm;
	input		memory_oct_rzqin;
	input		reset_reset_n;
endmodule
