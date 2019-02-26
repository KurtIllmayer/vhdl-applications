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

ENTITY vga_tb IS
END vga_tb;
 
ARCHITECTURE behavior OF vga_tb IS 

    COMPONENT vga_controller
    PORT(
         clk_i      : IN   std_ulogic;
         reset_i    : IN   std_ulogic;
         select_i   : IN   std_ulogic_vector(1 downto 0);
         h_sync_o   : OUT  std_ulogic;
         v_sync_o   : OUT  std_ulogic;
         red_o      : OUT  std_ulogic_vector(2 downto 0);
         green_o    : OUT  std_ulogic_vector(2 downto 0);
         blue_o     : OUT  std_ulogic_vector(1 downto 0));
    END COMPONENT;

   signal clk_i     : std_ulogic := '0';
   signal reset_i   : std_ulogic := '0';
   signal select_i  : std_ulogic_vector(1 downto 0) := (others => '0');
   signal h_sync_o  : std_ulogic;
   signal v_sync_o  : std_ulogic;
   signal red_o     : std_ulogic_vector(2 downto 0);
   signal green_o   : std_ulogic_vector(2 downto 0);
   signal blue_o    : std_ulogic_vector(1 downto 0);

   constant clk_i_period : time := 10 ns;
 
BEGIN

   uut: vga_controller PORT MAP (
          clk_i      => clk_i,
          reset_i    => reset_i,
          select_i   => select_i,
          h_sync_o   => h_sync_o,
          v_sync_o   => v_sync_o,
          red_o      => red_o,
          green_o    => green_o,
          blue_o     => blue_o);

   -- Clock process definitions
   clk_i_process :process
   begin
		clk_i <= '0';
		wait for clk_i_period/2;
		clk_i <= '1';
		wait for clk_i_period/2;
   end process;

 reset_i <= '1' after 0 ns,
            '0' after 10 ns;   
   
END;
