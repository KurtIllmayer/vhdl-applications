% n Bit Sinus Berechnung für VHDL

disp('       ');  
n = input('  Geben Sie die Auflösung des Signals in bit ein:          n = ');
disp('       '); 

A = (2^n) - 1;
f = (0:1:A);
wave_dec = round(A/2+(A/2)*sin((pi/A)*f-pi/2));
wave_bin = dec2bin(round(A/2+(A/2)*sin((pi/A)*f-pi/2)),n);

filename_vhd = ['sinusfunction_n_' num2str(n) '_bit.vhd'];
s1 = fopen(filename_vhd,'wb');  %opens the output file

fprintf(s1,'%s\n','');
fprintf(s1,'%s\n','   -- Funktionswerte der Sinusfunktion in VHDL :');

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
