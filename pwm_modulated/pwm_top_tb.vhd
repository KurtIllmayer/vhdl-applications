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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY pwm_top_tb IS
END pwm_top_tb;
 
ARCHITECTURE behavior OF pwm_top_tb IS 

   COMPONENT pwm_top
   Port (  clock_i         : in  STD_uLOGIC;
           reset_i         : in  STD_uLOGIC;
           pwm_o           : out STD_uLOGIC;
           led_o           : out STD_uLOGIC;           
           anode_o         : out STD_uLOGIC_VECTOR(3 downto 0);
           seven_segment_o : out STD_uLOGIC_VECTOR(6 downto 0));
   END COMPONENT;

   signal clock_i         : std_ulogic := '0';
   signal reset_i         : std_ulogic := '0';
   signal anode_o         : std_ulogic_vector(3 downto 0);
   signal seven_segment_o : std_ulogic_vector(6 downto 0);
   signal pwm_o, led_o    : std_ulogic;

   constant clock_i_period : time := 20 ns;
 
BEGIN

   uut: pwm_top PORT MAP (
          clock_i         => clock_i,
          reset_i         => reset_i,        
          pwm_o           => pwm_o,
          led_o           => led_o,
          anode_o         => anode_o,
          seven_segment_o => seven_segment_o);

   clock_i_process :process
   begin
		clock_i <= '0';
		wait for clock_i_period/2;
		clock_i <= '1';
		wait for clock_i_period/2;
   end process;

 reset_i <= '1' after  0 ns,
            '0' after 10 ns;

END;
