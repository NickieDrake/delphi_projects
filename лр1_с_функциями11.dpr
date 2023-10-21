program лр1_с_функциями11;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  a, b, h, x: real;

//функция :проверка ЕОО
function isValid(x: real): boolean;
begin
  if (abs(x) < 0.00000001) then
  begin
    isValid := false;
  end
  else if (x < 0) and ((abs((exp(2 * (ln(-x)))) - 1) < 0.00000001) or
    (1 - exp(5 * (ln(-x))) < -0.00000001)) then
  begin
    isValid := false;
  end
  else if (x > 0) and ((abs((exp(2 * (ln(x)))) - 1) < 0.00000001) or
    (1 + exp(5 * (ln(x))) < 0.00000001)) then
  begin
    isValid := false;
  end
  else
  begin
    isValid := true;
  end;
end;

//функция :расчет значения
function calcY(x: real): real;
begin
  if x > 0 then
  begin
    calcY := abs((exp(5 * ln(x))) - ((cos(2 * x)) / (exp(2 * ln(x)) - 1)) -
      (ln(1 + (exp(5 * ln(x))))) + (4 / x))
  end
  else
  begin
    calcY := abs((exp(5 * ln(-x))) - ((cos(2 * x)) / (exp(2 * ln(-x)) - 1)) -
      (ln(1 - (exp(5 * ln(-x))))) + (4 / x))
  end;
end;

//функция: вывод значения в соотвествии с проверкой ЕОО
function fullCalcY(x: real): real;
begin
  if isValid(x) then
    writeln('x = ', x:10:5, ' y = ', calcY(x):10:5)
  else
    writeln('x = ', x:10:5, ' нет значения');
end;

begin

  writeln('Введите a:');
  readln(a);
  writeln('Введите b:');
  readln(b);
  writeln('Введите h:');
  readln(h);

  fullCalcY(a); //расчет а
  if NOT(((a > b) and (h > 0)) or ((a < b) and (h < 0)) or ((a <> b) and (h = 0)
    ) or (a = b)) then
  begin
    x := a + h;
    if (h > 0) then
    begin
      while x <= b - 0.00000001 do      //Цикл А
      begin
        fullCalcY(x);
        x := x + h;
      end;
    end
    else
    begin
      while x >= b + 0.00000001 do      //Цикл В
      begin
        fullCalcY(x);
        x := x + h;
      end;
    end;
  end;

  if (a<>b) then  //расчет b
  fullCalcY(b);

  writeln('Конец программы. Нажмите ENTER');
  readln;

end.
