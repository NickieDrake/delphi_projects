program ��3_���_1;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  a, b, x1, x2, y1, y2: real;

begin
  writeln('����� ����� ��������� ������� ����:');
  a := 0;
  b := 1;
  x1 := 0;
  y1 := 0;
  repeat // ���� �
    begin
      x1 := a - ((cos(a) - (a * a)) * (b - a) /
        ((cos(b) - (b * b)) - (cos(a) - (a * a))));
      a := b;
      b := x1;
    end;
  until (abs(a - b) <= 0.0001);
  writeln('��������� ������: ', x1:10:7);
  y1 := cos(x1) - (x1 * x1);
  writeln;

  writeln('����� ����� ��������� ������� ������� ������� �������:');
  a := 0;
  b := 1;
  x2 := 0;
  y2 := 0;
  repeat // ���� �
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
  writeln('��������� ������: ', x2:10:7);
  writeln;

  writeln('�������� �� ������ ����:', y1:15:10);
  writeln('�������� �� ������ ������� ������� �������:', y2:15:10);
  writeln;

  if abs(y1) < abs(y2) then
    writeln('����� ���� �������� ����� ������')
  else if abs(y1) > abs(y2) then
    writeln('����� ������� ������� ������� �������� ����� ������')
  else
    writeln('������ ����� �� ����� ��������');

  writeln('��������� ���������. ������� ENTER');
  readln;

end.
