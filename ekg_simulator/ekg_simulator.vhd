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

entity ekg_simulator is
    Port ( clock_i       : in   STD_uLOGIC;
           clk_i         : in   STD_uLOGIC;
           reset_i       : in   STD_uLOGIC;
           data_o        : out  STD_uLOGIC_vector(5 downto 0);
           h_sync_o      : OUT  std_ulogic;
           v_sync_o      : OUT  std_ulogic;
           red_o         : OUT  std_ulogic_vector(2 downto 0);
           green_o       : OUT  std_ulogic_vector(2 downto 0);
           blue_o        : OUT  std_ulogic_vector(1 downto 0));
end ekg_simulator;

architecture Behavioral of ekg_simulator is

 component Clockdivider
    Port ( clock_i       : in   STD_uLOGIC;
           reset_i       : in   STD_uLOGIC;
           clk_divider_o : out  STD_uLOGIC);
 end component;

 component Counter
    Port ( clock_i   : in   STD_uLOGIC;
           reset_i   : in   STD_uLOGIC;
           counter_o : out  STD_uLOGIC_vector(5 downto 0));
 end component;

 component rom
    Port (clock_i   : in   STD_uLOGIC;
          address_i : in   STD_uLOGIC_vector(5 downto 0);
          data_o    : out  STD_uLOGIC_vector(5 downto 0));
 end component;

 component vga_controller
    PORT(clk_i    : in   std_ulogic;
         reset_i  : in   std_ulogic;
         h_sync_o : out  std_ulogic;
         v_sync_o : out  std_ulogic;
         red_o    : out  std_ulogic_vector(2 downto 0);
         green_o  : out  std_ulogic_vector(2 downto 0);
         blue_o   : out  std_ulogic_vector(1 downto 0));
 end component;

 signal clock   : std_ulogic;
 signal address : std_ulogic_vector(5 downto 0);

begin


Divider: clockdivider port map(clock_i       => clock_i,
                               reset_i       => reset_i,
                               clk_divider_o => clock);

Address_counter: counter port map(clock_i    => clock,
                                  reset_i    => reset_i,
                                  counter_o  => address);

EKG_ROM: rom port map(clock_i   => clock,
                      address_i => address,
                      data_o    => data_o);

VGA: vga_controller PORT MAP (clk_i    => clk_i,
                              reset_i  => reset_i,
                              h_sync_o => h_sync_o,
                              v_sync_o => v_sync_o,
                              red_o    => red_o,
                              green_o  => green_o,
                              blue_o   => blue_o);

end Behavioral;
