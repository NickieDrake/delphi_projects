program лр3_доп_1;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  a, b, x1, x2, y1, y2: real;

begin
  writeln('Поиск корня уравнения методом хорд:');
  a := 0;
  b := 1;
  x1 := 0;
  y1 := 0;
  repeat // Цикл А
    begin
      x1 := a - ((cos(a) - (a * a)) * (b - a) /
        ((cos(b) - (b * b)) - (cos(a) - (a * a))));
      a := b;
      b := x1;
    end;
  until (abs(a - b) <= 0.0001);
  writeln('Найденный корень: ', x1:10:7);
  y1 := cos(x1) - (x1 * x1);
  writeln;

  writeln('Поиск корня уравнения методом деления отрезка пополам:');
  a := 0;
  b := 1;
  x2 := 0;
  y2 := 0;
  repeat // Цикл В
    x2 := (a + b) / 2;
    y2 := (cos(x2) - (x2 * x2));
    if (((y2 > 0) and ((cos(a) - (a * a)) > 0)) or
            ((y2 < 0) and ((cos(a) - (a * a)) < 0))) then
      begin
        a := x2;
      end
    else
      begin
        b := x2;
      end;
  until (abs(a - b) <= 0.0001);
  writeln('Найденный корень: ', x2:10:7);
  writeln;

  writeln('Значение по методу хорд:', y1:15:10);
  writeln('Значение по методу деления отрезка пополам:', y2:15:10);
  writeln;

  if abs(y1) < abs(y2) then
    writeln('Метод хорд является более точным')
  else if abs(y1) > abs(y2) then
    writeln('Метод деления отрезка пополам является более точным')
  else
    writeln('Методы равны по своей точности');

  writeln('Программа завершена. Нажмите ENTER');
  readln;

end.
