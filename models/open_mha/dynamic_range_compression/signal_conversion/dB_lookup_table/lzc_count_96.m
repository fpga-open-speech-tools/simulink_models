function lzc_count = lzc_count_96(x)
%#codegen

if bitorreduce(x, 95, 48) == 1 % if ((b95 or b94 or b93 or b92 or b91 or b90 or b89 or b88 or b87 or b86 or b85 or b84 or b83 or b82 or b81 or b80 or b79 or b78 or b77 or b76 or b75 or b74 or b73 or b72 or b71 or b70 or b69 or b68 or b67 or b66 or b65 or b64 or b63 or b62 or b61 or b60 or b59 or b58 or b57 or b56 or b55 or b54 or b53 or b52 or b51 or b50 or b49 or b48) = '1') then   -- [95  48]
  if bitorreduce(x, 95, 72) == 1 % if ((b95 or b94 or b93 or b92 or b91 or b90 or b89 or b88 or b87 or b86 or b85 or b84 or b83 or b82 or b81 or b80 or b79 or b78 or b77 or b76 or b75 or b74 or b73 or b72) = '1') then   -- [95  72]
    if bitorreduce(x, 95, 84) == 1 % if ((b95 or b94 or b93 or b92 or b91 or b90 or b89 or b88 or b87 or b86 or b85 or b84) = '1') then   -- [95  84]
      if bitorreduce(x, 95, 90) == 1 %  if ((b95 or b94 or b93 or b92 or b91 or b90) = '1') then   -- [95  90]
        if bitorreduce(x, 95, 93) == 1 % if ((b95 or b94 or b93) = '1') then   -- [95  93]
          if bitorreduce(x, 95, 94) == 1 %if ((b95 or b94) = '1') then   -- [95  94]
            if bitorreduce(x, 95, 95) == 1 % if (b95 = '1') then   -- [95]
              lzc_count = fi(0,0,7,0); %lzc_count <= "0000000";  -- lzc = 0
            else % else  -- [94]
              lzc_count = fi(1,0,7,0); % lzc_count <= "0000001";  -- lzc = 1
            end % end if;
          else % else  -- [93]
            lzc_count = fi(2,0,7,0); % lzc_count <= "0000010";  -- lzc = 2
          end % end if;
        else % else  -- [92  90]
          if bitorreduce(x, 92, 91) == 1 % if ((b92 or b91) = '1') then   -- [92  91]
            if bitorreduce(x, 92, 92) == 1 % if (b92 = '1') then   -- [92]
              lzc_count = fi(3,0,7,0); % lzc_count <= "0000011";  -- lzc = 3
            else % else  -- [91]
              lzc_count = fi(4,0,7,0); % lzc_count <= "0000100";  -- lzc = 4
            end % end if;
          else % else  -- [90]
            lzc_count = fi(5,0,7,0); % lzc_count <= "0000101";  -- lzc = 5
          end % end if;
        end % end if; 
      else % else  -- [89  84]
        if bitorreduce(x, 89, 87) == 1 % if ((b89 or b88 or b87) = '1') then   -- [89  87]
          if bitorreduce(x, 89, 88) == 1 % if ((b89 or b88) = '1') then   -- [89  88]
            if bitorreduce(x, 89, 89) == 1 % if (b89 = '1') then   -- [89]
              lzc_count = fi(6,0,7,0); % lzc_count <= "0000110";  -- lzc = 6
            else % else  -- [88]
              lzc_count = fi(7,0,7,0); % lzc_count <= "0000111";  -- lzc = 7
            end % end if;
          else %else  -- [87]
            lzc_count = fi(8,0,7,0); % lzc_count <= "0001000";  -- lzc = 8
          end % end if;
        else % else  -- [86  84]
          if bitorreduce(x, 86, 85) == 1 % if ((b86 or b85) = '1') then   -- [86  85]
            if bitorreduce(x, 86, 86) == 1 % if (b86 = '1') then   -- [86]
              lzc_count = fi(9,0,7,0); % lzc_count <= "0001001";  -- lzc = 9
            else % else  -- [85]
              lzc_count = fi(10,0,7,0); % lzc_count <= "0001010";  -- lzc = 10
            end % end if;
          else % else  -- [84]
            lzc_count = fi(11,0,7,0); % lzc_count <= "0001011";  -- lzc = 11
          end % end if;
        end % end if; 
      end % end if; 
    else % else  -- [83  72]
      if bitorreduce(x, 83, 78) == 1 % if ((b83 or b82 or b81 or b80 or b79 or b78) = '1') then   -- [83  78]
        if bitorreduce(x, 83, 81) == 1 % if ((b83 or b82 or b81) = '1') then   -- [83  81]
          if bitorreduce(x, 83, 82) == 1 % if ((b83 or b82) = '1') then   -- [83  82]
            if bitorreduce(x, 83, 83) == 1 % if (b83 = '1') then   -- [83]
              lzc_count = fi(12,0,7,0); % lzc_count <= "0001100";  -- lzc = 12
            else % else  -- [82]
              lzc_count = fi(13,0,7,0); % lzc_count <= "0001101";  -- lzc = 13
            end % end if;
          else % else  -- [81]
            lzc_count = fi(14,0,7,0); % lzc_count <= "0001110";  -- lzc = 14
          end % end if;
        else % else  -- [80  78]
          if bitorreduce(x, 80, 79) == 1 % if ((b80 or b79) = '1') then   -- [80  79]
            if bitorreduce(x, 80, 80) == 1 % if (b80 = '1') then   -- [80]
              lzc_count = fi(15,0,7,0); % lzc_count <= "0001111";  -- lzc = 15
            else % else  -- [79]
              lzc_count = fi(16,0,7,0); % lzc_count <= "0010000";  -- lzc = 16
            end % end if;
          else % else  -- [78]
            lzc_count = fi(17,0,7,0); % lzc_count <= "0010001";  -- lzc = 17
          end % end if;
        end % end if; 
      else % else  -- [77  72]
        if bitorreduce(x, 77, 75) == 1 % if ((b77 or b76 or b75) = '1') then   -- [77  75]
          if bitorreduce(x, 77, 76) == 1 % if ((b77 or b76) = '1') then   -- [77  76]
            if bitorreduce(x, 77, 77) == 1 % if (b77 = '1') then   -- [77]
              lzc_count = fi(18,0,7,0); % lzc_count <= "0010010";  -- lzc = 18
            else % else  -- [76]
              lzc_count = fi(19,0,7,0); % lzc_count <= "0010011";  -- lzc = 19
            end % end if;
          else % else  -- [75]
            lzc_count = fi(20,0,7,0); % lzc_count <= "0010100";  -- lzc = 20
          end % end if;
        else % else  -- [74  72]
          if bitorreduce(x, 74, 73) == 1 % if ((b74 or b73) = '1') then   -- [74  73]
            if bitorreduce(x, 74, 74) == 1 % if (b74 = '1') then   -- [74]
              lzc_count = fi(21,0,7,0); % lzc_count <= "0010101";  -- lzc = 21
            else % else  -- [73]
              lzc_count = fi(22,0,7,0); % lzc_count <= "0010110";  -- lzc = 22
            end % end if;
          else % else  -- [72]
            lzc_count = fi(23,0,7,0); % lzc_count <= "0010111";  -- lzc = 23
          end % end if;
        end % end if; 
      end % end if; 
    end % end if; 
  else % else  -- [71  48]
    if bitorreduce(x, 71, 60) == 1 % if ((b71 or b70 or b69 or b68 or b67 or b66 or b65 or b64 or b63 or b62 or b61 or b60) = '1') then   -- [71  60]
      if bitorreduce(x, 71, 66) == 1 % if ((b71 or b70 or b69 or b68 or b67 or b66) = '1') then   -- [71  66]
        if bitorreduce(x, 71, 69) == 1 % if ((b71 or b70 or b69) = '1') then   -- [71  69]
          if bitorreduce(x, 71, 70) == 1 % if ((b71 or b70) = '1') then   -- [71  70]
            if bitorreduce(x, 71, 71) == 1 % if (b71 = '1') then   -- [71]
              lzc_count = fi(24,0,7,0); % lzc_count <= "0011000";  -- lzc = 24
            else % else  -- [70]
              lzc_count = fi(25,0,7,0); % lzc_count <= "0011001";  -- lzc = 25
            end % end if;
          else % else  -- [69]
            lzc_count = fi(26,0,7,0); % lzc_count <= "0011010";  -- lzc = 26
          end % end if;
        else % else  -- [68  66]
          if bitorreduce(x, 68, 67) == 1 % if ((b68 or b67) = '1') then   -- [68  67]
            if bitorreduce(x, 68, 68) == 1 % if (b68 = '1') then   -- [68]
              lzc_count = fi(27,0,7,0); % lzc_count <= "0011011";  -- lzc = 27
            else % else  -- [67]
              lzc_count = fi(28,0,7,0); % lzc_count <= "0011100";  -- lzc = 28
            end %end if;
          else % else  -- [66]
            lzc_count = fi(29,0,7,0); % lzc_count <= "0011101";  -- lzc = 29
          end % end if;
        end % end if; 
      else % else  -- [65  60]
        if bitorreduce(x, 65, 63) == 1 % if ((b65 or b64 or b63) = '1') then   -- [65  63]
          if bitorreduce(x, 65, 64) == 1 % if ((b65 or b64) = '1') then   -- [65  64]
            if bitorreduce(x, 65, 65) == 1 % if (b65 = '1') then   -- [65]
              lzc_count = fi(30,0,7,0); % lzc_count <= "0011110";  -- lzc = 30
            else % else  -- [64]
              lzc_count = fi(31,0,7,0); % lzc_count <= "0011111";  -- lzc = 31
            end % end if;
          else % else  -- [63]
            lzc_count = fi(32,0,7,0); % lzc_count <= "0100000";  -- lzc = 32
          end % end if;
        else % else  -- [62  60]
          if bitorreduce(x, 62, 61) == 1 % if ((b62 or b61) = '1') then   -- [62  61]
            if bitorreduce(x, 62, 62) == 1 % if (b62 = '1') then   -- [62]
              lzc_count = fi(33,0,7,0); % lzc_count <= "0100001";  -- lzc = 33
            else % else  -- [61]
              lzc_count = fi(34,0,7,0); % lzc_count <= "0100010";  -- lzc = 34
            end % end if;
          else % else  -- [60]
            lzc_count = fi(35,0,7,0); % lzc_count <= "0100011";  -- lzc = 35
          end % end if;
        end % end if; 
      end % end if; 
    else % else  -- [59  48]
      if bitorreduce(x, 59, 54) == 1 % if ((b59 or b58 or b57 or b56 or b55 or b54) = '1') then   -- [59  54]
        if bitorreduce(x, 59, 57) == 1 % if ((b59 or b58 or b57) = '1') then   -- [59  57]
          if bitorreduce(x, 59, 58) == 1 % if ((b59 or b58) = '1') then   -- [59  58]
            if bitorreduce(x, 59, 59) == 1 % if (b59 = '1') then   -- [59]
              lzc_count = fi(36,0,7,0); % lzc_count <= "0100100";  -- lzc = 36
            else % else  -- [58]
              lzc_count = fi(37,0,7,0); % lzc_count <= "0100101";  -- lzc = 37
            end % end if;
          else % else  -- [57]
            lzc_count = fi(38,0,7,0); % lzc_count <= "0100110";  -- lzc = 38
          end % end if;
        else % else  -- [56  54]
          if bitorreduce(x, 56, 55) == 1 % if ((b56 or b55) = '1') then   -- [56  55]
            if bitorreduce(x, 56, 56) == 1 % if (b56 = '1') then   -- [56]
              lzc_count = fi(39,0,7,0); % lzc_count <= "0100111";  -- lzc = 39
            else % else  -- [55]
              lzc_count = fi(40,0,7,0); % lzc_count <= "0101000";  -- lzc = 40
            end  % end if;
          else % else  -- [54]
            lzc_count = fi(41,0,7,0); % lzc_count <= "0101001";  -- lzc = 41
          end % end if;
        end % end if; 
      else % else  -- [53  48]
        if bitorreduce(x, 53, 51) == 1 % if ((b53 or b52 or b51) = '1') then   -- [53  51]
          if bitorreduce(x, 53, 52) == 1 % if ((b53 or b52) = '1') then   -- [53  52]
            if bitorreduce(x, 53, 53) == 1 % if (b53 = '1') then   -- [53]
              lzc_count = fi(42,0,7,0); % lzc_count <= "0101010";  -- lzc = 42
            else % else  -- [52]
              lzc_count = fi(43,0,7,0); % lzc_count <= "0101011";  -- lzc = 43
            end % end if;
          else % else  -- [51]
            lzc_count = fi(44,0,7,0); % lzc_count <= "0101100";  -- lzc = 44
          end % end if;
        else % else  -- [50  48]
          if bitorreduce(x, 50, 49) == 1 % if ((b50 or b49) = '1') then   -- [50  49]
            if bitorreduce(x, 50, 50) == 1 % if (b50 = '1') then   -- [50]
              lzc_count = fi(45,0,7,0); % lzc_count <= "0101101";  -- lzc = 45
            else % else  -- [49]
              lzc_count = fi(46,0,7,0); % lzc_count <= "0101110";  -- lzc = 46
            end % end if;
          else % else  -- [48]
            lzc_count = fi(47,0,7,0); % lzc_count <= "0101111";  -- lzc = 47
          end % end if;
        end % end if; 
      end % end if; 
    end % end if; 
  end % end if; 
else % else  -- [47   0]
  if bitorreduce(x, 47, 24) == 1 % if ((b47 or b46 or b45 or b44 or b43 or b42 or b41 or b40 or b39 or b38 or b37 or b36 or b35 or b34 or b33 or b32 or b31 or b30 or b29 or b28 or b27 or b26 or b25 or b24) = '1') then   -- [47  24]
    if bitorreduce(x, 47, 36) == 1 % if ((b47 or b46 or b45 or b44 or b43 or b42 or b41 or b40 or b39 or b38 or b37 or b36) = '1') then   -- [47  36]
      if bitorreduce(x, 47, 42) == 1 % if ((b47 or b46 or b45 or b44 or b43 or b42) = '1') then   -- [47  42]
        if bitorreduce(x, 47, 45) == 1 % if ((b47 or b46 or b45) = '1') then   -- [47  45]
          if bitorreduce(x, 47, 46) == 1 % if ((b47 or b46) = '1') then   -- [47  46]
            if bitorreduce(x, 47, 47) == 1 % if (b47 = '1') then   -- [47]
              lzc_count = fi(48,0,7,0); % lzc_count <= "0110000";  -- lzc = 48
            else % else  -- [46]
              lzc_count = fi(49,0,7,0); % lzc_count <= "0110001";  -- lzc = 49
            end % end if;
          else % else  -- [45]
            lzc_count = fi(50,0,7,0); % lzc_count <= "0110010";  -- lzc = 50
          end % end if;
        else % else  -- [44  42]
          if bitorreduce(x, 44, 43) == 1 % if ((b44 or b43) = '1') then   -- [44  43]
            if bitorreduce(x, 44, 44) == 1 % if (b44 = '1') then   -- [44]
              lzc_count = fi(51,0,7,0); % lzc_count <= "0110011";  -- lzc = 51
            else % else  -- [43]
              lzc_count = fi(52,0,7,0); % lzc_count <= "0110100";  -- lzc = 52
            end % end if;
          else % else  -- [42]
            lzc_count = fi(53,0,7,0); % lzc_count <= "0110101";  -- lzc = 53
          end % end if;
        end % end if; 
      else % else  -- [41  36]
        if bitorreduce(x, 41, 39) == 1 % if ((b41 or b40 or b39) = '1') then   -- [41  39]
          if bitorreduce(x, 41, 40) == 1 % if ((b41 or b40) = '1') then   -- [41  40]
            if bitorreduce(x, 41, 41) == 1 % if (b41 = '1') then   -- [41]
              lzc_count = fi(54,0,7,0); % lzc_count <= "0110110";  -- lzc = 54
            else % else  -- [40]
              lzc_count = fi(55,0,7,0); % lzc_count <= "0110111";  -- lzc = 55
            end % end if;
          else % else  -- [39]
            lzc_count = fi(56,0,7,0); % lzc_count <= "0111000";  -- lzc = 56
          end % end if;
        else % else  -- [38  36]
          if bitorreduce(x, 38, 37) == 1 % if ((b38 or b37) = '1') then   -- [38  37]
            if bitorreduce(x, 38, 38) == 1 % if (b38 = '1') then   -- [38]
              lzc_count = fi(57,0,7,0); % lzc_count <= "0111001";  -- lzc = 57
            else % else  -- [37]
              lzc_count = fi(58,0,7,0); % lzc_count <= "0111010";  -- lzc = 58
            end % end if;
          else % else  -- [36]
            lzc_count = fi(59,0,7,0); % lzc_count <= "0111011";  -- lzc = 59
          end % end if;
        end % end if; 
      end % end if; 
    else % else  -- [35  24]
      if bitorreduce(x, 35, 30) == 1 % if ((b35 or b34 or b33 or b32 or b31 or b30) = '1') then   -- [35  30]
        if bitorreduce(x, 35, 33) == 1 % if ((b35 or b34 or b33) = '1') then   -- [35  33]
          if bitorreduce(x, 35, 34) == 1 % if ((b35 or b34) = '1') then   -- [35  34]
            if bitorreduce(x, 35, 35) == 1 % if (b35 = '1') then   -- [35]
              lzc_count = fi(60,0,7,0); % lzc_count <= "0111100";  -- lzc = 60
            else % else  -- [34]
              lzc_count = fi(61,0,7,0); % lzc_count <= "0111101";  -- lzc = 61
            end % end if;
          else % else  -- [33]
            lzc_count = fi(62,0,7,0); % lzc_count <= "0111110";  -- lzc = 62
          end % end if;
        else % else  -- [32  30]
          if bitorreduce(x, 32, 31) == 1 % if ((b32 or b31) = '1') then   -- [32  31]
            if bitorreduce(x, 32, 32) == 1 % if (b32 = '1') then   -- [32]
              lzc_count = fi(63,0,7,0); % lzc_count <= "0111111";  -- lzc = 63
            else % else  -- [31]
              lzc_count = fi(64,0,7,0); % lzc_count <= "1000000";  -- lzc = 64
            end % end if;
          else % else  -- [30]
            lzc_count = fi(65,0,7,0); % lzc_count <= "1000001";  -- lzc = 65
          end % end if;
        end % end if; 
      else % else  -- [29  24]
        if bitorreduce(x, 29, 27) == 1 % if ((b29 or b28 or b27) = '1') then   -- [29  27]
          if bitorreduce(x, 29, 28) == 1 % if ((b29 or b28) = '1') then   -- [29  28]
            if bitorreduce(x, 29, 29) == 1 % if (b29 = '1') then   -- [29]
              lzc_count = fi(66,0,7,0); % lzc_count <= "1000010";  -- lzc = 66
            else % else  -- [28]
              lzc_count = fi(67,0,7,0); % lzc_count <= "1000011";  -- lzc = 67
            end % end if;
          else % else  -- [27]
            lzc_count = fi(68,0,7,0); % lzc_count <= "1000100";  -- lzc = 68
          end % end if;
        else % else  -- [26  24]
          if bitorreduce(x, 26, 25) == 1 % if ((b26 or b25) = '1') then   -- [26  25]
            if bitorreduce(x, 26, 26) == 1 % if (b26 = '1') then   -- [26]
              lzc_count = fi(69,0,7,0); % lzc_count <= "1000101";  -- lzc = 69
            else % else  -- [25]
              lzc_count = fi(70,0,7,0); % lzc_count <= "1000110";  -- lzc = 70
            end % end if;
          else % else  -- [24]
            lzc_count = fi(71,0,7,0); % lzc_count <= "1000111";  -- lzc = 71
          end % end if;
        end % end if; 
      end % end if; 
    end % end if; 
  else % else  -- [23   0]
    if bitorreduce(x, 23, 12) == 1 % if ((b23 or b22 or b21 or b20 or b19 or b18 or b17 or b16 or b15 or b14 or b13 or b12) = '1') then   -- [23  12]
      if bitorreduce(x, 23, 18) == 1 % if ((b23 or b22 or b21 or b20 or b19 or b18) = '1') then   -- [23  18]
        if bitorreduce(x, 23, 21) == 1 % if ((b23 or b22 or b21) = '1') then   -- [23  21]
          if bitorreduce(x, 23, 22) == 1 % if ((b23 or b22) = '1') then   -- [23  22]
            if bitorreduce(x, 23, 23) == 1 % if (b23 = '1') then   -- [23]
              lzc_count = fi(72,0,7,0); % lzc_count <= "1001000";  -- lzc = 72
            else % else  -- [22]
              lzc_count = fi(73,0,7,0); % lzc_count <= "1001001";  -- lzc = 73
            end % end if;
          else % else  -- [21]
            lzc_count = fi(74,0,7,0); % lzc_count <= "1001010";  -- lzc = 74
          end % end if;
        else % else  -- [20  18]
          if bitorreduce(x, 20, 19) == 1 % if ((b20 or b19) = '1') then   -- [20  19]
            if bitorreduce(x, 20, 20) == 1 % if (b20 = '1') then   -- [20]
              lzc_count = fi(75,0,7,0); % lzc_count <= "1001011";  -- lzc = 75
            else % else  -- [19]
              lzc_count = fi(76,0,7,0); % lzc_count <= "1001100";  -- lzc = 76
            end % end if;
          else % else  -- [18]
            lzc_count = fi(77,0,7,0); % lzc_count <= "1001101";  -- lzc = 77
          end % end if;
        end % end if; 
      else % else  -- [17  12]
        if bitorreduce(x, 17, 15) == 1 % if ((b17 or b16 or b15) = '1') then   -- [17  15]
          if bitorreduce(x, 17, 16) == 1 % if ((b17 or b16) = '1') then   -- [17  16]
            if bitorreduce(x, 17, 17) == 1 % if (b17 = '1') then   -- [17]
              lzc_count = fi(78,0,7,0); % lzc_count <= "1001110";  -- lzc = 78
            else % else  -- [16]
              lzc_count = fi(79,0,7,0); % lzc_count <= "1001111";  -- lzc = 79
            end % end if;
          else % else  -- [15]
            lzc_count = fi(80,0,7,0); % lzc_count <= "1010000";  -- lzc = 80
          end % end if;
        else % else  -- [14  12]
          if bitorreduce(x, 14, 13) == 1 % if ((b14 or b13) = '1') then   -- [14  13]
            if bitorreduce(x, 14, 14) == 1 % if (b14 = '1') then   -- [14]
              lzc_count = fi(81,0,7,0); % lzc_count <= "1010001";  -- lzc = 81
            else % else  -- [13]
              lzc_count = fi(82,0,7,0); % lzc_count <= "1010010";  -- lzc = 82
            end % end if;
          else % else  -- [12]
            lzc_count = fi(83,0,7,0); % lzc_count <= "1010011";  -- lzc = 83
          end % end if;
        end % end if; 
      end % end if; 
    else % else  -- [11   0]
      if bitorreduce(x, 11, 6) == 1 % if ((b11 or b10 or b9 or b8 or b7 or b6) = '1') then   -- [11   6]
        if bitorreduce(x, 11, 9) == 1 % if ((b11 or b10 or b9) = '1') then   -- [11   9]
          if bitorreduce(x, 11, 10) == 1 % if ((b11 or b10) = '1') then   -- [11  10]
            if bitorreduce(x, 11, 11) == 1 % if (b11 = '1') then   -- [11]
              lzc_count = fi(84,0,7,0); % lzc_count <= "1010100";  -- lzc = 84
            else % else  -- [10]
              lzc_count = fi(85,0,7,0); % lzc_count <= "1010101";  -- lzc = 85
            end % end if;
          else % else  -- [9]
            lzc_count = fi(86,0,7,0); % lzc_count <= "1010110";  -- lzc = 86
          end % end if;
        else % else  -- [8  6]
          if bitorreduce(x, 8, 7) == 1 % if ((b8 or b7) = '1') then   -- [8  7]
            if bitorreduce(x, 8, 8) == 1 % if (b8 = '1') then   -- [8]
              lzc_count = fi(87,0,7,0); % lzc_count <= "1010111";  -- lzc = 87
            else % else  -- [7]
              lzc_count = fi(88,0,7,0); % lzc_count <= "1011000";  -- lzc = 88
            end % end if;
          else % else  -- [6]
            lzc_count = fi(89,0,7,0); % lzc_count <= "1011001";  -- lzc = 89
          end % end if;
        end % end if; 
      else % else  -- [5  0]
        if bitorreduce(x, 5, 3) == 1 % if ((b5 or b4 or b3) = '1') then   -- [5  3]
          if bitorreduce(x, 5, 4) == 1 % if ((b5 or b4) = '1') then   -- [5  4]
            if bitorreduce(x, 5, 5) == 1 % if (b5 = '1') then   -- [5]
              lzc_count = fi(90,0,7,0); % lzc_count <= "1011010";  -- lzc = 90
            else % else  -- [4]
              lzc_count = fi(91,0,7,0); % lzc_count <= "1011011";  -- lzc = 91
            end % end if;
          else % else  -- [3]
            lzc_count = fi(92,0,7,0); % lzc_count <= "1011100";  -- lzc = 92
          end % end if;
        else % else  -- [2  0]
          if bitorreduce(x, 2, 1) == 1 % if ((b2 or b1) = '1') then   -- [2  1]
            if bitorreduce(x, 2, 2) == 1 % if (b2 = '1') then   -- [2]
              lzc_count = fi(93,0,7,0); % lzc_count <= "1011101";  -- lzc = 93
            else % else  -- [1]
              lzc_count = fi(94,0,7,0); % lzc_count <= "1011110";  -- lzc = 94
            end % end if;
          else % else  -- [0]
            lzc_count = fi(95,0,7,0); % lzc_count <= "1011111";  -- lzc = 95
          end % end if;
        end % end if; 
      end % end if; 
    end % end if; 
  end % end if; 
end % end if; 

