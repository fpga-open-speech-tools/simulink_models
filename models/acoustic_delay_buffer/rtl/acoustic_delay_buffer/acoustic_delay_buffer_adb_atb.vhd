-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 18.0 (Release Build #614)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2018 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from acoustic_delay_buffer_adb
-- VHDL created on Fri Apr 05 13:33:36 2019


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use work.dspba_sim_library_package.all;
entity acoustic_delay_buffer_adb_atb is
end;

architecture normal of acoustic_delay_buffer_adb_atb is

component acoustic_delay_buffer_adb is
    port (
        busIn_writedata : in std_logic_vector(31 downto 0);  -- ufix32
        busIn_address : in std_logic_vector(0 downto 0);  -- ufix1
        busIn_write : in std_logic_vector(0 downto 0);  -- ufix1
        busIn_read : in std_logic_vector(0 downto 0);  -- ufix1
        busOut_readdatavalid : out std_logic_vector(0 downto 0);  -- ufix1
        busOut_readdata : out std_logic_vector(31 downto 0);  -- ufix32
        busOut_waitrequest : out std_logic_vector(0 downto 0);  -- ufix1
        d : in std_logic_vector(31 downto 0);  -- sfix32_en28
        v : in std_logic_vector(0 downto 0);  -- ufix1
        c : in std_logic_vector(7 downto 0);  -- ufix8
        dout : out std_logic_vector(31 downto 0);  -- sfix32_en28
        vout : out std_logic_vector(0 downto 0);  -- ufix1
        cout : out std_logic_vector(7 downto 0);  -- ufix8
        clk : in std_logic;
        areset : in std_logic;
        h_areset : in std_logic
    );
end component;

component acoustic_delay_buffer_adb_stm is
    port (
        busIn_writedata_stm : out std_logic_vector(31 downto 0);
        busIn_address_stm : out std_logic_vector(0 downto 0);
        busIn_write_stm : out std_logic_vector(0 downto 0);
        busIn_read_stm : out std_logic_vector(0 downto 0);
        busOut_readdatavalid_stm : out std_logic_vector(0 downto 0);
        busOut_readdata_stm : out std_logic_vector(31 downto 0);
        busOut_waitrequest_stm : out std_logic_vector(0 downto 0);
        d_stm : out std_logic_vector(31 downto 0);
        v_stm : out std_logic_vector(0 downto 0);
        c_stm : out std_logic_vector(7 downto 0);
        dout_stm : out std_logic_vector(31 downto 0);
        vout_stm : out std_logic_vector(0 downto 0);
        cout_stm : out std_logic_vector(7 downto 0);
        clk : out std_logic;
        areset : out std_logic;
        h_areset : out std_logic
    );
end component;

signal busIn_writedata_stm : STD_LOGIC_VECTOR (31 downto 0);
signal busIn_address_stm : STD_LOGIC_VECTOR (0 downto 0);
signal busIn_write_stm : STD_LOGIC_VECTOR (0 downto 0);
signal busIn_read_stm : STD_LOGIC_VECTOR (0 downto 0);
signal busOut_readdatavalid_stm : STD_LOGIC_VECTOR (0 downto 0);
signal busOut_readdata_stm : STD_LOGIC_VECTOR (31 downto 0);
signal busOut_waitrequest_stm : STD_LOGIC_VECTOR (0 downto 0);
signal d_stm : STD_LOGIC_VECTOR (31 downto 0);
signal v_stm : STD_LOGIC_VECTOR (0 downto 0);
signal c_stm : STD_LOGIC_VECTOR (7 downto 0);
signal dout_stm : STD_LOGIC_VECTOR (31 downto 0);
signal vout_stm : STD_LOGIC_VECTOR (0 downto 0);
signal cout_stm : STD_LOGIC_VECTOR (7 downto 0);
signal busIn_writedata_dut : STD_LOGIC_VECTOR (31 downto 0);
signal busIn_address_dut : STD_LOGIC_VECTOR (0 downto 0);
signal busIn_write_dut : STD_LOGIC_VECTOR (0 downto 0);
signal busIn_read_dut : STD_LOGIC_VECTOR (0 downto 0);
signal busOut_readdatavalid_dut : STD_LOGIC_VECTOR (0 downto 0);
signal busOut_readdata_dut : STD_LOGIC_VECTOR (31 downto 0);
signal busOut_waitrequest_dut : STD_LOGIC_VECTOR (0 downto 0);
signal d_dut : STD_LOGIC_VECTOR (31 downto 0);
signal v_dut : STD_LOGIC_VECTOR (0 downto 0);
signal c_dut : STD_LOGIC_VECTOR (7 downto 0);
signal dout_dut : STD_LOGIC_VECTOR (31 downto 0);
signal vout_dut : STD_LOGIC_VECTOR (0 downto 0);
signal cout_dut : STD_LOGIC_VECTOR (7 downto 0);
        signal clk : std_logic;
        signal areset : std_logic;
        signal h_areset : std_logic;

begin

-- General Purpose data in real output
checkd : process (clk, areset, d_dut, d_stm)
begin
END PROCESS;


-- General Purpose data in real output
checkv : process (clk, areset, v_dut, v_stm)
begin
END PROCESS;


-- General Purpose data in real output
checkc : process (clk, areset, c_dut, c_stm)
begin
END PROCESS;


-- General Purpose data out check
checkdout : process (clk, areset)
variable mismatch_dout : BOOLEAN := FALSE;
variable ok : BOOLEAN := TRUE;
begin
    IF (areset = '1') THEN
        -- do nothing during reset
    ELSIF (clk'EVENT AND clk = '0') THEN -- falling clock edge to avoid transitions
        ok := TRUE;
        mismatch_dout := FALSE;
        IF ( (dout_dut /= dout_stm) and vout_dut = "1") THEN
            mismatch_dout := TRUE;
            report "Mismatch on device output pin dout" severity Warning;
        END IF;
        IF (mismatch_dout) THEN
            ok := FALSE;
        END IF;
        assert (ok)
        report "mismatch in device level signal." severity Failure;
    END IF;
END PROCESS;


-- General Purpose data out check
checkvout : process (clk, areset)
variable mismatch_vout : BOOLEAN := FALSE;
variable ok : BOOLEAN := TRUE;
begin
    IF (areset = '1') THEN
        -- do nothing during reset
    ELSIF (clk'EVENT AND clk = '0') THEN -- falling clock edge to avoid transitions
        ok := TRUE;
        mismatch_vout := FALSE;
        IF ( (vout_dut /= vout_stm)) THEN
            mismatch_vout := TRUE;
            report "Mismatch on device output pin vout" severity Warning;
        END IF;
        IF (mismatch_vout) THEN
            ok := FALSE;
        END IF;
        assert (ok)
        report "mismatch in device level signal." severity Failure;
    END IF;
END PROCESS;


-- General Purpose data out check
checkcout : process (clk, areset)
variable mismatch_cout : BOOLEAN := FALSE;
variable ok : BOOLEAN := TRUE;
begin
    IF (areset = '1') THEN
        -- do nothing during reset
    ELSIF (clk'EVENT AND clk = '0') THEN -- falling clock edge to avoid transitions
        ok := TRUE;
        mismatch_cout := FALSE;
        IF ( (cout_dut /= cout_stm) and vout_dut = "1") THEN
            mismatch_cout := TRUE;
            report "Mismatch on device output pin cout" severity Warning;
        END IF;
        IF (mismatch_cout) THEN
            ok := FALSE;
        END IF;
        assert (ok)
        report "mismatch in device level signal." severity Failure;
    END IF;
END PROCESS;


dut : acoustic_delay_buffer_adb port map (
    busIn_writedata_stm,
    busIn_address_stm,
    busIn_write_stm,
    busIn_read_stm,
    busOut_readdatavalid_dut,
    busOut_readdata_dut,
    busOut_waitrequest_dut,
    d_stm,
    v_stm,
    c_stm,
    dout_dut,
    vout_dut,
    cout_dut,
        clk,
        areset,
        h_areset
);

sim : acoustic_delay_buffer_adb_stm port map (
    busIn_writedata_stm,
    busIn_address_stm,
    busIn_write_stm,
    busIn_read_stm,
    busOut_readdatavalid_stm,
    busOut_readdata_stm,
    busOut_waitrequest_stm,
    d_stm,
    v_stm,
    c_stm,
    dout_stm,
    vout_stm,
    cout_stm,
        clk,
        areset,
        h_areset
);

end normal;
