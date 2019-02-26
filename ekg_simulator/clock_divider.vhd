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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Clockdivider is
    Port ( clock_i       : in   STD_uLOGIC;
           reset_i       : in   STD_uLOGIC;
           clk_divider_o : out  STD_uLOGIC);
end Clockdivider;

architecture rtl of Clockdivider is

 signal clk_divider : std_ulogic;
 signal count   	  : integer range 0 to 390624;

begin

count_p: process(reset_i,clock_i)

begin

if(reset_i='1') then

		count 		<=0;
		
		clk_divider <='1';
		
elsif(clock_i'event and clock_i='1') then
			
			if(count = 390624) then
				
					count 	<=0;
					
					clk_divider <= not clk_divider;
								
			else 	--for count = 0,1,2,3......, 24999999
								
					count <= count +1;
					
			end if;
			
		end if;
		
end process count_p;

clk_divider_o <= clk_divider;

end rtl;