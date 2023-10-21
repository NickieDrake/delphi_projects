program лр5_4;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

const p = 2000;

type tmas = array[1..p] of integer;

var
  mas, mas1, mas2: tmas;
  i, pere2, srav2, pere1, srav1, k : integer;
  h: real;

  procedure shell(h: real; k: integer; var m: tmas; var pere1, srav1: integer);
  var i, bok, hh, c: integer;
   begin
    pere1:= 0;
    srav1:=0;
    while h >= 1 do
       begin
         hh:= round(h);
         i := hh+1;
         while i <= k do
            begin
               bok := i;
               c:= mas1[i];
               pere1:= pere1 + 1;
               while (((i - hh) > 0) and (c < m[i-hh])) do
                  begin
                     m[i] := m[i-hh];
                     pere1:= pere1 + 1;
                     srav1:= srav1 + 1;
                     i := i - hh;
                  end;
               m[i] := c;
               pere1:= pere1 + 1;
               if ((i - hh) > 0) then
               begin
                 srav1:= srav1 + 1;
               end;
               i := bok + 1;
            end;
         h:= (h - 1)/3;
       end;
   end;

  procedure print(srav1, pere1, srav2, pere2: integer);
  begin
    writeln('|', srav1:12, '|', pere1:12,'|', srav2:12,'|', pere2:12, '|' );
    writeln('|________________|____________|____________|____________|____________|');
  end;

  procedure revers(k:integer; var m:tmas);
  var i, c: integer;
  begin
    for i:=1 to (k div 2) do
    begin
      c:= m[i];
      m[i]:= m[k-i+1];
      m[k-i+1]:= c;
    end;
  end;

  procedure cocktail(k: integer; var m: tmas; var pere2, srav2: integer);
    var l, r, i, c: integer;
    begin
      l:= 2;
      r:= k;
      pere2:= 0;
      srav2:=0;
      repeat
         for i := r downto l do
           begin
             if m[i-1]> m[i] then
             begin
               c:= m[i-1];
               m[i-1] := m[i];
               m[i] := c;

               pere2:= pere2 + 3;
             end;
             srav2:= srav2 + 1;
           end;
         l:= l+1;
         for i := l to r do
           begin
             if m[i-1]> m[i] then
               begin
                 c:= m[i-1];
                 m[i-1] := m[i];
                 m[i] := c;

                 pere2:= pere2 + 3;
               end;
              srav2:= srav2 + 1;
           end;
         r:= r-1;
      until l>r ;
    end;



  procedure qsort(var ar: tmas; m, l: Integer);
    begin

    end;

begin

    writeln('|                |    Сортировка Шелла     |   Шейкерная сортировка  |');
    writeln('|      Тип       |    Число   |   Число    |   Число    |   Число    |');
    writeln('|    массива     | сравнений  |перестановок| сравнений  |перестановок|');
    writeln('|________________|____________|____________|____________|____________|');

    i:= 1;
    while i <= p do
    begin
      randomize;
      mas[i] := 300 - random(450);
      //writeln(mas[i]);
      i := i + 1;
    end;

    //неотсорт 10
   mas1:= mas;
   k:= 10;
   h:= 4;
   pere1:= 0;
   srav1:=0;
   shell(h, k, mas1, pere1, srav1);

   mas2:= mas;
   k:= 10;
   pere2:= 0;
   srav2:=0;
   cocktail(k, mas2, pere2, srav2);

   write('|10 эл неотсорт  ');
   print(srav1, pere1, srav2, pere2);

   // отсорт  10
   k:= 10;
   h:= 4;
   shell(h, k, mas1, pere1, srav1);

   k:= 10;
   cocktail(k, mas2, pere2, srav2);

   write('|10 эл отсорт    ');
   print(srav1, pere1, srav2, pere2);

   //реверс и сорт реверс 10
   k:= 10;
   revers(k, mas1);
   h:= 4;
   shell(h, k, mas1, pere1, srav1);

   k:= 10;
   revers(k, mas2);
   cocktail(k, mas2, pere2, srav2);

   write('|10 эл реверс    ');
   print(srav1, pere1, srav2, pere2);

    //  неотсорт 100
   mas1:= mas;
   k:= 100;
   h:= 40;
   shell(h, k, mas1, pere1, srav1);

   mas2:= mas;
   k:= 100;
   cocktail(k, mas2, pere2, srav2);

   write('|100 эл неотсорт ');
   print(srav1, pere1, srav2, pere2);

    // отсорт 100
   k:= 100;
   h:= 40;
   shell(h, k, mas1, pere1, srav1);

   k:= 100;
   cocktail(k, mas2, pere2, srav2);

   write('|100 эл отсорт   ');
   print(srav1, pere1, srav2, pere2);

   //реверс и сорт реверс 100
   k:= 100;
   revers(k, mas1);
   h:= 40;
   shell(h, k, mas1, pere1, srav1);

   k:= 100;
   revers(k, mas2);
   cocktail(k, mas2, pere2, srav2);

   write('|100 эл реверс   ');
   print(srav1, pere1, srav2, pere2);

   // неотсорт 2000
   mas1:= mas;
   k:= 2000;
   h:= 1093;
   shell(h, k, mas1, pere1, srav1);

   mas2:= mas;
   k:= 2000;
   cocktail(k, mas2, pere2, srav2);

   write('|2000 эл неотсорт');
   print(srav1, pere1, srav2, pere2);

    // отсорт 2000
   k:= 2000;
   h:= 1093;
   shell(h, k, mas1, pere1, srav1);

   k:= 2000;
   cocktail(k, mas2, pere2, srav2);

   write('|2000 эл отсорт  ');
   print(srav1, pere1, srav2, pere2);

   //реверс и сорт реверс 2000
   k:= 2000;
   revers(k, mas1);
   h:= 1093;
   shell(h, k, mas1, pere1, srav1);

   k:= 2000;
   revers(k, mas2);
   cocktail(k, mas2, pere2, srav2);

   write('|2000 эл реверс  ');
   print(srav1, pere1, srav2, pere2);

  writeln('Программа завершена. Нажмите ENTER');
  readln;

end.
