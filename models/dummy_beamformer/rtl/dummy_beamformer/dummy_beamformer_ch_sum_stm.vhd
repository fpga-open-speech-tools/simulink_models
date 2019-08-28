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

-- VHDL created from dummy_beamformer_ch_sum
-- VHDL created on Fri Apr 05 13:36:52 2019


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use std.TextIO.all;

entity dummy_beamformer_ch_sum_stm is
    port (
        d_stm : out std_logic_vector(31 downto 0);
        v_stm : out std_logic_vector(0 downto 0);
        c_stm : out std_logic_vector(7 downto 0);
        dout_stm : out std_logic_vector(31 downto 0);
        vout_stm : out std_logic_vector(0 downto 0);
        cout_stm : out std_logic_vector(7 downto 0);
        clk : out std_logic;
        areset : out std_logic
    );
end dummy_beamformer_ch_sum_stm;

architecture normal of dummy_beamformer_ch_sum_stm is

    signal clk_stm_sig : std_logic := '0';
    signal clk_stm_sig_stop : std_logic := '0';
    signal areset_stm_sig : std_logic := '1';
    signal clk_d_stm_sig_stop : std_logic := '0';
    signal clk_v_stm_sig_stop : std_logic := '0';
    signal clk_c_stm_sig_stop : std_logic := '0';
    signal clk_dout_stm_sig_stop : std_logic := '0';
    signal clk_vout_stm_sig_stop : std_logic := '0';
    signal clk_cout_stm_sig_stop : std_logic := '0';

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

        -- Generating stimulus for d
        d_stm_init_p: process

            variable L : line;
            variable dummy_int : Integer;
            file data_file_ChannelIn : text open read_mode is "dummy_beamformer/dummy_beamformer_ch_sum_AStInput_ChannelIn.stm";
            variable in_3_avalonIfaceRole_data_sink_data_int_0 : Integer;
            variable in_3_avalonIfaceRole_data_sink_data_temp : std_logic_vector(31 downto 0);

        begin
            -- initialize all outputs to 0
            d_stm <= (others => '0');

            wait for 201 ps; -- wait delay
            
            while true loop
            
                -- (ports connected to d)
                IF (endfile(data_file_ChannelIn)) THEN
                    clk_d_stm_sig_stop <= '1';
                    wait;
                ELSE
                    readline(data_file_ChannelIn, L);
                    
                    read(L, dummy_int);
                    read(L, dummy_int);
                    read(L, in_3_avalonIfaceRole_data_sink_data_int_0);
                    in_3_avalonIfaceRole_data_sink_data_temp(31 downto 0) := std_logic_vector(to_signed(in_3_avalonIfaceRole_data_sink_data_int_0, 32));
                    d_stm <= in_3_avalonIfaceRole_data_sink_data_temp;

                    deallocate(L);
                END IF;
                -- -- wait for rising edge to pass (assert signals just after rising edge)
                wait until clk_stm_sig'EVENT and clk_stm_sig = '1';
                wait for 1 ps; -- wait delay
                
                end loop;
            wait;
        END PROCESS;
        -- Generating stimulus for v
        v_stm_init_p: process

            variable L : line;
            variable dummy_int : Integer;
            file data_file_ChannelIn : text open read_mode is "dummy_beamformer/dummy_beamformer_ch_sum_AStInput_ChannelIn.stm";
            variable in_1_avalonIfaceRole_valid_sink_valid_int_0 : Integer;
            variable in_1_avalonIfaceRole_valid_sink_valid_temp : std_logic_vector(0 downto 0);

        begin
            -- initialize all outputs to 0
            v_stm <= (others => '0');

            wait for 201 ps; -- wait delay
            
            while true loop
            
                -- (ports connected to v)
                IF (endfile(data_file_ChannelIn)) THEN
                    clk_v_stm_sig_stop <= '1';
                    wait;
                ELSE
                    readline(data_file_ChannelIn, L);
                    
                    read(L, in_1_avalonIfaceRole_valid_sink_valid_int_0);
                    in_1_avalonIfaceRole_valid_sink_valid_temp(0 downto 0) := std_logic_vector(to_unsigned(in_1_avalonIfaceRole_valid_sink_valid_int_0, 1));
                    v_stm <= in_1_avalonIfaceRole_valid_sink_valid_temp;
                    read(L, dummy_int);
                    read(L, dummy_int);

                    deallocate(L);
                END IF;
                -- -- wait for rising edge to pass (assert signals just after rising edge)
                wait until clk_stm_sig'EVENT and clk_stm_sig = '1';
                wait for 1 ps; -- wait delay
                
                end loop;
            wait;
        END PROCESS;
        -- Generating stimulus for c
        c_stm_init_p: process

            variable L : line;
            variable dummy_int : Integer;
            file data_file_ChannelIn : text open read_mode is "dummy_beamformer/dummy_beamformer_ch_sum_AStInput_ChannelIn.stm";
            variable in_2_avalonIfaceRole_channel_sink_channel_int_0 : Integer;
            variable in_2_avalonIfaceRole_channel_sink_channel_temp : std_logic_vector(7 downto 0);

        begin
            -- initialize all outputs to 0
            c_stm <= (others => '0');

            wait for 201 ps; -- wait delay
            
            while true loop
            
                -- (ports connected to c)
                IF (endfile(data_file_ChannelIn)) THEN
                    clk_c_stm_sig_stop <= '1';
                    wait;
                ELSE
                    readline(data_file_ChannelIn, L);
                    
                    read(L, dummy_int);
                    read(L, in_2_avalonIfaceRole_channel_sink_channel_int_0);
                    in_2_avalonIfaceRole_channel_sink_channel_temp(7 downto 0) := std_logic_vector(to_unsigned(in_2_avalonIfaceRole_channel_sink_channel_int_0, 8));
                    c_stm <= in_2_avalonIfaceRole_channel_sink_channel_temp;
                    read(L, dummy_int);

                    deallocate(L);
                END IF;
                -- -- wait for rising edge to pass (assert signals just after rising edge)
                wait until clk_stm_sig'EVENT and clk_stm_sig = '1';
                wait for 1 ps; -- wait delay
                
                end loop;
            wait;
        END PROCESS;
        -- Generating stimulus for dout
        dout_stm_init_p: process

            variable L : line;
            variable dummy_int : Integer;
            file data_file_ChannelOut : text open read_mode is "dummy_beamformer/dummy_beamformer_ch_sum_AStOutput_ChannelOut.stm";
            variable out_3_avalonIfaceRole_data_source_data_int_0 : Integer;
            variable out_3_avalonIfaceRole_data_source_data_temp : std_logic_vector(31 downto 0);

        begin
            -- initialize all outputs to 0
            dout_stm <= (others => '0');

            wait for 201 ps; -- wait delay
            
            while true loop
            
                -- (ports connected to dout)
                IF (endfile(data_file_ChannelOut)) THEN
                    clk_dout_stm_sig_stop <= '1';
                    wait;
                ELSE
                    readline(data_file_ChannelOut, L);
                    
                    read(L, dummy_int);
                    read(L, dummy_int);
                    read(L, out_3_avalonIfaceRole_data_source_data_int_0);
                    out_3_avalonIfaceRole_data_source_data_temp(31 downto 0) := std_logic_vector(to_signed(out_3_avalonIfaceRole_data_source_data_int_0, 32));
                    dout_stm <= out_3_avalonIfaceRole_data_source_data_temp;

                    deallocate(L);
                END IF;
                -- -- wait for rising edge to pass (assert signals just after rising edge)
                wait until clk_stm_sig'EVENT and clk_stm_sig = '1';
                wait for 1 ps; -- wait delay
                
                end loop;
            wait;
        END PROCESS;
        -- Generating stimulus for vout
        vout_stm_init_p: process

            variable L : line;
            variable dummy_int : Integer;
            file data_file_ChannelOut : text open read_mode is "dummy_beamformer/dummy_beamformer_ch_sum_AStOutput_ChannelOut.stm";
            variable out_1_avalonIfaceRole_valid_source_valid_int_0 : Integer;
            variable out_1_avalonIfaceRole_valid_source_valid_temp : std_logic_vector(0 downto 0);

        begin
            -- initialize all outputs to 0
            vout_stm <= (others => '0');

            wait for 201 ps; -- wait delay
            
            while true loop
            
                -- (ports connected to vout)
                IF (endfile(data_file_ChannelOut)) THEN
                    clk_vout_stm_sig_stop <= '1';
                    wait;
                ELSE
                    readline(data_file_ChannelOut, L);
                    
                    read(L, out_1_avalonIfaceRole_valid_source_valid_int_0);
                    out_1_avalonIfaceRole_valid_source_valid_temp(0 downto 0) := std_logic_vector(to_unsigned(out_1_avalonIfaceRole_valid_source_valid_int_0, 1));
                    vout_stm <= out_1_avalonIfaceRole_valid_source_valid_temp;
                    read(L, dummy_int);
                    read(L, dummy_int);

                    deallocate(L);
                END IF;
                -- -- wait for rising edge to pass (assert signals just after rising edge)
                wait until clk_stm_sig'EVENT and clk_stm_sig = '1';
                wait for 1 ps; -- wait delay
                
                end loop;
            wait;
        END PROCESS;
        -- Generating stimulus for cout
        cout_stm_init_p: process

            variable L : line;
            variable dummy_int : Integer;
            file data_file_ChannelOut : text open read_mode is "dummy_beamformer/dummy_beamformer_ch_sum_AStOutput_ChannelOut.stm";
            variable out_2_avalonIfaceRole_channel_source_channel_int_0 : Integer;
            variable out_2_avalonIfaceRole_channel_source_channel_temp : std_logic_vector(7 downto 0);

        begin
            -- initialize all outputs to 0
            cout_stm <= (others => '0');

            wait for 201 ps; -- wait delay
            
            while true loop
            
                -- (ports connected to cout)
                IF (endfile(data_file_ChannelOut)) THEN
                    clk_cout_stm_sig_stop <= '1';
                    wait;
                ELSE
                    readline(data_file_ChannelOut, L);
                    
                    read(L, dummy_int);
                    read(L, out_2_avalonIfaceRole_channel_source_channel_int_0);
                    out_2_avalonIfaceRole_channel_source_channel_temp(7 downto 0) := std_logic_vector(to_unsigned(out_2_avalonIfaceRole_channel_source_channel_int_0, 8));
                    cout_stm <= out_2_avalonIfaceRole_channel_source_channel_temp;
                    read(L, dummy_int);

                    deallocate(L);
                END IF;
                -- -- wait for rising edge to pass (assert signals just after rising edge)
                wait until clk_stm_sig'EVENT and clk_stm_sig = '1';
                wait for 1 ps; -- wait delay
                
                end loop;
            wait;
        END PROCESS;

    clk_stm_sig_stop <= clk_d_stm_sig_stop OR clk_v_stm_sig_stop OR clk_c_stm_sig_stop OR clk_dout_stm_sig_stop OR clk_vout_stm_sig_stop OR clk_cout_stm_sig_stop OR '0';


    END normal;
