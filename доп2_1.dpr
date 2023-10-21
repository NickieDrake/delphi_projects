program доп2_1;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  y, x, xok: real;
  i, k: integer;

begin
  x:= 0.5;
  while x <= 0.80000001 do     // Цикл А
    begin
      y := 13;
      xok:= x - 1;
      i:= 12;
      k:= 7;
      while i >= 0 do          // Цикл В
        begin
          if i = 0 then
            begin
              k:= 1;
            end
          else if((i mod 2) = 0) then
            begin
              k:= k - 1;
            end;
          y:= i + ((k*k*xok)/y);
          //writeln(y:8:4);       -  проверка промежуточных значений
          i:= i - 1;
        end;
      writeln('x=', x:8:4, ' y=', y:8:4);
      x := x + 0.05;
    end;
    writeln('Программа завершена. Нажмите ENTER');
   readln;
end.
