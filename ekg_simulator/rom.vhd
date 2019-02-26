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

entity rom is
    Port (clock_i   : in   STD_uLOGIC;
          address_i : in   STD_uLOGIC_vector(5 downto 0);
          data_o    : out  STD_uLOGIC_vector(5 downto 0));
end rom;

architecture rtl of rom is
   type EKG_63 is array (0 to 63) of std_ulogic_vector(5 downto 0);
   constant EKG1:EKG_63:=
	("000110",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "000111",
	 "001001",
	 "001011",
	 "001110",
	 "010000",
	 "010001",
	 "010000",
	 "001110",
	 "001011",
	 "001001",
	 "000111",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
 	 "000110",
	 "000010",
	 "000110",
	 "010010",
	 "100100",
	 "101101",
	 "110111",
	 "111111",
	 "110111",
	 "101101",
	 "100100",
	 "010010",
	 "000110",
	 "000000",
	 "000111",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "001001",
	 "001011",
	 "001111",
	 "010011",
	 "010110",
	 "010111",
	 "010110",
	 "010011",
	 "001111",
	 "001011",
	 "001001",
	 "000111",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "000110",
	 "000110");
begin

  EKG_p: process(clock_i, address_i)
  begin
  if(clock_i'event and clock_i= '1')then	
      data_o <= EKG1(Conv_Integer(To_Stdlogicvector(address_i)));
  end if;
  end process EKG_p;

end rtl;
