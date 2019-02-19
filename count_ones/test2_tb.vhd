--------------------------------------------------------------------------------
--
-- Company:        Bulme Graz Goesting
-- Engineer:       Kurt Illmayer 
--
-- Create Date:    18:29:57 02/15/2019
-- Design Name:    test2_tb
-- Module Name:    C:/Digital_Designs/SCHILF_VHDL/VHDL_Applications/count_ones/test2_tb.vhd
-- Project Name:   count_ones
-- Target Device:  XC3S100E
-- Tool versions:  ISE Webpack 14.7
-- Description:    VHDL Testbench
-- Revision 0.1 - File Created 
-- Additional Comments: 
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
 
entity test2_tb is
end test2_tb;
 
architecture test of test2_tb is 
 
    component count_ones
    port(
         clk_i     : IN   std_ulogic;
         reset_i   : IN   std_ulogic;
         start_i   : IN   std_ulogic;
         data_i    : IN   std_ulogic_vector(7 downto 0);
         count_v_o : OUT  std_ulogic_vector(3 downto 0);
         count_s_o : OUT  std_ulogic_vector(3 downto 0));
    end component;

   signal clk_i     : std_ulogic := '0';
   signal reset_i   : std_ulogic := '0';
   signal start_i   : std_ulogic := '0';
   signal data_i    : std_ulogic_vector(7 downto 0) := (others => '0');

   signal count_v_o : std_ulogic_vector(3 downto 0);
   signal count_s_o : std_ulogic_vector(3 downto 0);

   -- Clock period for the 50 MHz Systemclock of the Basys2 Board
   constant clk_i_period : time := 20 ns;
 
begin
 
   uut: count_ones port map (
          clk_i     => clk_i,
          reset_i   => reset_i,
          start_i   => start_i,
          data_i    => data_i,
          count_v_o => count_v_o,
          count_s_o => count_s_o);

   clk_i <= not clk_i after clk_i_period/2;
 
   -- Stimulus assignment example

   -- a_i <= '0' after   0 ns, 
   --        '1' after 100 ns, 
   --        '0' after 200 ns, 
   --        '1' after 300 ns; 

   -- b_i <= '0' after   0 ns, 
   --        '0' after 100 ns, 
   --        '1' after 200 ns, 
   --        '1' after 300 ns; 

    reset_i <= '1' after  0 ns, 
               '0' after 10 ns; 

end;
