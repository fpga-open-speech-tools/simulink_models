-------------------------------------------------------------------
-- Note: This is machine generated code.  Do not hand edit.
--       Modify Matlab function fxpt_lzc_code_gen.m instead.
--       This file was auto generated on 20-Dec-2016 10:25:10
--       This VDHL file finds the lead zero count (LZC) in a standard logic vector
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fxpt_lzc_W32 is
    port (
        clock      : in  std_logic;
        lzc_vector : in  std_logic_vector (31 downto 0);
        lzc_count  : out std_logic_vector ( 4 downto 0)
    );
end entity;

architecture rtl of fxpt_lzc_W32 is
    signal b0 : std_logic;
    signal b1 : std_logic;
    signal b2 : std_logic;
    signal b3 : std_logic;
    signal b4 : std_logic;
    signal b5 : std_logic;
    signal b6 : std_logic;
    signal b7 : std_logic;
    signal b8 : std_logic;
    signal b9 : std_logic;
    signal b10 : std_logic;
    signal b11 : std_logic;
    signal b12 : std_logic;
    signal b13 : std_logic;
    signal b14 : std_logic;
    signal b15 : std_logic;
    signal b16 : std_logic;
    signal b17 : std_logic;
    signal b18 : std_logic;
    signal b19 : std_logic;
    signal b20 : std_logic;
    signal b21 : std_logic;
    signal b22 : std_logic;
    signal b23 : std_logic;
    signal b24 : std_logic;
    signal b25 : std_logic;
    signal b26 : std_logic;
    signal b27 : std_logic;
    signal b28 : std_logic;
    signal b29 : std_logic;
    signal b30 : std_logic;
    signal b31 : std_logic;

begin

    process (clock)
    begin
        if rising_edge(clock) then
            b0 <= lzc_vector(0);
            b1 <= lzc_vector(1);
            b2 <= lzc_vector(2);
            b3 <= lzc_vector(3);
            b4 <= lzc_vector(4);
            b5 <= lzc_vector(5);
            b6 <= lzc_vector(6);
            b7 <= lzc_vector(7);
            b8 <= lzc_vector(8);
            b9 <= lzc_vector(9);
            b10 <= lzc_vector(10);
            b11 <= lzc_vector(11);
            b12 <= lzc_vector(12);
            b13 <= lzc_vector(13);
            b14 <= lzc_vector(14);
            b15 <= lzc_vector(15);
            b16 <= lzc_vector(16);
            b17 <= lzc_vector(17);
            b18 <= lzc_vector(18);
            b19 <= lzc_vector(19);
            b20 <= lzc_vector(20);
            b21 <= lzc_vector(21);
            b22 <= lzc_vector(22);
            b23 <= lzc_vector(23);
            b24 <= lzc_vector(24);
            b25 <= lzc_vector(25);
            b26 <= lzc_vector(26);
            b27 <= lzc_vector(27);
            b28 <= lzc_vector(28);
            b29 <= lzc_vector(29);
            b30 <= lzc_vector(30);
            b31 <= lzc_vector(31);
        end if;
    end process;
 
    process (b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23, b24, b25, b26, b27, b28, b29, b30, b31 )
    begin

        -- Binary Bisection Tree (Divide & Conquer)
        if ((b31 or b30 or b29 or b28 or b27 or b26 or b25 or b24 or b23 or b22 or b21 or b20 or b19 or b18 or b17 or b16) = '1') then   -- check bit range [31  16]
            if ((b31 or b30 or b29 or b28 or b27 or b26 or b25 or b24) = '1') then   -- check bit range [31  24]
                if ((b31 or b30 or b29 or b28) = '1') then   -- check bit range [31  28]
                    if ((b31 or b30) = '1') then   -- check bit range [31  30]
                        if (b31 = '1') then   -- [31]
                            lzc_count <= "00000";  -- lzc = 0
                        else  -- check bit range [30]
                            lzc_count <= "00001";  -- lzc = 1
                        end if;
                    else  -- check bit range [29  28]
                        if (b29 = '1') then   -- [29]
                            lzc_count <= "00010";  -- lzc = 2
                        else  -- check bit range [28]
                            lzc_count <= "00011";  -- lzc = 3
                        end if;
                    end if; 
                else  -- check bit range [27  24]
                    if ((b27 or b26) = '1') then   -- check bit range [27  26]
                        if (b27 = '1') then   -- [27]
                            lzc_count <= "00100";  -- lzc = 4
                        else  -- check bit range [26]
                            lzc_count <= "00101";  -- lzc = 5
                        end if;
                    else  -- check bit range [25  24]
                        if (b25 = '1') then   -- [25]
                            lzc_count <= "00110";  -- lzc = 6
                        else  -- check bit range [24]
                            lzc_count <= "00111";  -- lzc = 7
                        end if;
                    end if; 
                end if; 
            else  -- check bit range [23  16]
                if ((b23 or b22 or b21 or b20) = '1') then   -- check bit range [23  20]
                    if ((b23 or b22) = '1') then   -- check bit range [23  22]
                        if (b23 = '1') then   -- [23]
                            lzc_count <= "01000";  -- lzc = 8
                        else  -- check bit range [22]
                            lzc_count <= "01001";  -- lzc = 9
                        end if;
                    else  -- check bit range [21  20]
                        if (b21 = '1') then   -- [21]
                            lzc_count <= "01010";  -- lzc = 10
                        else  -- check bit range [20]
                            lzc_count <= "01011";  -- lzc = 11
                        end if;
                    end if; 
                else  -- check bit range [19  16]
                    if ((b19 or b18) = '1') then   -- check bit range [19  18]
                        if (b19 = '1') then   -- [19]
                            lzc_count <= "01100";  -- lzc = 12
                        else  -- check bit range [18]
                            lzc_count <= "01101";  -- lzc = 13
                        end if;
                    else  -- check bit range [17  16]
                        if (b17 = '1') then   -- [17]
                            lzc_count <= "01110";  -- lzc = 14
                        else  -- check bit range [16]
                            lzc_count <= "01111";  -- lzc = 15
                        end if;
                    end if; 
                end if; 
            end if; 
        else  -- check bit range [15   0]
            if ((b15 or b14 or b13 or b12 or b11 or b10 or b9 or b8) = '1') then   -- check bit range [15   8]
                if ((b15 or b14 or b13 or b12) = '1') then   -- check bit range [15  12]
                    if ((b15 or b14) = '1') then   -- check bit range [15  14]
                        if (b15 = '1') then   -- [15]
                            lzc_count <= "10000";  -- lzc = 16
                        else  -- check bit range [14]
                            lzc_count <= "10001";  -- lzc = 17
                        end if;
                    else  -- check bit range [13  12]
                        if (b13 = '1') then   -- [13]
                            lzc_count <= "10010";  -- lzc = 18
                        else  -- check bit range [12]
                            lzc_count <= "10011";  -- lzc = 19
                        end if;
                    end if; 
                else  -- check bit range [11   8]
                    if ((b11 or b10) = '1') then   -- check bit range [11  10]
                        if (b11 = '1') then   -- [11]
                            lzc_count <= "10100";  -- lzc = 20
                        else  -- check bit range [10]
                            lzc_count <= "10101";  -- lzc = 21
                        end if;
                    else  -- check bit range [9  8]
                        if (b9 = '1') then   -- [9]
                            lzc_count <= "10110";  -- lzc = 22
                        else  -- check bit range [8]
                            lzc_count <= "10111";  -- lzc = 23
                        end if;
                    end if; 
                end if; 
            else  -- check bit range [7  0]
                if ((b7 or b6 or b5 or b4) = '1') then   -- check bit range [7  4]
                    if ((b7 or b6) = '1') then   -- check bit range [7  6]
                        if (b7 = '1') then   -- [7]
                            lzc_count <= "11000";  -- lzc = 24
                        else  -- check bit range [6]
                            lzc_count <= "11001";  -- lzc = 25
                        end if;
                    else  -- check bit range [5  4]
                        if (b5 = '1') then   -- [5]
                            lzc_count <= "11010";  -- lzc = 26
                        else  -- check bit range [4]
                            lzc_count <= "11011";  -- lzc = 27
                        end if;
                    end if; 
                else  -- check bit range [3  0]
                    if ((b3 or b2) = '1') then   -- check bit range [3  2]
                        if (b3 = '1') then   -- [3]
                            lzc_count <= "11100";  -- lzc = 28
                        else  -- check bit range [2]
                            lzc_count <= "11101";  -- lzc = 29
                        end if;
                    else  -- check bit range [1  0]
                        if (b1 = '1') then   -- [1]
                            lzc_count <= "11110";  -- lzc = 30
                        else  -- check bit range [0]
                            lzc_count <= "11111";  -- lzc = 31
                        end if;
                    end if; 
                end if; 
            end if; 
        end if; 

    end process;
end rtl;
