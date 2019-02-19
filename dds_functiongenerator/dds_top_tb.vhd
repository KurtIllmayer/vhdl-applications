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
 
ENTITY dds_top_tb IS
END dds_top_tb;
 
ARCHITECTURE behavior OF dds_top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dds_top
    PORT(
         clock_i : IN  std_ulogic;
         reset_i : IN  std_ulogic;
         clk_o : OUT  std_ulogic;
         phase_select_i : IN  std_ulogic_vector(3 downto 0);
         wave_select_i : IN  std_ulogic_vector(1 downto 0);
         data_o : OUT  std_ulogic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock_i : std_ulogic := '0';
   signal reset_i : std_ulogic := '0';
   signal phase_select_i : std_ulogic_vector(3 downto 0) := (others => '0');
   signal wave_select_i : std_ulogic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal clk_o : std_ulogic;
   signal data_o : std_ulogic_vector(7 downto 0);

   -- Clock period definitions
   constant clock_i_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dds_top PORT MAP (
          clock_i => clock_i,
          reset_i => reset_i,
          clk_o => clk_o,
          phase_select_i => phase_select_i,
          wave_select_i => wave_select_i,
          data_o => data_o
        );

   -- Clock process definitions
   clock_i_process :process
   begin
		clock_i <= '0';
		wait for clock_i_period/2;
		clock_i <= '1';
		wait for clock_i_period/2;
   end process;

  reset_i <= '1' after 0 ns,
             '0' after 10 ns;  

  phase_select_i <= "0000" after 0 ns;

  wave_select_i <= "00" after 0 ns,
                   "01" after 7 ms,
                   "10" after 14 ms,
                   "11" after 21 ms;

END;
