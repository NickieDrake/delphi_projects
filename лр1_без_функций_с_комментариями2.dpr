program ��1_���_�������_�_�������������2;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  a, b, h, x, y: real;

begin
  writeln('������� a:');
  readln(a);
  writeln('������� b:');
  readln(b);
  writeln('������� h:');
  readln(h);

  // ������ �:
  x := a;
  // �������� ������� �����������
  if (abs(x) < 0.0001) then
    begin
      writeln('x= ', x:10:5, ' ��� ��������')
    end
  else if (x < 0) and (((exp(2 * (ln(-x))) - 1) = 0) or
    (1 - exp(5 * (ln(-x))) <= 0)) then
    begin
      writeln('x= ', x:10:5, ' ��� ��������')
    end
  else if (x > 0) and (((exp(2 * (ln(x))) - 1) = 0) or
    (1 + exp(5 * (ln(x))) <= 0)) then
    begin
      writeln('x= ', x:10:5, ' ��� ��������')
    end
  else
    begin
      // ������� �������� �������
      if x > 0 then
        begin
          y := abs((exp(5 * ln(x))) - ((cos(2 * x)) / (exp(2 * ln(x)) - 1)) -
            (ln(1 + (exp(5 * ln(x))))) + (4 / x))
        end
      else
        begin
          y := abs((exp(5 * ln(-x))) - ((cos(2 * x)) / (exp(2 * ln(-x)) - 1)) -
            (ln(1 - (exp(5 * ln(-x))))) + (4 / x))
        end;
      writeln('x= ', x:10:5, ' y= ', y:10:5);
    end;

  // �������� ���������� ��� ������������� ������
  if NOT(((a > b) and (h > 0)) or ((a < b) and (h < 0)) or ((a <> b) and (h = 0)
    ) or (a = b)) then
    begin
      x := x + h;
      if (h > 0) then
        begin
          while x <= b - 0.000001 do // ���� �
            begin
              if (abs(x) < 0.0001) then
                begin
                  writeln('x= ', x:10:5, ' ��� ��������')
                end
              else if (x < 0) and (((exp(2 * (ln(-x))) - 1) = 0) or
                (1 - exp(5 * (ln(-x))) <= 0)) then
                begin
                  writeln('x= ', x:10:5, ' ��� ��������')
                end
              else if (x > 0) and (((exp(2 * (ln(x))) - 1) = 0) or
                (1 + exp(5 * (ln(x))) <= 0)) then
                begin
                  writeln('x= ', x:10:5, ' ��� ��������')
                end
              else
                begin
                  if x > 0 then
                    begin
                      y := abs((exp(5 * ln(x))) -
                        ((cos(2 * x)) / (exp(2 * ln(x)) - 1)) -
                        (ln(1 + (exp(5 * ln(x))))) + (4 / x))
                    end
                  else
                    begin
                      y := abs((exp(5 * ln(-x))) -
                        ((cos(2 * x)) / (exp(2 * ln(-x)) - 1)) -
                        (ln(1 - (exp(5 * ln(-x))))) + (4 / x))
                    end;
                  writeln('x= ', x:10:5, ' y= ', y:10:5);
                end;
              x := x + h;
            end;
        end
      else
        begin
          while x >= b + 0.000001 do // ���� �
            begin
              if (abs(x) < 0.0001) then
                begin
                  writeln('x= ', x:10:5, ' ��� ��������')
                end
              else if (x < 0) and (((exp(2 * (ln(-x))) - 1) = 0) or
                (1 - exp(5 * (ln(-x))) <= 0)) then
                begin
                  writeln('x= ', x:10:5, ' ��� ��������')
                end
              else if (x > 0) and (((exp(2 * (ln(x))) - 1) = 0) or
                (1 + exp(5 * (ln(x))) <= 0)) then
                begin
                  writeln('x= ', x:10:5, ' ��� ��������')
                end
              else
                begin
                  if x > 0 then
                    begin
                      y := abs((exp(5 * ln(x))) -
                        ((cos(2 * x)) / (exp(2 * ln(x)) - 1)) -
                        (ln(1 + (exp(5 * ln(x))))) + (4 / x))
                    end
                  else
                    begin
                      y := abs((exp(5 * ln(-x))) -
                        ((cos(2 * x)) / (exp(2 * ln(-x)) - 1)) -
                        (ln(1 - (exp(5 * ln(-x))))) + (4 / x))
                    end;
                  writeln('x= ', x:10:5, ' y= ', y:10:5);
                end;
              x := x + h;
            end;
        end;
    end;

  // ������ b:
  x := b;
  if (abs(x) < 0.0001) then
    begin
      writeln('x= ', x:10:5, ' ��� ��������')
    end
  else if (x < 0) and (((exp(2 * (ln(-x))) - 1) = 0) or
    (1 - exp(5 * (ln(-x))) <= 0)) then
    begin
      writeln('x= ', x:10:5, ' ��� ��������')
    end
  else if (x > 0) and (((exp(2 * (ln(x))) - 1) = 0) or
    (1 + exp(5 * (ln(x))) <= 0)) then
    begin
      writeln('x= ', x:10:5, ' ��� ��������')
    end
  else
    begin
      if x > 0 then
        begin
          y := abs((exp(5 * ln(x))) - ((cos(2 * x)) / (exp(2 * ln(x)) - 1)) -
            (ln(1 + (exp(5 * ln(x))))) + (4 / x))
        end
      else
        begin
          y := abs((exp(5 * ln(-x))) - ((cos(2 * x)) / (exp(2 * ln(-x)) - 1)) -
            (ln(1 - (exp(5 * ln(-x))))) + (4 / x))
        end;
      writeln('x= ', x:10:5, ' y= ', y:10:5);
    end;

  writeln('����� ���������. ������� ENTER');
  readln;

end.
