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

entity dds_top is
  port(clock_i            : in  std_ulogic;
       reset_i            : in  std_ulogic; 
	    clk_o              : out std_ulogic;       
       phase_select_i     : in  std_ulogic_vector(3 downto 0);
       wave_select_i      : in  std_ulogic_vector(1 downto 0);
       data_o             : out std_ulogic_vector(7 downto 0));
end dds_top;

architecture Behavioral of dds_top is

 component select_logic
  port(phase_select_i     : in  std_ulogic_vector(3 downto 0);
       phase_start_o      : out std_ulogic_vector(31 downto 0));
 end component;

 component dds_generator
  port(clock_i            : in  std_ulogic;
       reset_i            : in  std_ulogic; 
    	 phase_start_i      : in  std_ulogic_vector(31 downto 0);
       da_sinus_o         : out std_ulogic_vector(7 downto 0);
       da_saegezahn_o     : out std_ulogic_vector(7 downto 0); 
       da_rechteck_o	     : out std_ulogic_vector(7 downto 0);  
       da_dreieck_o	     : out std_ulogic_vector(7 downto 0);  	  
	    clk_o              : out std_ulogic);
 end component;

 component mux
  port(wave_select_i      : in  std_ulogic_vector(1 downto 0);
       da_sinus_i         : in  std_ulogic_vector(7 downto 0);
	    da_saegezahn_i     : in  std_ulogic_vector(7 downto 0); 
       da_rechteck_i	     : in  std_ulogic_vector(7 downto 0);  
       da_dreieck_i	     : in  std_ulogic_vector(7 downto 0);
 	    data_o             : out std_ulogic_vector(7 downto 0)); 
 end component;

 signal phase_start      : std_ulogic_vector(31 downto 0);

 signal da_saegezahn     : std_ulogic_vector(7 downto 0); 
 signal da_rechteck	    : std_ulogic_vector(7 downto 0); 
 signal da_dreieck	    : std_ulogic_vector(7 downto 0);
 signal da_sinus         : std_ulogic_vector(7 downto 0);

begin

Phaseincrement: select_logic port map(phase_select_i => phase_select_i,
                                     phase_start_o  => phase_start);

waves: dds_generator port map(clock_i        => clock_i,
                              reset_i        => reset_i,
                              phase_start_i  => phase_start,
                              da_sinus_o     => da_sinus,
                              da_saegezahn_o => da_saegezahn,
                              da_rechteck_o  => da_rechteck,
                              da_dreieck_o   => da_dreieck,
                              clk_o          => clk_o);
                              
Multiplexer: mux port map (wave_select_i     => wave_select_i,
                           da_sinus_i        => da_sinus,
                           da_saegezahn_i    => da_saegezahn,
                           da_rechteck_i     => da_rechteck,
                           da_dreieck_i      => da_dreieck,
                           data_o            => data_o);                           

end Behavioral;
