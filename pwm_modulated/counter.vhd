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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity counter is
 port(clock_i        : in  std_ulogic;
      reset_i        : in  std_ulogic;
      counter_o      : out std_ulogic_vector(3 downto 0));
end counter;

architecture rtl of counter is   
   signal count        : integer range 0 to 15;
begin
  
  counter: process (clock_i, reset_i)
  begin
  if (reset_i = '1') then
      count   <= 0;
  elsif (clock_i'event and clock_i ='1') then
    if(count = 15) then
    	count    <=  0;
    else -- for count = 0,1,2,..,14,15
	    count    <=  count + 1;
    end if;
  end if;
  end process counter;

  counter_o <= To_StdUlogicVector(CONV_STD_LOGIC_VECTOR(count,4));
  
end rtl;
