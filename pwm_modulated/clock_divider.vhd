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

entity clock_divider is
    Port ( clock_i : in  STD_uLOGIC;
           reset_i : in  STD_uLOGIC;
           clk_o   : out STD_uLOGIC);
end clock_divider;

architecture Behavioral of clock_divider is

   signal clkdiv        : integer range 0 to 24999;
   signal clk           : std_ulogic;

begin

    clk_o <= clk;

    clock_divider_p: process (clock_i, reset_i)
	begin	  
   	if(reset_i = '1') then		  
            clkdiv <= 0;
            clk    <= '0';
    elsif (clock_i'event and clock_i = '1') then	  
         if(clkdiv = 24999)then         
            clkdiv <= 0;
            clk <= not clk;
         else
	         clkdiv <= clkdiv + 1;
	   end if;
    end if;      
	end process clock_divider_p;

end Behavioral;
