-- -------------------------------------------------------------
-- 
-- File Name: SG_hdl_prj\hdlsrc\SG\DataPlane_dut.vhd
-- Created: 2019-06-13 13:16:18
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: DataPlane_dut
-- Source Path: DataPlane/DataPlane_dut
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY DataPlane_dut IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        dut_enable                        :   IN    std_logic;  -- ufix1
        Avalon_Sink_Valid                 :   IN    std_logic;  -- ufix1
        Avalon_Sink_Data                  :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Avalon_Sink_Channel               :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        Avalon_Sink_Error                 :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
        Register_Control_Left_Gain        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Register_Control_Right_Gain       :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        ce_out                            :   OUT   std_logic;  -- ufix1
        Avalon_Source_Valid               :   OUT   std_logic;  -- ufix1
        Avalon_Source_Data                :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Avalon_Source_Channel             :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
        Avalon_Source_Error               :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
        );
END DataPlane_dut;


ARCHITECTURE rtl OF DataPlane_dut IS

  -- Component Declarations
  COMPONENT DataPlane_src_DataPlane
    PORT( clk                             :   IN    std_logic;
          clk_enable                      :   IN    std_logic;
          reset                           :   IN    std_logic;
          Avalon_Sink_Valid               :   IN    std_logic;  -- ufix1
          Avalon_Sink_Data                :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Avalon_Sink_Channel             :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          Avalon_Sink_Error               :   IN    std_logic_vector(1 DOWNTO 0);  -- ufix2
          Register_Control_Left_Gain      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Register_Control_Right_Gain     :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          ce_out                          :   OUT   std_logic;  -- ufix1
          Avalon_Source_Valid             :   OUT   std_logic;  -- ufix1
          Avalon_Source_Data              :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Avalon_Source_Channel           :   OUT   std_logic_vector(1 DOWNTO 0);  -- ufix2
          Avalon_Source_Error             :   OUT   std_logic_vector(1 DOWNTO 0)  -- ufix2
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : DataPlane_src_DataPlane
    USE ENTITY work.DataPlane_src_DataPlane(rtl);

  -- Signals
  SIGNAL enb                              : std_logic;
  SIGNAL Avalon_Sink_Valid_sig            : std_logic;  -- ufix1
  SIGNAL ce_out_sig                       : std_logic;  -- ufix1
  SIGNAL Avalon_Source_Valid_sig          : std_logic;  -- ufix1
  SIGNAL Avalon_Source_Data_sig           : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Avalon_Source_Channel_sig        : std_logic_vector(1 DOWNTO 0);  -- ufix2
  SIGNAL Avalon_Source_Error_sig          : std_logic_vector(1 DOWNTO 0);  -- ufix2

BEGIN
  u_DataPlane_src_DataPlane : DataPlane_src_DataPlane
    PORT MAP( clk => clk,
              clk_enable => enb,
              reset => reset,
              Avalon_Sink_Valid => Avalon_Sink_Valid_sig,  -- ufix1
              Avalon_Sink_Data => Avalon_Sink_Data,  -- sfix32_En28
              Avalon_Sink_Channel => Avalon_Sink_Channel,  -- ufix2
              Avalon_Sink_Error => Avalon_Sink_Error,  -- ufix2
              Register_Control_Left_Gain => Register_Control_Left_Gain,  -- sfix32_En28
              Register_Control_Right_Gain => Register_Control_Right_Gain,  -- sfix32_En28
              ce_out => ce_out_sig,  -- ufix1
              Avalon_Source_Valid => Avalon_Source_Valid_sig,  -- ufix1
              Avalon_Source_Data => Avalon_Source_Data_sig,  -- sfix32_En28
              Avalon_Source_Channel => Avalon_Source_Channel_sig,  -- ufix2
              Avalon_Source_Error => Avalon_Source_Error_sig  -- ufix2
              );

  Avalon_Sink_Valid_sig <= Avalon_Sink_Valid;

  enb <= dut_enable;

  ce_out <= ce_out_sig;

  Avalon_Source_Valid <= Avalon_Source_Valid_sig;

  Avalon_Source_Data <= Avalon_Source_Data_sig;

  Avalon_Source_Channel <= Avalon_Source_Channel_sig;

  Avalon_Source_Error <= Avalon_Source_Error_sig;

END rtl;

