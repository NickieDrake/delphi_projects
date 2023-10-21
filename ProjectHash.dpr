program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

const
  HTCount=34;   //����� ��������� ���-�������
type
  TPT=^TTermList;
  PPT=^TPageList;
  FPT=^TFindResultList;
  APT=^TAddressList;
  SPT=^TSortTermsList;

  THashTable=array[1..HTCount] of TPT;

  //������ ��������
  TTermList= record
    Word:string;
    SubTerm:THashTable;
    Pages:PPT;
    Next:TPT;
  end;

  //������ �������
  TPageList=record
    Page:integer;
    Next:PPT;
  end;

  //������ ����������� ������
  TFindResultList = record
    Address:APT;
    Result:TPT;
    Next:FPT;
  end;

  //������ ��� �������� ������
  TAddressList = record
    Point:string;
    Next:APT;
  end;

  //������ ��� �������� ��������������� ���������
  TSortTermsList = record
    Word:string;
    SubTerms:SPT;
    Pages:PPT;
    Next:SPT;
  end;
var
  Terms:THashTable;

//���������� ������ � ������ � �������
function RusWR(aStr : String) : String;
begin
  Result := '';
  if Length(aStr) > 0 then begin
    SetLength(Result, Length(aStr));
    CharToOem(PChar(aStr), PChar(Result));
  end;
end;

//�������� ������ ��� �����
function RusRD(const aStr : String) : String;
begin
  Result := '';
  if Length(aStr) > 0 then begin
    SetLength(Result, Length(aStr));
    OemToChar(PChar(aStr), PChar(Result));
  end;
end;


//���-�������
function H(name:string):integer;
begin
  name:= AnsiUpperCase(name);

  //�������� � �� �
  if ord(name[1]) = 240 then
    name[1]:=char(133);

  if (ord(name[1])<128) or (ord(name[1])>159) then
    result:=1
  else
    result:=ord(name[1])-191+1;
end;

//������������� ���-�������.
procedure Initialize(var HT:THashTable);
var
  i:Integer;
begin
  for i:= 1 to HTCount do
  begin
    new(HT[i]);
    HT[i]^.Next:=nil;
  end;
end;


//������� PPT �� ������ ��������
function GetPPT(page:integer):PPT;
begin
  New(result);
  result^.Page:=page;
  result^.Next:=nil;
end;

//���������� ��������
procedure AddPage(var first:PPT; page:PPT);
var
  x:PPT;
begin
  x:=first;    //���� ������ ������

  //���� �����
  while x^.Next  <> nil do
    x:=x^.Next;

  x^.Next:=page;
end;

//�������� ��������� TPT
function GetTPT(word:string;page:PPT):TPT;
begin
  New(result);
  result^.Word:=Word;               //��������� �������
  New(result^.Pages);                //���������
  result^.Pages^.Next:=page;        //��������
  //��������� ����������
  Initialize(result^.SubTerm);
  result^.Next:=nil;
end;

//�������� ��������� SPT
function GetSPT(word:string;page:PPT):SPT;
begin
  New(result);
  result^.Word:=Word;               //��������� �������
  New(result^.Pages);                //���������
  result^.Pages^.Next:=page;        //��������
  //��������� ����������
  New(result^.SubTerms);
  result^.Next:=nil;
end;

//����� ������� ������ � ������ ���-������� (��� �������� �� ������ ������)
function LittleFindTerm(term:TPT; parrent:THashTable):TPT;
var
  x:TPT;
begin
  x:=parrent[H(term^.Word)]^.Next;  //���������� ������ ���-�������

  while (x<>nil) and (x^.Word <>term^.Word) do
    x:=x^.Next;

  result:=x;
end;

//���������� � ������ first ������ plus. ������� first ���, ����� �� �������� �� ����� ������ ������
procedure AddResultsToList(var first:FPT;var plus:FPT);
var
  x:FPT;
begin
  if first = nil then
    first:=plus
  else
    first^.Next:=plus;

  if plus <> nil then
  begin
    x:=plus;

    while x^.Next  <> nil do
      x:=x^.Next;

    first:=x;
  end;
end;


//����������� ������ �������
function CopyAddress(x:APT):APT;
var
  y,z:APT;
begin
  New(y);
  result:=y;

  while x <> nil do
  begin
    y^.Point:=x^.Point;
    z:=y;
    New(y);
    z^.Next:=y;
    x:=x^.Next;
  end;

  z^.Next:=nil;
end;

//��������� �������� � ������
procedure AddAddress(var x,add:APT);
var
  y:APT;
begin
  y:=x;

  while y^.Next <> nil do
    y:=y.Next;

  y^.Next:=add;
end;

//����� ������� (����������� �����)
function FTerm(Address:APT; term:TPT; parrent:THashTable):FPT;
var
  i:integer;
  x:TPT;
  rez,t1,t2,t3:FPT;
  adr,t:APT;
begin
  x:=LittleFindTerm(term,parrent);

  New(rez);
  rez^.Next:=nil;
  t1:=rez;

  if x <> nil then
  begin
    New(t2);
    t2^.Address:=Address;
    t2^.Result:=x;
    t2^.Next:=nil;
    AddresultsToList(t1,t2);
  end;

  //������������� ��� ������� ���� �������� ������
  for i:=1 to HTCount do
  begin
    x:=parrent[i]^.Next;

    //������������� ������
    while x <> nil do
    begin
      //���������� � ������ ������� �������
      New(t);
      t^.Point:=x^.Word;
      t^.Next:=nil;
      adr:=CopyAddress(Address);
      AddAddress(adr,t);

      //��������� ����� �� ������� ����
      t3:=FTerm(adr,term,x^.SubTerm);
      AddResulTSToList(t1,t3);
      x:=x^.Next;
    end; //While
  end;//for

  FTerm:=rez^.Next;
end;

//����� �������� � ������ first. � prev ����������� ���������� ��. ������
function FindPage(first:PPT;page:PPT;var prev:PPT):PPT;
begin
  prev:=first;
  first:=first^.Next;

  while (first <> nil) and (first^.Page<> page^.Page) do
  begin
    prev:=prev^.Next;
    first:=first^.Next;
  end;
  result:=first;
end;

function GetParrent(x:FPT):THashTable;
var
  adr:APT;
  HT:THashTable;
begin
  adr:=x^.Address^.Next;
  HT:=Terms;

  //������������� ����� ���������
  while adr<> nil do
  begin
    HT:=LittleFindTerm(GetTPT(adr^.Point,nil),HT)^.SubTerm;  //�������� ����� ���-�������
    adr:=adr^.Next;
  end;

  result:=HT;
end;

//��������� ������� �� ����������� ������
function GetTermFormFind(x:FPT):TPT;
begin
  result:=LittleFindTerm(x^.Result,GetParrent(x));
end;

//����� ������� �� ��� ���������
function FindTerm(term:TPT):FPT;
var
  Adr:APT;
begin
  New(Adr);
  Adr^.Next:=nil;

  New(result);
  result^.Next:=FTerm(Adr,term,Terms);
end;


//���������� ������� � ���-�������
procedure AddTerm(var HT:ThashTable; Term:TPT);
var
  t:integer;
  prev:TPT;
  x:TPT;
begin
  t:=H(Term^.Word);     //�������� ���-�������;
  prev:=HT[t];
  x:=prev^.Next;

  //������� ����� ������� ��� ����� ������
  while (x <> nil) and (AnsiLowerCase(x^.Word) < AnsiLowerCase(Term^.Word)) do
  begin
    x:=x^.Next;
    prev:=prev^.Next;
  end;

  //���������
  prev^.Next:=Term;
  Term^.Next:=x;
end;

//����� ������ �������
procedure WritePageList(first:PPT);
var
  x:PPT;
begin
  x:=first^.Next;

  while x <> nil do
  begin
    write(x^.Page);
    x:=x^.Next;

    //������� ����� ������ ���� ������� ���-�� ����
    if x <> nil then
      write(',');
  end;
end;

procedure WriteHT(table:THashTable;tabs:integer);
  Forward;

//����� ������� � ������������ � �������� �������. Tabs - ������ �� ������ ��������
procedure WriteTerm(term:TPT;tabs:integer;sub:boolean);
var
  i:integer;
begin
  //����������� ����� ��������
  for i:= 1 to tabs do
    write('   ');

  write(RusWR(term^.Word),' ');
  WritePageList(term^.Pages);
  Writeln;
  if sub then
    WriteHT(term^.SubTerm,tabs+1);
end;

//����� ������� ����������� ���-�������
procedure WriteHT;
var
  i:integer;
  x:TPT;
begin
  for i:=1 to HTCount do
  begin
    //����� ������ ��������
    x:=table[i]^.Next;

    while x<>nil do
    begin
      WriteTerm(x,tabs,true);
      x:=x^.Next;
    end;
  end;
end;


//����� ����������� ������
procedure WriteFindResult(rez:FPT;sub:boolean);
var
  i,j,tabs:integer;
  x:FPT;
  y:APT;
begin
  i:=1;
  x:=rez^.Next;
  if x = nil then Writeln(RusWR('������ �� ������'));
  while x<>nil do
  begin
    Writeln(i,':');
    i:=i+1;

    //����� ������
    tabs:=0;
    y:=x^.Address^.Next;
    while y<>nil do
    begin
      //�������
      for j:=1 to tabs do
        write('  ');
      tabs:=tabs+1;

      writeln(RusWR(y^.Point));
      y:=y^.Next;
    end;
    //����� �����������
    WriteTerm(x^.Result,tabs,sub);
    x:=x^.Next;
  end;
end;

//����� ������ ������ ������� � �������� ������������ � ������ ������������ ��� �������������.
// � rez ������������ ��������� ��� ���������� ����������
function FindOneTerm(rez:FPT):FPT;
var
  n,i:integer;
  frez:FPT;
begin
  frez:=rez;

  if rez^.Next=nil then //������ �� ������
  begin
    result:=nil;
    exit;
  end
  //������ ���� ���������
  else if rez^.Next^.Next=nil then
    frez:=rez^.Next
  //������� ����� �����������
  else
  begin
    Writeln(RusWR('���� ������� ��������� ������: '));
    WriteFindResult(frez,false);
    Write(RusWR('� ����� �� ������ ���������� ������: '));
    Readln(n);

    //������� ��� ����� �������� ������������� ���������
    for i:=1 to n do
      frez:=frez^.Next;
  end; //if frez^.Next=nil

  //�������� ������
  result:=frez;
end;

procedure DeleteTerm(var par:THashTable;frez:TPT);
var
  x:TPT;
begin
  x:=par[H(frez^.Word)];  //���������� ������ ���-�������

  //�����
  while (x^.Next <>nil) and (x^.Next^.Word <>frez^.Word) do
    x:=x^.Next;

  //������
  x^.Next:=x^.Next^.Next;
end;

procedure WriteSPT(x:SPT;tabs:integer);
var
  i:integer;
begin
  while x <> nil do
  begin
    //����������� ����� ��������
    for i:= 1 to tabs do
      write('   ');

    //����� �������
    write(RusWR(x^.Word),' ');
    WritePageList(x^.Pages);
    Writeln;

    //����� �����������
    WriteSPT(x^.SubTerms,tabs+1);

    x:=x^.Next;
  end;
end;

//����������� ����� ���������� �� ���������
function PrSortByPages(HT:THashTable):SPT;
var
  x:TPT;
  y,prev,sort:SPT;
  i:integer;
begin
  New(sort);
  sort^.Next:=nil;

  for i := 1 to HTCount do  //��� ������ ������ ���-�������
  begin
    x:=HT[i]^.Next;

    while  x<>nil  do      //��� ������� �������� ������
    begin
      y:=sort^.Next;
      prev:=sort;

      //������� ���� �������
      while (y<>nil) and (y^.Pages^.Next^.Page < x^.Pages^.Next^.Page) do
      begin
        prev:=prev^.Next;
        y:=y^.Next;
      end;

      //�������
      prev^.Next:=GetSPT(x^.Word,x^.Pages^.Next);
      prev^.Next^.Next :=y;

      //���������� ����������
      prev^.Next^.SubTerms :=PrSortByPages(x^.SubTerm);

      x:=x^.Next;
    end;
  end;

  result:= sort^.Next;
end;

//���������� �� �������� � ����� ����������
procedure SortByPages;
begin
  WriteSPT(PrSortByPages(Terms),0);
end;


procedure WriteHelp;
begin
  Writeln(RusWR('���������� ������:'));
  Writeln(RusWR('   add   - �������� ������/���������'));
  Writeln(RusWR('   add�  - �������� �������� � �������'));
  Writeln(RusWR('   del   - ������� ������'));
  Writeln(RusWR('   delp  - ������� ��������'));
  Writeln(RusWR('   edit  - �������� ������'));
  Writeln(RusWR('   editp - �������� ��������'));
  Writeln(RusWR('   find  - ����� �������/����������'));
  Writeln(RusWR('   sorta - ������� ��������� ��������������� �� ��������'));
  Writeln(RusWR('   sortp - ������� ��������� ��������������� �� ���������'));
  Writeln(RusWR('   print - ������� ���������� ���������'));
  Writeln(RusWR('   help  - �������� ������ ����������'));
  Writeln(RusWR('   exit  - �����'));
end;

var
  com:string;
  upterm,p:string;
  frez:TPT;
  find:FPT;
  AddHT:THashTable;
  page,prev:PPT;
begin
  Initialize(Terms);     //�������������� �������� ���-������� ����������

  //��������� ���������� �������
  AddTerm(Terms,GetTPT(('�������'),GetPPT(250)));
  AddPage(Terms[H(('�������'))]^.Next^.Pages,GetPPT(252));
  AddPage(Terms[H(('�������'))]^.Next^.Pages,GetPPT(870));
  AddPage(Terms[H(('�������'))]^.Next^.Pages,GetPPT(963));

  AddTerm(Terms[H(('�������'))]^.Next^.SubTerm,GetTPT('�����',GetPPT(542)));
  AddTerm(Terms[H(('�������'))]^.Next^.SubTerm,GetTPT('������',GetPPT(987)));
  AddTerm(Terms[H(('�������'))]^.Next^.SubTerm,GetTPT('������',GetPPT(570)));
  AddTerm( FindTerm(GetTPT('������',nil))^.Next^.Result^.SubTerm, GetTPT(('���������'),GetPPT(100)));

  AddTerm(Terms,GetTPT(('����'),nil));
  AddPage(Terms[H(('����'))]^.Next^.Pages,GetPPT(180));
  AddPage(Terms[H(('����'))]^.Next^.Pages,GetPPT(258));
  AddPage(Terms[H(('����'))]^.Next^.Pages,GetPPT(300));

  AddTerm(Terms[H(('����'))]^.Next^.SubTerm,GetTPT('�������',GetPPT(400)));
  AddTerm(Terms[H(('����'))]^.Next^.SubTerm,GetTPT('�����',GetPPT(580)));
  AddTerm(Terms[H(('����'))]^.Next^.SubTerm,GetTPT('������',GetPPT(503)));

  AddTerm(Terms,GetTPT(('������'),GetPPT(259)));




  WriteHelp;
  Writeln;

  Write(RusWR('�������: '));
  Readln(com);

  while com <> 'exit' do
  begin
    if (com = 'sorta') or (com='print') then
      WriteHT(Terms,0)
    else if com =  'help' then
      WriteHelp

    //���������� ��������
    else if com = 'add' then
    begin
      Write(RusWR('������� ��������� ������������ ������� ('''' - ������ ���������): '));
      Readln(upterm);
      upterm:=RusRD(upterm);

      if upterm = '' then  AddHT:=Terms //��������� � ������
      else
      begin
        //��������� ������
        frez:=GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm,nil))));
        if frez=nil then //��������� �� ������
        begin
          WriteLn(RusWR('��������� �� ������'));
          continue;
        end;

        //���-������� ��� ����������
        AddHT:=frez^.SubTerm;
      end;//if upterm = ''

      //������� ���������
      Write(RusWR('������� ����������� ������: '));
      Readln(upterm);
      upterm:=RusRD(upterm);

      if LittleFindTerm(GetTPT(upterm,nil),AddHT) = nil then //������ ��� ���
      begin
        //���� ��������
        Write(RusWR('������� ����� ��������: '));
        Readln(p);

        AddTerm(AddHT,GetTPT(upterm,GetPPT(StrToInt(p))));
        Writeln(RusWR('������ ������� ��������'));
      end
      else //����� ��� ����
        Writeln(RusWR('����� ������ ��� ����'));
    end
    //���������� ��������
    else if com='addp' then
    begin
      Write(RusWR('������� ������: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      frez:=GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm,nil))));

      if frez=nil then
        Writeln(RusWR('������ �� ������'))
      else
      begin
        Write(RusWR('������� ����� ��������: '));
        Readln(upterm);

        AddPage(frez^.Pages,GetPPT(StrToInt(upterm)));
        Writeln(RusWR('�������� ������� ���������'));
      end;
    end

    //�������� ������
    else if com='edit' then
    begin
      Write(RusWR('������� ������: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      find:=FindOneTerm(FindTerm(GetTPT(upterm,nil)));
      frez:=GetTermFormFind(find);

      if frez=nil then
        Writeln(RusWR('������ �� ������'))
      else
      begin
        Write(RusWR('������� ����� ��������: '));
        Readln(upterm);
        upterm:=RusRD(upterm);

        //������ �������� �������� - ������ ���������� ����������. ������� ������
        // ������� ��������������� ������ ������ � ������� ����� ������
        AddHT:=GetParrent(find);
        DeleteTerm(AddHT,frez);
        frez^.Word:=upterm;
        AddTerm(AddHT,frez);

        Writeln(RusWR('������ ������� ������'));
      end;
    end

    //�������� ��������
    else if com='editp' then
    begin
      Write(RusWR('������� ������: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      frez:=GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm,nil))));

      if frez=nil then
        Writeln(RusWR('������ �� ������'))
      else
      begin
        Write(RusWR('������� ������ ��������: '));
        Readln(upterm);

        //������ ������ ��������
        page:=FindPage(frez^.Pages,GetPPT(StrToInt(upterm)),prev);

        if page=nil then
          Writeln(RusWR('�������� �� �������'))
        else
        begin
          Write(RusWR('������� ����� ��������: '));
          Readln(upterm);

          page^.Page:=StrToInt(upterm);
          Writeln(RusWR('�������� ������� �������'));
        end;
      end;
    end

    //�����
    else if com='find' then
    begin
      Write(RusWR('������� ������: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      WriteFindResult(FindTerm(GetTPT(upterm,nil)),true);
    end

    //������� �������
    else if com='del' then
    begin
      Write(RusWR('������� ������: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      //���������� � ������� ������ � ��������� ������ ��� ��������� ��������
      find:=FindOneTerm(FindTerm(GetTPT(upterm,nil)));
      frez:=GetTermFormFind(find);

      if frez=nil then
        Writeln(RusWR('������ �� ������'))
      else
      begin
        AddHT:=GetParrent(find);
        DeleteTerm(AddHT,frez);
        Writeln(RusWR('������ ����� �������'))
      end;
    end

    //������� ��������
    else if com='delp' then
    begin
      Write(RusWR('������� ������: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      frez:=GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm,nil))));

      if frez=nil then
        Writeln(RusWR('������ �� ������'))
      else if frez^.Pages^.Next^.Next = nil then //������� ��������� �������� ������
        Writeln(RusWR('���������� ������� ������������ ��������'))
      else
      begin
        Write(RusWR('������� ����� ��������: '));
        Readln(upterm);

        //������ ������ ��������
        page:=FindPage(frez^.Pages,GetPPT(StrToInt(upterm)),prev);

        if page=nil then
          Writeln(RusWR('�������� �� �������'))
        else
        begin
          prev^.Next:=page^.Next;

          Writeln(RusWR('�������� ������� �������'));
        end;
      end;
    end

    //���������� �� ���������
    else if com='sortp' then
      SortByPages;

    Writeln;
    Write(RusWR('�������: '));
    Readln(com);
  end; //while true
end.



//128-159,240   �-133