program newton;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
    tmas = array [0..30] of integer;

var k, n, checkvalue: byte;
    checkn, checkk: string;
    coef: integer;
    coefmas: tmas;

function bincoef(const n, k: byte):integer;
begin
  if (n=0)or(n=1)or(k=0)or(k=n) then
    result:= 1
  else
    begin
      result:= bincoef((n-1),k)+bincoef((n-1),(k-1));
    end;

end;

procedure allcoefs( const n: byte; var mas: tmas);
var i: byte;
begin
   write('Биномиальные коэффициенты для n равного ', n, ':  ');
   for i := 0 to n do
     begin
       mas[i]:= bincoef(n, i);
       write(mas[i], ' ');
     end;
end;


//проверка ввода
 function numvalue( var num: string; var checkvalue: byte): integer;
var flag: boolean;
    ectnum, errorcode: integer;
begin
  ectnum:= 0;
  flag:= false;
  while flag = false do
     begin
       val(num, ectnum, errorcode);
       if (errorcode=0)and(ectnum<=checkvalue)and(ectnum>=0) then
          flag:= true
       else
         begin
          write('Неверный ввод, попытайтесь еще раз: ');
          readln(num);
         end;
     end;
  result:= ectnum;
end;







begin
  checkvalue:= 30;
  write('Введите степень разложения n от 0 до 30: ');
  readln(checkn);
  n:= numvalue(checkn, checkvalue);
  writeln;
  checkvalue:= n;
  if (n=0) then
    begin
       write('В данном случае существует единственный коэффициент разложения, равный 1 ');
    end
  else
    begin
       write('Введите номер элемента разложения от 0 до ',n, ': ');
       readln(checkk);
       k:= numvalue(checkk, checkvalue);
       writeln;
       coef:= bincoef(n, k);
       writeln('Ваш искомый биномиальный коэффициент равен ', coef);
       allcoefs(n, coefmas);
    end;


  readln;
end.
