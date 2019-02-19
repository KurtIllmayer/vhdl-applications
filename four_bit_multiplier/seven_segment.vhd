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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity seven_segment is
 Port(clock_i : in std_ulogic;
      reset_i : in std_ulogic;
      register_1_i : in std_ulogic_vector(3 downto 0);
      register_2_i : in std_ulogic_vector(3 downto 0);
      register_3_i : in std_ulogic_vector(3 downto 0);
      register_4_i : in std_ulogic_vector(3 downto 0);
      anode_1_o : out std_ulogic;
      anode_2_o : out std_ulogic;
      anode_3_o : out std_ulogic;
      anode_4_o : out std_ulogic;
      seven_segment_o : out std_ulogic_vector(6 downto 0));
end seven_segment;

architecture Behavioral of seven_segment is
 -- Clockdivider
 signal count : integer range 0 to 249999;
 -- Clockdivider für 4 Anoden
 signal clkdiv : std_logic_vector(1 downto 0);
 -- Sieben Segment Anzeige
 signal register_data : std_ulogic_vector(3 downto 0);
 -- Clock Divider Enable Signal
 signal clock_enable : std_ulogic;

begin

   clock_divider_p: process(clock_i, reset_i)
   begin
   if (reset_i = '1') then
     count <= 0;
     clock_enable <= '0';
   elsif (clock_i'event and clock_i = '1') then
    if (count = 249999) then
       count <= 0;
       clock_enable <= '1';
    else
       count <= count + 1;
       clock_enable <= '0';
    end if;
   end if;
   end process clock_divider_p;

   clock_counter_p: process(clock_i, reset_i)
   begin
   if(reset_i = '1') then 
       clkdiv <= "00";
   elsif(clock_i'event and clock_i = '1') then
    if (clock_enable = '1') then
       clkdiv <= clkdiv + 1;
    end if;
   end if;
   end process clock_counter_p;

 AnodenMux_p: process(clkdiv, register_1_i, register_2_i, register_3_i, register_4_i)

 begin

   case clkdiv is

               when "00" => register_data(3 downto 0) <= register_1_i(3 downto 0);

                                                         anode_1_o <= '0';

                                                         anode_2_o <= '1';

                                                         anode_3_o <= '1';

                                                         anode_4_o <= '1';

               when "01" => register_data(3 downto 0) <= register_2_i(3 downto 0);

                                                         anode_1_o <= '1';

                                                         anode_2_o <= '0';

                                                         anode_3_o <= '1';

                                                         anode_4_o <= '1';

               when "10" => register_data(3 downto 0) <= register_3_i(3 downto 0);

                                                         anode_1_o <= '1';

                                                         anode_2_o <= '1';

                                                         anode_3_o <= '0';

                                                         anode_4_o <= '1';

               when "11" => register_data(3 downto 0) <= register_4_i(3 downto 0);

                                                         anode_1_o <= '1';

                                                         anode_2_o <= '1';

                                                         anode_3_o <= '1';

                                                         anode_4_o <= '0';

               when others => null;

               end case;

 end process;

 SiebenSegment_p: process(register_data)

 begin

 case register_data is
 
               when "0000" => seven_segment_o(6 downto 0) <= "1000000"; --0

               when "0001" => seven_segment_o(6 downto 0) <= "1111001"; --1

               when "0010" => seven_segment_o(6 downto 0) <= "0100100"; --2

               when "0011" => seven_segment_o(6 downto 0) <= "0110000"; --3

               when "0100" => seven_segment_o(6 downto 0) <= "0011001"; --4

               when "0101" => seven_segment_o(6 downto 0) <= "0010010"; --5

               when "0110" => seven_segment_o(6 downto 0) <= "0000010"; --6

               when "0111" => seven_segment_o(6 downto 0) <= "1111000"; --7

               when "1000" => seven_segment_o(6 downto 0) <= "0000000"; --8

               when "1001" => seven_segment_o(6 downto 0) <= "0010000"; --9

               when "1010" => seven_segment_o(6 downto 0) <= "0001100"; --P

               when "1011" => seven_segment_o(6 downto 0) <= "0000111"; --t

               when "1100" => seven_segment_o(6 downto 0) <= "1000110"; --C

               when "1101" => seven_segment_o(6 downto 0) <= "0100001"; --d

               when "1110" => seven_segment_o(6 downto 0) <= "0000110"; --E

               when "1111" => seven_segment_o(6 downto 0) <= "0001110"; --F

               when others => seven_segment_o(6 downto 0) <= "1111111"; --nothing

               end case;

 end process;

end Behavioral;
