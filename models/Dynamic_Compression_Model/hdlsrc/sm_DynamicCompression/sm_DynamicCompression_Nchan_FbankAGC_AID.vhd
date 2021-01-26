-- -------------------------------------------------------------
-- 
-- File Name: /home/cb54103/Documents/fpga-open-speech-tools/simulink_models/models/Dynamic_Compression_Model/hdlsrc/sm_DynamicCompression/sm_DynamicCompression_Nchan_FbankAGC_AID.vhd
-- 
-- Generated by MATLAB 9.7 and HDL Coder 3.15
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: sm_DynamicCompression_Nchan_FbankAGC_AID
-- Source Path: sm_DynamicCompression/dataplane/Avalon Data Processing/Left Channel Processing/recalculate/Nchan_FbankAGC_AID
-- Hierarchy Level: 4
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY sm_DynamicCompression_Nchan_FbankAGC_AID IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb_1_1024_0                      :   IN    std_logic;
        enb                               :   IN    std_logic;
        enb_1_1024_5                      :   IN    std_logic;
        Register_Data                     :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Register_Addr                     :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        input_signal                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Valid_in                          :   IN    std_logic;
        proc_sig                          :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
        Valid_out                         :   OUT   std_logic
        );
END sm_DynamicCompression_Nchan_FbankAGC_AID;


ARCHITECTURE rtl OF sm_DynamicCompression_Nchan_FbankAGC_AID IS

  -- Component Declarations
  COMPONENT sm_DynamicCompression_Static_pFIR
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          Data_In                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Valid_in                        :   IN    std_logic;
          Data_out                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Valid_out                       :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Addr_Splitter
    PORT( Register_Addr                   :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Addr                            :   OUT   std_logic_vector(8 DOWNTO 0);  -- ufix9
          Sel                             :   OUT   std_logic_vector(2 DOWNTO 0)  -- ufix3
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Static_pFIR1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          Data_In                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Valid_in                        :   IN    std_logic;
          Data_out                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Static_pFIR2
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          Data_In                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Valid_in                        :   IN    std_logic;
          Data_out                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Static_pFIR3
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          Data_In                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Valid_in                        :   IN    std_logic;
          Data_out                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Static_pFIR4
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          Data_In                         :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Valid_in                        :   IN    std_logic;
          Data_out                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Compression_1
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_1024_5                    :   IN    std_logic;
          Sig_Band_1                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Table_In                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Table_Sel                       :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
          Write_Addr                      :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix9
          Sig_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Compression_2
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_1024_5                    :   IN    std_logic;
          Sig_Band_1                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Table_In                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Table_Sel                       :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
          Write_Addr                      :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix9
          Sig_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Compression_3
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_1024_5                    :   IN    std_logic;
          Sig_Band_1                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Table_In                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Table_Sel                       :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
          Write_Addr                      :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix9
          Sig_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Compression_4
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_1024_5                    :   IN    std_logic;
          Sig_Band_1                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Table_In                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Table_Sel                       :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
          Write_Addr                      :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix9
          Sig_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  COMPONENT sm_DynamicCompression_Compression_5
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb_1_1024_0                    :   IN    std_logic;
          enb                             :   IN    std_logic;
          enb_1_1024_5                    :   IN    std_logic;
          Sig_Band_1                      :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Table_In                        :   IN    std_logic_vector(31 DOWNTO 0);  -- sfix32_En28
          Table_Sel                       :   IN    std_logic_vector(2 DOWNTO 0);  -- ufix3
          Write_Addr                      :   IN    std_logic_vector(8 DOWNTO 0);  -- ufix9
          Sig_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- sfix32_En28
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : sm_DynamicCompression_Static_pFIR
    USE ENTITY work.sm_DynamicCompression_Static_pFIR(rtl);

  FOR ALL : sm_DynamicCompression_Addr_Splitter
    USE ENTITY work.sm_DynamicCompression_Addr_Splitter(rtl);

  FOR ALL : sm_DynamicCompression_Static_pFIR1
    USE ENTITY work.sm_DynamicCompression_Static_pFIR1(rtl);

  FOR ALL : sm_DynamicCompression_Static_pFIR2
    USE ENTITY work.sm_DynamicCompression_Static_pFIR2(rtl);

  FOR ALL : sm_DynamicCompression_Static_pFIR3
    USE ENTITY work.sm_DynamicCompression_Static_pFIR3(rtl);

  FOR ALL : sm_DynamicCompression_Static_pFIR4
    USE ENTITY work.sm_DynamicCompression_Static_pFIR4(rtl);

  FOR ALL : sm_DynamicCompression_Compression_1
    USE ENTITY work.sm_DynamicCompression_Compression_1(rtl);

  FOR ALL : sm_DynamicCompression_Compression_2
    USE ENTITY work.sm_DynamicCompression_Compression_2(rtl);

  FOR ALL : sm_DynamicCompression_Compression_3
    USE ENTITY work.sm_DynamicCompression_Compression_3(rtl);

  FOR ALL : sm_DynamicCompression_Compression_4
    USE ENTITY work.sm_DynamicCompression_Compression_4(rtl);

  FOR ALL : sm_DynamicCompression_Compression_5
    USE ENTITY work.sm_DynamicCompression_Compression_5(rtl);

  -- Signals
  SIGNAL chan_sig_1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Static_pFIR_out2                 : std_logic;
  SIGNAL chan_sig_1_signed                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL aligned_sig_1                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Addr_wr                          : std_logic_vector(8 DOWNTO 0);  -- ufix9
  SIGNAL Table_sel                        : std_logic_vector(2 DOWNTO 0);  -- ufix3
  SIGNAL chan_sig_2                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL chan_sig_2_signed                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL aligned_sig_2                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL chan_sig_3                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL chan_sig_3_signed                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL aligned_sig_3                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL chan_sig_4                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL chan_sig_4_signed                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL aligned_sig_4                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL chan_sig_5                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL chan_sig_5_signed                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL aligned_sig_5                    : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Compressor_1_output              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Compressor_1_output_signed       : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Compressor_2_output              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Compressor_2_output_signed       : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Compressor_3_output              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Compressor_3_output_signed       : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Compressor_4_output              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Compressor_4_output_signed       : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Compressor_5_output              : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Compressor_5_output_signed       : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Subtract_add_temp                : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Subtract_add_temp_1              : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Subtract_add_temp_2              : signed(31 DOWNTO 0);  -- sfix32_En28
  SIGNAL Subtract_out1                    : signed(31 DOWNTO 0);  -- sfix32_En28

  ATTRIBUTE multstyle : string;

BEGIN
  -- LOOK INSIDE
  -- 
  -- Commenting this out for now, have to deal with "in programming case" elsewhere.
  -- 
  -- At some point, we want FIRs to be programmable.
  -- This block will do that, but we need to keep z delays consistent.
  -- Maybe those will need some variable input as well?
  -- Maybe we can identify latency and store that somewhere?
  -- 
  -- Setup Reset at some point?
  -- 
  -- Apply Recombining Gain to Smooth Output
  -- 
  -- Fast or slow compression
  -- should be chosen based 
  -- on Speech Recognition or
  -- SNR aware binary decision
  -- 
  -- Delays to reallign FIR outputs
  -- 
  -- Bandpass FIR Filters
  -- 
  -- There are nchans number of bands,
  -- each goes through their own dual
  -- channel AGC, the outputs are summed.

  u_Static_pFIR : sm_DynamicCompression_Static_pFIR
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              Data_In => input_signal,  -- sfix32_En28
              Valid_in => Valid_in,
              Data_out => chan_sig_1,  -- sfix32_En28
              Valid_out => Static_pFIR_out2
              );

  u_Addr_Splitter : sm_DynamicCompression_Addr_Splitter
    PORT MAP( Register_Addr => Register_Addr,  -- sfix32_En28
              Addr => Addr_wr,  -- ufix9
              Sel => Table_sel  -- ufix3
              );

  u_Static_pFIR1 : sm_DynamicCompression_Static_pFIR1
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              Data_In => input_signal,  -- sfix32_En28
              Valid_in => Valid_in,
              Data_out => chan_sig_2  -- sfix32_En28
              );

  u_Static_pFIR2 : sm_DynamicCompression_Static_pFIR2
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              Data_In => input_signal,  -- sfix32_En28
              Valid_in => Valid_in,
              Data_out => chan_sig_3  -- sfix32_En28
              );

  u_Static_pFIR3 : sm_DynamicCompression_Static_pFIR3
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              Data_In => input_signal,  -- sfix32_En28
              Valid_in => Valid_in,
              Data_out => chan_sig_4  -- sfix32_En28
              );

  u_Static_pFIR4 : sm_DynamicCompression_Static_pFIR4
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              Data_In => input_signal,  -- sfix32_En28
              Valid_in => Valid_in,
              Data_out => chan_sig_5  -- sfix32_En28
              );

  u_Compression_1 : sm_DynamicCompression_Compression_1
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              enb_1_1024_5 => enb_1_1024_5,
              Sig_Band_1 => std_logic_vector(aligned_sig_1),  -- sfix32_En28
              Table_In => Register_Data,  -- sfix32_En28
              Table_Sel => Table_sel,  -- ufix3
              Write_Addr => Addr_wr,  -- ufix9
              Sig_out => Compressor_1_output  -- sfix32_En28
              );

  u_Compression_2 : sm_DynamicCompression_Compression_2
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              enb_1_1024_5 => enb_1_1024_5,
              Sig_Band_1 => std_logic_vector(aligned_sig_2),  -- sfix32_En28
              Table_In => Register_Data,  -- sfix32_En28
              Table_Sel => Table_sel,  -- ufix3
              Write_Addr => Addr_wr,  -- ufix9
              Sig_out => Compressor_2_output  -- sfix32_En28
              );

  u_Compression_3 : sm_DynamicCompression_Compression_3
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              enb_1_1024_5 => enb_1_1024_5,
              Sig_Band_1 => std_logic_vector(aligned_sig_3),  -- sfix32_En28
              Table_In => Register_Data,  -- sfix32_En28
              Table_Sel => Table_sel,  -- ufix3
              Write_Addr => Addr_wr,  -- ufix9
              Sig_out => Compressor_3_output  -- sfix32_En28
              );

  u_Compression_4 : sm_DynamicCompression_Compression_4
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              enb_1_1024_5 => enb_1_1024_5,
              Sig_Band_1 => std_logic_vector(aligned_sig_4),  -- sfix32_En28
              Table_In => Register_Data,  -- sfix32_En28
              Table_Sel => Table_sel,  -- ufix3
              Write_Addr => Addr_wr,  -- ufix9
              Sig_out => Compressor_4_output  -- sfix32_En28
              );

  u_Compression_5 : sm_DynamicCompression_Compression_5
    PORT MAP( clk => clk,
              reset => reset,
              enb_1_1024_0 => enb_1_1024_0,
              enb => enb,
              enb_1_1024_5 => enb_1_1024_5,
              Sig_Band_1 => std_logic_vector(aligned_sig_5),  -- sfix32_En28
              Table_In => Register_Data,  -- sfix32_En28
              Table_Sel => Table_sel,  -- ufix3
              Write_Addr => Addr_wr,  -- ufix9
              Sig_out => Compressor_5_output  -- sfix32_En28
              );

  chan_sig_1_signed <= signed(chan_sig_1);

  aligned_sig_1 <= chan_sig_1_signed;

  chan_sig_2_signed <= signed(chan_sig_2);

  aligned_sig_2 <= chan_sig_2_signed;

  chan_sig_3_signed <= signed(chan_sig_3);

  aligned_sig_3 <= chan_sig_3_signed;

  chan_sig_4_signed <= signed(chan_sig_4);

  aligned_sig_4 <= chan_sig_4_signed;

  chan_sig_5_signed <= signed(chan_sig_5);

  aligned_sig_5 <= chan_sig_5_signed;

  Compressor_1_output_signed <= signed(Compressor_1_output);

  Compressor_2_output_signed <= signed(Compressor_2_output);

  Compressor_3_output_signed <= signed(Compressor_3_output);

  Compressor_4_output_signed <= signed(Compressor_4_output);

  Compressor_5_output_signed <= signed(Compressor_5_output);

  Subtract_add_temp <= Compressor_1_output_signed + Compressor_2_output_signed;
  Subtract_add_temp_1 <= Subtract_add_temp + Compressor_3_output_signed;
  Subtract_add_temp_2 <= Subtract_add_temp_1 + Compressor_4_output_signed;
  Subtract_out1 <= Subtract_add_temp_2 + Compressor_5_output_signed;

  proc_sig <= std_logic_vector(Subtract_out1);




  Valid_out <= Static_pFIR_out2;

END rtl;
