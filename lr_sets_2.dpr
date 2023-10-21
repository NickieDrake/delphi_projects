program lr_sets_2;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, Windows;

type

  TSigns = array [0..11] of string;
  TColors = array [0..4] of string;
  TSignsSet = Set of 1..12;
  TColorSet = Set of 1..5;
  const

  Signs: TSigns = ('�����', '����', '�����', '�����', '�������', '����',
                   '������', '����', '��������', '������', '������', '������');
  Colors: TColors = ('���', '�����', '����', '���', '����');
  MaleSignsSet: TSignsSet = [1, 2, 3, 4, 9];
  HardColors: TColorSet = [1, 2, 3, 4];


  procedure InputYear(var year: integer; var exitflag: boolean);
  var yearword: string;
      flag: boolean;
  begin
    writeln('������� ��� (��������������� ���� ����� ��� �� ����� 2100-��) :');
    writeln('���� ������ ����� �� ���������, ������� ����� "�����".');
    flag:= true;
    readln(yearword);
   if yearword = '�����' then
      exitflag:= true
   else
    begin
    if not(TryStrToInt(yearword, year)) or (year < 1) or (year > 2100) then
       flag:= false;
    while flag = false do
      begin
        Writeln('�������� ����! ����������, ��������� ��� ���!');
        readln(yearword);
        if yearword = '�����' then
          exitflag:= true
        else
          begin
            if not(TryStrToInt(yearword, year)) or (year < 1) or (year > 2100) then
               flag:= false
            else
               flag:= true;
          end;
      end;
    end;
  end;

  procedure CheckWrongNumber(var year: integer);
  begin
    if year in [1, 2, 3] then
      year:= year + 60;
  end;

  procedure clr;
  var
    cursor: COORD;
    r: cardinal;
  begin
    r := 300;
    cursor.X := 0;
    cursor.Y := 0;
    FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * r, cursor, r);
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cursor);
  end;

  procedure GetYearName;
  var
      year: integer;
      SignNum, ColorNum: integer;
      ismale, exitflag: boolean;

begin
  exitflag:= false;
  InputYear(year, exitflag);
  while exitflag = false do
    begin
      CheckWrongNumber(year);
      SignNum:= (year-4) mod 12;
      ColorNum:= trunc((((year-4) mod 10))/2);
      write('��� ');
      if SignNum in MaleSignsSet then
       begin
          if ColorNum in HardColors then
             writeln(Colors[ColorNum],'��� ', Signs[SignNum])
         else
             writeln(Colors[ColorNum],'��� ', Signs[SignNum]);
       end
     else
       begin
         if ColorNum in HardColors then
             writeln(Colors[ColorNum],'�� ', Signs[SignNum])
         else
             writeln(Colors[ColorNum],'�� ', Signs[SignNum]);
       end;
     readln;
     clr;
     InputYear(year, exitflag);

    end;


end;

begin
  GetYearName;
  write('��� ������ ������� ENTER.');
  readln;
end.