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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity pwm_top is
   Port (  clock_i         : in  STD_uLOGIC;
           reset_i         : in  STD_uLOGIC;
           pwm_o           : out STD_uLOGIC;
           led_o           : out STD_uLOGIC;           
           anode_o         : out STD_uLOGIC_VECTOR(3 downto 0);
           seven_segment_o : out STD_uLOGIC_VECTOR(6 downto 0));
end pwm_top;

architecture Behavioral of pwm_top is

 component clock_divider
   Port(clock_i : in  STD_uLOGIC;
        reset_i : in  STD_uLOGIC;
        clk_o   : out STD_uLOGIC); 
 end component;

 component key_counter
    Port ( clock_i     : in  STD_uLOGIC;
           reset_i     : in  STD_uLOGIC;
           counter_o   : out STD_uLOGIC_vector(3 downto 0));
 end component;

 component comparator
 PORT(a_i       :  IN   std_ulogic_vector(3 DOWNTO 0);
      b_i       :  IN   std_ulogic_vector(3 DOWNTO 0);
      x_o       :  OUT  std_ulogic);
 END component; 

 component counter is
 port(clock_i        : in  std_ulogic;
      reset_i        : in  std_ulogic;
      counter_o      : out std_ulogic_vector(3 downto 0));
 end component;

 component seven_segment
   Port(clock_i         : in  STD_uLOGIC;
        reset_i         : in  STD_uLOGIC;
        data_i          : in  STD_uLOGIC_VECTOR(7 downto 0);
        anode_o         : out STD_uLOGIC_VECTOR(3 downto 0);
        seven_segment_o : out STD_uLOGIC_VECTOR(6 downto 0));
 end component;

 -- http://vhdlguru.blogspot.com/2010/04/8-bit-binary-to-bcd-converter-double.html
 -- Double dabble Algorithmus realized by Vipin Lal:
 ----------------------------------------------------------------------------------------------
 -- Disclaimer:
 --"I don't makes any claims, promises or guarantees about the accuracy, completeness, or 
 -- adequacy of the contents of this website and expressly disclaims liability for errors and 
 -- omissions in the contents of this website. All the source code and tutorials are to be used
 -- on your own risk. All the ideas and views in this site are my own and are not by any means 
 -- related to my past or current employers. You can use the codes given in this website for 
 -- non-commercial purposes without my permission. But if you are using it for commercial 
 -- purposes then contact me with the details of your project for my permission."  ---------------------------------------------------------------------------------------------- 
 function bin_2_bcd (bin : std_logic_vector(3 downto 0)) return std_logic_vector is
   variable i    : integer range 0 to 3 :=0;
   variable bcd  : std_logic_vector(7 downto 0):= (others => '0');
   variable bint : std_logic_vector(3 downto 0):= bin;
 begin
 for i in 0 to 3 loop
  bcd(7 downto 1) := bcd(6 downto 0);
  bcd(0)          := bint(3);
  bint(3 downto 1):= bint(2 downto 0);
  bint(0)         :='0';
  if(i < 3 and bcd(3 downto 0) >= "0101") then
    bcd(3 downto 0) := bcd(3 downto 0) + "0011";
  end if;
  if(i < 3 and bcd(7 downto 4) >= "0101") then
    bcd(7 downto 4) := bcd(7 downto 4) + "0011";
  end if;
 end loop;
 return bcd;
 end bin_2_bcd;

 signal key         : std_ulogic_vector(3 downto 0);
 signal count       : std_ulogic_vector(3 downto 0);
 signal count_seven : std_ulogic_vector(7 downto 0); 
 signal clk         : std_ulogic;
 signal enable      : std_ulogic;
 signal pwm         : std_ulogic; 

begin

 CLOCKDIVIDE: clock_divider port map(clock_i    => clock_i,
                                     reset_i    => reset_i,
                                     clk_o      => clk);

 KEY_COUNT:   key_counter port map (clock_i     => clock_i,
     	                            reset_i     => reset_i,
		                            counter_o   => key(3 downto 0));

 COMPARE:       comparator port map(a_i         => count(3 downto 0),
                                    b_i         => key(3 downto 0),
			                        x_o         => pwm);
 pwm_o <= pwm;
 
 led_o <= pwm;
 
 COUNT16:         counter port map (clock_i     => clk,
 		                            reset_i     => reset_i,
			                        counter_o   => count(3 downto 0));

 count_seven(7 downto 0) <= to_stdulogicvector(bin_2_bcd(to_stdlogicvector(key(3 downto 0))));

 SEVENSEGMENT: seven_segment port map(clock_i         => clock_i,
                                      reset_i         => reset_i,
                                      data_i          => count_seven(7 downto 0),
                                      anode_o         => anode_o,
                                      seven_segment_o => seven_segment_o);
end Behavioral;
