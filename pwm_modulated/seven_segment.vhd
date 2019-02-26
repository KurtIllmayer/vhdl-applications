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

entity seven_segment is
   port(clock_i         : in  std_ulogic;
        reset_i         : in  std_ulogic; 
        data_i          : in  std_ulogic_vector(7 downto 0);
        anode_o         : out std_ulogic_vector(3 downto 0);
        seven_segment_o : out std_ulogic_vector(6 downto 0));
end seven_segment;

architecture rtl of seven_segment is
  
  signal clk           : std_logic;
  signal clkdiv        : std_logic_vector(14 downto 0);
  signal clkdiv2       : std_logic_vector(1 downto 0);
  signal register_data : std_ulogic_vector(3 downto 0);   
  
begin

   clock_divider: process (clock_i, reset_i)

	begin
	  
   	if(reset_i = '1') then
		  
             clkdiv <= "000000000000000";

	elsif (clock_i'event and clock_i = '1') then
	  
	         clkdiv <= clkdiv + 1;

	end if;
		
	end process clock_divider;

	clk <= clkdiv(14);

	clock_divider2: process (clk, reset_i)
	begin
   	if(reset_i = '1') then
		  
            clkdiv2 <= "00";

	elsif (clk'event and clk = '1') then
	  
	        clkdiv2 <= clkdiv2 + 1;

	end if;
		
	end process clock_divider2;	

	mux_p: process(data_i, clkdiv2)
	begin
	  case clkdiv2 is
	  
	   when "00" =>  register_data(3 downto 0) <= data_i(3 downto 0);
                     anode_o  <= "1110";
			 			 
	   when "01" =>  register_data(3 downto 0) <= data_i(7 downto 4);
                     anode_o  <= "1101";
						  
	   when "10" =>  register_data(3 downto 0) <= "0000";
                     anode_o  <= "1011";
			 
	   when "11" =>  register_data(3 downto 0) <= "0000";
                     anode_o  <= "0111";

	   when others => null;
			   
	  end case;
	  
	end  process mux_p;
      
     
  seven_1_p: process(register_data)
                 
  begin
                 
  case register_data is

    when "0000" => seven_segment_o(6 downto 0) <= "1000000";  --0

    when "0001" => seven_segment_o(6 downto 0) <= "1111001";  --1

    when "0010" => seven_segment_o(6 downto 0) <= "0100100";  --2

    when "0011" => seven_segment_o(6 downto 0) <= "0110000";  --3

    when "0100" => seven_segment_o(6 downto 0) <= "0011001";  --4

    when "0101" => seven_segment_o(6 downto 0) <= "0010010";  --5

    when "0110" => seven_segment_o(6 downto 0) <= "0000010";  --6

    when "0111" => seven_segment_o(6 downto 0) <= "1111000";  --7

    when "1000" => seven_segment_o(6 downto 0) <= "0000000";  --8

    when "1001" => seven_segment_o(6 downto 0) <= "0010000";  --9

    when "1010" => seven_segment_o(6 downto 0) <= "0001000";  --A

    when "1011" => seven_segment_o(6 downto 0) <= "0000011";  --b

    when "1100" => seven_segment_o(6 downto 0) <= "1000110";  --C

    when "1101" => seven_segment_o(6 downto 0) <= "0100001";  --d

    when "1110" => seven_segment_o(6 downto 0) <= "0000110";  --E

    when "1111" => seven_segment_o(6 downto 0) <= "0001110";  --F

    when others => seven_segment_o(6 downto 0) <= "1111111";  --nothing
   
  end case;
  
  end process seven_1_p;
	
end rtl;
