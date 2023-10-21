program лр1_2_zdez_vse_peredelyvat_2;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

type
  elem = record
    number: 0 .. 200;
    str: string[15];
    check: boolean;
  end;

  tcompfunc = function(x1, x2: elem): boolean;
  tmas = array [1 .. 1000] of elem;

var
  mas: tmas;
  binsn, binss, blocksn, blockss, indexstr, i: integer;
  myelem: elem;
  flag1, flag2, flag3, flag4: boolean;

const
  el: integer = 1000;

  //  компараторы
function numbercomp(a, b: elem): boolean;
begin
  result := a.number < b.number;
end;

function strcomp(a, b: elem): boolean;
begin
  result := a.str < b.str;
end;


procedure swap(var a, b: elem); inline;
var
  c: elem;
begin
  c := a;
  a := b;
  b := c;
end;

// сортировка по передаваемому сравнению
procedure cocktail(const n: integer; var a: tmas; comparefunc: tcompfunc);
var
  l, r, i: integer;
begin
  l := 2;
  r := n;

  repeat
    for i := r downto l do
      if comparefunc(a[i], a[i-1]) then
        begin
          swap(a[i - 1], a[i]);
        end;
    l := l + 1;
    for i := l to r do
      if comparefunc(a[i], a[i-1]) then
        begin
          swap(a[i - 1], a[i]);
        end;
    r := r - 1;
  until l > r;
end;

// блочный
procedure blocksuch(var b: integer; var a: tmas; rec: elem; comparefunc: tcompfunc);
var
  h, i, n, st: integer;
  find: boolean;
begin
  st:= low(a);
  n:= high(a);
  repeat
    h:= trunc(sqrt(n-st+1));
    i:= st;

    while ((i) <= n) and (comparefunc(a[i],rec)) do
      begin
        a[i].check := true;
        i := i + h;
      end;
    if (i) <= n  then
        begin
          a[i].check := true;
        end;

      if i-h+1 > st then
         st:= i-h+1;

      if i>n then
        i:= n
      else
        n:= i;

      b:= i;
  until (h = 1) or (st>=n);

end;


// бинарный
procedure binsuch(var b: integer; var a: tmas; rec: elem; comparefunc: tcompfunc);
var
  i, r, l: integer;
begin
  r := high(a);
  l:= low(a);

  while l<r do
    begin
      i := trunc((r+l)/ 2);
      a[i].check := true;
      if comparefunc(a[i],rec) then
        begin
          l:= i+1;
        end
      else
        begin
          r := i;
        end;
    end;
  b:= l;
end;



procedure output(a: tmas);
var
  i: integer;
begin
  writeln('  Поле 1   Поле 2     Поле 3');
  for i := 1 to el do
    writeln('   ', a[i].number:3, '    ', a[i].str, '    ', a[i].check);
end;


procedure sbros(var a:tmas; var count: integer);
var i: integer;
begin
  for i := 1 to 1000 do
    begin
      if a[i].check = true then
        begin
           count:= count + 1;
           a[i].check := false;
        end;

    end;
end;


procedure allcheck(index: integer; var a: tmas; rec: elem);
var i: integer;
begin
  i := index - 1;
      while a[i].number = rec.number do
        begin
          a[i].check := true;
          writeln('   ', a[i].number:3, '    ', a[i].str, '    ',
            a[i].check);
          i := i - 1;
        end;
      i := index + 1;
      while a[i].number = rec.number do
        begin
          a[i].check := true;
          writeln('   ', a[i].number:3, '    ', a[i].str, '    ',
            a[i].check);
          i := i + 1;
        end;
  readln;
end;


procedure outputcount( count: integer);
begin
  writeln('_______________________________________________________');
  writeln('Количество записей с логическим значением true:', count);
  readln;
end;



begin
  // ввод массива записей
  randomize;
  for i := 1 to 1000 do
    begin
      mas[i].number := random(201);
      mas[i].str := 'my_test_' + Inttostr(i);
      mas[i].check := false;
    end;
  output(mas);
  readln;

  // работа с полем строк
  cocktail(el, mas, strcomp);
  output(mas);

  writeln('Введите строку вида ''my_test_'' + k, где k - число от 1 до 1000, которую вы хотите найти: ');
  readln(myelem.str);

  indexstr := 0;
  blockss := 0;
  blocksuch(indexstr, mas, myelem, strcomp);
  writeln('Блочный поиск:');
  if mas[indexstr].str = myelem.str then
     begin
       writeln('_______________________________________________________');
       writeln('   ', mas[indexstr].number:3, '    ', mas[indexstr].str, '    ',
        mas[indexstr].check);
     end
  else
     begin
       writeln('Введенной строки не существует в данном списке');
     end;
  readln;
  output(mas);
  sbros(mas, blockss);
  outputcount(blockss);

  indexstr := 0;
  binss := 0;
  binsuch(indexstr, mas, myelem, strcomp);
  writeln('Бинарный поиск:');
  if mas[indexstr].str = myelem.str then
     begin
       writeln('_______________________________________________________');
       writeln('   ', mas[indexstr].number:3, '    ', mas[indexstr].str, '    ',
        mas[indexstr].check);
     end
  else
     begin
       writeln('Введенной строки не существует в данном списке');
     end;
  readln;
  output(mas);
  sbros(mas, binss);
  outputcount(binss);

   // работа с полем чисел
  cocktail(el, mas, numbercomp);
  output(mas);
  readln;

  writeln('Введите число от 0 до 200, которое вы хотите найти: ');
  readln(myelem.number);

  indexstr := 0;
  blocksn := 0;
  blocksuch(indexstr, mas, myelem, numbercomp);
  writeln('Блочный поиск:');
  if mas[indexstr].number = myelem.number then
     begin
       writeln('_______________________________________________________');
       writeln('   ', mas[indexstr].number:3, '    ', mas[indexstr].str, '    ',
        mas[indexstr].check);
     end
  else
     begin
       writeln('Введенной строки не существует в данном списке');
     end;
  allcheck(indexstr, mas, myelem);
  output(mas);
  sbros(mas, blocksn);
  outputcount(blocksn);


  indexstr := 0;
  binsn := 0;
  binsuch(indexstr, mas, myelem, numbercomp);
  writeln('Бинарный поиск:');
  if mas[indexstr].number = myelem.number then
     begin
       writeln('_______________________________________________________');
       writeln('   ', mas[indexstr].number:3, '    ', mas[indexstr].str, '    ',
        mas[indexstr].check);
     end
  else
     begin
       writeln('Введенной строки не существует в данном списке');
     end;
  allcheck(indexstr, mas, myelem);
  output(mas);
  sbros(mas, binsn);
  outputcount(binsn);

 // финальный вывод
    writeln('          Блочный поиск      Бинарный поиск');
    writeln('Строка:        ', blockss, '                    ', binss);
    writeln;
    writeln('Число:        ', blocksn, '                    ', binsn);

  readln;
end.

