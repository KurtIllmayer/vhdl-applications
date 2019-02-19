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
use ieee.std_logic_arith.all;

entity select_logic is
port(phase_select_i     : in  std_ulogic_vector(3 downto 0);
     phase_start_o      : out std_ulogic_vector(31 downto 0));
end select_logic;

architecture Behavioral of select_logic is

 signal phase_increment : integer range 0 to 75591;

begin

  -- Taktfrequenz fclk = 50 MHz beim Basys2 Board
  -- DDS mit Phasenakkumulator: M = (fout*2^32)/fclk... Phasenincrement
  -- z.B.     M = 880*2^32/(50000000 Hz) = 75591,4244
  -- M = 75591 gewählt: => fout = 75591*50000000 Hz/2^32 = 879.995059 

  phase_increment_p: process(phase_select_i)  
 
  begin 

	case phase_select_i is
	--    Midi Note 69 = 45H = 440 Hz       = A3
	--    Pitchbending: Differenz: für Halbton: 	
	when "0000" => phase_increment <= 37796;
	--    Midi Note 70 = 46H = 466.16376 Hz = A#3
	--    Pitchbending: Differenz: für Halbton:	
	when "0001" => phase_increment <= 40043;
	--    Midi Note 71 = 47H = 493.88330 Hz = H3
	--    Pitchbending: Differenz: für Halbton: 	
	when "0010" => phase_increment <= 42424;
	--    Midi Note 72 = 48H = 523.25113 Hz = C4
	--    Pitchbending: Differenz: für Halbton: 	
	when "0011" => phase_increment <= 44947;
	--    Midi Note 73 = 49H = 554,3652613 Hz = C#4
	--    Pitchbending: Differenz: für Halbton:
	when "0100" => phase_increment <= 47620;
	--    Midi Note 74 = 4AH = 587,3295349 Hz = D4
	--    Pitchbending: Differenz: für Halbton:	
	when "0101" => phase_increment <= 50451; 
	--    Midi Note 75 = 4BH = 622,253966 Hz = D#4
	--    Pitchbending: Differenz: für Halbton:	
	when "0110" => phase_increment <= 53451;
	--    Midi Note 76 = 4CH = 659,2551123 Hz = E4
	--    Pitchbending: Differenz: für Halbton:	
	when "0111" => phase_increment <= 56630;
	--    Midi Note 77 = 4DH = 698,456461 Hz = F4
	--    Pitchbending: Differenz: für Halbton: 1783	
	when "1000" => phase_increment <= 59997;
	--    Midi Note 78 = 4EH = 739,9888432 Hz = F#4
	--    Pitchbending: Differenz: für Halbton: 	
	when "1001" => phase_increment <= 63565;   
	--    Midi Note 79 = 4FH = 783,9908693 Hz = G4
	--    Pitchbending: Differenz: für Halbton:	
	when "1010" => phase_increment <= 67344;
   --    Pitchbending: Differenz: für Halbton: 
	--    Midi Note 80 = 50H = 830,6093921 Hz = G#4	
	when "1011" => phase_increment <= 71349;
	--    Midi Note 81 = 51H = 880 Hz = A4
	--    Pitchbending: Differenz: für Halbton: 
	when "1100" => phase_increment <= 75591;
	--    Midi Note 69 = 45H = 440 Hz       = A3
	--    Pitchbending: Differenz: für Halbton: 	
	when others    => phase_increment <= 37796;
   
	end case;

  end process phase_increment_p;

 phase_start_o(31 downto 0)  <= to_stdulogicvector(conv_std_logic_vector(phase_increment,32));

end Behavioral;
