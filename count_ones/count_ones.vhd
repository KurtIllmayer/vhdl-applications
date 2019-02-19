----------------------------------------------------------------------------------
-- Company: 
-- Engineer:       Kurt Illmayer 
-- 
-- Create Date:    16:38:34 02/15/2019 
-- Design Name: 
-- Module Name:    count_ones - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.1 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity count_ones is
    Port (clk_i      : in  std_ulogic;
          reset_i    : in  std_ulogic;
          start_i    : in  std_ulogic;  
          data_i     : in  STD_uLOGIC_VECTOR(7 downto 0);
          count_v_o  : out STD_uLOGIC_VECTOR(3 downto 0);
          count_s_o  : out STD_uLOGIC_VECTOR(3 downto 0));
end count_ones;

architecture Behavioral of count_ones is

 signal count_s   : integer range 0 to 8;
 signal count_one : integer range 0 to 8; 
 signal data      : STD_uLOGIC_VECTOR(7 downto 0); 
 type states is (idle, calculate, result);
 signal state : states;
 signal sync   : std_ulogic;
 signal start  : std_ulogic;
 
begin
  
  dff_p: process(clk_i, reset_i) 

  begin

  if(reset_i = '1')then

          sync <= '0';    
         
  elsif(clk_i'event and clk_i = '1')then

          sync <= start_i;

  end if;
      
  end process dff_p;   

  process (clk_i, reset_i)
  
    variable count : integer range 0 to 8 := 0;
  
  begin
  
  if(reset_i = '1')then
  
    count     := 0;

    count_v_o <= (others=>'0');
  
  elsif(clk_i'event and clk_i='1')then
  
     count := 0;

     for i in 0 to 7 loop

       if(data_i(i) = '1')then 

          count := count + 1; 

       end if;

     end loop;

     count_v_o(3 downto 0) <= to_stdulogicvector(conv_std_logic_vector(count,4));

  end if;

  end process;

--  process (clk_i, reset_i)
--  
--  begin
--  
--  if(reset_i = '1')then
--  
--    count_s               <= 0;
--
--    count_s_o(3 downto 0) <= (others=>'0');
--
--    count_one             <= 0;
--
--    data(7 downto 0)      <= (others=>'0');
--  
--    state                 <= idle;
--  
--  elsif(clk_i'event and clk_i='1')then
--
--  case state is
--  
--  when idle =>
--
--    if(start_i = '1' and sync = '0')then
--
--        data(7 downto 0) <= data_i(7 downto 0);
--
--        count_one        <= 0;
--        
--        count_s          <= 0;
--    
--        state            <= calculate;
--    
--    else 
--
--        state            <= idle;    
--    
--    end if;
--    
--  when calculate => 
--  
--    if(data(count_one)='1')then
--     
--        count_s <= count_s + 1; 
--
--    end if;
--
--    if(count_one = 7)then
--
--       count_one <= 0;
--
--       state     <= result;
--
--    else
--    
--       count_one <= count_one + 1;
--    
--    end if; 
--    
--   when result =>       
--
--       count_s_o(3 downto 0) <= to_stdulogicvector(conv_std_logic_vector(count_s,4));
--
--       state                 <= idle; 
--   
--   end case;
--
--  end if;
--
--  end process;
--  
  process (clk_i, reset_i)
  
  begin
  
  if(reset_i = '1')then
  
    count_s               <= 0;

    count_s_o(3 downto 0) <= (others=>'0');

    count_one            <= 0;

    data(7 downto 0)      <= (others=>'0');
  
    start                 <= '0';

  elsif(clk_i'event and clk_i='1')then
  
    if(start_i = '1' and sync = '0')then

        data(7 downto 0) <= data_i(7 downto 0);

        count_one        <= 0;
        
        count_s          <= 0;
    
        start            <= '1';

    elsif(start = '1')then

      if(data(count_one)='1')then
     
        count_s <= count_s + 1; 

      end if;

      if(count_one = 7)then

        count_one             <= 0;

        start                 <= '0';

      else
    
        count_one             <= count_one + 1;
    
      end if;   
    
    else
   
       count_s_o(3 downto 0) <= to_stdulogicvector(conv_std_logic_vector(count_s,4));
    
    end if;

  end if;

  end process;  

end Behavioral;
