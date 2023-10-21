program лр6_11;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

type
  tmas = array [1 .. 10, 1 .. 10] of integer;
  tmas2 = array [1 .. 100, 1 .. 100] of integer;
const
  n: integer = 10;
  labth1: tmas = ((1, 1, 1, 1, 1, 1, 1, 1, 1, 1), (1, 0, 1, 1, 1, 1, 0, 0, 0,
    1), (1, 0, 0, 0, 1, 0, 0, 1, 0, 1), (1, 1, 1, 0, 1, 0, 1, 1, 0, 0),
    (1, 0, 0, 0, 0, 0, 1, 0, 0, 1), (1, 0, 1, 1, 0, 1, 1, 0, 1, 1),
    (1, 0, 1, 0, 0, 1, 0, 0, 1, 1), (1, 0, 1, 0, 0, 1, 0, 1, 1, 1),
    (1, 0, 1, 0, 1, 1, 0, 0, 0, 1), (1, 1, 1, 1, 1, 1, 1, 0, 1, 1));

  labth2: tmas = ((1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
                  (1, 0, 0, 0, 0, 0, 0, 0, 0, 1),
                  (1, 0, 0, 0, 0, 0, 0, 1, 1, 1),
                  (1, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                  (1, 0, 0, 0, 0, 0, 0, 1, 1, 1),
                  (1, 0, 0, 0, 0, 0, 0, 0, 0, 1),
                  (1, 0, 0, 0, 0, 0, 0, 0, 0, 1),
                  (1, 0, 0, 0, 0, 0, 0, 0, 0, 1),
                  (1, 0, 0, 0, 0, 0, 0, 0, 0, 1),
                  (1, 1, 1, 1, 1, 1, 1, 1, 1, 1));

  labth3: tmas = ((1, 0, 1, 1, 1, 1, 1, 1, 1, 1), (1, 0, 0, 0, 0, 0, 0, 0, 0,
    1), (1, 1, 1, 1, 1, 1, 1, 1, 0, 1), (1, 0, 0, 0, 0, 0, 0, 0, 0, 1),
    (1, 0, 1, 1, 1, 1, 1, 1, 1, 1), (1, 0, 0, 0, 0, 0, 0, 0, 0, 1),
    (1, 1, 1, 1, 1, 1, 1, 1, 0, 1), (1, 0, 0, 1, 0, 0, 0, 1, 0, 1),
    (1, 1, 0, 0, 0, 1, 0, 0, 0, 1), (1, 1, 1, 1, 1, 1, 1, 1, 1, 1));

  labth4: tmas = ((1, 0, 1, 1, 1, 1, 1, 1, 1, 1), (1, 0, 1, 0, 0, 0, 1, 0, 0,
    1), (1, 0, 0, 0, 1, 0, 0, 0, 0, 1), (1, 1, 1, 1, 1, 1, 1, 1, 0, 1),
    (1, 0, 0, 1, 0, 0, 0, 1, 0, 1), (1, 0, 0, 0, 0, 1, 0, 0, 0, 1),
    (1, 0, 1, 1, 1, 1, 1, 1, 1, 1), (1, 0, 0, 1, 0, 0, 0, 1, 0, 1),
    (1, 1, 0, 0, 0, 1, 0, 0, 0, 1), (1, 1, 1, 1, 1, 1, 1, 1, 1, 1));

  labth5: tmas = ((1, 1, 1, 1, 1, 1, 1, 1, 1, 1), (0, 0, 0, 0, 0, 0, 0, 0, 0,
    0), (1, 0, 1, 1, 0, 0, 1, 1, 0, 1), (1, 0, 1, 1, 0, 0, 1, 1, 0, 1),
    (1, 0, 0, 0, 0, 0, 0, 0, 0, 1), (1, 0, 0, 0, 0, 0, 0, 0, 0, 1),
    (1, 0, 1, 1, 0, 0, 1, 1, 0, 1), (1, 0, 1, 1, 0, 0, 1, 1, 0, 1),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0), (1, 1, 1, 1, 1, 1, 1, 1, 1, 1));

  labth6: tmas = ((1, 1, 1, 1, 1, 1, 1, 1, 1, 1), (1, 0, 0, 0, 0, 0, 0, 0, 0,
    1), (1, 0, 1, 1, 0, 0, 1, 1, 0, 1), (1, 0, 1, 1, 0, 0, 1, 1, 0, 1),
    (1, 0, 0, 0, 0, 0, 0, 0, 0, 1), (1, 0, 0, 0, 0, 0, 0, 0, 0, 1),
    (1, 0, 1, 1, 0, 0, 1, 1, 0, 1), (1, 0, 1, 1, 0, 0, 1, 1, 0, 1),
    (1, 0, 0, 0, 0, 0, 0, 0, 0, 1), (1, 1, 1, 1, 1, 1, 1, 1, 1, 1));

var
  waymap, labthanswer: tmas;
   i, j, k, m, number, step: integer;
  masend, existend: boolean;


begin

  //labthanswer:= labth1;
  labthanswer:= labth2;
  //labthanswer := labth3;
  //labthanswer := labth4;
  //labthanswer := labth5;
  //labthanswer := labth6;

  //labthanswer:= masss;

 // writeln('Labyrinth:');
  {randomize;
  for k := 1 to n do               // Цикл А
    begin
      for m := 1 to n do           // Цикл В
        begin
          if (k=1) or (k=n) or (m=1) or (m=n) then
             labthanswer[k,m]:= 1
          else
             labthanswer[k,m]:= 0;
          //labthanswer[k,m]:= random(2);
          //write(labthanswer[k, m]:3);
        end;
      writeln;
    end;}

    //labthanswer[80,80]:= 0;


  // вывод лабиринта
  writeln('Labyrinth:');
  for k := 1 to n do               // Цикл А
    begin
      for m := 1 to n do           // Цикл В
        begin
          write(labthanswer[k, m]:3);
        end;
      writeln;
    end;

  // стартовое положение и проверка его корректности
  writeln('Starter place:');
  writeln('Line');
  readln(i);
  writeln('Column');
  readln(j);
  if (i > 10) or (j > 10) then
    begin
      writeln('Out of array');
    end
  else if labthanswer[i, j] = 1 then
    begin
      writeln('Not clear place');
    end
  else
    begin
      // поиск выхода
      waymap[i, j] := 1;
      step := 0;
      masend := false;
      existend := false;
      number := 1;
      repeat
        number := number + 1;
        for k := 1 to n do
          begin
            for m := 1 to n do
              begin
                if waymap[k, m] = (number - 1) then
                  begin
                    if (k < n) and (waymap[k + 1, m] = 0) and
                      (labthanswer[k + 1, m] = 0) then
                      begin
                        waymap[k + 1, m] := number;
                      end;

                    if (k > 1) and (waymap[k - 1, m] = 0) and
                      (labthanswer[k - 1, m] = 0) then
                      begin
                        waymap[k - 1, m] := number;
                      end;

                    if (m < n) and (waymap[k, m + 1] = 0) and
                      (labthanswer[k, m + 1] = 0) then
                      begin
                        waymap[k, m + 1] := number;
                      end;

                    if (m > 1) and (waymap[k, m - 1] = 0) and
                      (labthanswer[k, m - 1] = 0) then
                      begin
                        waymap[k, m - 1] := number;
                      end;

                    if (((k = 1) or (k = n) or (m = 1) or (m = n)) and
                      (waymap[k, m] > 0) and (masend = false)) then
                      begin
                        masend := true;
                        existend := true;
                        labthanswer[k, m] := (-3);
                      end;
                  end;
              end;
          end;

        if (masend = false) and (number > 100000) then
          begin
            masend := true;
          end;
      until masend = true;

      if existend = true then
        begin

          // вывод карты пути волны
          {writeln('Waymap:');
          for k := 1 to n do
            begin
              for m := 1 to n do
                begin
                  write(waymap[k, m]:3);
                end;
              writeln;
            end;}

          // отрисовка путя
          number := number - 2;
          step := number;
          while number >= 1 do               //   Цикл  G
            begin
              for k := n downto 1 do         //   Цикл  H
                begin
                  for m := n downto 1 do     //   Цикл  I
                    begin
                      if (number >= 1) and (waymap[k, m] = number) and
                        ((labthanswer[k + 1, m] = (-3)) or
                        (labthanswer[k - 1, m] = (-3)) or
                        (labthanswer[k, m + 1] = (-3)) or
                        (labthanswer[k, m - 1] = (-3))) then
                        begin
                          labthanswer[k, m] := (-3);
                          number := number - 1;
                        end;

                    end;
                end;
            end;

          // вывод лабиринта с путем
          writeln('Way to find the exit:');
          for k := 1 to n do                 //   Цикл  K
            begin
              for m := 1 to n do             //   Цикл  M
                begin
                  write(labthanswer[k, m]:3);
                end;
              writeln;
            end;

          writeln('Steps:');
          writeln(step);
        end
      else
        begin
          writeln('No exit');
        end;
    end;

  writeln('Программа завершена. Нажмите ENTER.');
  readln;

end.
