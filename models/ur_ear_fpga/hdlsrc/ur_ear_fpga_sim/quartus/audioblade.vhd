LIBRARY IEEE ;                      --! Use standard library.
USE     IEEE.STD_LOGIC_1164.ALL;    --! Use standard logic elements.
USE     IEEE.NUMERIC_STD.ALL ;      --! Use numeric standard

LIBRARY altera;
USE altera.altera_primitives_components.all;

library pll;

ENTITY Audioblade IS
  PORT(
    clk_200                           : in std_logic;
    ddr_ref_clk_i                     : in std_logic;
    fpga_clk_i                        : in std_logic;
    
    -- FPGA memory signals
    FPGA_memory_mem1_a                : out std_logic_vector(16 downto 0);
    FPGA_memory_mem1_act_n            : out std_logic;
    FPGA_memory_mem1_alert_n          : in std_logic;
    FPGA_memory_mem1_ba               : out std_logic_vector(1 downto 0);
    FPGA_memory_mem1_bg               : out std_logic;
    FPGA_memory_mem1_ck               : out std_logic;
    FPGA_memory_mem1_ck_n             : out std_logic;
    FPGA_memory_mem1_cke              : out std_logic;
    FPGA_memory_mem1_cs_n             : out std_logic;
    FPGA_memory_mem1_dbi_n            : inout std_logic_vector(7 downto 0);
    FPGA_memory_mem1_dq               : inout std_logic_vector(63 downto 0);
    FPGA_memory_mem1_dqs              : inout std_logic_vector(7 downto 0);
    FPGA_memory_mem1_dqs_n            : inout std_logic_vector(7 downto 0);
    FPGA_memory_mem1_odt              : out std_logic;
    FPGA_memory_mem1_par              : out std_logic;
    FPGA_memory_mem1_reset_n          : out std_logic;
    FPGA_memory_oct1_rzqin            : in std_logic;
    
    -- Dedicated  HPS signal
    hps_emac1_MDC                     : out std_logic;
    hps_emac1_MDIO                    : inout std_logic;
    hps_emac1_RX_CLK                  : in std_logic;
    hps_emac1_RX_CTL                  : in std_logic;
    hps_emac1_RXD0                    : in std_logic;
    hps_emac1_RXD1                    : in std_logic;
    hps_emac1_RXD2                    : in std_logic;
    hps_emac1_RXD3                    : in std_logic;
    hps_emac1_TX_CLK                  : out std_logic;
    hps_emac1_TX_CTL                  : out std_logic;
    hps_emac1_TXD0                    : out std_logic;
    hps_emac1_TXD1                    : out std_logic;
    hps_emac1_TXD2                    : out std_logic;
    hps_emac1_TXD3                    : out std_logic;
    hps_gpio2_GPIO6                   : inout std_logic;
    hps_gpio2_GPIO8                   : inout std_logic;
    hps_gpio_GPIO0                    : inout std_logic;
    hps_gpio_GPIO1                    : inout std_logic;
    hps_gpio_GPIO6                    : inout std_logic;
    hps_gpio_GPIO11                   : inout std_logic;
    hps_gpio_GPIO12                   : inout std_logic;
    hps_gpio_GPIO13                   : inout std_logic;
    hps_gpio_GPIO14                   : inout std_logic;
    hps_gpio_GPIO15                   : inout std_logic;
    hps_gpio_GPIO16                   : inout std_logic;
    hps_gpio_GPIO17                   : inout std_logic;
    hps_gpio_GPIO18                   : inout std_logic;
    hps_gpio_GPIO19                   : inout std_logic;
    hps_gpio_GPIO20                   : inout std_logic;
    hps_gpio_GPIO21                   : inout std_logic;
    hps_gpio_GPIO22                   : inout std_logic;
    hps_gpio_GPIO23                   : inout std_logic;
    
    -- HPS I2C
    hps_i2c0_SCL                      : inout std_logic;
    hps_i2c0_SDA                      : inout std_logic;
    
    -- HPS Memory mapping
    hps_memory_mem_a                  : out std_logic_vector(16 downto 0);
    hps_memory_mem_act_n              : out std_logic;
    hps_memory_mem_alert_n            : in std_logic;
    hps_memory_mem_ba                 : out std_logic_vector(1 downto 0);
    hps_memory_mem_bg                 : out std_logic;
    hps_memory_mem_ck                 : out std_logic;
    hps_memory_mem_ck_n               : out std_logic;
    hps_memory_mem_cke                : out std_logic;
    hps_memory_mem_cs_n               : out std_logic;
    hps_memory_mem_dbi_n              : inout std_logic_vector(4 downto 0);
    hps_memory_mem_dq                 : inout std_logic_vector(39 downto 0);
    hps_memory_mem_dqs                : inout std_logic_vector(4 downto 0);
    hps_memory_mem_dqs_n              : inout std_logic_vector(4 downto 0);
    hps_memory_mem_odt                : out std_logic;
    hps_memory_mem_par                : out std_logic;
    hps_memory_mem_reset_n            : out std_logic;
    hps_memory_oct_rzqin              : in std_logic;
    
    
    -- HPS serial
    hps_sdio_CLK                      : out std_logic;
    hps_sdio_CMD                      : inout std_logic;
    hps_sdio_D0                       : inout std_logic;
    hps_sdio_D1                       : inout std_logic;
    hps_sdio_D2                       : inout std_logic;
    hps_sdio_D3                       : inout std_logic;
    
    -- HPS UART
    hps_uart1_RX                      : in std_logic;
    hps_uart1_TX                      : out std_logic;
    
    -- HPS USB mapping
    hps_usb1_CLK                      : in std_logic;
    hps_usb1_D0                       : inout std_logic;
    hps_usb1_D1                       : inout std_logic;
    hps_usb1_D2                       : inout std_logic;
    hps_usb1_D3                       : inout std_logic;
    hps_usb1_D4                       : inout std_logic;
    hps_usb1_D5                       : inout std_logic;
    hps_usb1_D6                       : inout std_logic;
    hps_usb1_D7                       : inout std_logic;
    hps_usb1_DIR                      : in std_logic;
    hps_usb1_NXT                      : in std_logic;
    hps_usb1_STP                      : out std_logic;
    
    pcie_npor_pin_perst               : in std_logic;
       
    som_config_pio                    : in std_logic_vector(4 downto 0);
    sys_reset_n_i                     : in std_logic;
    
    AD4020_EN                         : out std_logic;
    AD5791_EN                         : out std_logic;
    
    HSA_IN_CLK                        : out std_logic;
    HSA_IN_EN_N                       : out std_logic;
    HSA_IN_L_CNV                      : out std_logic;
    HSA_IN_R_CNV                      : out std_logic;
    HSA_IN_L_SDI                      : out std_logic;
    HSA_IN_R_SDI                      : out std_logic;
    HSA_IN_L_SDO                      : in std_logic;
    HSA_IN_R_SDO                      : in std_logic;
    
    HSA_OUT_CLK                       : out std_logic;
    HSA_OUT_L_CLR_N                   : out std_logic;
    HSA_OUT_R_CLR_N                   : out std_logic;
    HSA_OUT_L_LDAC_N                  : out std_logic;
    HSA_OUT_R_LDAC_N                  : out std_logic;
    HSA_OUT_L_RESET_N                 : out std_logic;
    HSA_OUT_R_RESET_N                 : out std_logic;
    HSA_OUT_L_SDI                     : out std_logic;
    HSA_OUT_R_SDI                     : out std_logic;
    HSA_OUT_L_SDO                     : in std_logic;
    HSA_OUT_R_SDO                     : in std_logic;
    HSA_OUT_L_SYNC_N                  : out std_logic;
    HSA_OUT_R_SYNC_N                  : out std_logic;
        
    HDPHN_I2C_SCL                     : inout std_logic;
    HDPHN_I2C_SDA                     : inout std_logic;
    HDPHN_PWR_OFF_N                   : out std_logic;
    
    PGA2505_CS_N                      : out std_logic;
    
    EEPROM_WP                         : out std_logic;
    FAN_FAIL_N                        : in std_logic;
    FPGA_LED                          : out std_logic;
    FPGA_RESET                        : out std_logic;
    FULL_SPEED_N                      : out std_logic;
    TEMP_ALERT_N                      : in std_logic;

    MSATA_A                           : out std_logic;
    MSATA_B                           : in std_logic;
    MSATA_PWR_EN                      : out std_logic;

    AD7768_CS_N                       : out std_logic;
    AD7768_DCLK                       : out std_logic;
    AD7768_DRDY_N                     : in std_logic;
    AD7768_EN                         : out std_logic;
    AD7768_MCLK                       : out std_logic;
    AD7768_RESET_N                    : out std_logic;
    AD7768_SDI                        : out std_logic;
    AD7768_SDO                        : in std_logic;
    AD7768_SPI_SCK                    : out std_logic;
    AD7768_SYNC_IN                    : out std_logic;
    AD7768_DOUT                       : in std_logic_vector(3 downto 0);
    
    FPGA_RX                           : in std_logic;
    FPGA_TX                           : out std_logic;
    
    DB25_PWR_EN                       : out std_logic;
    GPIO_LED                          : out std_logic;
    
    AD1939_MCLK                       : in std_logic;
    AD1939_ABCLK                      : in std_logic;
    AD1939_ALRCLK                     : in std_logic;
    AD1939_CS_N                       : out std_logic;
    AD1939_DBCLK                      : out std_logic;
    AD1939_DLRCLK                     : out std_logic;
    AD1939_HDPHN_OUT_DSDATA           : out std_logic;
    AD1939_LINE_IN_DSDATA             : in std_logic;
    AD1939_LINE_OUT_DSDATA            : out std_logic;
    AD1939_MIC_IN_DSDATA              : in std_logic;
    AD1939_PWR_EN                     : out std_logic;
    AD1939_RST_CODEC_N                : out std_logic;
    AD1939_SPI_MISO                   : in std_logic;
    AD1939_SPI_MOSI                   : out std_logic;
    AD1939_SPI_SCK                    : out std_logic;

    I2C_SCL                           : inout std_logic;
    I2C_SDA                           : inout std_logic;
    
    AA_12V0_EN                        : out std_logic_vector(3 downto 0);
    AA_BANK_EN                        : out std_logic_vector(1 downto 0);
    AA_LVDS_EN_N                      : out std_logic_vector(15 downto 0);
    AA_MCLK                           : out std_logic_vector(3 downto 0);
    AA_SDI                            : in  std_logic_vector(15 downto 0);
    AA_SDO                            : out std_logic_vector(15 downto 0);
    
    DB25_GPIO                         : inout std_logic_vector(17 downto 0);
    P3_GPIO                           : inout std_logic_vector(3 downto 0)
);

end entity;

ARCHITECTURE Audioblade_Arch OF Audioblade IS

component audioblade_system is
port (
    ad1939_abclk_clk                               : in    std_logic                     := 'X';             -- clk
    ad1939_alrclk_clk                              : in    std_logic                     := 'X';             -- clk
    ad1939_mclk_clk                                : in    std_logic                     := 'X';             -- clk
    ad1939_physical_ad1939_adc_asdata1             : in    std_logic                     := 'X';             -- ad1939_adc_asdata1
    ad1939_physical_ad1939_adc_asdata2             : in    std_logic                     := 'X';             -- ad1939_adc_asdata2
    ad1939_physical_ad1939_dac_dbclk               : out   std_logic;                                        -- ad1939_dac_dbclk
    ad1939_physical_ad1939_dac_dlrclk              : out   std_logic;                                        -- ad1939_dac_dlrclk
    ad1939_physical_ad1939_dac_dsdata1             : out   std_logic;                                        -- ad1939_dac_dsdata1
    ad1939_physical_ad1939_dac_dsdata2             : out   std_logic;                                        -- ad1939_dac_dsdata2
    ad5791_left_physical_ad5791_clr_n_out          : out   std_logic;                                        -- ad5791_clr_n_out
    ad5791_left_physical_ad5791_ldac_n_out         : out   std_logic;                                        -- ad5791_ldac_n_out
    ad5791_left_physical_ad5791_miso_out           : in    std_logic                     := 'X';             -- ad5791_miso_out
    ad5791_left_physical_ad5791_mosi_in            : out   std_logic;                                        -- ad5791_mosi_in
    ad5791_left_physical_ad5791_sclk_out           : out   std_logic;                                        -- ad5791_sclk_out
    ad5791_left_physical_ad5791_sync_n_out         : out   std_logic;                                        -- ad5791_sync_n_out
    ad7768_physical_ad7768_dout_in                 : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- ad7768_dout_in
    ad7768_physical_ad7768_drdy_in                 : in    std_logic                     := 'X';             -- ad7768_drdy_in
    ad7768_physical_ad7768_dclk_in                 : in    std_logic                     := 'X';             -- ad7768_dclk_in
    addr_sel_in_add_sel                            : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- add_sel
    axi_clk_bridge_in_clk_clk                      : in    std_logic                     := 'X';             -- clk
    clk_100_clk                                    : in    std_logic                     := 'X';             -- clk
    ddr_ref_clk_clk                                : in    std_logic                     := 'X';             -- clk
    emif_0_global_reset_n_reset_n                  : in    std_logic                     := 'X';             -- reset_n
    emif_0_mem_mem_ck                              : out   std_logic;                     -- mem_ck
    emif_0_mem_mem_ck_n                            : out   std_logic;                     -- mem_ck_n
    emif_0_mem_mem_a                               : out   std_logic_vector(16 downto 0);                    -- mem_a
    emif_0_mem_mem_act_n                           : out   std_logic;                     -- mem_act_n
    emif_0_mem_mem_ba                              : out   std_logic_vector(1 downto 0);                     -- mem_ba
    emif_0_mem_mem_bg                              : out   std_logic;                     -- mem_bg
    emif_0_mem_mem_cke                             : out   std_logic;                     -- mem_cke
    emif_0_mem_mem_cs_n                            : out   std_logic;                     -- mem_cs_n
    emif_0_mem_mem_odt                             : out   std_logic;                     -- mem_odt
    emif_0_mem_mem_reset_n                         : out   std_logic;                     -- mem_reset_n
    emif_0_mem_mem_par                             : out   std_logic;                     -- mem_par
    emif_0_mem_mem_alert_n                         : in    std_logic                     := 'X'; -- mem_alert_n
    emif_0_mem_mem_dqs                             : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs
    emif_0_mem_mem_dqs_n                           : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dqs_n
    emif_0_mem_mem_dq                              : inout std_logic_vector(63 downto 0) := (others => 'X'); -- mem_dq
    emif_0_mem_mem_dbi_n                           : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dbi_n
    emif_0_oct_oct_rzqin                           : in    std_logic                     := 'X';             -- oct_rzqin
    emif_0_pll_extra_clk_0_pll_extra_clk_0         : out   std_logic;                                        -- pll_extra_clk_0
    emif_0_pll_locked_pll_locked                   : out   std_logic;                                        -- pll_locked
    emif_0_pll_ref_clk_clk                         : in    std_logic                     := 'X';             -- clk
    emif_0_status_local_cal_success                : out   std_logic;                                        -- local_cal_success
    emif_0_status_local_cal_fail                   : out   std_logic;                                        -- local_cal_fail
    emif_a10_hps_0_global_reset_reset_sink_reset_n : in    std_logic                     := 'X';             -- reset_n
    hps_0_h2f_reset_reset_n                        : out   std_logic;                                        -- reset_n
    hps_io_hps_io_phery_emac1_TX_CLK               : out   std_logic;                                        -- hps_io_phery_emac1_TX_CLK
    hps_io_hps_io_phery_emac1_TXD0                 : out   std_logic;                                        -- hps_io_phery_emac1_TXD0
    hps_io_hps_io_phery_emac1_TXD1                 : out   std_logic;                                        -- hps_io_phery_emac1_TXD1
    hps_io_hps_io_phery_emac1_TXD2                 : out   std_logic;                                        -- hps_io_phery_emac1_TXD2
    hps_io_hps_io_phery_emac1_TXD3                 : out   std_logic;                                        -- hps_io_phery_emac1_TXD3
    hps_io_hps_io_phery_emac1_RX_CTL               : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RX_CTL
    hps_io_hps_io_phery_emac1_TX_CTL               : out   std_logic;                                        -- hps_io_phery_emac1_TX_CTL
    hps_io_hps_io_phery_emac1_RX_CLK               : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RX_CLK
    hps_io_hps_io_phery_emac1_RXD0                 : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD0
    hps_io_hps_io_phery_emac1_RXD1                 : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD1
    hps_io_hps_io_phery_emac1_RXD2                 : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD2
    hps_io_hps_io_phery_emac1_RXD3                 : in    std_logic                     := 'X';             -- hps_io_phery_emac1_RXD3
    hps_io_hps_io_phery_emac1_MDIO                 : inout std_logic                     := 'X';             -- hps_io_phery_emac1_MDIO
    hps_io_hps_io_phery_emac1_MDC                  : out   std_logic;                                        -- hps_io_phery_emac1_MDC
    hps_io_hps_io_phery_sdmmc_CMD                  : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_CMD
    hps_io_hps_io_phery_sdmmc_D0                   : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D0
    hps_io_hps_io_phery_sdmmc_D1                   : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D1
    hps_io_hps_io_phery_sdmmc_D2                   : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D2
    hps_io_hps_io_phery_sdmmc_D3                   : inout std_logic                     := 'X';             -- hps_io_phery_sdmmc_D3
    hps_io_hps_io_phery_sdmmc_CCLK                 : out   std_logic;                                        -- hps_io_phery_sdmmc_CCLK
    hps_io_hps_io_phery_usb1_DATA0                 : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA0
    hps_io_hps_io_phery_usb1_DATA1                 : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA1
    hps_io_hps_io_phery_usb1_DATA2                 : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA2
    hps_io_hps_io_phery_usb1_DATA3                 : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA3
    hps_io_hps_io_phery_usb1_DATA4                 : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA4
    hps_io_hps_io_phery_usb1_DATA5                 : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA5
    hps_io_hps_io_phery_usb1_DATA6                 : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA6
    hps_io_hps_io_phery_usb1_DATA7                 : inout std_logic                     := 'X';             -- hps_io_phery_usb1_DATA7
    hps_io_hps_io_phery_usb1_CLK                   : in    std_logic                     := 'X';             -- hps_io_phery_usb1_CLK
    hps_io_hps_io_phery_usb1_STP                   : out   std_logic;                                        -- hps_io_phery_usb1_STP
    hps_io_hps_io_phery_usb1_DIR                   : in    std_logic                     := 'X';             -- hps_io_phery_usb1_DIR
    hps_io_hps_io_phery_usb1_NXT                   : in    std_logic                     := 'X';             -- hps_io_phery_usb1_NXT
    hps_io_hps_io_phery_uart1_RX                   : in    std_logic                     := 'X';             -- hps_io_phery_uart1_RX
    hps_io_hps_io_phery_uart1_TX                   : out   std_logic;                                        -- hps_io_phery_uart1_TX
    hps_io_hps_io_phery_i2c0_SDA                   : inout std_logic                     := 'X';             -- hps_io_phery_i2c0_SDA
    hps_io_hps_io_phery_i2c0_SCL                   : inout std_logic                     := 'X';             -- hps_io_phery_i2c0_SCL
    hps_io_hps_io_gpio_gpio2_io6                   : inout std_logic                     := 'X';             -- hps_io_gpio_gpio2_io6
    hps_io_hps_io_gpio_gpio2_io8                   : inout std_logic                     := 'X';             -- hps_io_gpio_gpio2_io8
    hps_io_hps_io_gpio_gpio0_io0                   : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io0
    hps_io_hps_io_gpio_gpio0_io1                   : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io1
    --hps_io_hps_io_gpio_gpio0_io2                   : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io2
    --hps_io_hps_io_gpio_gpio0_io3                   : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io3
    hps_io_hps_io_gpio_gpio0_io6                   : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io6
    --hps_io_hps_io_gpio_gpio0_io7                   : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io7
    --hps_io_hps_io_gpio_gpio0_io10                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io10
    hps_io_hps_io_gpio_gpio0_io11                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio0_io11
    hps_io_hps_io_gpio_gpio1_io12                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io12
    hps_io_hps_io_gpio_gpio1_io13                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io13
    hps_io_hps_io_gpio_gpio1_io14                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io14
    hps_io_hps_io_gpio_gpio1_io15                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io15
    hps_io_hps_io_gpio_gpio1_io16                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io16
    hps_io_hps_io_gpio_gpio1_io17                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io17
    hps_io_hps_io_gpio_gpio1_io18                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io18
    hps_io_hps_io_gpio_gpio1_io19                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io19
    hps_io_hps_io_gpio_gpio1_io20                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io20
    hps_io_hps_io_gpio_gpio1_io21                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io21
    hps_io_hps_io_gpio_gpio1_io22                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io22
    hps_io_hps_io_gpio_gpio1_io23                  : inout std_logic                     := 'X';             -- hps_io_gpio_gpio1_io23
    hps_spim0_mosi_o                               : out   std_logic;                                        -- mosi_o
    hps_spim0_miso_i                               : in    std_logic                     := 'X';             -- miso_i
    hps_spim0_ss_in_n                              : in    std_logic                     := 'X';             -- ss_in_n
    hps_spim0_mosi_oe                              : out   std_logic;                                        -- mosi_oe
    hps_spim0_ss0_n_o                              : out   std_logic;                                        -- ss0_n_o
    hps_spim0_ss1_n_o                              : out   std_logic;                                        -- ss1_n_o
    hps_spim0_ss2_n_o                              : out   std_logic;                                        -- ss2_n_o
    hps_spim0_ss3_n_o                              : out   std_logic;                                        -- ss3_n_o
    hps_spim0_sclk_out_clk                         : out   std_logic;                                        -- clk
    hps_i2c1_scl_in_clk                            : in    std_logic                     := 'X';             -- clk
    hps_i2c1_clk_clk                               : out   std_logic;                                        -- clk
    hps_i2c1_sda_i                                 : in    std_logic                     := 'X';             -- sda_i
    hps_i2c1_sda_oe                                : out   std_logic;                                         -- sda_oe
    mclk_pll_locked_export                         : out   std_logic;                                        -- export
    mem_mem_ck                                     : out   std_logic;                     -- mem_ck
    mem_mem_ck_n                                   : out   std_logic;                     -- mem_ck_n
    mem_mem_a                                      : out   std_logic_vector(16 downto 0);                    -- mem_a
    mem_mem_act_n                                  : out   std_logic;                     -- mem_act_n
    mem_mem_ba                                     : out   std_logic_vector(1 downto 0);                     -- mem_ba
    mem_mem_bg                                     : out   std_logic;                     -- mem_bg
    mem_mem_cke                                    : out   std_logic;                     -- mem_cke
    mem_mem_cs_n                                   : out   std_logic;                     -- mem_cs_n
    mem_mem_odt                                    : out   std_logic;                     -- mem_odt
    mem_mem_reset_n                                : out   std_logic;                     -- mem_reset_n
    mem_mem_par                                    : out   std_logic;                     -- mem_par
    mem_mem_alert_n                                : in    std_logic                     := 'X'; -- mem_alert_n
    mem_mem_dqs                                    : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dqs
    mem_mem_dqs_n                                  : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dqs_n
    mem_mem_dq                                     : inout std_logic_vector(39 downto 0) := (others => 'X'); -- mem_dq
    mem_mem_dbi_n                                  : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- mem_dbi_n
    oct_oct_rzqin                                  : in    std_logic                     := 'X';             -- oct_rzqin
    reset_reset_n                                  : in    std_logic                     := 'X';             -- reset_n
    som_config_pio_export                          : inout std_logic_vector(4 downto 0)  := (others => 'X'); -- export
    mic_array0_physical_serial_data_in             : in    std_logic                     := 'X';             -- serial_data_in
    mic_array0_physical_serial_data_out            : out   std_logic;                                        -- serial_data_out
    mic_array0_physical_serial_clk_out             : out   std_logic;                                        -- serial_clk_out
    mic_array0_control_busy_out                    : out   std_logic;                                        -- busy_out
    mic_array1_physical_serial_data_in             : in    std_logic                     := 'X';             -- serial_data_in
    mic_array1_physical_serial_data_out            : out   std_logic;                                        -- serial_data_out
    mic_array1_physical_serial_clk_out             : out   std_logic;                                        -- serial_clk_out
    mic_array2_physical_serial_data_in             : in    std_logic                     := 'X';             -- serial_data_in
    mic_array2_physical_serial_data_out            : out   std_logic;                                        -- serial_data_out
    mic_array2_physical_serial_clk_out             : out   std_logic;                                        -- serial_clk_out
    mic_array2_control_busy_out                    : out   std_logic;                                        -- busy_out
    mic_array3_physical_serial_data_in             : in    std_logic                     := 'X';             -- serial_data_in
    mic_array3_physical_serial_data_out            : out   std_logic;                                        -- serial_data_out
    mic_array3_physical_serial_clk_out             : out   std_logic;                                        -- serial_clk_out
    mic_array3_control_busy_out                    : out   std_logic;                                        -- busy_out
    mic_array4_physical_serial_data_in             : in    std_logic                     := 'X';             -- serial_data_in
    mic_array4_physical_serial_data_out            : out   std_logic;                                        -- serial_data_out
    mic_array4_physical_serial_clk_out             : out   std_logic;                                        -- serial_clk_out
    mic_array4_control_busy_out                    : out   std_logic;                                        -- busy_out
    mic_array5_physical_serial_data_in             : in    std_logic                     := 'X';             -- serial_data_in
    mic_array5_physical_serial_data_out            : out   std_logic;                                        -- serial_data_out
    mic_array5_physical_serial_clk_out             : out   std_logic;                                        -- serial_clk_out
    mic_array5_control_busy_out                    : out   std_logic;                                        -- busy_out
    mic_array6_physical_serial_data_in             : in    std_logic                     := 'X';             -- serial_data_in
    mic_array6_physical_serial_data_out            : out   std_logic;                                        -- serial_data_out
    mic_array6_physical_serial_clk_out             : out   std_logic;                                        -- serial_clk_out
    mic_array6_physical_1_busy_out                 : out   std_logic;                                        -- busy_out
    mic_array7_physical_serial_data_in             : in    std_logic                     := 'X';             -- serial_data_in
    mic_array7_physical_serial_data_out            : out   std_logic;                                        -- serial_data_out
    mic_array7_physical_serial_clk_out             : out   std_logic;                                        -- serial_clk_out
    mic_array7_control_busy_out                    : out   std_logic;                                        -- busy_out
    mic_array8_physical_serial_data_in             : in    std_logic                     := 'X';             -- serial_data_in
    mic_array8_physical_serial_data_out            : out   std_logic;                                        -- serial_data_out
    mic_array8_physical_serial_clk_out             : out   std_logic;                                        -- serial_clk_out
    mic_array8_control_busy_out                    : out   std_logic;                                        -- busy_out
    mic_array9_physical_serial_data_in             : in    std_logic                     := 'X';             -- serial_data_in
    mic_array9_physical_serial_data_out            : out   std_logic;                                        -- serial_data_out
    mic_array9_physical_serial_clk_out             : out   std_logic;                                        -- serial_clk_out
    mic_array9_control_busy_out                    : out   std_logic;                                        -- busy_out
    mic_array10_physical_serial_data_in            : in    std_logic                     := 'X';             -- serial_data_in
    mic_array10_physical_serial_data_out           : out   std_logic;                                        -- serial_data_out
    mic_array10_physical_serial_clk_out            : out   std_logic;                                        -- serial_clk_out
    mic_array10_control_busy_out                   : out   std_logic;                                        -- busy_out
    mic_array11_physical_serial_data_in            : in    std_logic                     := 'X';             -- serial_data_in
    mic_array11_physical_serial_data_out           : out   std_logic;                                        -- serial_data_out
    mic_array11_physical_serial_clk_out            : out   std_logic;                                        -- serial_clk_out
    mic_array11_control_busy_out                   : out   std_logic;                                        -- busy_out
    mic_array12_physical_serial_data_in            : in    std_logic                     := 'X';             -- serial_data_in
    mic_array12_physical_serial_data_out           : out   std_logic;                                        -- serial_data_out
    mic_array12_physical_serial_clk_out            : out   std_logic;                                        -- serial_clk_out
    mic_array12_control_busy_out                   : out   std_logic;                                        -- busy_out
    mic_array13_physical_serial_data_in            : in    std_logic                     := 'X';             -- serial_data_in
    mic_array13_physical_serial_data_out           : out   std_logic;                                        -- serial_data_out
    mic_array13_physical_serial_clk_out            : out   std_logic;                                        -- serial_clk_out
    mic_array13_control_busy_out                   : out   std_logic;                                        -- busy_out
    mic_array14_physical_serial_data_in            : in    std_logic                     := 'X';             -- serial_data_in
    mic_array14_physical_serial_data_out           : out   std_logic;                                        -- serial_data_out
    mic_array14_physical_serial_clk_out            : out   std_logic;                                        -- serial_clk_out
    mic_array14_control_busy_out                   : out   std_logic;                                        -- busy_out
    mic_array15_physical_serial_data_in            : in    std_logic                     := 'X';             -- serial_data_in
    mic_array15_physical_serial_data_out           : out   std_logic;                                        -- serial_data_out
    mic_array15_physical_serial_clk_out            : out   std_logic;                                        -- serial_clk_out
    mic_array15_control_busy_out                   : out   std_logic;                                        -- busy_out
    mic_array1_control_busy_out                    : out   std_logic;                                        -- busy_out
    ad5791_right_physical_ad5791_clr_n_out         : out   std_logic;                                        -- ad5791_clr_n_out
    ad5791_right_physical_ad5791_ldac_n_out        : out   std_logic;                                        -- ad5791_ldac_n_out
    ad5791_right_physical_ad5791_miso_out          : in    std_logic                     := 'X';             -- ad5791_miso_out
    ad5791_right_physical_ad5791_mosi_in           : out   std_logic;                                        -- ad5791_mosi_in
    ad5791_right_physical_ad5791_sclk_out          : out   std_logic;                                        -- ad5791_sclk_out
    ad5791_right_physical_ad5791_sync_n_out        : out   std_logic;                                        -- ad5791_sync_n_out
    ad4020_right_physical_cnv                      : out   std_logic;                                        -- cnv
    ad4020_right_physical_miso                     : in    std_logic                     := 'X';             -- miso
    ad4020_right_physical_mosi                     : out   std_logic;                                        -- mosi
    ad4020_right_physical_sclk                     : out   std_logic;                                        -- sclk
    ad4020_left_physical_cnv                       : out   std_logic;                                        -- cnv
    ad4020_left_physical_miso                      : in    std_logic                     := 'X';             -- miso
    ad4020_left_physical_mosi                      : out   std_logic;                                        -- mosi
    ad4020_left_physical_sclk                      : out   std_logic                                         -- sclk
  );
end component audioblade_system;



  signal hps_fpga_reset_n : std_logic;
  signal reset_n : std_logic;
  
  signal count : integer := 0;
  signal count1 : std_logic;
  
  signal reset1_n : std_logic;
  signal RESETn : std_logic;
  
  signal user_clk : std_logic;
  signal ddr_clk : std_logic;
  
  signal locked : std_logic;
  signal addr_sel : std_logic;  
  
  signal ddr_reset_clk : std_logic;
  signal temp_sens_clk : std_logic;
  
  signal Cal_success : std_logic;
  signal Cal_success_1 : std_logic;  
  signal Cal_success_2 : std_logic;
  signal Cal_fail : std_logic;
  signal Cal_fail_1 : std_logic;
  signal Cal_fail_2 : std_logic;
  
    
  signal spi_mosi : std_logic;
  signal spi_miso : std_logic;
  signal spi_clk  : std_logic;
  
  signal heartbeat_counter : integer range 0 to 12288001 := 0;
  
  signal i2c1_i2c_serial_sda_in		: std_logic;
	signal i2c1_serial_scl_in				: std_logic;
	signal i2c1_serial_sda_oe				: std_logic;
	signal serial_scl_oe						: std_logic;

     
  begin 
  
  
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- Code written by Tushar Sharma from the iWave reference design
-- *****************************************************************************
-- *                            Combinational logic                             *
-- *****************************************************************************

  reset_n             <= hps_fpga_reset_n and sys_reset_n_i;
  reset1_n            <= sys_reset_n_i and RESETn;
  RESETn              <= count1;
  
-- *****************************************************************************
-- *                              Sequential logic                             *
-- *****************************************************************************

  process(ddr_reset_clk, sys_reset_n_i)
  begin 
    if sys_reset_n_i = '0' then 
      count <= 0;
      count1 <= '0';
    elsif rising_edge(ddr_reset_clk) then 
      if count = 16#1000000# then 
        count <= count;
        count1 <= '1';
      else
        count <= count + 1;
      end if;
    end if;
  end process;
     
  process(user_clk, sys_reset_n_i) 
  begin 
    if sys_reset_n_i = '0' then 
      Cal_success_1 <= '0';
      Cal_success_2 <= '0';
      Cal_fail_1 <= '0';
      Cal_fail_2 <= '0';
    elsif rising_edge(user_clk) then 
      Cal_success_1 <= Cal_success;
      Cal_success_2 <= Cal_success_1;
      Cal_fail_1 <= Cal_fail;
      Cal_fail_2 <= Cal_fail_1;
    end if;  
  end process;
 
  
-- *******************************************************************************
-- *                              Internal Modules                               *
-- *******************************************************************************

 -- Clock Genereation using PLL
  pll_entity : entity pll.pll port map 
  ( 
    rst       => not sys_reset_n_i,                                         
    refclk    => fpga_clk_i,                                             
    locked    => locked,  
    outclk_0  => user_clk,              -- 100 Mhz O/P
    outclk_1  => ddr_reset_clk,         -- 266.66 Mhz O/P
    outclk_2  => temp_sens_clk          -- 20 Mhz O/P 
  );

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
   
 -- QSYS Design 
  i0: component audioblade_system
    port map(
    -- Clock
    clk_100_clk                                    => user_clk,                                            
    -- HPS DDR Signals                             
    ddr_ref_clk_clk                                => ddr_ref_clk_i,
    emif_0_global_reset_n_reset_n                  => RESETn,
    emif_0_mem_mem_ck                              => FPGA_memory_mem1_ck,
    emif_0_mem_mem_ck_n                            => FPGA_memory_mem1_ck_n,
    emif_0_mem_mem_a                               => FPGA_memory_mem1_a,
    emif_0_mem_mem_act_n                           => FPGA_memory_mem1_act_n,
    emif_0_mem_mem_ba                              => FPGA_memory_mem1_ba,
    emif_0_mem_mem_bg                              => FPGA_memory_mem1_bg,
    emif_0_mem_mem_cke                             => FPGA_memory_mem1_cke,
    emif_0_mem_mem_cs_n                            => FPGA_memory_mem1_cs_n,
    emif_0_mem_mem_odt                             => FPGA_memory_mem1_odt,
    emif_0_mem_mem_reset_n                         => FPGA_memory_mem1_reset_n,
    emif_0_mem_mem_par                             => FPGA_memory_mem1_par,
    emif_0_mem_mem_alert_n                         => FPGA_memory_mem1_alert_n,
    emif_0_mem_mem_dqs                             => FPGA_memory_mem1_dqs,
    emif_0_mem_mem_dqs_n                           => FPGA_memory_mem1_dqs_n,
    emif_0_mem_mem_dq                              => FPGA_memory_mem1_dq,
    emif_0_mem_mem_dbi_n                           => FPGA_memory_mem1_dbi_n,
    emif_0_oct_oct_rzqin                           => FPGA_memory_oct1_rzqin,
    emif_0_pll_ref_clk_clk                         => clk_200,
    emif_0_status_local_cal_success                => Cal_success,
    emif_0_status_local_cal_fail                   => Cal_fail,
    emif_a10_hps_0_global_reset_reset_sink_reset_n => reset_n,
    hps_0_h2f_reset_reset_n                        => hps_fpga_reset_n,                                         
    
    --HPS PIN Muxing Signals  
    hps_io_hps_io_phery_emac1_TX_CLK               => hps_emac1_TX_CLK,
    hps_io_hps_io_phery_emac1_TXD0                 => hps_emac1_TXD0,                                              
    hps_io_hps_io_phery_emac1_TXD1                 => hps_emac1_TXD1,
    hps_io_hps_io_phery_emac1_TXD2                 => hps_emac1_TXD2,
    hps_io_hps_io_phery_emac1_TXD3                 => hps_emac1_TXD3,                                         
    hps_io_hps_io_phery_emac1_MDIO                 => hps_emac1_MDIO,
    hps_io_hps_io_phery_emac1_MDC                  => hps_emac1_MDC,
    hps_io_hps_io_phery_emac1_RX_CTL               => hps_emac1_RX_CTL,
    hps_io_hps_io_phery_emac1_TX_CTL               => hps_emac1_TX_CTL,
    hps_io_hps_io_phery_emac1_RX_CLK               => hps_emac1_RX_CLK,
    hps_io_hps_io_phery_emac1_RXD0                 => hps_emac1_RXD0,
    hps_io_hps_io_phery_emac1_RXD1                 => hps_emac1_RXD1,
    hps_io_hps_io_phery_emac1_RXD2                 => hps_emac1_RXD2,
    hps_io_hps_io_phery_emac1_RXD3                 => hps_emac1_RXD3,
    hps_io_hps_io_phery_usb1_DATA0                 => hps_usb1_D0,
    hps_io_hps_io_phery_usb1_DATA1                 => hps_usb1_D1,
    hps_io_hps_io_phery_usb1_DATA2                 => hps_usb1_D2,
    hps_io_hps_io_phery_usb1_DATA3                 => hps_usb1_D3,
    hps_io_hps_io_phery_usb1_DATA4                 => hps_usb1_D4,
    hps_io_hps_io_phery_usb1_DATA5                 => hps_usb1_D5,
    hps_io_hps_io_phery_usb1_DATA6                 => hps_usb1_D6,
    hps_io_hps_io_phery_usb1_DATA7                 => hps_usb1_D7,
    hps_io_hps_io_phery_usb1_CLK                   => hps_usb1_CLK,
    hps_io_hps_io_phery_usb1_STP                   => hps_usb1_STP,
    hps_io_hps_io_phery_usb1_DIR                   => hps_usb1_DIR,
    hps_io_hps_io_phery_usb1_NXT                   => hps_usb1_NXT,    
    hps_io_hps_io_phery_uart1_RX                   => hps_uart1_RX,
    hps_io_hps_io_phery_uart1_TX                   => hps_uart1_TX,  
    hps_io_hps_io_phery_sdmmc_CMD                  => hps_sdio_CMD,
    hps_io_hps_io_phery_sdmmc_D0                   => hps_sdio_D0,
    hps_io_hps_io_phery_sdmmc_D1                   => hps_sdio_D1,
    hps_io_hps_io_phery_sdmmc_D2                   => hps_sdio_D2,
    hps_io_hps_io_phery_sdmmc_D3                   => hps_sdio_D3,
    hps_io_hps_io_phery_sdmmc_CCLK                 => hps_sdio_CLK,
    hps_io_hps_io_phery_i2c0_SDA                   => hps_i2c0_SDA,
    hps_io_hps_io_phery_i2c0_SCL                   => hps_i2c0_SCL,                                         
    
    hps_io_hps_io_gpio_gpio2_io6                   => hps_gpio2_GPIO6,                                         
    hps_io_hps_io_gpio_gpio2_io8                   => hps_gpio2_GPIO8,                                            
    hps_io_hps_io_gpio_gpio0_io0                   => hps_gpio_GPIO0,                                         
    hps_io_hps_io_gpio_gpio0_io1                   => hps_gpio_GPIO1,
    hps_io_hps_io_gpio_gpio0_io6                   => hps_gpio_GPIO6,
    hps_io_hps_io_gpio_gpio0_io11                  => hps_gpio_GPIO11,
    hps_io_hps_io_gpio_gpio1_io12                  => hps_gpio_GPIO12,
    hps_io_hps_io_gpio_gpio1_io13                  => hps_gpio_GPIO13,
    hps_io_hps_io_gpio_gpio1_io14                  => hps_gpio_GPIO14,
    hps_io_hps_io_gpio_gpio1_io15                  => hps_gpio_GPIO15,
    hps_io_hps_io_gpio_gpio1_io16                  => hps_gpio_GPIO16,
    hps_io_hps_io_gpio_gpio1_io17                  => hps_gpio_GPIO17,
    hps_io_hps_io_gpio_gpio1_io18                  => hps_gpio_GPIO18,
    hps_io_hps_io_gpio_gpio1_io19                  => hps_gpio_GPIO19,
    hps_io_hps_io_gpio_gpio1_io20                  => hps_gpio_GPIO20,
    hps_io_hps_io_gpio_gpio1_io21                  => hps_gpio_GPIO21,
    hps_io_hps_io_gpio_gpio1_io22                  => hps_gpio_GPIO22,
    hps_io_hps_io_gpio_gpio1_io23                  => hps_gpio_GPIO23,

    -- FPGA SPI Signals
    hps_spim0_mosi_o                               => spi_mosi,
    hps_spim0_miso_i                               => spi_miso,
    hps_spim0_ss_in_n                              => '1',
    hps_spim0_mosi_oe                              => open,
    hps_spim0_ss0_n_o                              => AD1939_CS_N,
    hps_spim0_ss1_n_o                              => PGA2505_CS_N,
    hps_spim0_ss2_n_o                              => open,
    hps_spim0_ss3_n_o                              => open,
    hps_spim0_sclk_out_clk                         => spi_clk,

    -- I2C1 Signals
    hps_i2c1_scl_in_clk                          => i2c1_serial_scl_in,
    hps_i2c1_clk_clk                             => serial_scl_oe,
    hps_i2c1_sda_i                               => i2c1_i2c_serial_sda_in,
    hps_i2c1_sda_oe                              => i2c1_serial_sda_oe,
            
    -- FPGA DDR Signals
    mem_mem_a                                      => hps_memory_mem_a,
    mem_mem_act_n                                  => hps_memory_mem_act_n,
    mem_mem_par                                    => hps_memory_mem_par,
    mem_mem_alert_n                                => hps_memory_mem_alert_n,
    mem_mem_ba                                     => hps_memory_mem_ba,
    mem_mem_bg                                     => hps_memory_mem_bg,
    mem_mem_ck                                     => hps_memory_mem_ck,
    mem_mem_ck_n                                   => hps_memory_mem_ck_n,
    mem_mem_cke                                    => hps_memory_mem_cke,
    mem_mem_cs_n                                   => hps_memory_mem_cs_n,
    mem_mem_reset_n                                => hps_memory_mem_reset_n,
    mem_mem_dq                                     => hps_memory_mem_dq,
    mem_mem_dqs                                    => hps_memory_mem_dqs,
    mem_mem_dqs_n                                  => hps_memory_mem_dqs_n,
    mem_mem_dbi_n                                  => hps_memory_mem_dbi_n,
    mem_mem_odt                                    => hps_memory_mem_odt,
    oct_oct_rzqin                                  => hps_memory_oct_rzqin,
    reset_reset_n                                  => reset1_n,                                         
    
    -- DDR Clock Mappings
    emif_0_pll_extra_clk_0_pll_extra_clk_0        => ddr_clk,                      
    axi_clk_bridge_in_clk_clk                     => ddr_clk,                                             

  -- AD1939 Connections
  ad1939_abclk_clk                                =>  AD1939_ABCLK,   
  ad1939_alrclk_clk                               =>  AD1939_ALRCLK,  
  ad1939_mclk_clk                                 =>  AD1939_MCLK,    
  ad1939_physical_ad1939_adc_asdata1              =>  AD1939_LINE_IN_DSDATA, 
  ad1939_physical_ad1939_adc_asdata2              =>  AD1939_MIC_IN_DSDATA, 
  ad1939_physical_ad1939_dac_dbclk                =>  AD1939_DBCLK, 
  ad1939_physical_ad1939_dac_dlrclk               =>  AD1939_DLRCLK, 
  ad1939_physical_ad1939_dac_dsdata1              =>  AD1939_LINE_OUT_DSDATA, 
  ad1939_physical_ad1939_dac_dsdata2              =>  AD1939_HDPHN_OUT_DSDATA, 

  mclk_pll_locked_export                          => open,
  
  --AD4020 connections  
  ad4020_left_physical_cnv                        => HSA_IN_L_CNV,    
  ad4020_left_physical_miso                       => HSA_IN_L_SDO,    
  ad4020_left_physical_mosi                       => HSA_IN_L_SDI,    
  ad4020_left_physical_sclk                       => HSA_IN_CLK,      
          
  ad4020_right_physical_cnv                       =>  HSA_IN_R_CNV,   
  ad4020_right_physical_miso                      =>  HSA_IN_R_SDO,   
  ad4020_right_physical_mosi                      =>  HSA_IN_R_SDI,   
  ad4020_right_physical_sclk                      =>  open,     

  
  -- AD5791 connections
  ad5791_left_physical_ad5791_clr_n_out          => HSA_OUT_L_CLR_N,  
  ad5791_left_physical_ad5791_ldac_n_out         => HSA_OUT_L_LDAC_N, 
  ad5791_left_physical_ad5791_miso_out           => HSA_OUT_L_SDO,    
  ad5791_left_physical_ad5791_mosi_in            => HSA_OUT_L_SDI,    
  ad5791_left_physical_ad5791_sclk_out           => HSA_OUT_CLK,      
  ad5791_left_physical_ad5791_sync_n_out         => HSA_OUT_L_SYNC_N, 
 
  ad5791_right_physical_ad5791_clr_n_out          => HSA_OUT_R_CLR_N, 
  ad5791_right_physical_ad5791_ldac_n_out         => HSA_OUT_R_LDAC_N,
  ad5791_right_physical_ad5791_miso_out           => HSA_OUT_R_SDO,   
  ad5791_right_physical_ad5791_mosi_in            => HSA_OUT_R_SDI,   
  ad5791_right_physical_ad5791_sclk_out           => open,     
  ad5791_right_physical_ad5791_sync_n_out         => HSA_OUT_R_SYNC_N,
   
  
  -- Microphone array connections
  mic_array0_physical_serial_data_in             => AA_SDI(0), 
  mic_array0_physical_serial_data_out            => AA_SDO(0), 
  mic_array0_physical_serial_clk_out             => AA_MCLK(0),
  mic_array0_control_busy_out                    => open,      
  mic_array1_physical_serial_data_in             => AA_SDI(1), 
  mic_array1_physical_serial_data_out            => AA_SDO(1), 
  mic_array1_physical_serial_clk_out             => open,
  mic_array1_control_busy_out                    => open,      
  mic_array2_physical_serial_data_in             => AA_SDI(2), 
  mic_array2_physical_serial_data_out            => AA_SDO(2), 
  mic_array2_physical_serial_clk_out             => open,
  mic_array2_control_busy_out                    => open,      
  mic_array3_physical_serial_data_in             => AA_SDI(3), 
  mic_array3_physical_serial_data_out            => AA_SDO(3), 
  mic_array3_physical_serial_clk_out             => open,
  mic_array3_control_busy_out                    => open,      
  mic_array4_physical_serial_data_in             => AA_SDI(4), 
  mic_array4_physical_serial_data_out            => AA_SDO(4), 
  mic_array4_physical_serial_clk_out             => AA_MCLK(1),
  mic_array4_control_busy_out                    => open,      
  mic_array5_physical_serial_data_in             => AA_SDI(5), 
  mic_array5_physical_serial_data_out            => AA_SDO(5), 
  mic_array5_physical_serial_clk_out             => open,
  mic_array5_control_busy_out                    => open,      
  mic_array6_physical_serial_data_in             => AA_SDI(6), 
  mic_array6_physical_serial_data_out            => AA_SDO(6), 
  mic_array6_physical_serial_clk_out             => open,
  mic_array6_physical_1_busy_out                 => open,      
  mic_array7_physical_serial_data_in             => AA_SDI(7), 
  mic_array7_physical_serial_data_out            => AA_SDO(7), 
  mic_array7_physical_serial_clk_out             => open,
  mic_array7_control_busy_out                    => open,      
  mic_array8_physical_serial_data_in             => AA_SDI(8), 
  mic_array8_physical_serial_data_out            => AA_SDO(8), 
  mic_array8_physical_serial_clk_out             => AA_MCLK(2),
  mic_array8_control_busy_out                    => open,      
  mic_array9_physical_serial_data_in             => AA_SDI(9), 
  mic_array9_physical_serial_data_out            => AA_SDO(9), 
  mic_array9_physical_serial_clk_out             => open,
  mic_array9_control_busy_out                    => open,      
  mic_array10_physical_serial_data_in            => AA_SDI(10),
  mic_array10_physical_serial_data_out           => AA_SDO(10),
  mic_array10_physical_serial_clk_out            => open,
  mic_array10_control_busy_out                   => open,      
  mic_array11_physical_serial_data_in            => AA_SDI(11),
  mic_array11_physical_serial_data_out           => AA_SDO(11),
  mic_array11_physical_serial_clk_out            => open,
  mic_array11_control_busy_out                   => open,      
  mic_array12_physical_serial_data_in            => AA_SDI(12),
  mic_array12_physical_serial_data_out           => AA_SDO(12),
  mic_array12_physical_serial_clk_out            => AA_MCLK(3),
  mic_array12_control_busy_out                   => open,      
  mic_array13_physical_serial_data_in            => AA_SDI(13),
  mic_array13_physical_serial_data_out           => AA_SDO(13),
  mic_array13_physical_serial_clk_out            => open,
  mic_array13_control_busy_out                   => open,      
  mic_array14_physical_serial_data_in            => AA_SDI(14),
  mic_array14_physical_serial_data_out           => AA_SDO(14),
  mic_array14_physical_serial_clk_out            => open,
  mic_array14_control_busy_out                   => open,      
  mic_array15_physical_serial_data_in            => AA_SDI(15),
  mic_array15_physical_serial_data_out           => AA_SDO(15),
  mic_array15_physical_serial_clk_out            => open,
  mic_array15_control_busy_out                   => open       
    
);

-- Enable the audio arrays
AA_LVDS_EN_N  <= (others => '0');
AA_BANK_EN    <= (others => '1');
AA_12V0_EN    <= (others => '1');

-- Enable the AD1939
AD1939_PWR_EN       <= '1';
AD1939_RST_CODEC_N  <= '1';

-- Enable the high speed audio
HSA_IN_EN_N   <= '0';
AD4020_EN     <= '1';
AD5791_EN     <= '1';

-- Enable the TPA613
HDPHN_PWR_OFF_N <= '1';

-- Map the SPI signals
spi_miso          <= AD1939_SPI_MISO;
AD1939_SPI_MOSI   <= spi_mosi;
AD1939_SPI_SCK    <= spi_clk;

---------------------------------------------------------------------------------------------
-- Tri-state buffer the I2C signals
---------------------------------------------------------------------------------------------
-- ubuf1 : component alt_iobuf
-- port map(
    -- i   => '0',
    -- oe  => i2c1_serial_sda_oe,
    -- io  => I2C_SDA,
    -- o   => i2c1_i2c_serial_sda_in
 -- );

-- ubuf2 : component alt_iobuf
 -- port map(
    -- i   => '0',
    -- oe  => serial_scl_oe,
    -- io  => I2C_SCL,
    -- o   => i2c1_serial_scl_in
 -- );

ubuf3 : component alt_iobuf
port map(
    i   => '0',
    oe  => i2c1_serial_sda_oe,
    io  => HDPHN_I2C_SCL,
    o   => i2c1_i2c_serial_sda_in
 );

ubuf4 : component alt_iobuf
 port map(
    i   => '0',
    oe  => serial_scl_oe,
    io  => HDPHN_I2C_SDA,
    o   => i2c1_serial_scl_in
 );


heartbeat: process(AD1939_MCLK,sys_reset_n_i)
begin 
  -- if sys_reset_n_i = '0' then 
    -- FPGA_LED <= '0';
    -- GPIO_LED <= '1';
    -- heartbeat_counter <= 0;
  if rising_edge(AD1939_MCLK) then 
    if heartbeat_counter > 0 and heartbeat_counter < 1228800 then 
      FPGA_LED <= '1';
      GPIO_LED <= '0';
    elsif heartbeat_counter > 3686400 and heartbeat_counter < 4915200 then 
      FPGA_LED <= '1';
      GPIO_LED <= '0';
    else
      FPGA_LED <= '0';
      GPIO_LED <= '1';
    end if;
    
    if heartbeat_counter = 12288000 then 
      heartbeat_counter <= 0;
    else
      heartbeat_counter <= heartbeat_counter + 1;
    end if;
    
  end if;
end process;


end architecture;








































