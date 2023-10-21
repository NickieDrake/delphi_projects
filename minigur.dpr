program minigur;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils;

type

  TIngrInfo = record // ���������� �� �������� ������ ������������
    ID: integer;
    Name: string[20];
    Quantity: integer;
    Proteins: integer; // ���������� �� 100 �����
    Fats: integer; // ���������� �� 100 �����
    Carbohs: integer; // ���������� �� 100 �����
    SubID: integer;
  end;

  PIngr = ^TIngr; // ������� ������ �����������

  TIngr = record
    Info: TIngrInfo;
    Next: PIngr;
  end;

  TPair = record
    ID: integer;
    Much: real;
  end;

  TIngrArray = array [1 .. 5] of TPair;

  TSalatInfo = record // ���������� �� �������� ������ �������
    ID: integer;
    Name: string[20];
    Content: TIngrArray;
  end;

  PSalat = ^TSalat; // ������� ������ �������

  TSalat = record
    Info: TSalatInfo;
    Next: PSalat;
  end;

  TOrderElementInfo = record // ���������� �� �������� ������
    SalatID: integer;
    Quantity: integer;
    Afford: boolean;
  end;

  POrder = ^TOrder; // ������� ������

  TOrder = record
    Info: TOrderElementInfo;
    Next: POrder;
  end;

  TIngrNames = array [1 .. 28] of string[20];
  TIngrCount = array [1 .. 28] of integer;
  TSalatNames = array [1 .. 10] of string[20];
  TSalatContent = array [1 .. 10, 1 .. 5] of integer;

  FileIngr = file of TIngrInfo;
  FileSalat = file of TSalatInfo;
  FileOrder = file of TOrderElementInfo;

  TComparatorIngr = function(x1: PIngr; x2: TIngrInfo): boolean;
  TComparatorSalat = function(x1: PSalat; x2: TSalatInfo): boolean;
  TComparatorOrder = function(x1: POrder; x2: TOrderElementInfo): boolean;

const
  IngrName: TIngrNames = ('�����', '�������', '�����', '������� ����',
    '�������', '������', '�������', '�������', '������', '�����', '���������',
    '��������� �����', '���������', '�������', '������', '������� ����',
    '�����', '������', '�������', '����', '�������', '��������', '�����',
    '��������', '�������', '����������', '������� �����', '�����');

  IngrPr: TIngrCount = (23, 2, 1, 19, 6, 1, 1, 3, 5, 1, 10, 0, 25, 2, 17, 14,
    13, 7, 1, 13, 12, 4, 3, 19, 23, 3, 0, 1);
  IngrFats: TIngrCount = (1, 0, 0, 20, 0, 0, 0, 10, 12, 0, 0, 100, 27, 23, 0,
    12, 16, 10, 0, 12, 50, 0, 0, 12, 21, 1, 100, 0);
  IngrCrb: TIngrCount = (0, 2, 11, 2, 3, 3, 4, 2, 2, 6, 0, 0, 0, 7, 6, 0, 0, 35,
    7, 1, 0, 8, 10, 0, 0, 2, 0, 7);

  SalatName: TSalatNames = ('������������', '���������', '�����������',
    '������', '�������', '������', '�������', '����', '�����', '� ������');

  SalatIngrIDs: TSalatContent = ((6, 7, 10, 11, 12), (2, 6, 7, 8, 13),
    (5, 7, 14, 17, 27), (2, 6, 7, 22, 27), (4, 5, 7, 12, 26), (2, 4, 7, 18, 20),
    (3, 10, 11, 19, 25), (1, 15, 25, 26, 28), (3, 9, 14, 24, 26),
    (6, 10, 16, 18, 20));

  SalatIngrMuch: TSalatContent = ((50, 55, 50, 32, 50), (106, 30, 20, 34, 60),
    (30, 30, 70, 10, 10), (44, 20, 51, 20, 43), (15, 60, 37, 8, 70),
    (20, 45, 21, 44, 10), (66, 78, 20, 25, 20), (40, 40, 40, 40, 40),
    (56, 67, 28, 61, 14), (25, 15, 53, 10, 45));

  // ����������� �� Ingr
function IngrNameComp(el: PIngr; such: TIngrInfo): boolean;
begin
  result := (el^.Info.Name = such.Name);
end;

function IngrIDComp(el: PIngr; such: TIngrInfo): boolean;
begin
  result := (el^.Info.ID = such.ID);
end;

function IngrProteinsComp(el: PIngr; such: TIngrInfo): boolean;
begin
  result := (el^.Info.Proteins = such.Proteins);
end;

function IngrFatsComp(el: PIngr; such: TIngrInfo): boolean;
begin
  result := (el^.Info.Fats = such.Fats);
end;

function IngrCarbohsComp(el: PIngr; such: TIngrInfo): boolean;
begin
  result := (el^.Info.Carbohs = such.Carbohs);
end;

// ����������� �� Salat
function SalatNameComp(el: PSalat; such: TSalatInfo): boolean;
begin
  result := (el^.Info.Name = such.Name);
end;

function SalatIDComp(el: PSalat; such: TSalatInfo): boolean;
begin
  result := (el^.Info.ID = such.ID);
end;

// ����������� �� Order
function OrderElemIDComp(el: POrder; such: TOrderElementInfo): boolean;
begin
  result := (el^.Info.SalatID = such.SalatID);
end;

function OrderElemAffordComp(el: POrder; such: TOrderElementInfo): boolean;
begin
  result := (el^.Info.Afford = such.Afford);
end;

// �������� ������
procedure FileMakingIngr(Header: PIngr; var IngrMainFile: FileIngr);
var
  Element: PIngr;
begin
  rewrite(IngrMainFile);
  Element := Header^.Next;
  while Element <> nil do
    begin
      write(IngrMainFile, Element^.Info);
      Element := Element^.Next;
    end;
  closefile(IngrMainFile);
end;

procedure FileMakingSalat(Header: PSalat; var SalatMainFile: FileSalat);
var
  Element: PSalat;
begin
  rewrite(SalatMainFile);
  Element := Header^.Next;
  while Element <> nil do
    begin
      write(SalatMainFile, Element^.Info);
      Element := Element^.Next;
    end;
  closefile(SalatMainFile);
end;

procedure FileMakingOrder(Header: POrder; var OrderMainFile: FileOrder);
var
  Element: POrder;
begin
  rewrite(OrderMainFile);
  Element := Header^.Next;
  while Element <> nil do
    begin
      write(OrderMainFile, Element^.Info);
      Element := Element^.Next;
    end;
  closefile(OrderMainFile);
end;

// ������
procedure ShowMainMenu;
begin
  writeln;
  writeln;
  writeln;
  writeln(' ---------------------------------------------------------------- ');
  writeln('|                      �������� �������                          |');
  writeln('|----------------------------------------------------------------|');
  writeln('|                1 -  ������ ������ �� ������                    |');
  writeln('|                2 -  �������� ������                            |');
  writeln('|                3 -  �������������                              |');
  writeln('|                4 -  �����                                      |');
  writeln('|                5 -  ��������                                   |');
  writeln('|                6 -  �������                                    |');
  writeln('|                7 -  �������������                              |');
  writeln('|                8 -  �������� ������                            |');
  writeln('|                9 -  �����                                      |');
  writeln('|                10 - ��������� � �����                          |');
  writeln(' ---------------------------------------------------------------  ');
end;

procedure FirstShow;
begin
  writeln(' ---------------------------------------------------------------------- ');
  writeln('|����� ������� ���������!                                              |');
  writeln('|����������� �����: ������ ������������, ������ �������, ������ ������.|');
  writeln(' ---------------------------------------------------------------------- ');
  ShowMainMenu;
end;

// �������� ������ ������
procedure OrderListCreating(var Header: POrder);
var
  SubElement, Element: POrder;
  i: integer;

begin
  randomize;
  new(Element);
  Header^.Next := Element;
  for i := 1 to 7 do
    begin
      Element^.Info.SalatID := i;
      Element^.Info.Quantity := random(5) + 1;
      Element^.Info.Afford := false;

      SubElement := Element;
      new(Element);
      SubElement^.Next := Element;
    end;
  SubElement^.Next := nil;
end;

// �������� ������ �������
procedure SalatListCreating(var Header: PSalat);
var
  SubElement, Element: PSalat;
  i, k, num: integer;
  ArrElems: TIngrArray;
begin
  new(Element);
  Header^.Next := Element;
  for i := 1 to 10 do
    begin
      Element^.Info.ID := i;
      Element^.Info.Name := SalatName[i];
      for k := 1 to 5 do
        begin
          ArrElems[k].ID := SalatIngrIDs[i, k];
          ArrElems[k].Much := SalatIngrMuch[i, k];
        end;
      Element^.Info.Content := ArrElems;

      SubElement := Element;
      new(Element);
      SubElement^.Next := Element;
    end;
  SubElement^.Next := nil;
end;

// �������� ������ ������������
procedure IngrListCreating(var Header: PIngr);
var
  SubElement, Element: PIngr;
  i: integer;
begin
  new(Element);
  Header^.Next := Element;
  for i := 1 to 28 do
    begin
      Element^.Info.ID := i;
      Element^.Info.Name := IngrName[i];
      Element^.Info.Quantity := 3000;
      Element^.Info.Proteins := IngrPr[i];
      Element^.Info.Fats := IngrFats[i];
      Element^.Info.Carbohs := IngrCrb[i];

      case i of
        4:
          Element^.Info.SubID := 25; // ������� ���� � �������
        5:
          Element^.Info.SubID := 15; // ������� � ������
        12:
          Element^.Info.SubID := 27; // ��������� � ������� �����
        15:
          Element^.Info.SubID := 5; //
        16:
          Element^.Info.SubID := 24; // ������� ���� � ��������
        17:
          Element^.Info.SubID := 21; // ����� � �������
        19:
          Element^.Info.SubID := 28; // ������� � �����
        21:
          Element^.Info.SubID := 17; //
        22:
          Element^.Info.SubID := 23; // �������� � �����
        23:
          Element^.Info.SubID := 22; //
        24:
          Element^.Info.SubID := 16; //
        25:
          Element^.Info.SubID := 4; //
        27:
          Element^.Info.SubID := 12; //
        28:
          Element^.Info.SubID := 19; //
      else
        Element^.Info.SubID := 0; //
      end;

      SubElement := Element;
      new(Element);
      SubElement^.Next := Element;
    end;
  SubElement^.Next := nil;

end;

procedure Creating(var IngrHeader: PIngr; var SalatHeader: PSalat;
  var OrderHeader: POrder);
begin
  IngrListCreating(IngrHeader);
  SalatListCreating(SalatHeader);
  OrderListCreating(OrderHeader);
end;

// �� ��� ���
function AskForSureness: boolean;
var
  askflag: boolean;
  askword: string;
  ask: integer;
begin
  writeln('�� ������� � ����� ������?');
  writeln('1 - ��, ����������');
  writeln('2 - ���, ���������');
  while (ask <> 1) and (ask <> 2) do
    begin
      readln(askword);
      askflag := TryStrToInt(askword, ask);
      if askflag = false then
        ask := 0;
      case ask of
        1:
          result := true;
        2:
          result := false;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;
    end;
end;

// ������ �������
procedure OrderOutput(Header: POrder);
var
  Element: POrder;
  wordaff: string[15];
begin
  writeln(' _________________________________________');
  writeln('| ��� ������ | ���������� |   ���������   |');

  Element := Header^.Next;
  while Element <> nil do
    begin
      if Element^.Info.Afford = false then
        wordaff := '��� � �������'
      else
        wordaff := '  ��� �����  ';
      writeln('|------------|------------|---------------|');
      writeln('|   ', Element^.Info.SalatID:4, '     | ', Element^.Info.Quantity
        :6, '     | ', wordaff:13, ' |');
      Element := Element^.Next;
    end;
  writeln('|____________|____________|_______________|');
end;

// ����� ������ �������
procedure SalatOutput(Header: PSalat);
var
  Element: PSalat;
  j: integer;
begin
  writeln('____________________________________________________');
  writeln('| ID |      ��������      |   ����������� ������:   |');
  writeln('|    |                    |   ID  -->  ����������   |');
  Element := Header^.Next;
  while Element <> nil do
    begin

      writeln('|----|--------------------|-------------------------|');
      writeln('|', Element^.Info.ID:4, '|', Element^.Info.Name:16,
        '    |       �����������       |');
      for j := 1 to 5 do
        begin
          writeln('|    |                    | ', Element^.Info.Content[j].ID:4,
            '  -->   ', Element^.Info.Content[j].Much:4:0, '�       |');

        end;
      Element := Element^.Next;
    end;
  writeln('|____|____________________|_________________________|');
end;

// ����� ������ ������������
procedure IngrOutput(Header: PIngr);
var
  Element: PIngr;
begin
  writeln('____________________________________________________________________________________');
  writeln('| ID |      ��������      | ���������� |  �����   |   ����   | �������� | ID ������ |');

  Element := Header^.Next;
  while Element <> nil do
    begin
      writeln('|----|--------------------|------------|----------|----------|----------|-----------|');
      write('|', Element^.Info.ID:4, '|', Element^.Info.Name:16, '    |   ',
        Element^.Info.Quantity:5, '    |', Element^.Info.Proteins:6, '    |',
        Element^.Info.Fats:6, '    |', Element^.Info.Carbohs:6, '    |');
      if Element^.Info.SubID = 0 then
        writeln('    ���    |')
      else
        writeln(Element^.Info.SubID:6, '     |');

      Element := Element^.Next;
    end;
  writeln('|____|____________________|____________|__________|__________|__________|___________|');
end;

procedure OutputTables(IngrHead: PIngr; SalatHead: PSalat; OrderHead: POrder);
begin
  writeln('������ ������������');
  IngrOutput(IngrHead);
  writeln;
  writeln('������ �������');
  SalatOutput(SalatHead);
  writeln;
  writeln('������ ������');
  OrderOutput(OrderHead);
end;

procedure ShowAskForOutput;
begin
  writeln;
  writeln;
  writeln;
  writeln('����� ������ �� ������ �����������?');
  writeln('1 - ������ ������������');
  writeln('2 - ������ �������');
  writeln('3 - ������ ������');
  writeln('4 - ��� ���������������� ������');
  writeln('5 - ����� �� �������');
end;

// ������� ���������
procedure AskForOutput(IngrHead: PIngr; SalatHead: PSalat; OrderHead: POrder);
var
  num: integer;
  numword: string;
  numflag: boolean;
begin
  ShowAskForOutput;
  while (num <> 5) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of
        1:
          begin
            writeln('������ ������������');
            IngrOutput(IngrHead);

            ShowAskForOutput;
          end;
        2:
          begin
            writeln('������ �������');
            SalatOutput(SalatHead);

            ShowAskForOutput;
          end;
        3:
          begin
            writeln('������ ������');
            OrderOutput(OrderHead);

            ShowAskForOutput;
          end;
        4:
          begin
            OutputTables(IngrHead, SalatHead, OrderHead);

            ShowAskForOutput;
          end;
        5:
          begin
            if AskForSureness = false then
              begin
                num := 0;

                ShowAskForOutput;
              end
            else
              begin

                ShowMainMenu;
              end;
          end
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;
    end;
end;

// ������ �� ������ �� �����������
procedure FromIngrFileReading(var IngrMainHead: PIngr;
  var IngrMainFile: FileIngr; var MaxIngr: integer);
var
  Element, SubElement: PIngr;
begin
  reset(IngrMainFile);
  new(Element);
  IngrMainHead^.Next := Element;
  while not(EoF(IngrMainFile)) do
    begin
      read(IngrMainFile, Element^.Info);
      SubElement := Element;
      new(Element);
      SubElement^.Next := Element;
      Inc(MaxIngr);
    end;
  SubElement^.Next := nil;
end;

procedure FromSalatFileReading(var SalatMainHead: PSalat;
  var SalatMainFile: FileSalat; var MaxSalat: integer);
var
  Element, SubElement: PSalat;
begin
  reset(SalatMainFile);
  new(Element);
  SalatMainHead^.Next := Element;
  while not(EoF(SalatMainFile)) do
    begin
      read(SalatMainFile, Element^.Info);
      SubElement := Element;
      new(Element);
      SubElement^.Next := Element;
      Inc(MaxSalat);
    end;
  SubElement^.Next := nil;
end;

procedure FromOrderFileReading(var OrderMainHead: POrder;
  var OrderMainFile: FileOrder; var MaxOrder: integer);
var
  Element, SubElement: POrder;
begin
  reset(OrderMainFile);
  new(Element);
  OrderMainHead^.Next := Element;
  while not(EoF(OrderMainFile)) do
    begin
      read(OrderMainFile, Element^.Info);
      SubElement := Element;
      new(Element);
      SubElement^.Next := Element;
      Inc(MaxOrder);
    end;
  SubElement^.Next := nil;
end;




// ������� ������ �������

procedure DisposeIngr(var IngrMainHead: PIngr);
var
  ElemIngr, SubElemIngr: PIngr;
begin
  ElemIngr := IngrMainHead^.Next;
  while ElemIngr <> nil do
    begin
      SubElemIngr := ElemIngr;
      ElemIngr := ElemIngr^.Next;
      Dispose(SubElemIngr);
    end;
  IngrMainHead^.Next := nil;
end;

procedure DisposeSalat(var SalatMainHead: PSalat);
var
  ElemSalat, SubElemSalat: PSalat;
begin
  ElemSalat := SalatMainHead^.Next;
  while ElemSalat <> nil do
    begin
      SubElemSalat := ElemSalat;
      ElemSalat := ElemSalat^.Next;
      Dispose(SubElemSalat);
    end;
  SalatMainHead^.Next := nil;
end;

procedure DisposeOrder(var OrderMainHead: POrder);
var
  ElemOrder, SubElemOrder: POrder;
begin
  ElemOrder := OrderMainHead^.Next;
  while ElemOrder <> nil do
    begin
      SubElemOrder := ElemOrder;
      ElemOrder := ElemOrder^.Next;
      Dispose(SubElemOrder);
    end;
  OrderMainHead^.Next := nil;
end;

procedure DisposeLists(var IngrMainHead: PIngr; var SalatMainHead: PSalat;
  var OrderMainHead: POrder);
var
  ElemIngr, SubElemIngr: PIngr;
  ElemSalat, SubElemSalat: PSalat;
  ElemOrder, SubElemOrder: POrder;
begin
  DisposeIngr(IngrMainHead);
  DisposeSalat(SalatMainHead);
  DisposeOrder(OrderMainHead);
end;

// ������� ������ ��� ����������
procedure AskForExit(var key: integer; var IngrMainHead: PIngr;
  var SalatMainHead: PSalat; var OrderMainHead: POrder);
begin
  writeln('�����������: �� ��� �� ��������� ��������� ���������!');
  writeln('����� ������, �� ��������� ��� ���������.');
  if AskForSureness = false then
    begin
      key := 0;

      ShowMainMenu;
    end
  else
    begin
      DisposeLists(IngrMainHead, SalatMainHead, OrderMainHead);
      writeln;
      writeln;
      writeln;
      writeln('������� �� ��� �����! ��� ������ ������� ENTER.');
    end;
end;

// ������� ������ � �����������
procedure AskForExitWithSave(var key: integer; var IngrMainHead: PIngr;
  var IngrMainFile: FileIngr; var SalatMainHead: PSalat;
  var SalatMainFile: FileSalat; var OrderMainHead: POrder;
  var OrderMainFile: FileOrder);
begin
  writeln('��������� ��������� � �����.');
  if AskForSureness = false then
    begin
      key := 0;
      ShowMainMenu;
    end
  else
    begin
      key := 9;
      FileMakingIngr(IngrMainHead, IngrMainFile);
      FileMakingSalat(SalatMainHead, SalatMainFile);
      FileMakingOrder(OrderMainHead, OrderMainFile);

      DisposeLists(IngrMainHead, SalatMainHead, OrderMainHead);
      writeln;
      writeln;
      writeln;
      writeln('������� �� ��� �����! ��� ������ ������� ENTER.');
    end;
end;

// ������� ������ �� ������
procedure AskForReadFiles(var IngrMainHead: PIngr; var IngrMainFile: FileIngr;
  var SalatMainHead: PSalat; var SalatMainFile: FileSalat;
  var OrderMainHead: POrder; var OrderMainFile: FileOrder;
  MaxIngr, MaxSalat, MaxOrder: integer);
begin
  writeln('�����������: �� ��� �� ��������� ��������� ���������!');
  writeln('��������� ������ �� ����� ������ ������, ������������ � ���������, ��������� ���.');
  if AskForSureness = false then
    begin
      ShowMainMenu;
    end
  else
    begin
      DisposeLists(IngrMainHead, SalatMainHead, OrderMainHead);
      try
        FromIngrFileReading(IngrMainHead, IngrMainFile, MaxIngr);
        FromSalatFileReading(SalatMainHead, SalatMainFile, MaxSalat);
        FromOrderFileReading(OrderMainHead, OrderMainFile, MaxOrder);
      except
        writeln('������ �������� ������!');
      end;

      FirstShow;
    end;
end;

procedure OrderLengthCheck(OrderHead: POrder; var ordlenflag: boolean);
var
  Element: POrder;
begin
  Element := OrderHead^.Next;
  if Element = nil then
    ordlenflag := false
  else
    ordlenflag := true;
end;

procedure SalatLengthCheck(SalatHead: PSalat; var sallenflag: boolean);
var
  Element: PSalat;
begin
  Element := SalatHead^.Next;
  if Element = nil then
    sallenflag := false
  else
    sallenflag := true;
end;

procedure IngrLengthCheck(IngrHead: PIngr; var ingrlenflag: boolean);
var
  Element: PIngr;
begin
  Element := IngrHead^.Next;
  if Element = nil then
    ingrlenflag := false
  else
    ingrlenflag := true;
end;

procedure ShowAskForMCheck(var OrderHead: POrder);
begin
  writeln;
  writeln;
  writeln;
  writeln('��� �����:');
  OrderOutput(OrderHead);
  writeln;
  writeln;
  writeln;
  writeln('�������:');
  writeln('1 - ���������� �������� ������������� ������������');
  writeln('2 - ���������� ���������� ������/�����/��������� �����');
  writeln('    ���������� ��������� ������ (������������ ������');
  writeln('    ����� �������� ��� ������� ���������� ���������)');
  writeln('3 - ����� ��������� ������ �� ����������� (������������ ������');
  writeln('    ����� �������� ��� ������� ���������� ���������)');
  writeln('4 - ����� �� �������');
end;

// �����
procedure ShowAskForFunction;
begin
  writeln;
  writeln;
  writeln;
  writeln('� ����� ������� �� ������ ��������?');
  writeln('1 - ������ ������������');
  writeln('2 - ������ �������');
  writeln('3 - ������ ������');
  writeln('4 - ����� �� �������');
end;

procedure ShowAskForIngrSearch;
begin
  writeln;
  writeln;
  writeln;
  writeln('�� ������ ���� �� ������ ����������� �����?');
  writeln('1 - �������� �����������');
  writeln('2 - ������ ����������� - ID');
  writeln('3 - ������������ ������ �� 100�');
  writeln('4 - ������������ ����� �� 100�');
  writeln('5 - ������������ ��������� �� 100�');
  writeln('6 - ��������� � ������ ������');
end;

procedure ShowAskForEditFirst;
begin
  writeln;
  writeln;
  writeln;
  writeln('��������� ��������:');
  writeln('1 - ����� �� ��������   --->  ������ ����������� ������������� ���');
  writeln('                              ��������� ������ � ��������� ��������� - ');
  writeln('                              ������� �������� ��������, � ��������');
  writeln('                              ������ ���-�� ��������, ����� ������� ��� ������.');
  writeln('2 - ���� ������� �������� � ��� ��������������');
  writeln('3 - ��������� � ������ ������');
end;

procedure ShowAskForDeleteFirst;
begin
  writeln;
  writeln;
  writeln;
  writeln('��������� ��������:');
  writeln('1 - ����� �� ��������   --->  ������ ����������� ������������� ���');
  writeln('                              ��������� ������ � ��������� ��������� - ');
  writeln('                              ������� �������� ��������, �������');
  writeln('                              ������ �������, ����� ������� ��� ������.');
  writeln('2 - ���� ������� �������� � ��� ��������');
  writeln('3 - ��������� � ������ ������');
end;

procedure ShowAskForDelete;
begin
  writeln;
  writeln;
  writeln;
  writeln('��������� ��������:');
  writeln('1 - ����� �� ��������');
  writeln('2 - ���� ������� �������� � ��� ��������');
  writeln('3 - ��������� � ������ ������');
end;

procedure ShowAskForEdit;
begin
  writeln;
  writeln;
  writeln;
  writeln('��������� ��������:');
  writeln('1 - ����� �� ��������');
  writeln('2 - ���� ������� �������� � ��� ��������������');
  writeln('3 - ��������� � ������ ������');
end;

procedure ShowAskForOrderEdit;
begin
  writeln;
  writeln;
  writeln;
  writeln('��� �� ������ ��������������� �����?');
  writeln('1 - ������� ������� ������');
  writeln('2 - �������� ����� ������� ������');
  writeln('3 - ��������� � ������ ������');
end;

procedure ShowAskForSalatEdit;
begin
  writeln;
  writeln;
  writeln;
  writeln('����� ���� �� ������ ���������������?');
  writeln('1 - �������� ������');
  writeln('2 - ������ ������');
  writeln('3 - ��������� � ������ �������');
end;

procedure ShowAskForReceipElemEdit;
begin
  writeln;
  writeln;
  writeln;
  writeln('����� ������� ������ �� ������ ���������������?');
  writeln('1-5 - ������ ��������� ������� ������');
  writeln('6 - ��������� � ������ ���� ���������');
end;

procedure ShowAskForReceipChange;
begin
  writeln;
  writeln;
  writeln;
  writeln('����� ����� �������� ������ �� ������ ���������������?');
  writeln('1 - ID �����������');
  writeln('2 - ���������� ���������� � ������');
  writeln('3 - ��������� � ������ ��������');
end;

procedure ShowAskForIngrEdit;
begin
  writeln;
  writeln;
  writeln;
  writeln('����� ���� �� ������� ���������������?');
  writeln('1 - �������� �����������');
  writeln('2 - ���������� �����������');
  writeln('3 - ������������ ������ �� 100�');
  writeln('4 - ������������ ����� �� 100�');
  writeln('5 - ������������ ��������� �� 100�');
  writeln('6 - ������ ����������� �����������');
  writeln('7 - ��������� � ������ �������');
end;

procedure ShowAskForSalatSearch;
begin
  writeln;
  writeln;
  writeln;
  writeln('�� ������ ���� �� ������ ����������� �����?');
  writeln('1 - �������� ������');
  writeln('2 - ������ ������ - ID');
  writeln('3 - ��������� � ������ ������');
end;

procedure ShowAskForOrderSearch;
begin
  writeln;
  writeln;
  writeln;
  writeln('�� ������ ���� �� ������ ����������� �����?');
  writeln('1 - ������ ������ - ID');
  writeln('2 - �� ����������� �������������');
  writeln('3 - ��������� � ������ ������');
end;

procedure check(var ID: integer);
var
  idword: string;
begin
  readln(idword);
  while not(TryStrToInt(idword, ID)) or (ID < 0) do
    begin
      writeln('�������� ����! ����������, ���������� ��� ���!');
      readln(idword);
    end;
end;

procedure checkword(var newname: string);
var
  i: integer;
begin
  readln(newname);
  for i := 1 to Length(newname) do
    begin
      if newname[1] = ' ' then
        Delete(newname, 1, 1);
    end;
  while newname = '' do
    begin
      writeln('�� ����� ������ ������! ���������� ��� ���!');
      readln(newname);
      for i := 1 to Length(newname) do
        begin
          if newname[1] = ' ' then
            Delete(newname, 1, 1);
        end;
    end;
end;

procedure OrderSearching(OrderHead: POrder; var OrderFindHead: POrder);
var
  num, ID: integer;
  numword: string;
  numflag: boolean;
  CompFunc: TComparatorOrder;
  Element, FindElems, SubFindElems: POrder;
  such: TOrderElementInfo;
begin
  ShowAskForOrderSearch;
  Element := OrderHead^.Next;
  new(FindElems);
  OrderFindHead^.Next := FindElems;
  SubFindElems := OrderFindHead;
  while (num <> 3) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of
        1:
          begin
            writeln('����� �� ID');
            CompFunc := OrderElemIDComp;
            writeln('������� ID �������� �����������');
            check(ID);
            such.SalatID := ID;
          end;
        2:
          begin
            writeln('����� �� ����������� �������������');
            CompFunc := OrderElemAffordComp;
            writeln('�������, ����� �������� ������ �� ������ �����.');
            writeln('1 - ��� �����');
            writeln('0 - ��� � �������');
            check(ID);
            while (ID > 1) do
              begin
                writeln('�������� ����! ����������, ���������� ��� ���!');
                check(ID);
              end;
            if ID = 1 then
              such.Afford := true
            else
              such.Afford := false;
          end;
        3:
          begin
            if AskForSureness = false then
              begin
                num := 0;
                ShowAskForOrderSearch;
              end
            else
              begin
                ShowAskForFunction;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;

      case num of
        1, 2:
          begin
            while Element <> nil do
              begin
                if CompFunc(Element, such) = true then
                  begin
                    FindElems^.Info := Element^.Info;

                    SubFindElems := FindElems;
                    new(FindElems);
                    SubFindElems^.Next := FindElems;
                  end;
                Element := Element^.Next;
              end;
            SubFindElems^.Next := nil;

            if OrderFindHead^.Next = nil then
              begin
                writeln;
                writeln;
                writeln('��������� � �������� ���������� � ������ �� ����������!');
              end
            else
              OrderOutput(OrderFindHead);

            DisposeOrder(OrderFindHead);
            Element := OrderHead^.Next;
            new(FindElems);
            OrderFindHead^.Next := FindElems;
            SubFindElems := OrderFindHead;
            ShowAskForOrderSearch;
          end;
      end;
    end;
end;

procedure SalatSearching(SalatHead: PSalat; var SalatFindHead: PSalat);
var
  num, ID: integer;
  numword: string;
  numflag: boolean;
  CompFunc: TComparatorSalat;
  Element, FindElems, SubFindElems: PSalat;
  such: TSalatInfo;
begin
  ShowAskForSalatSearch;
  Element := SalatHead^.Next;
  new(FindElems);
  SalatFindHead^.Next := FindElems;
  SubFindElems := SalatFindHead;
  while (num <> 3) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of
        1:
          begin
            writeln('����� �� ��������');
            CompFunc := SalatNameComp;
            writeln('������� �������� �������� �����������');
            readln(such.Name);
          end;
        2:
          begin
            writeln('����� �� ID');
            CompFunc := SalatIDComp;
            writeln('������� ID �������� �����������');
            check(ID);
            such.ID := ID;
          end;
        3:
          begin
            if AskForSureness = false then
              begin
                num := 0;
                ShowAskForSalatSearch;
              end
            else
              begin
                ShowAskForFunction;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;

      case num of
        1, 2:
          begin
            while Element <> nil do
              begin
                if CompFunc(Element, such) = true then
                  begin
                    FindElems^.Info := Element^.Info;

                    SubFindElems := FindElems;
                    new(FindElems);
                    SubFindElems^.Next := FindElems;
                  end;
                Element := Element^.Next;
              end;
            SubFindElems^.Next := nil;

            if SalatFindHead^.Next = nil then
              begin
                writeln;
                writeln;
                writeln('��������� � �������� ���������� � ������ �� ����������!');
              end
            else
              SalatOutput(SalatFindHead);

            DisposeSalat(SalatFindHead);
            Element := SalatHead^.Next;
            new(FindElems);
            SalatFindHead^.Next := FindElems;
            SubFindElems := SalatFindHead;
            ShowAskForSalatSearch;
          end;
      end;
    end;
end;

procedure IngrSearching(IngrHead: PIngr; var IngrFindHead: PIngr);
var
  num, ID: integer;
  numword: string;
  numflag: boolean;
  CompFunc: TComparatorIngr;
  Element, FindElems, SubFindElems: PIngr;
  such: TIngrInfo;
begin
  ShowAskForIngrSearch;
  Element := IngrHead^.Next;
  new(FindElems);
  IngrFindHead^.Next := FindElems;
  SubFindElems := IngrFindHead;
  while (num <> 6) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of
        1:
          begin
            writeln('����� �� ��������');
            CompFunc := IngrNameComp;
            writeln('������� �������� �������� �����������');
            readln(such.Name);
          end;
        2:
          begin
            writeln('����� �� ID');
            CompFunc := IngrIDComp;
            writeln('������� ID �������� �����������');
            check(ID);
            such.ID := ID;
          end;
        3:
          begin
            writeln('����� �� ������');
            CompFunc := IngrProteinsComp;
            writeln('������� ���������� ������ �������� �����������');
            check(ID);
            such.Proteins := ID;
          end;
        4:
          begin
            writeln('����� �� �����');
            CompFunc := IngrFatsComp;
            writeln('������� ���������� ����� �������� �����������');
            check(ID);
            such.Fats := ID;
          end;
        5:
          begin
            writeln('����� �� ���������');
            CompFunc := IngrCarbohsComp;
            writeln('������� ���������� ��������� �������� �����������');
            check(ID);
            such.Carbohs := ID;
          end;
        6:
          begin
            if AskForSureness = false then
              begin
                num := 0;

                ShowAskForIngrSearch;
              end
            else
              begin

                ShowAskForFunction;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;

      case num of
        1, 2, 3, 4, 5:
          begin
            while Element <> nil do
              begin
                if CompFunc(Element, such) = true then
                  begin
                    FindElems^.Info := Element^.Info;

                    SubFindElems := FindElems;
                    new(FindElems);
                    SubFindElems^.Next := FindElems;
                  end;
                Element := Element^.Next;
              end;
            SubFindElems^.Next := nil;

            if IngrFindHead^.Next = nil then
              begin
                writeln;
                writeln;
                writeln('��������� � �������� ���������� � ������ �� ����������!');
              end
            else
              IngrOutput(IngrFindHead);

            DisposeIngr(IngrFindHead);
            Element := IngrHead^.Next;
            new(FindElems);
            IngrFindHead^.Next := FindElems;
            SubFindElems := IngrFindHead;
            ShowAskForIngrSearch;
          end;
      end;
    end;
end;

procedure OrderAdd(OrderHead: POrder; SalatHead: PSalat);
var
  FreshMan, Element: POrder;
  SubElement: PSalat;
  // newname, str: string;
  num, i: integer;
  flag, dopflag: boolean;
begin
  Element := OrderHead^.Next;
  new(FreshMan);
  writeln('ID ������: ');
  flag := false;
  while flag = false do
    begin
      check(num);
      // if num = 0 then
      dopflag := false;
      Element := OrderHead^.Next;
      while Element <> nil do
        begin
          if Element^.Info.SalatID = num then
            dopflag := true;
          Element := Element^.Next;
        end;
      if dopflag = true then
        begin
          writeln('������ ����� ��� ������������ � ������!');
          flag := true;
        end
      else
        begin
          SubElement := SalatHead^.Next;
          while (SubElement <> nil) and (flag = false) do
            begin
              if SubElement^.Info.ID = num then
                flag := true;
              SubElement := SubElement^.Next;
            end;
          if flag = false then
            writeln('������ ������ �� ����������! ����������, ���������� ��� ���!');
        end;
    end;
  if dopflag = false then
    begin
      FreshMan^.Info.SalatID := num;
      writeln('���������� �������: ');
      check(num);
      FreshMan^.Info.Quantity := num;

      FreshMan^.Info.Afford := false;

      // ...............................
      Element := OrderHead;

      while Element^.Next <> nil do
        begin
          Element := Element^.Next;
        end;
      Element^.Next := FreshMan;
      FreshMan^.Next := nil;
    end;
end;

procedure SalatAdd(SalatHead: PSalat; var MaxSalat: integer; IngrHead: PIngr);
var
  FreshMan, Element: PSalat;
  SubElement: PIngr;
  newname, str: string;
  num, i: integer;
  flag: boolean;
begin
  Element := SalatHead^.Next;
  MaxSalat := MaxSalat + 1;
  writeln('������� ������ ������ ������!');
  new(FreshMan);
  FreshMan^.Info.ID := MaxSalat;

  writeln('�������� ������ : ');
  checkword(newname);
  { readln(newname);
    for i := 1 to Length(newname) do
    begin
    if newname[1] = ' ' then
    Delete(newname, 1, 1);
    end;
    while newname = '' do
    begin
    writeln('�� ����� ������ ������! ���������� ��� ���!');
    readln(newname);
    for i := 1 to Length(newname) do
    begin
    if newname[1] = ' ' then
    Delete(newname, 1, 1);
    end;
    end; }
  FreshMan^.Info.Name := newname;

  for i := 1 to 5 do
    begin
      // SubElement:= IngrHead^.Next;
      writeln('ID ����������� ������: ');
      flag := false;
      while flag = false do
        begin
          check(num);
          // if num = 0 then
          // flag := true;
          SubElement := IngrHead^.Next;
          while (SubElement <> nil) and (flag = false) do
            begin
              if SubElement^.Info.ID = num then
                flag := true;
              SubElement := SubElement^.Next;
            end;
          if flag = false then
            writeln('������ ����������� �� ����������! ����������, ���������� ��� ���!');
        end;
      FreshMan^.Info.Content[i].ID := num;
      writeln('���������� �����������: ');
      check(num);
      FreshMan^.Info.Content[i].Much := num;
    end;

  // ...............................
  Element := SalatHead^.Next;

  while Element^.Next <> nil do
    begin
      Element := Element^.Next;
    end;
  Element^.Next := FreshMan;
  FreshMan^.Next := nil;
end;

procedure IngrAdd(IngrHead: PIngr; var MaxIngr: integer);
var
  FreshMan, Element: PIngr;
  newname, str: string;
  num, i: integer;
  flag: boolean;
begin
  Element := IngrHead^.Next;
  MaxIngr := MaxIngr + 1;
  writeln('������� ������ ������ �����������!');
  new(FreshMan);
  FreshMan^.Info.ID := MaxIngr;

  writeln('�������� �����������: ');

  checkword(newname);
  { readln(newname);
    for i := 1 to Length(newname) do
    begin
    if newname[1] = ' ' then
    Delete(newname, 1, 1);
    end;
    while newname = '' do
    begin
    writeln('�� ����� ������ ������! ���������� ��� ���!');
    readln(newname);
    for i := 1 to Length(newname) do
    begin
    if newname[1] = ' ' then
    Delete(newname, 1, 1);
    end;
    end; }
  FreshMan^.Info.Name := newname;

  writeln('���������� �����������: ');
  check(num);
  FreshMan^.Info.Quantity := num;
  writeln('���������� ������ �� 100 �����: ');
  check(num);
  FreshMan^.Info.Proteins := num;
  writeln('���������� ����� �� 100 �����: ');
  check(num);
  FreshMan^.Info.Fats := num;
  writeln('���������� ��������� �� 100 �����: ');
  check(num);
  FreshMan^.Info.Carbohs := num;

  writeln('ID �����������, ������� ����� �������� ������.');
  writeln('���� ������ �������� ��� ���������� ��� ������, ������� 0(����).');
  flag := false;

  while flag = false do
    begin

      check(num);
      if num = 0 then
        flag := true;
      Element := IngrHead^.Next;
      while (Element <> nil) and (flag = false) do
        begin
          if Element^.Info.ID = num then
            flag := true;
          Element := Element^.Next;
        end;
      if flag = false then
        writeln('������ ����������� �� ����������! ����������, ���������� ��� ���!');
    end;
  FreshMan^.Info.SubID := num;

  Element := IngrHead^.Next;

  while Element^.Next <> nil do
    begin
      Element := Element^.Next;
    end;
  Element^.Next := FreshMan;
  FreshMan^.Next := nil;
end;

procedure SalatReceipChange(var SalatElement: PSalat; IngrHead: PIngr;
  recepnum: integer);
var
  IngrElement, SubIngrElement: PIngr;
  num, newnum: integer;
  numword: string;
  numflag, flag: boolean;
begin
  ShowAskForReceipChange;
  while (num <> 3) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of
        1:
          begin
            flag := false;
            writeln('������� ID ����������� ������ �������� �������');
            while flag = false do
              begin

                check(newnum);
                SubIngrElement := IngrHead^.Next;
                while (SubIngrElement <> nil) and (flag = false) do
                  begin
                    if SubIngrElement^.Info.ID = newnum then
                      flag := true;
                    SubIngrElement := SubIngrElement^.Next;
                  end;
                if flag = false then
                  writeln('������ ����������� �� ����������! ����������, ���������� ��� ���!');
              end;
            SalatElement^.Info.Content[recepnum].ID := newnum;

            ShowAskForReceipChange;
          end;
        2:
          begin
            writeln('������� ���������� ����������� ������ �������� �������');
            check(newnum);
            SalatElement^.Info.Content[recepnum].Much := newnum;

            ShowAskForReceipChange;
          end;
        3:
          begin
            if AskForSureness = false then
              begin
                num := 0;

                ShowAskForReceipChange;
              end
            else
              begin

                ShowAskForReceipElemEdit;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;
    end;
end;

procedure SalatExstraSearch(SalatHead: PSalat; var SalatFindHead: PSalat);
var
  Element, SubElement, FindElems, SubFindElems: PSalat;
  suchname: string;
begin

  new(SalatFindHead);

  Element := SalatHead^.Next;
  new(FindElems);
  SalatFindHead^.Next := FindElems;
  SubFindElems := SalatFindHead;

  writeln('������� �������� ������!');
  readln(suchname);
  while Element <> nil do
    begin
      if (Element^.Info.Name = suchname) = true then
        begin
          FindElems^.Info := Element^.Info;

          SubFindElems := FindElems;
          new(FindElems);
          SubFindElems^.Next := FindElems;
        end;
      Element := Element^.Next;
    end;
  SubFindElems^.Next := nil;

  if SalatFindHead^.Next = nil then
    begin
      writeln;
      writeln;
      writeln('��������� � �������� ���������� � ������ �� ����������!');
    end
  else
    begin
      SalatOutput(SalatFindHead);
    end;

  DisposeSalat(SalatFindHead);

  new(FindElems);
  SalatFindHead^.Next := FindElems;
  SubFindElems := SalatFindHead;
end;

procedure SalatEditFunc(var SalatHead: PSalat; MaxSalat: integer;
  IngrHead: PIngr);
var
  Element, SubElement, FindElems, SubFindElems, SalatFindHead: PSalat;
  newname, str, suchname: string;
  num, i, rednum, newnum, recepnum: integer;
  numword, rednumword, recepword: string;
  numflag, rednumflag, recepflag: boolean;
  flag: boolean;
  IngrElement, SubIngrElement: PIngr;

begin
  // new(SalatFindHead);
  //
  // Element := SalatHead^.Next;
  // new(FindElems);
  // SalatFindHead^.Next := FindElems;
  // SubFindElems := SalatFindHead;
  ShowAskForEditFirst;
  while (num <> 3) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of
        1:
          begin
            SalatExstraSearch(SalatHead, SalatFindHead);
            Element := SalatHead^.Next;
            ShowAskForEdit;
          end;
        2:
          begin

            writeln('������� ID ������, ������� ������ ���������������');
            flag := false;

            while flag = false do
              begin

                check(newnum);
                SubElement := SalatHead^.Next;
                while (SubElement <> nil) and (flag = false) do
                  begin
                    if SubElement^.Info.ID = newnum then
                      flag := true;
                    SubElement := SubElement^.Next;
                  end;
                if flag = false then
                  writeln('������ ������ �� ����������! ����������, ���������� ��� ���!');
              end;
            Element := SalatHead^.Next;

            flag := false;
            while (Element <> nil) and (flag = false) do
              begin
                if Element^.Info.ID = newnum then
                  flag := true
                else
                  Element := Element^.Next;
              end;

            ShowAskForSalatEdit;
            while (rednum <> 3) do
              begin
                readln(rednumword);
                rednumflag := TryStrToInt(rednumword, rednum);
                if rednumflag = false then
                  rednum := 0;
                case rednum of
                  1:
                    begin
                      writeln('�������������� ��������');
                      writeln('������� ����� ��������');
                      checkword(newname);
                      Element^.Info.Name := newname;
                      ShowAskForSalatEdit;
                    end;
                  2:
                    begin
                      writeln('�������������� �������');
                      ShowAskForReceipElemEdit;
                      while (recepnum <> 6) do
                        begin
                          readln(recepword);
                          recepflag := TryStrToInt(recepword, recepnum);
                          if recepflag = false then
                            recepnum := 0;
                          case recepnum of
                            1 .. 5:
                              begin
                                SalatReceipChange(Element, IngrHead, recepnum);
                              end;
                            6:
                              begin
                                if AskForSureness = false then
                                  begin
                                    recepnum := 0;

                                    ShowAskForReceipElemEdit;
                                  end
                                else
                                  begin

                                    ShowAskForSalatEdit;
                                  end;
                              end;
                          else
                            writeln('�������� ����! ����������, ���������� ��� ���!');
                          end;
                        end;

                      // ShowAskForSalatEdit;
                    end;
                  3:
                    begin
                      if AskForSureness = false then
                        begin
                          rednum := 0;

                          ShowAskForSalatEdit;
                        end
                      else
                        begin

                          ShowAskForEdit;
                        end;
                    end;
                else
                  writeln('�������� ����! ����������, ���������� ��� ���!');
                end;
              end;
            // ShowAskForEdit;
          end;
        3:
          begin
            if AskForSureness = false then
              begin
                num := 0;

                ShowAskForEdit;
              end
            else
              begin

                ShowAskForFunction;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;
    end;
end;

procedure IngrExstraSearch(IngrHead: PIngr; var IngrFindHead: PIngr);
var
  Element, SubElement, FindElems, SubFindElems: PIngr;
  suchname: string;
begin
  new(IngrFindHead);
  Element := IngrHead^.Next;
  new(FindElems);
  IngrFindHead^.Next := FindElems;
  SubFindElems := IngrFindHead;

  writeln('������� �������� �����������!');
  readln(suchname);
  while Element <> nil do
    begin
      if (Element^.Info.Name = suchname) = true then
        begin
          FindElems^.Info := Element^.Info;

          SubFindElems := FindElems;
          new(FindElems);
          SubFindElems^.Next := FindElems;
        end;
      Element := Element^.Next;
    end;
  SubFindElems^.Next := nil;

  if IngrFindHead^.Next = nil then
    begin
      writeln;
      writeln;
      writeln('��������� � �������� ���������� � ������ �� ����������!');
    end
  else
    begin
      IngrOutput(IngrFindHead);
    end;

  DisposeIngr(IngrFindHead);

  new(FindElems);
  IngrFindHead^.Next := FindElems;
  SubFindElems := IngrFindHead;
end;

procedure IngrEditFunc(var IngrHead: PIngr; MaxIngr: integer);
var
  Element, SubElement, FindElems, SubFindElems, IngrFindHead: PIngr;
  newname, str, suchname: string;
  num, i, rednum, newnum: integer;
  numword, rednumword: string;
  numflag, rednumflag: boolean;
  flag: boolean;

begin
  // new(IngrFindHead);

  // Element := IngrHead^.Next;
  // new(FindElems);
  // IngrFindHead^.Next := FindElems;
  // SubFindElems := IngrFindHead;
  ShowAskForEditFirst;
  while (num <> 3) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of // ������� �������� �� ������ ������
        1:
          begin
            IngrExstraSearch(IngrHead, IngrFindHead);
            Element := IngrHead^.Next;
            ShowAskForEdit;
          end;
        2:
          begin

            writeln('������� ID �����������, ������� ������ ���������������');
            flag := false;

            while flag = false do
              begin

                check(newnum);
                SubElement := IngrHead^.Next;
                while (SubElement <> nil) and (flag = false) do
                  begin
                    if SubElement^.Info.ID = newnum then
                      flag := true;
                    SubElement := SubElement^.Next;
                  end;
                if flag = false then
                  writeln('������ ����������� �� ����������! ����������, ���������� ��� ���!');
              end;
            Element := IngrHead^.Next;

            flag := false;
            while (Element <> nil) and (flag = false) do
              begin
                if Element^.Info.ID = newnum then
                  flag := true
                else
                  Element := Element^.Next;
              end;

            ShowAskForIngrEdit;
            while (rednum <> 7) do
              begin
                readln(rednumword);
                rednumflag := TryStrToInt(rednumword, rednum);
                if rednumflag = false then
                  rednum := 0;
                case rednum of
                  1:
                    begin
                      writeln('�������������� ��������');
                      writeln('������� ����� ��������');
                      checkword(newname);
                      Element^.Info.Name := newname;
                      ShowAskForIngrEdit;
                    end;
                  2:
                    begin
                      writeln('�������������� ����������');
                      writeln('������� ����� ���������� �����������');
                      check(newnum);
                      Element^.Info.Quantity := newnum;
                      ShowAskForIngrEdit;
                    end;
                  3:
                    begin
                      writeln('�������������� ������');
                      writeln('������� ����� ���������� ������');
                      check(newnum);
                      Element^.Info.Proteins := newnum;
                      ShowAskForIngrEdit;
                    end;
                  4:
                    begin
                      writeln('�������������� �����');
                      writeln('������� ����� ���������� �����');
                      check(newnum);
                      Element^.Info.Fats := newnum;
                      ShowAskForIngrEdit;
                    end;
                  5:
                    begin
                      writeln('�������������� ���������');
                      writeln('������� ����� ���������� ���������');
                      check(newnum);
                      Element^.Info.Carbohs := newnum;
                      ShowAskForIngrEdit;
                    end;
                  6:
                    begin
                      writeln('�������������� ID ������');
                      writeln('���� ������ �������� ��� ���������� ��� ������, ������� 0(����).');
                      flag := false;

                      while flag = false do
                        begin

                          check(newnum);
                          if newnum = 0 then
                            flag := true;
                          SubElement := IngrHead^.Next;
                          while (SubElement <> nil) and (flag = false) do
                            begin
                              if SubElement^.Info.ID = newnum then
                                flag := true;
                              SubElement := SubElement^.Next;
                            end;
                          if flag = false then
                            writeln('������ ����������� �� ����������! ����������, ���������� ��� ���!');
                        end;
                      Element^.Info.SubID := newnum;
                      ShowAskForIngrEdit;
                    end;
                  7:
                    begin
                      if AskForSureness = false then
                        begin
                          rednum := 0;

                          ShowAskForIngrEdit;
                        end
                      else
                        begin

                          ShowAskForEdit;
                        end;
                    end;
                else
                  writeln('�������� ����! ����������, ���������� ��� ���!');
                end;
              end;
            ShowAskForEdit;
          end;
        3:
          begin
            if AskForSureness = false then
              begin
                num := 0;

                ShowAskForEdit;
              end
            else
              begin

                ShowAskForFunction;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;
    end;
end;

// end;
procedure IngrBack(IngrHead: PIngr; CheckPair: TPair; salatqu: integer);
var
  IngrElement: PIngr;
  qudiff, needqu, ingrmuch: integer;
  flag: boolean;
begin
  IngrElement := IngrHead^.Next;
  flag := false;
  while (IngrElement <> nil) and (flag = false) do
    begin
      if IngrElement^.Info.ID = CheckPair.ID then
        flag := true
      else
        IngrElement := IngrElement^.Next;
    end;
  ingrmuch := round(CheckPair.Much);
  needqu := ingrmuch * salatqu;

  IngrElement^.Info.Quantity := IngrElement^.Info.Quantity + needqu;
end;

procedure OrderDelete(var OrderHead: POrder; SalatHead: PSalat;
  var IngrHead: PIngr);
var
  SalatElement: PSalat;
  OrderElement, SubOrderElement: POrder;
  IngrElement: PIngr;
  flag: boolean;
  num, salatcode, salatqu, i, ingrcode, ingrqu: integer;
begin
  OrderOutput(OrderHead);
  writeln('�������� ID ������ ���������� �������� ������ :');
  flag := false;
  while flag = false do
    begin
      check(num);
      SubOrderElement := OrderHead;
      while (SubOrderElement^.Next <> nil) and (flag = false) do
        begin
          if SubOrderElement^.Next^.Info.SalatID = num then
            flag := true
          else
            SubOrderElement := SubOrderElement^.Next;
        end;
      if flag = false then
        writeln('������ �������� ������ �� ����������!');
    end;
  OrderElement := SubOrderElement^.Next;

  if OrderElement^.Info.Afford = true then
    begin
      salatcode := num;
      salatqu := OrderElement^.Info.Quantity;
      SalatElement := SalatHead^.Next;
      flag := false;
      while (SalatElement <> nil) and (flag = false) do
        begin
          if SalatElement^.Info.ID = salatcode then
            flag := true
          else
            SalatElement := SalatElement^.Next;
        end;
      for i := 1 to 5 do
        begin
          ingrcode := SalatElement^.Info.Content[i].ID;
          // ingrqu:= SalatElement^.Info.Content[i].Much;
          IngrBack(IngrHead, SalatElement^.Info.Content[i], salatqu);
        end;
      writeln('������ ������������ ��������!');
    end;
  SubOrderElement^.Next := OrderElement^.Next;
  Dispose(OrderElement);
  writeln('������� ������ ��� ������� �����!');
end;

procedure OrderEditFunc(var OrderHead: POrder; SalatHead: PSalat;
  var IngrHead: PIngr);
var
  num, newnum: integer;
  numword: string;
  numflag, flag: boolean;
begin
  ShowAskForOrderEdit;
  while (num <> 3) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of
        1:
          begin
            OrderDelete(OrderHead, SalatHead, IngrHead);
            ShowAskForOrderEdit;
          end;
        2:
          begin
            OrderAdd(OrderHead, SalatHead);
            ShowAskForOrderEdit;
          end;
        3:
          begin
            if AskForSureness = false then
              begin
                num := 0;

                ShowAskForOrderEdit;
              end
            else
              begin

                ShowAskForFunction;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;
    end;
end;

procedure SalatDelete(var SalatHead: PSalat; var OrderHead: POrder);
var
  SalatElement, SubSalatElement, FindElems, SubFindElems, SalatFindHead: PSalat;
  num, i, rednum, newnum, IDforcheck: integer;
  numword, rednumword: string;
  numflag, rednumflag: boolean;
  flag: boolean;
  OrderElement: POrder;
begin
  ShowAskForDeleteFirst;
  while (num <> 3) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of
        1:
          begin
            SalatExstraSearch(SalatHead, SalatFindHead);
            SalatElement := SalatHead^.Next;
            ShowAskForDelete;
          end;
        2:
          begin
            writeln('������� ID ������, ������� ������ �������');
            flag := false;

            while flag = false do
              begin

                check(newnum);
                SubSalatElement := SalatHead^.Next;
                while (SubSalatElement <> nil) and (flag = false) do
                  begin
                    if SubSalatElement^.Info.ID = newnum then
                      flag := true;
                    SubSalatElement := SubSalatElement^.Next;
                  end;
                if flag = false then
                  writeln('������ ������ �� ����������! ����������, ���������� ��� ���!');
              end;
            SubSalatElement := SalatHead;

            flag := false;
            while (SubSalatElement^.Next <> nil) and (flag = false) do
              begin
                if SubSalatElement^.Next^.Info.ID = newnum then
                  flag := true
                else
                  SubSalatElement := SubSalatElement^.Next;
              end;
            SalatElement := SubSalatElement^.Next;

            IDforcheck := newnum;
            OrderElement := OrderHead^.Next;
            flag := false;
            while (OrderElement <> nil) and (flag = false) do
              begin
                if OrderElement^.Info.SalatID = IDforcheck then
                  flag := true;
                OrderElement := OrderElement^.Next;
              end;

            if flag = true then
              begin
                writeln('������ ����� ������� � �����!');
                writeln('����������, �������� ����� ������, ���');
                writeln('������� ������ �����, ����������� ������ �������');
                writeln('��� �������� ������ �����!');
              end
            else
              begin
                SubSalatElement^.Next := SalatElement^.Next;
                Dispose(SalatElement);
                writeln('����� ��� ������� �����!');
              end;

            ShowAskForDelete;
          end;
        3:
          begin
            if AskForSureness = false then
              begin
                num := 0;

                ShowAskForDelete;
              end
            else
              begin

                ShowAskForFunction;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;
    end;
end;

procedure IngrDelete(var IngrHead: PIngr; var SalatHead: PSalat);
var
  IngrElement, SubIngrElement, FindElems, SubFindElems, IngrFindHead: PIngr;
  num, i, rednum, newnum, IDforcheck: integer;
  numword, rednumword: string;
  numflag, rednumflag: boolean;
  flag: boolean;
  SalatElement: PSalat;
begin
  // new(IngrFindHead);

  // IngrElement := IngrHead^.Next;
  // new(FindElems);
  // IngrFindHead^.Next := FindElems;
  // SubFindElems := IngrFindHead;
  ShowAskForDeleteFirst;
  while (num <> 3) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of // ������� �������� �� ������ ������
        1:
          begin
            IngrExstraSearch(IngrHead, IngrFindHead);
            IngrElement := IngrHead^.Next;
            ShowAskForDelete;
          end;
        2:
          begin
            writeln('������� ID �����������, ������� ������ �������');
            flag := false;

            while flag = false do
              begin

                check(newnum);
                SubIngrElement := IngrHead^.Next;
                while (SubIngrElement <> nil) and (flag = false) do
                  begin
                    if SubIngrElement^.Info.ID = newnum then
                      flag := true;
                    SubIngrElement := SubIngrElement^.Next;
                  end;
                if flag = false then
                  writeln('������ ����������� �� ����������! ����������, ���������� ��� ���!');
              end;
            SubIngrElement := IngrHead;

            flag := false;
            while (SubIngrElement^.Next <> nil) and (flag = false) do
              begin
                if SubIngrElement^.Next^.Info.ID = newnum then
                  flag := true
                else
                  SubIngrElement := SubIngrElement^.Next;
              end;
            IngrElement := SubIngrElement^.Next;

            IDforcheck := newnum;
            SalatElement := SalatHead^.Next;
            flag := false;
            while (SalatElement <> nil) and (flag = false) do
              begin
                for i := 1 to 5 do
                  begin
                    if SalatElement^.Info.Content[i].ID = IDforcheck then
                      flag := true;
                  end;
                SalatElement := SalatElement^.Next;
              end;

            if flag = true then
              begin
                writeln('������ ���������� ������������ � �������� �������!');
                writeln('����������, �������� ������ ������� ������, ���');
                writeln('������� ������ ����������, ����������� ������ ������������');
                writeln('��� �������� ������ ����������!');
              end
            else
              begin
                SubIngrElement^.Next := IngrElement^.Next;
                Dispose(IngrElement);
                writeln('���������� ��� ������� �����!');

                SubIngrElement := IngrHead^.Next;
                while (SubIngrElement <> nil) do
                  begin
                    if SubIngrElement^.Info.SubID = IDforcheck then
                      SubIngrElement^.Info.SubID := 0;
                    SubIngrElement := SubIngrElement^.Next;
                  end;
              end;

            ShowAskForDelete;
          end;
        3:
          begin
            if AskForSureness = false then
              begin
                num := 0;

                ShowAskForDelete;
              end
            else
              begin

                ShowAskForFunction;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;
    end;
end;

procedure IfIngrList(key: integer; var IngrHead: PIngr; var SalatHead: PSalat;
  var MaxIngr: integer);
var
  IngrFindHead: PIngr;
  lenflag: boolean;
begin
  case key of
    4:
      begin

        IngrLengthCheck(IngrHead, lenflag);
        if lenflag = true then
          begin
            new(IngrFindHead);
            IngrSearching(IngrHead, IngrFindHead);
          end
        else
          begin
            writeln('���! ������, ������ ������! �������� ��������, ������ ��� ������������ �����!');
            ShowAskForFunction;
          end;
      end;
    5:
      begin
        IngrAdd(IngrHead, MaxIngr);
        ShowAskForFunction;
      end;
    6:
      begin

        IngrLengthCheck(IngrHead, lenflag);
        if lenflag = true then
          begin
            IngrDelete(IngrHead, SalatHead);
          end
        else
          begin
            writeln('���! ������, ������ ������!');
            ShowAskForFunction;
          end;
      end;
    7:
      begin

        IngrLengthCheck(IngrHead, lenflag);
        if lenflag = true then
          begin
            IngrEditFunc(IngrHead, MaxIngr);
          end
        else
          begin
            writeln('���! ������, ������ ������! �������� ��������, ������� ����� ������� �������������!');
            ShowAskForFunction;
          end;
      end;
  end;
end;

procedure IfSalatList(key: integer; var IngrHead: PIngr; var SalatHead: PSalat;
  var OrderHead: POrder; var MaxSalat: integer);
var
  SalatFindHead: PSalat;
  lenflag: boolean;
begin
  case key of
    4:
      begin

        SalatLengthCheck(SalatHead, lenflag);
        if lenflag = true then
          begin
            new(SalatFindHead);
            SalatSearching(SalatHead, SalatFindHead);
          end
        else
          begin
            writeln('���! ������, ������ ������! �������� ��������, ������ ��� ������������ �����!');
            ShowAskForFunction;
          end;
      end;
    5:
      begin


        IngrLengthCheck(IngrHead, lenflag);
        if lenflag = true then
          begin
            SalatAdd(SalatHead, MaxSalat, IngrHead);
            ShowAskForFunction;
          end
        else
          begin
            writeln('���! ������, ������ ������������ ������!');
            ShowAskForFunction;
          end;
      end;
    6:
      begin

        SalatLengthCheck(SalatHead, lenflag);
        if lenflag = true then
          begin
            SalatDelete(SalatHead, OrderHead);
          end
        else
          begin
            writeln('���! ������, ������ ������!');
            ShowAskForFunction;
          end;
      end;
    7:
      begin

        SalatLengthCheck(SalatHead, lenflag);
        if lenflag = true then
          begin
             SalatEditFunc(SalatHead, MaxSalat, IngrHead);
          end
        else
          begin
            writeln('���! ������, ������ ������! �������� ��������, ������� ����� ������� �������������!');
            ShowAskForFunction;
          end;
      end;
  end;
end;

procedure IfOrderList(key: integer; var IngrHead: PIngr; var SalatHead: PSalat;
  var OrderHead: POrder; var MaxOrder: integer);
var
  OrderFindHead: POrder;
  lenflag: boolean;
begin
  case key of
    4:
      begin

        OrderLengthCheck(OrderHead, lenflag);
        if lenflag = true then
          begin
            new(OrderFindHead);
            OrderSearching(OrderHead, OrderFindHead);
          end
        else
          begin
            writeln('���! ������, ������ ������! �������� ��������, ������ ��� ������������ �����!');
            ShowAskForFunction;
          end;
      end;
    5:
      begin


        SalatLengthCheck(SalatHead, lenflag);
        if lenflag = true then
          begin
           OrderAdd(OrderHead, SalatHead);
           ShowAskForFunction;
          end
        else
          begin
            writeln('���! ������, ������ ������� ������!');
            ShowAskForFunction;
          end;
      end;
    6:
      begin

        OrderLengthCheck(OrderHead, lenflag);
        if lenflag = true then
          begin
            OrderDelete(OrderHead, SalatHead, IngrHead);
            ShowAskForFunction;
          end
        else
          begin
            writeln('���! ������, ������ ������!');
            ShowAskForFunction;
          end;
      end;
    7:
      begin

        OrderLengthCheck(OrderHead, lenflag);
        if lenflag = true then
          begin
            OrderEditFunc(OrderHead, SalatHead, IngrHead);
          end
        else
          begin
            writeln('���! ������, ������ ������! �������� ��������, ������� ����� ������� �������������!');
            ShowAskForFunction;
          end;
      end;
  end;
end;

procedure AskForFunction(var IngrHead: PIngr; var SalatHead: PSalat;
  var OrderHead: POrder; key: integer; var MaxIngr, MaxSalat,
  MaxOrder: integer);
var
  num: integer;
  numword: string;
  numflag, lenflag: boolean;
  IngrFindHead: PIngr;
  SalatFindHead: PSalat;
  OrderFindHead: POrder;
begin
  ShowAskForFunction;
  while (num <> 4) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of
        1:
          begin
            writeln('������ ������������');
            IfIngrList(key, IngrHead, SalatHead, MaxIngr);
          end;
        2:
          begin
            writeln('������ �������');
            IfSalatList(key, IngrHead, SalatHead, OrderHead, MaxSalat);
          end;
        3:
          begin
            writeln('������ ������');
            IfOrderList(key, IngrHead, SalatHead, OrderHead, MaxOrder);
          end;
        4:
          begin
            if AskForSureness = false then
              begin
                num := 0;

                ShowAskForFunction;
              end
            else
              begin

                ShowMainMenu;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;
    end;
end;

// --------------------------------------------------------------------------
function IngrMainCheck(IngrHead: PIngr; CheckPair: TPair;
  salatqu: integer): boolean;
var
  IngrElement: PIngr;
  qudiff, needqu, ingrmuch: integer;
  flag: boolean;
begin
  IngrElement := IngrHead^.Next;
  flag := false;
  while (IngrElement <> nil) and (flag = false) do
    begin
      if IngrElement^.Info.ID = CheckPair.ID then
        flag := true
      else
        IngrElement := IngrElement^.Next;
    end;
  ingrmuch := round(CheckPair.Much);
  needqu := ingrmuch * salatqu;
  qudiff := IngrElement^.Info.Quantity - needqu;
  if qudiff > 0 then
    begin
      IngrElement^.Info.Quantity := qudiff;
      result := true;
    end
  else
    result := false;
end;

function IngrMainCheckWithChanges(IngrHead: PIngr; CheckPair: TPair;
  salatqu: integer): boolean;
var
  IngrElement, SubIngrElement: PIngr;
  qudiff, needqu, ingrmuch: integer;
  flag, subflag: boolean;
begin
  IngrElement := IngrHead^.Next;
  flag := false;
  while (IngrElement <> nil) and (flag = false) do
    begin
      if IngrElement^.Info.ID = CheckPair.ID then
        flag := true
      else
        IngrElement := IngrElement^.Next;
    end;
  ingrmuch := round(CheckPair.Much);
  needqu := ingrmuch * salatqu;
  qudiff := IngrElement^.Info.Quantity - needqu;
  if qudiff > 0 then
    begin
      IngrElement^.Info.Quantity := qudiff;
      result := true;
    end
  else
    begin
      if IngrElement^.Info.SubID = 0 then
        result := false
      else
        begin
          SubIngrElement := IngrHead^.Next;
          subflag := false;
          while (SubIngrElement <> nil) and (subflag = false) do
            begin
              if SubIngrElement^.Info.ID = IngrElement^.Info.SubID then
                subflag := true
              else
                SubIngrElement := SubIngrElement^.Next;
            end;
          ingrmuch := round(CheckPair.Much);
          needqu := ingrmuch * salatqu;
          qudiff := SubIngrElement^.Info.Quantity - needqu;
          if qudiff > 0 then
            begin
              SubIngrElement^.Info.Quantity := qudiff;
              result := true;
              writeln('��-�� �������� ����������� "',
                IngrElement^.Info.Name, '"');
              writeln('���� ����������� ������ ��� �� "',
                SubIngrElement^.Info.Name, '"');
            end
          else
            begin
              result := false;

            end;
        end;
    end;
end;

function SalatMainCheck(SalatElement: PSalat; IngrHead: PIngr;
  salatqu: integer): boolean;
var
  i, j: integer;
  helpflag: boolean;
begin
  result := true;
  i := 1;
  helpflag := false;
  while (i <= 5) and (helpflag = false) do
    begin
      // result:= ������� �������� �����������, ������� ����
      if IngrMainCheck(IngrHead, SalatElement^.Info.Content[i], salatqu) = false
      then
        begin
          result := false;
          for j := 1 to (i - 1) do
            begin
              IngrBack(IngrHead, SalatElement^.Info.Content[j], salatqu);
            end;
        end;
      i := i + 1;
    end;
end;

function SalatMainCheckWithChanges(SalatElement: PSalat; IngrHead: PIngr;
  salatqu: integer): boolean;
var
  i, j: integer;
  helpflag: boolean;
begin
  result := true;
  i := 1;
  helpflag := false;
  while (i <= 5) and (helpflag = false) do
    begin
      // result:= ������� �������� �����������, ������� ����
      if IngrMainCheckWithChanges(IngrHead, SalatElement^.Info.Content[i],
        salatqu) = false then
        begin
          result := false;
          for j := 1 to (i - 1) do
            begin
              IngrBack(IngrHead, SalatElement^.Info.Content[j], salatqu);
            end;
        end;
      i := i + 1;
    end;
end;

procedure OrderMainCheck(var OrderHead: POrder; SalatHead: PSalat;
  IngrHead: PIngr);
var
  OrderElement: POrder;
  SalatElement: PSalat;
  salatcode, salatqu: integer;
  flagcircle, normaflag: boolean;
begin

  OrderElement := OrderHead^.Next;
  while OrderElement <> nil do
    begin
      if OrderElement^.Info.Afford = false then
        begin
          salatcode := OrderElement^.Info.SalatID;
          salatqu := OrderElement^.Info.Quantity;
          SalatElement := SalatHead^.Next;
          flagcircle := false;
          normaflag := false;
          while (SalatElement <> nil) and (flagcircle = false) do
            begin
              if SalatElement^.Info.ID = salatcode then
                begin
                  // salat check
                  normaflag := SalatMainCheck(SalatElement, IngrHead, salatqu);
                  flagcircle := true;
                  // ������ ��� ����������� normaflag ����� var
                end
              else
                SalatElement := SalatElement^.Next;
            end;

          if normaflag = true then
            OrderElement^.Info.Afford := true;
        end;

      OrderElement := OrderElement^.Next;
    end;

  OrderOutput(OrderHead);
  SalatOutput(SalatHead);

  OrderElement := OrderHead^.Next;
  while OrderElement <> nil do
    begin
      if OrderElement^.Info.Afford = false then
        begin
          salatcode := OrderElement^.Info.SalatID;
          salatqu := OrderElement^.Info.Quantity;
          SalatElement := SalatHead^.Next;
          flagcircle := false;
          normaflag := false;
          while (SalatElement <> nil) and (flagcircle = false) do
            begin
              if SalatElement^.Info.ID = salatcode then
                begin
                  // salat check
                  normaflag := SalatMainCheckWithChanges(SalatElement,
                    IngrHead, salatqu);
                  flagcircle := true;
                  // ������ ��� ����������� normaflag ����� var
                end
              else
                SalatElement := SalatElement^.Next;
            end;

          if normaflag = true then
            OrderElement^.Info.Afford := true;
        end;

      OrderElement := OrderElement^.Next;
    end;

  // ���� ������ ���� �������� � ������ �����!!!!!
  // ���� ��� ��� ������ - �������� ��������� � ��������� ������, ��� ��� ������ �����������
  writeln('�������� ������ ���������!');
end;

procedure CostsFunc(OrderHead: POrder; SalatHead: PSalat);
var
  OrderElement: POrder;
  SalatElement: PSalat;
  finalcost, elcost, salatcode: integer;
  flag: boolean;
begin
  writeln('���� �� ����� :');
  finalcost := 0;
  OrderElement := OrderHead^.Next;
  while OrderElement <> nil do
    begin
      if OrderElement^.Info.Afford = true then
        begin
          salatcode := OrderElement^.Info.SalatID;
          SalatElement := SalatHead^.Next;
          flag := false;
          while (SalatElement <> nil) and (flag = false) do
            begin
              if SalatElement^.Info.ID = salatcode then
                flag := true
              else
                SalatElement := SalatElement^.Next;
            end;
          elcost := OrderElement^.Info.Quantity * 10;
          finalcost := finalcost + elcost;
          writeln;
          writeln('   ', SalatElement^.Info.Name, ' : ', elcost, ' ������');
        end;

      OrderElement := OrderElement^.Next;
    end;
  writeln;
  writeln('����� : ', finalcost, ' ������');
  writeln;
  writeln('������� ENTER ����� ����������.');
  readln;
end;

procedure PFCCount(OrderHead: POrder; SalatHead: PSalat; IngrHead: PIngr;
  var isokflag: boolean);
var
  totalP, totalF, totalC, salatcode, salatqu, i, ingrcode: integer;
  ingrqu, Ps, Fs, Cs: real;
  OrderElement: POrder;
  SalatElement: PSalat;
  IngrElement: PIngr;
  flag: boolean;
begin
  writeln('������ ������/�����/��������� � ������ �������� ������ :');
  isokflag := false;
  OrderElement := OrderHead^.Next;
  while OrderElement <> nil do
    begin
      if OrderElement^.Info.Afford = true then
        begin
          isokflag := true;
          totalP := 0;
          totalF := 0;
          totalC := 0;
          salatcode := OrderElement^.Info.SalatID;
          salatqu := OrderElement^.Info.Quantity;
          SalatElement := SalatHead^.Next;
          flag := false;
          while (SalatElement <> nil) and (flag = false) do
            begin
              if SalatElement^.Info.ID = salatcode then
                flag := true
              else
                SalatElement := SalatElement^.Next;
            end;
          for i := 1 to 5 do
            begin
              ingrcode := SalatElement^.Info.Content[i].ID;
              ingrqu := SalatElement^.Info.Content[i].Much;

              IngrElement := IngrHead^.Next;
              flag := false;
              while (IngrElement <> nil) and (flag = false) do
                begin
                  if IngrElement^.Info.ID = ingrcode then
                    flag := true
                  else
                    IngrElement := IngrElement^.Next;
                end;

              Ps := real(IngrElement^.Info.Proteins);
              totalP := totalP + round((Ps / 100) * ingrqu * salatqu);

              Fs := real(IngrElement^.Info.Fats);
              totalF := totalF + round((Fs / 100) * ingrqu * salatqu);

              Cs := real(IngrElement^.Info.Carbohs);
              totalC := totalC + round((Cs / 100) * ingrqu * salatqu);
            end;
          writeln;
          writeln('"', SalatElement^.Info.Name, '" � ���������� ', salatqu,
            ' ����(�) :');
          writeln('�����: ', totalP);
          writeln('����: ', totalF);
          writeln('��������: ', totalC);
        end;
      OrderElement := OrderElement^.Next;
    end;
end;

function GetSalatName(OrderElement: POrder; SalatHead: PSalat): string;
var
  Name: string;
  salatcode: integer;
  SalatElement: PSalat;
  flag: boolean;
begin
  salatcode := OrderElement^.Info.SalatID;
  SalatElement := SalatHead^.Next;
  flag := false;
  while (SalatElement <> nil) and (flag = false) do
    begin
      if SalatElement^.Info.ID = salatcode then
        begin
          result := SalatElement^.Info.Name;
          flag := true;
        end;
      SalatElement := SalatElement^.Next;
    end;
end;

procedure SortOrderSubList(var SortOrderHead: POrder; SalatHead: PSalat);
var
  Sorted, Curr, Min, Temp: POrder;
begin
  Sorted := SortOrderHead;
  while Sorted^.Next <> nil do
    begin
      Min := Sorted;
      Curr := Sorted^.Next;
      while Curr^.Next <> nil do
        begin
          if GetSalatName(Curr^.Next, SalatHead) < GetSalatName(Min^.Next,
            SalatHead) then
            Min := Curr;
          Curr := Curr^.Next;
        end;
      if (Min <> Sorted) then
        begin
          Temp := Min^.Next;
          Min^.Next := Min^.Next^.Next;
          Temp^.Next := Sorted^.Next;
          Sorted^.Next := Temp;

        end;
      Sorted := Sorted^.Next;
    end;
end;

procedure MainFuncSearch(OrderHead: POrder; SalatHead: PSalat; IngrHead: PIngr;
  var isokflag: boolean);
var
  OrderElement, SortOrderElem, SubSortOrderElem, SortOrderHead: POrder;
  IngrElement, IngrFindHead, SubIngrElement: PIngr;
  SalatElement: PSalat;
  dopflag, flag, issmth: boolean;
  suchname: string;
  newnum, i, salatcode, ingrcode: integer;
begin
  isokflag := true;
  dopflag := false;
  OrderElement := OrderHead^.Next;

  new(SortOrderHead);
  new(SortOrderElem);
  SortOrderHead^.Next := SortOrderElem;
  while OrderElement <> nil do
    begin
      // new(SortOrderElement);
      if OrderElement^.Info.Afford = true then
        begin
          dopflag := true;
          SortOrderElem^.Info := OrderElement^.Info;
          SubSortOrderElem := SortOrderElem;
          new(SortOrderElem);
          SubSortOrderElem^.Next := SortOrderElem;
        end;

      OrderElement := OrderElement^.Next;
    end;

  if dopflag = false then
    SortOrderHead^.Next := nil
  else
    SubSortOrderElem^.Next := nil;

  if SortOrderHead^.Next <> nil then
    begin
      SortOrderSubList(SortOrderHead, SalatHead);
      writeln('���������� �������� ������ (������ ������������ �� ��������� �������):');
      OrderOutput(SortOrderHead);
      // OrderOutput(OrderHead);
      writeln;
      writeln('������� ENTER ����� ����������.');
      readln;

      writeln('������ ��������� ������������ :');
      IngrOutput(IngrHead);
      writeln('������, ��� ������ ����������, ����������� ��������� ��������!');
      IngrExstraSearch(IngrHead, IngrFindHead);
      writeln('������� ID �����������, �� ������� �������� ������ ��������� :');
      flag := false;

      while flag = false do
        begin

          check(newnum);
          SubIngrElement := IngrHead^.Next;
          while (SubIngrElement <> nil) and (flag = false) do
            begin
              if SubIngrElement^.Info.ID = newnum then
                flag := true;
              SubIngrElement := SubIngrElement^.Next;
            end;
          if flag = false then
            writeln('������ ����������� �� ����������! ����������, ���������� ��� ���!');
        end;
      // IngrElement := IngrHead^.Next;
      ingrcode := newnum;
      SortOrderElem := SortOrderHead^.Next;
      issmth := false;
      while SortOrderElem <> nil do
        begin
          dopflag := false;
          salatcode := SortOrderElem^.Info.SalatID;
          SalatElement := SalatHead^.Next;
          flag := false;
          while (SalatElement <> nil) and (flag = false) do
            begin
              if SalatElement^.Info.ID = salatcode then
                flag := true
              else
                SalatElement := SalatElement^.Next;
            end;

          for i := 1 to 5 do
            begin
              // ingrcode:= SalatElement^.Info.Content[i].ID;

              if SalatElement^.Info.Content[i].ID = ingrcode then
                dopflag := true;

            end;
          if dopflag = true then
            begin
              writeln('������� ������ � ������� "',
                SalatElement^.Info.Name, '"');
              issmth := true;
            end;
          SortOrderElem := SortOrderElem^.Next;
        end;
      if issmth = false then
        writeln('���������� �� ������������ � ������!');
    end
  else
    begin
      isokflag := false;
    end;

end;

procedure CheckFunc(var OrderHead: POrder; SalatHead: PSalat; IngrHead: PIngr);
var
  num: integer;
  numword: string;
  numflag, isokflag: boolean;
begin
  ShowAskForMCheck(OrderHead);
  while (num <> 4) do
    begin
      readln(numword);
      numflag := TryStrToInt(numword, num);
      if numflag = false then
        num := 0;
      case num of
        1:
          begin

            OrderMainCheck(OrderHead, SalatHead, IngrHead);
            CostsFunc(OrderHead, SalatHead);

            ShowAskForMCheck(OrderHead);
          end;
        2:
          begin
            // ���
            PFCCount(OrderHead, SalatHead, IngrHead, isokflag);
            if isokflag = false then
              writeln('���! ������, �� ���� ������� ������ ��� �� ��� �������(((');

            writeln;
            writeln('������� ENTER ����� ����������.');
            readln;
            ShowAskForMCheck(OrderHead);
          end;
        3:
          begin
            // �����
            MainFuncSearch(OrderHead, SalatHead, IngrHead, isokflag);
            if isokflag = false then
              writeln('���! ������, �� ���� ������� ������ ��� �� ��� �������(((');

            writeln;
            writeln('������� ENTER ����� ����������.');
            readln;
            ShowAskForMCheck(OrderHead);
            // �������� ���������� ������ ������ � ����������� ���������� ������
            // ���������� ����� ���������� ������ �� ��������
            // ���� �������� �����������, ����� ��� ����� ������������, �������� �� ���� ��������
            // ������ �� ������ ������, ������ ������� ������ �� ������ ������
            // ������ �� �������, ���� ���� ����, ��� - ��� ������ �� ����� ����� �������
          end;
        4:
          begin
            if AskForSureness = false then
              begin
                num := 0;

                ShowAskForFunction;
              end
            else
              begin

                ShowMainMenu;
              end;
          end;
      else
        writeln('�������� ����! ����������, ���������� ��� ���!');
      end;
    end;
end;

procedure OrderSortFunc(OrderHead: POrder; SalatHead: PSalat);
var dopflag, lenflag: boolean;
    OrderElement, SortOrderHead, SortOrderElem, SubSortOrderElem: POrder;
begin
  writeln('� ������ ������ ��������� "Minigur" ������ �������');
  writeln('����������� ��� ����������� ������������� ��� �����');
  writeln('�� ��������� �������!');
  writeln;
  writeln('������� ENTER ����� ����������');
  readln;
  writeln;
  OrderLengthCheck(OrderHead, lenflag);
 if lenflag = true then
 begin
  writeln('��� ����� :');
  OrderOutput(OrderHead);
  writeln;
  writeln('������� ENTER ����� ����������');
  readln;
  dopflag := false;
  OrderElement := OrderHead^.Next;

  new(SortOrderHead);
  new(SortOrderElem);
  SortOrderHead^.Next := SortOrderElem;
  while OrderElement <> nil do
    begin
      // new(SortOrderElement);
      if OrderElement^.Info.Afford = true then
        begin
          dopflag := true;
          SortOrderElem^.Info := OrderElement^.Info;
          SubSortOrderElem := SortOrderElem;
          new(SortOrderElem);
          SubSortOrderElem^.Next := SortOrderElem;
        end;

      OrderElement := OrderElement^.Next;
    end;

  if dopflag = false then
    SortOrderHead^.Next := nil
  else
    SubSortOrderElem^.Next := nil;

  if SortOrderHead^.Next <> nil then
    begin
      SortOrderSubList(SortOrderHead, SalatHead);
      writeln('��������������� ����� :');
      OrderOutput(SortOrderHead);
      writeln('�������� � ����! ������� ENTER.');
      readln;
      ShowMainMenu;
    end
  else
    begin
      writeln('���! ������, �� ���� ������� ������ ��� �� ��� �������(((');
      ShowMainMenu;
    end;
 end
 else
 begin
  writeln('���! ������, ������ ������! �������� ��������, ������� ����� �������������!');
  ShowMainMenu;
 end;

end;

// --------------------------------------------------------------------------

var
  IngrHead, IngrMainHead: PIngr;
  SalatHead, SalatMainHead: PSalat;
  OrderHead, OrderMainHead: POrder;
  IngrMainFile: FileIngr;
  SalatMainFile: FileSalat;
  OrderMainFile: FileOrder;
  key: integer;
  keyword: string;
  keyflag, ifwrong: boolean;
  MaxIngr, MaxSalat, MaxOrder: integer;

begin
  assignfile(IngrMainFile, 'ingredients.ingr');
  assignfile(SalatMainFile, 'salats.salat');
  assignfile(OrderMainFile, 'order_one.order');

  // �������� �������
  //new(IngrHead);
  //new(SalatHead);
  //new(OrderHead);
  //Creating(IngrHead, SalatHead, OrderHead);
  // �������� �����
  //FileMakingIngr(IngrHead, IngrMainFile);
  //FileMakingSalat(SalatHead, SalatMainFile);
  //FileMakingOrder(OrderHead, OrderMainFile);

  // ������ �� �����
  new(IngrMainHead);
  new(SalatMainHead);
  new(OrderMainHead);
  MaxIngr := 0;
  MaxSalat := 0;
  MaxOrder := 0;
  ifwrong := false;
  try
    FromIngrFileReading(IngrMainHead, IngrMainFile, MaxIngr);
    FromSalatFileReading(SalatMainHead, SalatMainFile, MaxSalat);
    FromOrderFileReading(OrderMainHead, OrderMainFile, MaxOrder);
  except
    writeln('������ �������� ������!');
    ifwrong := true;
  end;

  if ifwrong = false then
    begin
      FirstShow;
      // ������ ���������
      while (key <> 9) do
        begin

          readln(keyword);
          keyflag := TryStrToInt(keyword, key);
          if keyflag = false then
            key := 0;
          case key of
            1: // ������ ������
              AskForReadFiles(IngrMainHead, IngrMainFile, SalatMainHead,
                SalatMainFile, OrderMainHead, OrderMainFile, MaxIngr, MaxSalat,
                MaxOrder);
            2: // ��������
              AskForOutput(IngrMainHead, SalatMainHead, OrderMainHead);
            3: // ����������
              OrderSortFunc(OrderMainHead, SalatMainHead);
            4: // �����
              AskForFunction(IngrMainHead, SalatMainHead, OrderMainHead, key,
                MaxIngr, MaxSalat, MaxOrder);
            5: // ����������
              AskForFunction(IngrMainHead, SalatMainHead, OrderMainHead, key,
                MaxIngr, MaxSalat, MaxOrder);
            6: // ��������
              AskForFunction(IngrMainHead, SalatMainHead, OrderMainHead, key,
                MaxIngr, MaxSalat, MaxOrder);
            7: // ��������������
              AskForFunction(IngrMainHead, SalatMainHead, OrderMainHead, key,
                MaxIngr, MaxSalat, MaxOrder);
            8: // ���� �������
              CheckFunc(OrderMainHead, SalatMainHead, IngrMainHead);
            9: // ����� ��� ����������
              AskForExit(key, IngrMainHead, SalatMainHead, OrderMainHead);
            10: // ����� � �����������
              AskForExitWithSave(key, IngrMainHead, IngrMainFile, SalatMainHead,
                SalatMainFile, OrderMainHead, OrderMainFile);
          else
            writeln('�������� ����! ����������, ���������� ��� ���!');
          end;
        end;
    end
  else
    begin
      writeln('������, � ������� ���-�� �� ���! ����������, ���������, ����� ���');
      writeln('���������� � ����� ����� � EXE-������ ���������!');
      writeln('���������� �������� ������: ingredients.ingr ');
      writeln('                            salats.salat');
      writeln('                            order_one.order');
      writeln;
      writeln;
      writeln;
      writeln('��� ������ �� ��������� ������� ENTER');
    end;

  readln;

end.
