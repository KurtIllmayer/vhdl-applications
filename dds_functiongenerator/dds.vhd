---------------------------------------------------------------------------------
-- MIT License

-- Copyright (c) 2019 Kurt Illmayer

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
---------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity dds_generator is
port(clock_i            : in  std_ulogic;
     reset_i            : in  std_ulogic;
	  phase_start_i      : in  std_ulogic_vector(31 downto 0);
     da_sinus_o         : out std_ulogic_vector(7 downto 0);
	  da_saegezahn_o     : out std_ulogic_vector(7 downto 0); 
     da_rechteck_o	   : out std_ulogic_vector(7 downto 0);  
     da_dreieck_o	      : out std_ulogic_vector(7 downto 0);  	  
	  clk_o              : out std_ulogic);
end dds_generator;

architecture Behavioral of dds_generator is

 signal phase_accu        : std_logic_vector(31 downto 0);
 signal da_dreieck        : std_logic_vector(7 downto 0); 
 
begin

process(clock_i, reset_i)

begin

if(reset_i='1')then
 
  phase_accu(31 downto 0) <= (others=>'0');
 
  clk_o                   <= '0';
  
  da_saegezahn_o          <= (others=>'0');
  
  da_rechteck_o           <= (others=>'0');  
  
  da_dreieck              <= (others=>'0');   

  da_dreieck_o            <=  (others=>'0');  
  
elsif(clock_i'event and clock_i='1')then

  phase_accu(31 downto 0) <= phase_accu(31 downto 0) + to_stdlogicvector(phase_start_i(31 downto 0));
 
  clk_o                   <= phase_accu(31);

  da_saegezahn_o          <= to_stdulogicvector(phase_accu(31 downto 24)); 

  if(phase_accu(31)='1')then
  
     da_rechteck_o <= (others=>'1');

     da_dreieck    <= not phase_accu(30 downto 23); 

     da_dreieck_o  <= to_stdulogicvector(not phase_accu(30 downto 23)); 
	  
     da_saegezahn_o  <= to_stdulogicvector(phase_accu(31 downto 24)); 	  
	  
  else 

     da_dreieck    <= phase_accu(30 downto 23); 

     da_dreieck_o  <= to_stdulogicvector(phase_accu(30 downto 23)); 

     da_rechteck_o <= (others=>'0');  

     da_saegezahn_o  <= to_stdulogicvector(phase_accu(31 downto 24));

  end if;

end if;  

end process;

  sinus_p: process(da_dreieck)

  begin

   case da_dreieck is
   when "00000000" => da_sinus_o <= "00000000"; -- 0:0
   when "00000001" => da_sinus_o <= "00000000"; -- 1:0
   when "00000010" => da_sinus_o <= "00000000"; -- 2:0
   when "00000011" => da_sinus_o <= "00000000"; -- 3:0
   when "00000100" => da_sinus_o <= "00000000"; -- 4:0
   when "00000101" => da_sinus_o <= "00000000"; -- 5:0
   when "00000110" => da_sinus_o <= "00000000"; -- 6:0 
   when "00000111" => da_sinus_o <= "00000000"; -- 7:0
   when "00001000" => da_sinus_o <= "00000001"; -- 8:1
   when "00001001" => da_sinus_o <= "00000001"; -- 9:1
   when "00001010" => da_sinus_o <= "00000001"; -- 10:1
   when "00001011" => da_sinus_o <= "00000001"; -- 11:1
   when "00001100" => da_sinus_o <= "00000001"; -- 12:1
   when "00001101" => da_sinus_o <= "00000010"; -- 13:2
   when "00001110" => da_sinus_o <= "00000010"; -- 14:2
   when "00001111" => da_sinus_o <= "00000010"; -- 15:2
   when "00010000" => da_sinus_o <= "00000010"; -- 16:2
   when "00010001" => da_sinus_o <= "00000011"; -- 17:3
   when "00010010" => da_sinus_o <= "00000011"; -- 18:3
   when "00010011" => da_sinus_o <= "00000011"; -- 19:3
   when "00010100" => da_sinus_o <= "00000100"; -- 20:4
   when "00010101" => da_sinus_o <= "00000100"; -- 21:4
   when "00010110" => da_sinus_o <= "00000101"; -- 22:5
   when "00010111" => da_sinus_o <= "00000101"; -- 23:5
   when "00011000" => da_sinus_o <= "00000110"; -- 24:6
   when "00011001" => da_sinus_o <= "00000110"; -- 25:6
   when "00011010" => da_sinus_o <= "00000110"; -- 26:6
   when "00011011" => da_sinus_o <= "00000111"; -- 27:7
   when "00011100" => da_sinus_o <= "00001000"; -- 28:8
   when "00011101" => da_sinus_o <= "00001000"; -- 29:8
   when "00011110" => da_sinus_o <= "00001001"; -- 30:9
   when "00011111" => da_sinus_o <= "00001001"; -- 31:9
   when "00100000" => da_sinus_o <= "00001010"; -- 32:10
   when "00100001" => da_sinus_o <= "00001010"; -- 33:10
   when "00100010" => da_sinus_o <= "00001011"; -- 34:11
   when "00100011" => da_sinus_o <= "00001100"; -- 35:12
   when "00100100" => da_sinus_o <= "00001100"; -- 36:12
   when "00100101" => da_sinus_o <= "00001101"; -- 37:13
   when "00100110" => da_sinus_o <= "00001110"; -- 38:14
   when "00100111" => da_sinus_o <= "00001110"; -- 39:14
   when "00101000" => da_sinus_o <= "00001111"; -- 40:15
   when "00101001" => da_sinus_o <= "00010000"; -- 41:16
   when "00101010" => da_sinus_o <= "00010001"; -- 42:17
   when "00101011" => da_sinus_o <= "00010001"; -- 43:17
   when "00101100" => da_sinus_o <= "00010010"; -- 44:18
   when "00101101" => da_sinus_o <= "00010011"; -- 45:19
   when "00101110" => da_sinus_o <= "00010100"; -- 46:20
   when "00101111" => da_sinus_o <= "00010101"; -- 47:21
   when "00110000" => da_sinus_o <= "00010110"; -- 48:22
   when "00110001" => da_sinus_o <= "00010111"; -- 49:23
   when "00110010" => da_sinus_o <= "00010111"; -- 50:23
   when "00110011" => da_sinus_o <= "00011000"; -- 51:24
   when "00110100" => da_sinus_o <= "00011001"; -- 52:25
   when "00110101" => da_sinus_o <= "00011010"; -- 53:26
   when "00110110" => da_sinus_o <= "00011011"; -- 54:27
   when "00110111" => da_sinus_o <= "00011100"; -- 55:28
   when "00111000" => da_sinus_o <= "00011101"; -- 56:29
   when "00111001" => da_sinus_o <= "00011110"; -- 57:30
   when "00111010" => da_sinus_o <= "00011111"; -- 58:31
   when "00111011" => da_sinus_o <= "00100000"; -- 59:32
   when "00111100" => da_sinus_o <= "00100001"; -- 60:33
   when "00111101" => da_sinus_o <= "00100010"; -- 61:34
   when "00111110" => da_sinus_o <= "00100011"; -- 62:35
   when "00111111" => da_sinus_o <= "00100101"; -- 63:37
   when "01000000" => da_sinus_o <= "00100110"; -- 64:38
   when "01000001" => da_sinus_o <= "00100111"; -- 65:39
   when "01000010" => da_sinus_o <= "00101000"; -- 66:40
   when "01000011" => da_sinus_o <= "00101001"; -- 67:41
   when "01000100" => da_sinus_o <= "00101010"; -- 68:42
   when "01000101" => da_sinus_o <= "00101011"; -- 69:43
   when "01000110" => da_sinus_o <= "00101101"; -- 70:45
   when "01000111" => da_sinus_o <= "00101110"; -- 71:46
   when "01001000" => da_sinus_o <= "00101111"; -- 72:47
   when "01001001" => da_sinus_o <= "00110000"; -- 73:48
   when "01001010" => da_sinus_o <= "00110001"; -- 74:49
   when "01001011" => da_sinus_o <= "00110011"; -- 75:51
   when "01001100" => da_sinus_o <= "00110100"; -- 76:52
   when "01001101" => da_sinus_o <= "00110101"; -- 77:53
   when "01001110" => da_sinus_o <= "00110110"; -- 78:54
   when "01001111" => da_sinus_o <= "00111000"; -- 79:56
   when "01010000" => da_sinus_o <= "00111001"; -- 80:57
   when "01010001" => da_sinus_o <= "00111010"; -- 81:58
   when "01010010" => da_sinus_o <= "00111100"; -- 82:60
   when "01010011" => da_sinus_o <= "00111101"; -- 83:61
   when "01010100" => da_sinus_o <= "00111110"; -- 84:62
   when "01010101" => da_sinus_o <= "01000000"; -- 85:64
   when "01010110" => da_sinus_o <= "01000001"; -- 86:65
   when "01010111" => da_sinus_o <= "01000010"; -- 87:66
   when "01011000" => da_sinus_o <= "01000100"; -- 88:68
   when "01011001" => da_sinus_o <= "01000101"; -- 89:69
   when "01011010" => da_sinus_o <= "01000111"; -- 90:71
   when "01011011" => da_sinus_o <= "01001000"; -- 91:72
   when "01011100" => da_sinus_o <= "01001001"; -- 92:73
   when "01011101" => da_sinus_o <= "01001011"; -- 93:75
   when "01011110" => da_sinus_o <= "01001100"; -- 94:76
   when "01011111" => da_sinus_o <= "01001110"; -- 95:78
   when "01100000" => da_sinus_o <= "01001111"; -- 96:79
   when "01100001" => da_sinus_o <= "01010001"; -- 97:81
   when "01100010" => da_sinus_o <= "01010010"; -- 98:82
   when "01100011" => da_sinus_o <= "01010100"; -- 99:84
   when "01100100" => da_sinus_o <= "01010101"; -- 100:85
   when "01100101" => da_sinus_o <= "01010111"; -- 101:87
   when "01100110" => da_sinus_o <= "01011000"; -- 102:88
   when "01100111" => da_sinus_o <= "01011010"; -- 103:90
   when "01101000" => da_sinus_o <= "01011011"; -- 104:91
   when "01101001" => da_sinus_o <= "01011101"; -- 105:93
   when "01101010" => da_sinus_o <= "01011110"; -- 106:94
   when "01101011" => da_sinus_o <= "01100000"; -- 107:96
   when "01101100" => da_sinus_o <= "01100001"; -- 108:97
   when "01101101" => da_sinus_o <= "01100011"; -- 109:99
   when "01101110" => da_sinus_o <= "01100100"; -- 110:100
   when "01101111" => da_sinus_o <= "01100110"; -- 111:102
   when "01110000" => da_sinus_o <= "01100111"; -- 112:103
   when "01110001" => da_sinus_o <= "01101001"; -- 113:105
   when "01110010" => da_sinus_o <= "01101010"; -- 114:106
   when "01110011" => da_sinus_o <= "01101100"; -- 115:108
   when "01110100" => da_sinus_o <= "01101101"; -- 116:109
   when "01110101" => da_sinus_o <= "01101111"; -- 117:111
   when "01110110" => da_sinus_o <= "01110001"; -- 118:113
   when "01110111" => da_sinus_o <= "01110010"; -- 119:114
   when "01111000" => da_sinus_o <= "01110100"; -- 120:116
   when "01111001" => da_sinus_o <= "01110101"; -- 121:117
   when "01111010" => da_sinus_o <= "01110111"; -- 122:119
   when "01111011" => da_sinus_o <= "01111000"; -- 123:120
   when "01111100" => da_sinus_o <= "01111010"; -- 124:122
   when "01111101" => da_sinus_o <= "01111100"; -- 125:124
   when "01111110" => da_sinus_o <= "01111101"; -- 126:125
   when "01111111" => da_sinus_o <= "01111111"; -- 127:127
   when "10000000" => da_sinus_o <= "10000000"; -- 128:128
   when "10000001" => da_sinus_o <= "10000010"; -- 129:130
   when "10000010" => da_sinus_o <= "10000011"; -- 130:131
   when "10000011" => da_sinus_o <= "10000101"; -- 131:133
   when "10000100" => da_sinus_o <= "10000111"; -- 132:135
   when "10000101" => da_sinus_o <= "10001000"; -- 133:136
   when "10000110" => da_sinus_o <= "10001010"; -- 134:138
   when "10000111" => da_sinus_o <= "10001011"; -- 135:139
   when "10001000" => da_sinus_o <= "10001101"; -- 136:141
   when "10001001" => da_sinus_o <= "10001110"; -- 137:142
   when "10001010" => da_sinus_o <= "10010000"; -- 138:144
   when "10001011" => da_sinus_o <= "10010010"; -- 139:146
   when "10001100" => da_sinus_o <= "10010011"; -- 140:147
   when "10001101" => da_sinus_o <= "10010101"; -- 141:149
   when "10001110" => da_sinus_o <= "10010110"; -- 142:150
   when "10001111" => da_sinus_o <= "10011000"; -- 143:152
   when "10010000" => da_sinus_o <= "10011001"; -- 144:153
   when "10010001" => da_sinus_o <= "10011011"; -- 145:155
   when "10010010" => da_sinus_o <= "10011100"; -- 146:156
   when "10010011" => da_sinus_o <= "10011110"; -- 147:158
   when "10010100" => da_sinus_o <= "10011111"; -- 148:159
   when "10010101" => da_sinus_o <= "10100001"; -- 149:161
   when "10010110" => da_sinus_o <= "10100010"; -- 150:162
   when "10010111" => da_sinus_o <= "10100100"; -- 151:164
   when "10011000" => da_sinus_o <= "10100101"; -- 152:165
   when "10011001" => da_sinus_o <= "10100111"; -- 153:167
   when "10011010" => da_sinus_o <= "10101000"; -- 154:168
   when "10011011" => da_sinus_o <= "10101010"; -- 155:170
   when "10011100" => da_sinus_o <= "10101011"; -- 156:171
   when "10011101" => da_sinus_o <= "10101101"; -- 157:173
   when "10011110" => da_sinus_o <= "10101110"; -- 158:174
   when "10011111" => da_sinus_o <= "10110000"; -- 159:176
   when "10100000" => da_sinus_o <= "10110001"; -- 160:177
   when "10100001" => da_sinus_o <= "10110011"; -- 161:179
   when "10100010" => da_sinus_o <= "10110100"; -- 162:180
   when "10100011" => da_sinus_o <= "10110110"; -- 163:182
   when "10100100" => da_sinus_o <= "10110111"; -- 164:183
   when "10100101" => da_sinus_o <= "10111000"; -- 165:184
   when "10100110" => da_sinus_o <= "10111010"; -- 166:186
   when "10100111" => da_sinus_o <= "10111011"; -- 167:187
   when "10101000" => da_sinus_o <= "10111101"; -- 168:189
   when "10101001" => da_sinus_o <= "10111110"; -- 169:190
   when "10101010" => da_sinus_o <= "10111111"; -- 170:191
   when "10101011" => da_sinus_o <= "11000001"; -- 171:193
   when "10101100" => da_sinus_o <= "11000010"; -- 172:194
   when "10101101" => da_sinus_o <= "11000011"; -- 173:195
   when "10101110" => da_sinus_o <= "11000101"; -- 174:197
   when "10101111" => da_sinus_o <= "11000110"; -- 175:198
   when "10110000" => da_sinus_o <= "11000111"; -- 176:199
   when "10110001" => da_sinus_o <= "11001001"; -- 177:201
   when "10110010" => da_sinus_o <= "11001010"; -- 178:202
   when "10110011" => da_sinus_o <= "11001011"; -- 179:203
   when "10110100" => da_sinus_o <= "11001100"; -- 180:204
   when "10110101" => da_sinus_o <= "11001110"; -- 181:206
   when "10110110" => da_sinus_o <= "11001111"; -- 182:207
   when "10110111" => da_sinus_o <= "11010000"; -- 183:208
   when "10111000" => da_sinus_o <= "11010001"; -- 184:209
   when "10111001" => da_sinus_o <= "11010010"; -- 185:210
   when "10111010" => da_sinus_o <= "11010100"; -- 186:212
   when "10111011" => da_sinus_o <= "11010101"; -- 187:213
   when "10111100" => da_sinus_o <= "11010110"; -- 188:214
   when "10111101" => da_sinus_o <= "11010111"; -- 189:215
   when "10111110" => da_sinus_o <= "11011000"; -- 190:216
   when "10111111" => da_sinus_o <= "11011001"; -- 191:217
   when "11000000" => da_sinus_o <= "11011010"; -- 192:218
   when "11000001" => da_sinus_o <= "11011100"; -- 193:220
   when "11000010" => da_sinus_o <= "11011101"; -- 194:221
   when "11000011" => da_sinus_o <= "11011110"; -- 195:222
   when "11000100" => da_sinus_o <= "11011111"; -- 196:223
   when "11000101" => da_sinus_o <= "11100000"; -- 197:224
   when "11000110" => da_sinus_o <= "11100001"; -- 198:225
   when "11000111" => da_sinus_o <= "11100010"; -- 199:226
   when "11001000" => da_sinus_o <= "11100011"; -- 200:227
   when "11001001" => da_sinus_o <= "11100100"; -- 201:228
   when "11001010" => da_sinus_o <= "11100101"; -- 202:229
   when "11001011" => da_sinus_o <= "11100110"; -- 203:230
   when "11001100" => da_sinus_o <= "11100111"; -- 204:231
   when "11001101" => da_sinus_o <= "11101000"; -- 205:232
   when "11001110" => da_sinus_o <= "11101000"; -- 206:232
   when "11001111" => da_sinus_o <= "11101001"; -- 207:233
   when "11010000" => da_sinus_o <= "11101010"; -- 208:234
   when "11010001" => da_sinus_o <= "11101011"; -- 209:235
   when "11010010" => da_sinus_o <= "11101100"; -- 210:236
   when "11010011" => da_sinus_o <= "11101101"; -- 211:237
   when "11010100" => da_sinus_o <= "11101110"; -- 212:238
   when "11010101" => da_sinus_o <= "11101110"; -- 213:238
   when "11010110" => da_sinus_o <= "11101111"; -- 214:239
   when "11010111" => da_sinus_o <= "11110000"; -- 215:240
   when "11011000" => da_sinus_o <= "11110001"; -- 216:241
   when "11011001" => da_sinus_o <= "11110001"; -- 217:241
   when "11011010" => da_sinus_o <= "11110010"; -- 218:242
   when "11011011" => da_sinus_o <= "11110011"; -- 219:243
   when "11011100" => da_sinus_o <= "11110011"; -- 220:243
   when "11011101" => da_sinus_o <= "11110100"; -- 221:244
   when "11011110" => da_sinus_o <= "11110101"; -- 222:245
   when "11011111" => da_sinus_o <= "11110101"; -- 223:245
   when "11100000" => da_sinus_o <= "11110110"; -- 224:246
   when "11100001" => da_sinus_o <= "11110110"; -- 225:246
   when "11100010" => da_sinus_o <= "11110111"; -- 226:247
   when "11100011" => da_sinus_o <= "11110111"; -- 227:247
   when "11100100" => da_sinus_o <= "11111000"; -- 228:248
   when "11100101" => da_sinus_o <= "11111001"; -- 229:249
   when "11100110" => da_sinus_o <= "11111001"; -- 230:249
   when "11100111" => da_sinus_o <= "11111001"; -- 231:249
   when "11101000" => da_sinus_o <= "11111010"; -- 232:250
   when "11101001" => da_sinus_o <= "11111010"; -- 233:250
   when "11101010" => da_sinus_o <= "11111011"; -- 234:251
   when "11101011" => da_sinus_o <= "11111011"; -- 235:251
   when "11101100" => da_sinus_o <= "11111100"; -- 236:252
   when "11101101" => da_sinus_o <= "11111100"; -- 237:252
   when "11101110" => da_sinus_o <= "11111100"; -- 238:252
   when "11101111" => da_sinus_o <= "11111101"; -- 239:253
   when "11110000" => da_sinus_o <= "11111101"; -- 240:253
   when "11110001" => da_sinus_o <= "11111101"; -- 241:253
   when "11110010" => da_sinus_o <= "11111101"; -- 242:253
   when "11110011" => da_sinus_o <= "11111110"; -- 243:254
   when "11110100" => da_sinus_o <= "11111110"; -- 244:254
   when "11110101" => da_sinus_o <= "11111110"; -- 245:254
   when "11110110" => da_sinus_o <= "11111110"; -- 246:254
   when "11110111" => da_sinus_o <= "11111110"; -- 247:254
   when "11111000" => da_sinus_o <= "11111111"; -- 248:255
   when "11111001" => da_sinus_o <= "11111111"; -- 249:255
   when "11111010" => da_sinus_o <= "11111111"; -- 250:255
   when "11111011" => da_sinus_o <= "11111111"; -- 251:255
   when "11111100" => da_sinus_o <= "11111111"; -- 252:255
   when "11111101" => da_sinus_o <= "11111111"; -- 253:255
   when "11111110" => da_sinus_o <= "11111111"; -- 254:255
   when "11111111" => da_sinus_o <= "11111111"; -- 255:255 
   when others => NULL;
   end case;

  end process sinus_p;

end Behavioral;
