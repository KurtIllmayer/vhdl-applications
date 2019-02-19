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

entity mux is
  port(wave_select_i      : in  std_ulogic_vector(1 downto 0);
       da_sinus_i         : in  std_ulogic_vector(7 downto 0);
	    da_saegezahn_i     : in  std_ulogic_vector(7 downto 0); 
       da_rechteck_i	     : in  std_ulogic_vector(7 downto 0);  
       da_dreieck_i	     : in  std_ulogic_vector(7 downto 0);
 	    data_o             : out std_ulogic_vector(7 downto 0)); 
end mux;

architecture Behavioral of mux is

begin

 mux_p: process(wave_select_i, da_sinus_i, da_saegezahn_i, 
                da_rechteck_i, da_dreieck_i)
  begin  

    case wave_select_i is

      when "00"    => data_o <= da_dreieck_i;
		      
      when "01"    => data_o <= da_rechteck_i;
		      
      when "10"    => data_o <= da_saegezahn_i;
		      
      when "11"    => data_o <= da_sinus_i;
		  
      when others =>  data_o <= da_dreieck_i;

    end case;

  end process mux_p;  

end Behavioral;
