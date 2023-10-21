program лр2_1;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  x, f, cos, cosok, k, dx, log, n: real;

begin
  x := 0.6;
  dx:= 0.25;
  while (x <= 1.1 + 0.0000001) do   // Цикл А
    begin
      log := ln(abs(x));
      n := 10;
      k := 1;
      cosok := 0;
      while n <= 15 do // Цикл В
        begin
          f:= ((n * (exp(2 * ln(x)/3))) + ((exp(x * ln(n)))/5));
          while k <= n do  // Цикл С
            begin
              cos:= (log/(2 - (1/k)));
              k := k + 1;
              cosok := cosok + cos;
              //writeln(333); - для проверки, что расчеты не повторяются
            end;
          f:= f + cosok;
          writeln('n =', n:12:5, ' x =', x:12:5, ' f =', f:12:5);
          n:= n + 1;
        end;
      x:= x + dx;
    end;
  writeln('Программа завершена нажмите ENTER.');
  readln;
end.
