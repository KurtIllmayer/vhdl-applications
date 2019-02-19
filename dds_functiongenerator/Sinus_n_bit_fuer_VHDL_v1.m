% ---------------------------------------------------------------------------------
% -- MIT License

% -- Copyright (c) 2019 Kurt Illmayer

% -- Permission is hereby granted, free of charge, to any person obtaining a copy
% -- of this software and associated documentation files (the "Software"), to deal
% -- in the Software without restriction, including without limitation the rights
% -- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% -- copies of the Software, and to permit persons to whom the Software is
% -- furnished to do so, subject to the following conditions:

% -- The above copyright notice and this permission notice shall be included in all
% -- copies or substantial portions of the Software.

% -- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% -- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% -- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% -- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% -- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% -- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% -- SOFTWARE.
% ---------------------------------------------------------------------------------

% n Bit Sine Calculation for VHDL

disp('       ');  
n = input('  Signal Resolution in bit:          n = ');
disp('       '); 

A = (2^n) - 1;
f = (0:1:A);
wave_dec = round(A/2+(A/2)*sin((pi/A)*f-pi/2));
wave_bin = dec2bin(round(A/2+(A/2)*sin((pi/A)*f-pi/2)),n);

filename_vhd = ['sinusfunction_n_' num2str(n) '_bit.vhd'];
s1 = fopen(filename_vhd,'wb');  %opens the output file

fprintf(s1,'%s\n','');
fprintf(s1,'%s\n','   -- Values of the sine-function in VHDL :');

for i=0:A

  fprintf(s1,'%s\n','');
  fprintf(s1,'    when "');
  fprintf(s1,'%s',num2str(dec2bin(i,n)));
  fprintf(s1,'" => ');
  fprintf(s1,'   data_o(');
  fprintf(s1,'%d',n-1);
  fprintf(s1,' downto 0) <= "');
  fprintf(s1,'%s',num2str(wave_bin(i+1,1:n)));
  fprintf(s1,'%c','";');
  fprintf(s1,'%c\n','');

end  
  
fprintf(s1,'%s\n','');
fprintf(s1,'    when others =>');
fprintf(s1,'   data_o(');
fprintf(s1,'%d',n-1);
fprintf(s1,' downto 0) <= "');
fprintf(s1,'%s',num2str(wave_bin(i+1,1:n)));
fprintf(s1,'%c','";');
fprintf(s1,'%c\n','');

fclose(s1);

stairs(wave_dec);
pause;
stairs(-1 + 2*(wave_dec/((2^n)-1)));
pause;
stairs(2*(wave_dec/((2^n)-1)));
