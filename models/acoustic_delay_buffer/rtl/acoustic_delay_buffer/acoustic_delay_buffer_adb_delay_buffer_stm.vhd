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

-- VHDL created from acoustic_delay_buffer_adb_delay_buffer
-- VHDL created on Fri Apr 05 13:33:36 2019


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.TextIO.all;

entity acoustic_delay_buffer_adb_delay_buffer_stm is
    port (
        in_1_valid_in_stm : out std_logic_vector(0 downto 0);
        in_2_channel_in_stm : out std_logic_vector(7 downto 0);
        in_3_din_stm : out std_logic_vector(31 downto 0);
        out_1_valid_out_stm : out std_logic_vector(0 downto 0);
        out_2_channel_out_stm : out std_logic_vector(7 downto 0);
        out_3_dout_stm : out std_logic_vector(31 downto 0);
        in_4_delay_compensation_stm : out std_logic_vector(11 downto 0);
        clk : out std_logic;
        areset : out std_logic
    );
end acoustic_delay_buffer_adb_delay_buffer_stm;

architecture normal of acoustic_delay_buffer_adb_delay_buffer_stm is

    signal clk_stm_sig : std_logic := '0';
    signal clk_stm_sig_stop : std_logic := '0';
    signal areset_stm_sig : std_logic := '1';
    signal clk_ChannelIn_stm_sig_stop : std_logic := '0';
    signal clk_ChannelOut_stm_sig_stop : std_logic := '0';
    signal clk_GPIn_stm_sig_stop : std_logic := '0';

    function str_to_stdvec(inp: string) return std_logic_vector is
        variable temp: std_logic_vector(inp'range) := (others => 'X');
    begin
        for i in inp'range loop
            IF ((inp(i) = '1')) THEN
                temp(i) := '1';
            elsif (inp(i) = '0') then
                temp(i) := '0';
            END IF;
            end loop;
            return temp;
        end function str_to_stdvec;
        

    begin

    clk <= clk_stm_sig;
    clk_process: process 
    begin
        wait for 200 ps;
        clk_stm_sig <= not clk_stm_sig;
        wait for 20145 ps;
        if (clk_stm_sig_stop = '1') then
            assert (false)
            report "Arrived at end of stimulus data on clk clk" severity NOTE;
            wait;
        end if;
        wait for 200 ps;
        clk_stm_sig <= not clk_stm_sig;
        wait for 20145 ps;
        if (clk_stm_sig_stop = '1') then
            assert (false)
            report "Arrived at end of stimulus data on clk clk" severity NOTE;
            wait;
        end if;
    end process;

    areset <= areset_stm_sig;
    areset_process: process begin
        areset_stm_sig <= '1';
        wait for 30517 ps;
        areset_stm_sig <= '0';
        wait;
    end process;

        -- Generating stimulus for ChannelIn
        ChannelIn_stm_init_p: process

            variable L : line;
            variable dummy_int : Integer;
            file data_file_ChannelIn : text open read_mode is "acoustic_delay_buffer/acoustic_delay_buffer_adb_delay_buffer_ChannelIn.stm";
            variable in_1_valid_in_int_0 : Integer;
            variable in_1_valid_in_temp : std_logic_vector(0 downto 0);
            variable in_2_channel_in_int_0 : Integer;
            variable in_2_channel_in_temp : std_logic_vector(7 downto 0);
            variable in_3_din_int_0 : Integer;
            variable in_3_din_temp : std_logic_vector(31 downto 0);

        begin
            -- initialize all outputs to 0
            in_1_valid_in_stm <= (others => '0');
            in_2_channel_in_stm <= (others => '0');
            in_3_din_stm <= (others => '0');

            wait for 201 ps; -- wait delay
            
            while true loop
            
                IF (endfile(data_file_ChannelIn)) THEN
                    clk_ChannelIn_stm_sig_stop <= '1';
                    wait;
                ELSE
                    readline(data_file_ChannelIn, L);
                    
                    read(L, in_1_valid_in_int_0);
                    in_1_valid_in_temp(0 downto 0) := std_logic_vector(to_unsigned(in_1_valid_in_int_0, 1));
                    in_1_valid_in_stm <= in_1_valid_in_temp;
                    read(L, in_2_channel_in_int_0);
                    in_2_channel_in_temp(7 downto 0) := std_logic_vector(to_unsigned(in_2_channel_in_int_0, 8));
                    in_2_channel_in_stm <= in_2_channel_in_temp;
                    read(L, in_3_din_int_0);
                    in_3_din_temp(31 downto 0) := std_logic_vector(to_signed(in_3_din_int_0, 32));
                    in_3_din_stm <= in_3_din_temp;

                    deallocate(L);
                END IF;
                -- -- wait for rising edge to pass (assert signals just after rising edge)
                wait until clk_stm_sig'EVENT and clk_stm_sig = '1';
                wait for 1 ps; -- wait delay
                
                end loop;
            wait;
        END PROCESS;
        -- Generating stimulus for ChannelOut
        ChannelOut_stm_init_p: process

            variable L : line;
            variable dummy_int : Integer;
            file data_file_ChannelOut : text open read_mode is "acoustic_delay_buffer/acoustic_delay_buffer_adb_delay_buffer_ChannelOut.stm";
            variable out_1_valid_out_int_0 : Integer;
            variable out_1_valid_out_temp : std_logic_vector(0 downto 0);
            variable out_2_channel_out_int_0 : Integer;
            variable out_2_channel_out_temp : std_logic_vector(7 downto 0);
            variable out_3_dout_int_0 : Integer;
            variable out_3_dout_temp : std_logic_vector(31 downto 0);

        begin
            -- initialize all outputs to 0
            out_1_valid_out_stm <= (others => '0');
            out_2_channel_out_stm <= (others => '0');
            out_3_dout_stm <= (others => '0');

            wait for 201 ps; -- wait delay
            
            while true loop
            
                IF (endfile(data_file_ChannelOut)) THEN
                    clk_ChannelOut_stm_sig_stop <= '1';
                    wait;
                ELSE
                    readline(data_file_ChannelOut, L);
                    
                    read(L, out_1_valid_out_int_0);
                    out_1_valid_out_temp(0 downto 0) := std_logic_vector(to_unsigned(out_1_valid_out_int_0, 1));
                    out_1_valid_out_stm <= out_1_valid_out_temp;
                    read(L, out_2_channel_out_int_0);
                    out_2_channel_out_temp(7 downto 0) := std_logic_vector(to_unsigned(out_2_channel_out_int_0, 8));
                    out_2_channel_out_stm <= out_2_channel_out_temp;
                    read(L, out_3_dout_int_0);
                    out_3_dout_temp(31 downto 0) := std_logic_vector(to_signed(out_3_dout_int_0, 32));
                    out_3_dout_stm <= out_3_dout_temp;

                    deallocate(L);
                END IF;
                -- -- wait for rising edge to pass (assert signals just after rising edge)
                wait until clk_stm_sig'EVENT and clk_stm_sig = '1';
                wait for 1 ps; -- wait delay
                
                end loop;
            wait;
        END PROCESS;
        -- Generating stimulus for GPIn
        GPIn_stm_init_p: process

            variable L : line;
            variable dummy_int : Integer;
            file data_file_GPIn : text open read_mode is "acoustic_delay_buffer/acoustic_delay_buffer_adb_delay_buffer_GPIn.stm";
            variable in_4_delay_compensation_int_0 : Integer;
            variable in_4_delay_compensation_temp : std_logic_vector(11 downto 0);

        begin
            -- initialize all outputs to 0
            in_4_delay_compensation_stm <= (others => '0');

            wait for 201 ps; -- wait delay
            
            while true loop
            
                IF (endfile(data_file_GPIn)) THEN
                    clk_GPIn_stm_sig_stop <= '1';
                    wait;
                ELSE
                    readline(data_file_GPIn, L);
                    
                    read(L, in_4_delay_compensation_int_0);
                    in_4_delay_compensation_temp(11 downto 0) := std_logic_vector(to_unsigned(in_4_delay_compensation_int_0, 12));
                    in_4_delay_compensation_stm <= in_4_delay_compensation_temp;

                    deallocate(L);
                END IF;
                -- -- wait for rising edge to pass (assert signals just after rising edge)
                wait until clk_stm_sig'EVENT and clk_stm_sig = '1';
                wait for 1 ps; -- wait delay
                
                end loop;
            wait;
        END PROCESS;

    clk_stm_sig_stop <= clk_ChannelIn_stm_sig_stop OR clk_ChannelOut_stm_sig_stop OR clk_GPIn_stm_sig_stop OR '0';


    END normal;
