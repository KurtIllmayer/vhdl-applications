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
 
ENTITY dds_tb IS
END dds_tb;
 
ARCHITECTURE behavior OF dds_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT dds
    PORT(clk_i              : IN   std_ulogic;
         reset_i            : IN   std_ulogic;
         phase_start_i      : IN   std_ulogic_vector(31 downto 0);
		   da_sinus_o         : out  std_ulogic_vector(7 downto 0);
		   da_saegezahn_o     : out  std_ulogic_vector(7 downto 0);
			da_rechteck_o	    : out  std_ulogic_vector(7 downto 0);
			da_dreieck_o	    : out std_ulogic_vector(7 downto 0); 
         clk_o              : OUT  std_ulogic);
    END COMPONENT;
    
   --Inputs
   signal clk_i         : std_ulogic := '0';
   signal reset_i       : std_ulogic := '0';
   signal phase_start_i : std_ulogic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal clk_o         : std_ulogic;
   signal da_sinus_o    : std_ulogic_vector(7 downto 0);
   signal da_saegezahn_o: std_ulogic_vector(7 downto 0);
   signal da_rechteck_o : std_ulogic_vector(7 downto 0);	
	signal da_dreieck_o  : std_ulogic_vector(7 downto 0); 
  -- Clock period definitions
   constant clk_i_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dds PORT MAP (
          clk_i              => clk_i,
          reset_i            => reset_i,
          phase_start_i      => phase_start_i,
			 da_sinus_o         => da_sinus_o,
	       da_saegezahn_o     => da_saegezahn_o, 
			 da_rechteck_o      => da_rechteck_o,
			 da_dreieck_o       => da_dreieck_o, 
          clk_o              => clk_o
        );

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

-- Calculate the frequency to be produced by dds:  e.g. 880 Hz
-- fout = (phase_start * clock_frequency) / (2^(number of bits from phase_accu)) 
-- 879,9950593 = (75591*50000000)/(2^32)
-- The Signal fout is the MSB of teh phase accu: phase(31)
-- respectively: 880*2^32/50000000 = 75591,4244 phase_start value!
-- Frequency resolution: delta_f = clock_frequency/2^(number of bits from phase_accu)
--                       delta_f = 50000000/2^32 = 0,011641532

--  phase_start_i <=  4095 after 0 ns,
--                   75592 after 40 ms,
--						179787 after 50 ms;
--                37796
						 
  phase_start_i <= "00000000000000010010011101000111" after  0 ms,
                   "00000000000000001001001110100100" after  2 ms;
  
END;
