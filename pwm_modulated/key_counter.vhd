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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity key_counter is
    Port ( clock_i     : in  STD_uLOGIC;
           reset_i     : in  STD_uLOGIC;
           counter_o   : out STD_uLOGIC_vector(3 downto 0));
end key_counter;

architecture Behavioral of key_counter is
   signal clkdiv        : integer range 0 to 4999999;
   signal clk           : std_ulogic;
   signal count         : integer range 0 to 15;
   signal state         : std_ulogic;
begin

    clock_divider_p: process (clock_i, reset_i)
	begin	  
   	if(reset_i = '1') then		
            clkdiv <= 0;
            clk    <= '0';
	elsif (clock_i'event and clock_i = '1') then
       if(clkdiv = 4999999)then
            clkdiv <= 0;            
            clk    <= not clk;     
       else     
            clkdiv <= clkdiv + 1;
	   end if;		
    end if;     
    end process clock_divider_p;

    counter_p: process (clk, reset_i)	
    begin
    if (reset_i = '1') then
      count   <= 0;
      state   <= '0';
    elsif (clk'event and clk ='1') then
     if(state = '0')then
       if(count = 15) then
         state    <= '1';
       else -- for count = 0,1,2,..,14,15
	     count    <=  count + 1;
       end if;
     elsif(state = '1')then
       if(count = 0) then
         state    <= '0';
       else -- for count = 15,14,..,2,1,0
	     count    <=  count - 1;
       end if;    
     end if;
    end if;
    end process counter_p;

    counter_o <= To_StdUlogicVector(CONV_STD_LOGIC_VECTOR(count,4));

end Behavioral;
