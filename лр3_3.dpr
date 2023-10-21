program лр3_3;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  psl, tsl, tslok, pslok, x, k, i, n, f2, f1, mins, eps, NW: real;
  f21f, f22f: boolean;

begin
  writeln('   |  x    |   f1(x)   |   eps= 10^-2   |   eps= 10^-3   |   eps= 10^-4  |');
  writeln('   |       |           |  f2(x)      N  |  f2(x)      N  |  f2(x)      N |');
  writeln('   |_______|___________|________________|________________|_______________|');
  x := -0.6;
  while (x < (-0.6 + 20 * 0.05)) do                  // Цикл А
    begin

      // расчет f1
      f1 := ((1/2) * (arctan(x)) * (ln(1 + (x * x))));
      write('   |', x:6:2, ' |', f1:10:6, ' ');

      k := 1;
      i := 3;
      n := 3;
      tsl := x * (-1);
      f2 := 0;
      mins := 3 / 2;
      f21f := true;
      f22f := true;
      eps := 0.01;
      NW := 0;
      pslok:= 0;
      tslok:= 0;



      // расчет f2
      repeat                           // Цикл В

        while (n <= (2 * k)) do        // Цикл С
          begin
            mins := (mins + (1 / n));
            n := n + 1;
          end;


        psl := tsl;
        pslok := tslok;
        tsl := (psl * (-1) * x * x);
        tslok:= tsl*mins/i;
        NW := NW + 1;
        i := i + 2;
        k := k + 1;
        f2 := f2 + tslok;

        // проверка точности
        if ((abs(abs(tslok) - abs(pslok)) < eps) and (f21f)) then
          begin
            write('|', f2:10:6, ' ', NW:3:0, '  ');
            f21f := false;
            eps := eps / 10;
          end;

        if ((abs(abs(tslok) - abs(pslok)) < eps) and (f22f)) then
          begin
            write('|', f2:10:6, ' ', NW:3:0, '  ');
            f22f := false;
            eps := eps / 10;
          end;

      until ((abs(abs(tslok) - abs(pslok)) < eps) and (NOT(f22f)));

      writeln('|', f2:10:6, ' ', NW:3:0, ' |');
      x := x + 0.050000000001;
    end;
  writeln('   |_______|___________|________________|________________|_______________|');
  writeln('Программа завершена. Нажмите ENTER');
  readln;

end.
