program ��4_4_����;

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
  // ���������� ������ �������� � �������� �
  writeln('������� ���������� ������ ������� � (�� 10):');
  readln(n);
  writeln('������� ���������� ������ ������� B (�� 10):');
  readln(m);
  writeln('������� ����� �:');
  readln(chM);
  // ���������� �������� �������� �������
  { writeln('����� ������� �:');
    isum := 1;
    while isum <= n do
    begin
    randomize;
    masA[isum] := 100 - random(180);
    writeln(masA[isum]);
    isum := isum + 1;
    end;

    writeln('����� ������� �:');
    isum := 1;
    while isum <= m do
    begin
    randomize;
    masB[isum] := 100 - random(180);
    writeln(masB[isum]);
    isum := isum + 1;
    end; }
  // ���������� �������� �������
  writeln('������� �������� ������� �:');
  isum := 1;
  while isum <= n do // ���� �
    begin
      readln(masA[isum]);
      isum := isum + 1;
    end;
  writeln('������� �������� ������� �:');
  isum := 1;
  while isum <= m do // ���� �
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

  // ������� ���� ��������� ��������� ������� ����� �������
  for i := 1 to kolvoi do // ���� �
    begin
      sum := 0;
      minm := 0;
      x := i;
      schk := 1;
      nn := round(s);
      // ���� ���������� ����
      while x > 0 do // ����  D
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
      // �������� ������� � ����� ������ ������������ �������
      if ((minm < chM) and (sum > sumpred)) then
        begin
          sumpred := sum;
          hh := i;
          sumhh:= sum;
          { writeln('������ ��������� - ������ ��������:');
            isum := 1;
            while isum < schk do // ����  E
            begin
            write(masK[isum], ' ');
            isum := isum + 1;
            end;
            writeln;
            writeln('����� ������ ������� �:');
            writeln(sum);
            writeln; }

        end;

    end;
  {if (minm < chM) then
    begin
      //sumpred := sum;
      writeln('������ ��������� - ������ ��������:');
      isum := 1;
      while isum < schk do // ����  E
        begin
          write(masK[isum], ' ');
          isum := isum + 1;
        end;
      writeln;
      writeln('����� ������ ������� �:');
      writeln(sum);
      writeln;

    end; }
    writeln('������ ��������� - ������ ��������:');
    nn := round(s);
    while hh > 0 do // ����  D
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
      writeln('����� ������ ������� �:');
      writeln(sumhh);
      writeln;


  if (sumpred = -100000000) then
    begin
      writeln('������� ����� ������ ������� � �� ��������� ������ �. ��������� ���������. ������� ENTER.');
    end
  else
    begin
      writeln('����������� ��������� ����� �������. ��������� ���������. ������� ENTER.');
    end;
  readln;

end.
