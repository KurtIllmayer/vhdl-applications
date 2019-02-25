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
use ieee.std_logic_unsigned.all;

entity four_bit_multiplier is
 port (reset_i         : in  std_ulogic;
       clock_i         : in  std_ulogic;
       select_i        : in  std_ulogic;
       a_i             : IN  std_ulogic_vector(3 DOWNTO 0);
       b_i             : IN  std_ulogic_vector(3 DOWNTO 0);
       anode_o         : out std_ulogic_vector(3 downto 0);
       seven_segment_o : out std_ulogic_vector(6 downto 0));
end four_bit_multiplier;

architecture Behavioral of four_bit_multiplier is

   component multiplier
   PORT(a_i        : IN   std_ulogic_vector(3 DOWNTO 0);
        b_i        : IN   std_ulogic_vector(3 DOWNTO 0);
        result_o   : OUT  std_ulogic_vector(7 DOWNTO 0));
   END component; 

   component seven_segment
   port(clock_i : in std_ulogic;
        reset_i : in std_ulogic;
        register_1_i : in std_ulogic_vector(3 downto 0);
        register_2_i : in std_ulogic_vector(3 downto 0);
        register_3_i : in std_ulogic_vector(3 downto 0);
        register_4_i : in std_ulogic_vector(3 downto 0);
        anode_1_o : out std_ulogic;
        anode_2_o : out std_ulogic;
        anode_3_o : out std_ulogic;
        anode_4_o : out std_ulogic;
        seven_segment_o : out std_ulogic_vector(6 downto 0));
   end component;

   signal result          : std_ulogic_vector(7 downto 0);   
   signal mult_out        : std_ulogic_vector(11 downto 0);    
   signal register_1      : std_ulogic_vector(3 downto 0); 
   signal register_2      : std_ulogic_vector(3 downto 0); 
   signal register_3      : std_ulogic_vector(3 downto 0); 
   signal register_4      : std_ulogic_vector(3 downto 0); 
   signal bcd_a           : std_ulogic_vector(7 downto 0); 
   signal bcd_b           : std_ulogic_vector(7 downto 0);    

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
  -- purposes then contact me with the details of your project for my permission."  
  ----------------------------------------------------------------------------------------------   
  function bin_to_bcd_mult (bin : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable i      : integer :=0;
    variable bcd : std_logic_vector(11 downto 0) := (others => '0');
    variable bint : std_logic_vector(7 downto 0)  := bin;
  begin
  
   for i in 0 to 7 loop
      bcd(11 downto 1) := bcd(10 downto 0);
      bcd(0)                   := bint(7);
      bint(7 downto 1)  := bint(6 downto 0);
      bint(0)                  :='0';
    
      -- UNITS  
      if(i < 7 and bcd(3 downto 0) > "0100") then
            bcd(3 downto 0) := bcd(3 downto 0) + "0011";
      end if;

      -- TENS
      if(i < 7 and bcd(7 downto 4) > "0100") then                  
            bcd(7 downto 4) := bcd(7 downto 4) + "0011";
      end if;

      -- HUNDREDS
      if(i < 7 and bcd(11 downto 8) > "0100") then
            bcd(11 downto 8) := bcd(11 downto 8) + "0011";
      end if;
 
   end loop;

   return bcd;

  end bin_to_bcd_mult;
 
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
  -- purposes then contact me with the details of your project for my permission."  
  ---------------------------------------------------------------------------------------------- 
  function bin_to_bcd (bin : std_logic_vector(3 downto 0)) return std_logic_vector is 
   variable i : integer range 0 to 3 :=0;
   variable bcd : std_logic_vector(7 downto 0):= (others => '0');
   variable bint : std_logic_vector(3 downto 0):= bin;
  begin
  for i in 0 to 3 loop
    bcd(7 downto 1) := bcd(6 downto 0);
    bcd(0) := bint(3);
    bint(3 downto 1):= bint(2 downto 0);
    bint(0) :='0';
    if(i < 3 and bcd(3 downto 0) >= "0101") then
      bcd(3 downto 0) := bcd(3 downto 0) + "0011";
    end if;
    if(i < 3 and bcd(7 downto 4) >= "0101") then
      bcd(7 downto 4) := bcd(7 downto 4) + "0011";
    end if;
  end loop;
  return bcd;
  end bin_to_bcd;

begin

   four_bit: multiplier port map(a_i       => a_i,
                                 b_i       => b_i,
			                        result_o  => result(7 downto 0));

   mult_out(11 downto 0) <= to_stdulogicvector(bin_to_bcd_mult(to_stdlogicvector(result(7 downto 0)))); 

   bcd_a(7 downto 0) <= to_stdulogicvector(bin_to_bcd(to_stdlogicvector(a_i(3 downto 0))));
   
   bcd_b(7 downto 0) <= to_stdulogicvector(bin_to_bcd(to_stdlogicvector(b_i(3 downto 0))));   

   process(result, bcd_a, bcd_b, select_i)
   
   begin
   
   if(select_i='0')then
   
         register_1 <= mult_out(3 downto 0);
         
         register_2 <= mult_out(7 downto 4);

         register_3 <= mult_out(11 downto 8);

         register_4 <= "0000";  
         
   else

         register_1 <= bcd_b(3 downto 0);
         
         register_2 <= bcd_b(7 downto 4);

         register_3 <= bcd_a(3 downto 0);

         register_4 <= bcd_a(7 downto 4); 

   end if;   
   
   end process;

   Seven_Display:seven_segment port map(clock_i         => clock_i,
                                        reset_i         => reset_i,
                                        register_1_i    => register_1,
                                        register_2_i    => register_2,
                                        register_3_i    => register_3,
                                        register_4_i    => register_4,
                                        anode_1_o       => anode_o(0),
                                        anode_2_o       => anode_o(1),
                                        anode_3_o       => anode_o(2),
                                        anode_4_o       => anode_o(3),
                                        seven_segment_o => seven_segment_o);

end Behavioral;
