program ���_��1_6;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

var
  x, ch, chr, k, i, mul, mulok, xr, rem, n, rmul, ppmul, k2, mul2, mulok2, xr2,
    rmul2, ppmul2: integer;

begin
  writeln('������� ����� �����-����� �����, ������� ������ �����:');
  readln(n);
  ch := 3; // ����� ����� �����
  i := 0; // ������� ����� �����
  while (i < n) do // ���� A
    begin
      ch := ch + 1;

      xr2 := ch; // �������� ��� ������ ����� �������� ������ �����
      mulok2 := 0; // ����� ������� ����������
      mul2 := 2; // ������� ������� ����������
      k2 := 0;

      while (xr2 >= mul2) do // ���� B
        begin
          if ((xr2 mod mul2) = 0) then
            begin
              k2 := k2 + 1;
              xr2 := xr2 div mul2;
              rmul2 := 0;
              ppmul2 := mul2;
              while (ppmul2 > 0) do // ���� C
                begin
                  rmul2 := rmul2 + (ppmul2 mod 10);
                  ppmul2 := ppmul2 div 10;
                end;
              mulok2 := mulok2 + rmul2;
            end
          else
            begin
              mul2 := mul2 + 1;
            end;
        end;

      if NOT(k2 = 1) then // �������� �������� �� ����� � ������ �������
        begin                         //���������

          chr := ch;
          x := 0; // ����� ���� ����� ����� �����
          while (chr > 0) do // ���� D
            begin
              x := x + (chr mod 10);
              chr := chr div 10;
            end;
          if (x = mulok2) then
            begin
              xr := x;
              mulok := 0; // ����� ������� ����������
              mul := 2; // ������� ������� ����������
              k := 0;
              while (xr >= mul) do // ���� F
                begin
                  if ((xr mod mul) = 0) then
                    begin
                      k := k + 1;
                      xr := xr div mul;
                      rmul := 0;
                      ppmul := mul;
                      while (ppmul > 0) do // ���� G
                        begin
                          rmul := rmul + (ppmul mod 10);
                          ppmul := ppmul div 10;
                        end;
                      mulok := mulok + rmul;
                    end
                  else
                    begin
                      mul := mul + 1;
                    end;
                end;
              if NOT(k = 1) then // �������� �������� �� ����� � ������ �������
                begin // ���������
                  rem := 0;
                  while x > 0 do // ���� H
                    begin
                      rem := rem + (x mod 10);
                      x := x div 10;
                    end;
                  if rem = mulok then
                    i := i + 1;
                end;
            end;
        end;
    end;
  writeln('����� � ������ ��� �������: ', ch);
  readln;

end.
