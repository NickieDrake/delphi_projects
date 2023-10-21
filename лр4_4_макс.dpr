program лр4_4_макс;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

const
  p = 10;

type
  tmas = array [1 .. p] of integer;

var
  masA, masB, masK: tmas;
  i, isum, x, schk, chM, sum, sumpred, minm, kolvoi, nn, m, hh, sumhh: integer;
  n, s: real;

begin
  // Количество членов массивов и значение М
  writeln('Введите количество членов массива А (до 10):');
  readln(n);
  writeln('Введите количество членов массива B (до 10):');
  readln(m);
  writeln('Введите число М:');
  readln(chM);
  // Заполнение массивов функцией рандома
  { writeln('Числа массива А:');
    isum := 1;
    while isum <= n do
    begin
    randomize;
    masA[isum] := 100 - random(180);
    writeln(masA[isum]);
    isum := isum + 1;
    end;

    writeln('Числа массива В:');
    isum := 1;
    while isum <= m do
    begin
    randomize;
    masB[isum] := 100 - random(180);
    writeln(masB[isum]);
    isum := isum + 1;
    end; }
  // Заполнение массивов вручную
  writeln('Введите значения массива А:');
  isum := 1;
  while isum <= n do // Цикл А
    begin
      readln(masA[isum]);
      isum := isum + 1;
    end;
  writeln('Введите значения массива В:');
  isum := 1;
  while isum <= m do // Цикл В
    begin
      readln(masB[isum]);
      isum := isum + 1;
    end;

  if n < m then
    begin
      s := n;
    end
  else
    begin
      s := m;
    end;
  kolvoi := round(exp(s * ln(2)) - 1);
  sumpred := -100000000;

  // Перебор всех возможных вариантов выборки члено массива
  for i := 1 to kolvoi do // Цикл С
    begin
      sum := 0;
      minm := 0;
      x := i;
      schk := 1;
      nn := round(s);
      // Цикл нахождения сумм
      while x > 0 do // Цикл  D
        begin
          if (x mod 2) = 1 then
            begin
              sum := sum + masB[nn];
              minm := minm + masA[nn];
              masK[schk] := nn;
              schk := schk + 1;
            end;
          nn := nn - 1;
          x := x div 2;
        end;
      // Проверка условий и вывод нового оптимального решения
      if ((minm < chM) and (sum > sumpred)) then
        begin
          sumpred := sum;
          hh := i;
          sumhh:= sum;
          { writeln('Лучший результат - номера индексов:');
            isum := 1;
            while isum < schk do // Цикл  E
            begin
            write(masK[isum], ' ');
            isum := isum + 1;
            end;
            writeln;
            writeln('Сумма членов массива В:');
            writeln(sum);
            writeln; }

        end;

    end;
  {if (minm < chM) then
    begin
      //sumpred := sum;
      writeln('Лучший результат - номера индексов:');
      isum := 1;
      while isum < schk do // Цикл  E
        begin
          write(masK[isum], ' ');
          isum := isum + 1;
        end;
      writeln;
      writeln('Сумма членов массива В:');
      writeln(sum);
      writeln;

    end; }
    writeln('Лучший результат - номера индексов:');
    nn := round(s);
    while hh > 0 do // Цикл  D
        begin
          if (hh mod 2) = 1 then
            begin
              {sum := sum + masB[nn];
              minm := minm + masA[nn];
              masK[schk] := nn;
              schk := schk + 1;}
              writeln(nn);
            end;
          nn := nn - 1;
          hh := hh div 2;
        end;
     writeln;
      writeln('Сумма членов массива В:');
      writeln(sumhh);
      writeln;


  if (sumpred = -100000000) then
    begin
      writeln('Никакая сумма членов массива А не оказалась больше М. Программа завершена. Нажмите ENTER.');
    end
  else
    begin
      writeln('Максимально возможная сумма найдена. Программа завершена. Нажмите ENTER.');
    end;
  readln;

end.
