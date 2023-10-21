program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

const
  HTCount=34;   //Число элементов хеш-таблицы
type
  TPT=^TTermList;
  PPT=^TPageList;
  FPT=^TFindResultList;
  APT=^TAddressList;
  SPT=^TSortTermsList;

  THashTable=array[1..HTCount] of TPT;

  //Список терминов
  TTermList= record
    Word:string;
    SubTerm:THashTable;
    Pages:PPT;
    Next:TPT;
  end;

  //Список страниц
  TPageList=record
    Page:integer;
    Next:PPT;
  end;

  //Список результатов поиска
  TFindResultList = record
    Address:APT;
    Result:TPT;
    Next:FPT;
  end;

  //Список для хранения адреса
  TAddressList = record
    Point:string;
    Next:APT;
  end;

  //Список для хранения отсортированных элементов
  TSortTermsList = record
    Word:string;
    SubTerms:SPT;
    Pages:PPT;
    Next:SPT;
  end;
var
  Terms:THashTable;

//Подготовка строки к выводу в консоль
function RusWR(aStr : String) : String;
begin
  Result := '';
  if Length(aStr) > 0 then begin
    SetLength(Result, Length(aStr));
    CharToOem(PChar(aStr), PChar(Result));
  end;
end;

//Обрабтка строки при вводе
function RusRD(const aStr : String) : String;
begin
  Result := '';
  if Length(aStr) > 0 then begin
    SetLength(Result, Length(aStr));
    OemToChar(PChar(aStr), PChar(Result));
  end;
end;


//Хеш-функция
function H(name:string):integer;
begin
  name:= AnsiUpperCase(name);

  //Заменяем Ё на Е
  if ord(name[1]) = 240 then
    name[1]:=char(133);

  if (ord(name[1])<128) or (ord(name[1])>159) then
    result:=1
  else
    result:=ord(name[1])-191+1;
end;

//Инициализация хеш-таблицы.
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


//Создаем PPT по номеру страницы
function GetPPT(page:integer):PPT;
begin
  New(result);
  result^.Page:=page;
  result^.Next:=nil;
end;

//Добавление страницы
procedure AddPage(var first:PPT; page:PPT);
var
  x:PPT;
begin
  x:=first;    //Берём начало списка

  //Ищем конец
  while x^.Next  <> nil do
    x:=x^.Next;

  x^.Next:=page;
end;

//Создание указателя TPT
function GetTPT(word:string;page:PPT):TPT;
begin
  New(result);
  result^.Word:=Word;               //Заполняем знчение
  New(result^.Pages);                //Заполняем
  result^.Pages^.Next:=page;        //страницы
  //Заполняем подтермины
  Initialize(result^.SubTerm);
  result^.Next:=nil;
end;

//Создание указателя SPT
function GetSPT(word:string;page:PPT):SPT;
begin
  New(result);
  result^.Word:=Word;               //Заполняем знчение
  New(result^.Pages);                //Заполняем
  result^.Pages^.Next:=page;        //страницы
  //Заполняем подтермины
  New(result^.SubTerms);
  result^.Next:=nil;
end;

//Поиск термина только в данной хеш-таблице (без перехода на нижние уровни)
function LittleFindTerm(term:TPT; parrent:THashTable):TPT;
var
  x:TPT;
begin
  x:=parrent[H(term^.Word)]^.Next;  //Определяем ячейку хеш-таблицы

  while (x<>nil) and (x^.Word <>term^.Word) do
    x:=x^.Next;

  result:=x;
end;

//Дописывает к списку first список plus. Изменяя first так, чтобы он ссылался на конец нового списка
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


//Копирование списка адресов
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

//Добавлние элемента в список
procedure AddAddress(var x,add:APT);
var
  y:APT;
begin
  y:=x;

  while y^.Next <> nil do
    y:=y.Next;

  y^.Next:=add;
end;

//Поиск термина (рекурсивный вызов)
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

  //Просматриваем все элемнты ниже текущего уровня
  for i:=1 to HTCount do
  begin
    x:=parrent[i]^.Next;

    //Просматриваем список
    while x <> nil do
    begin
      //Дописываем к адресу текущий элемент
      New(t);
      t^.Point:=x^.Word;
      t^.Next:=nil;
      adr:=CopyAddress(Address);
      AddAddress(adr,t);

      //Продолжим поиск на уровень ниже
      t3:=FTerm(adr,term,x^.SubTerm);
      AddResulTSToList(t1,t3);
      x:=x^.Next;
    end; //While
  end;//for

  FTerm:=rez^.Next;
end;

//Поиск страницы в списке first. В prev зписывается предыдущий эл. списка
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

  //Просматриваем адрес полностью
  while adr<> nil do
  begin
    HT:=LittleFindTerm(GetTPT(adr^.Point,nil),HT)^.SubTerm;  //Получаем новую хеш-таблицу
    adr:=adr^.Next;
  end;

  result:=HT;
end;

//Получение термина по результатам поиска
function GetTermFormFind(x:FPT):TPT;
begin
  result:=LittleFindTerm(x^.Result,GetParrent(x));
end;

//Поиск термина во всём указателе
function FindTerm(term:TPT):FPT;
var
  Adr:APT;
begin
  New(Adr);
  Adr^.Next:=nil;

  New(result);
  result^.Next:=FTerm(Adr,term,Terms);
end;


//Добавление термина в хеш-таблицу
procedure AddTerm(var HT:ThashTable; Term:TPT);
var
  t:integer;
  prev:TPT;
  x:TPT;
begin
  t:=H(Term^.Word);     //Значение Хеш-функции;
  prev:=HT[t];
  x:=prev^.Next;

  //Находим точку вставки или конец списка
  while (x <> nil) and (AnsiLowerCase(x^.Word) < AnsiLowerCase(Term^.Word)) do
  begin
    x:=x^.Next;
    prev:=prev^.Next;
  end;

  //Вставляем
  prev^.Next:=Term;
  Term^.Next:=x;
end;

//Вывод списка страниц
procedure WritePageList(first:PPT);
var
  x:PPT;
begin
  x:=first^.Next;

  while x <> nil do
  begin
    write(x^.Page);
    x:=x^.Next;

    //Запятая нужна только если впереди что-то есть
    if x <> nil then
      write(',');
  end;
end;

procedure WriteHT(table:THashTable;tabs:integer);
  Forward;

//Вывод термина с подтерминами и номерами страниц. Tabs - отступ от начала страницы
procedure WriteTerm(term:TPT;tabs:integer;sub:boolean);
var
  i:integer;
begin
  //необходимое число отступов
  for i:= 1 to tabs do
    write('   ');

  write(RusWR(term^.Word),' ');
  WritePageList(term^.Pages);
  Writeln;
  if sub then
    WriteHT(term^.SubTerm,tabs+1);
end;

//Вывод полного содержимого хеш-таблицы
procedure WriteHT;
var
  i:integer;
  x:TPT;
begin
  for i:=1 to HTCount do
  begin
    //Вывод списка терминов
    x:=table[i]^.Next;

    while x<>nil do
    begin
      WriteTerm(x,tabs,true);
      x:=x^.Next;
    end;
  end;
end;


//Вывод результатов поиска
procedure WriteFindResult(rez:FPT;sub:boolean);
var
  i,j,tabs:integer;
  x:FPT;
  y:APT;
begin
  i:=1;
  x:=rez^.Next;
  if x = nil then Writeln(RusWR('Термин не найден'));
  while x<>nil do
  begin
    Writeln(i,':');
    i:=i+1;

    //Вывод адреса
    tabs:=0;
    y:=x^.Address^.Next;
    while y<>nil do
    begin
      //Отступы
      for j:=1 to tabs do
        write('  ');
      tabs:=tabs+1;

      writeln(RusWR(y^.Point));
      y:=y^.Next;
    end;
    //Вывод подтерминов
    WriteTerm(x^.Result,tabs,sub);
    x:=x^.Next;
  end;
end;

//Поиск только одного термина с запросом пользователю о выборе небходдимого при необходимости.
// В rez возвращается результат для выбранного результата
function FindOneTerm(rez:FPT):FPT;
var
  n,i:integer;
  frez:FPT;
begin
  frez:=rez;

  if rez^.Next=nil then //Термин не найден
  begin
    result:=nil;
    exit;
  end
  //Найден один надтермин
  else if rez^.Next^.Next=nil then
    frez:=rez^.Next
  //Найдено много надтерминов
  else
  begin
    Writeln(RusWR('Были найдены следующие термны: '));
    WriteFindResult(frez,false);
    Write(RusWR('С каким вы хотите продолжить работу: '));
    Readln(n);

    //Находим тот самый указаный пользователем результат
    for i:=1 to n do
      frez:=frez^.Next;
  end; //if frez^.Next=nil

  //Получаем термин
  result:=frez;
end;

procedure DeleteTerm(var par:THashTable;frez:TPT);
var
  x:TPT;
begin
  x:=par[H(frez^.Word)];  //Определяем ячейку хеш-таблицы

  //Поиск
  while (x^.Next <>nil) and (x^.Next^.Word <>frez^.Word) do
    x:=x^.Next;

  //Удаляю
  x^.Next:=x^.Next^.Next;
end;

procedure WriteSPT(x:SPT;tabs:integer);
var
  i:integer;
begin
  while x <> nil do
  begin
    //необходимое число отступов
    for i:= 1 to tabs do
      write('   ');

    //Вывод термина
    write(RusWR(x^.Word),' ');
    WritePageList(x^.Pages);
    Writeln;

    //Вывод подтерминов
    WriteSPT(x^.SubTerms,tabs+1);

    x:=x^.Next;
  end;
end;

//Рекурсивный вызов сортировки по страницам
function PrSortByPages(HT:THashTable):SPT;
var
  x:TPT;
  y,prev,sort:SPT;
  i:integer;
begin
  New(sort);
  sort^.Next:=nil;

  for i := 1 to HTCount do  //Для каждой ячейки хеш-таблицы
  begin
    x:=HT[i]^.Next;

    while  x<>nil  do      //Для каждого элемента списка
    begin
      y:=sort^.Next;
      prev:=sort;

      //Находим точк вставки
      while (y<>nil) and (y^.Pages^.Next^.Page < x^.Pages^.Next^.Page) do
      begin
        prev:=prev^.Next;
        y:=y^.Next;
      end;

      //Вставка
      prev^.Next:=GetSPT(x^.Word,x^.Pages^.Next);
      prev^.Next^.Next :=y;

      //Сортировка подпунктов
      prev^.Next^.SubTerms :=PrSortByPages(x^.SubTerm);

      x:=x^.Next;
    end;
  end;

  result:= sort^.Next;
end;

//Сортировка по станицам и вывод результата
procedure SortByPages;
begin
  WriteSPT(PrSortByPages(Terms),0);
end;


procedure WriteHelp;
begin
  Writeln(RusWR('Справочник команд:'));
  Writeln(RusWR('   add   - добавить термин/подтермин'));
  Writeln(RusWR('   addр  - добавить страницу к термину'));
  Writeln(RusWR('   del   - удалить термин'));
  Writeln(RusWR('   delp  - удалить страницу'));
  Writeln(RusWR('   edit  - изменить термин'));
  Writeln(RusWR('   editp - изменить страницу'));
  Writeln(RusWR('   find  - поиск термина/подтермина'));
  Writeln(RusWR('   sorta - вывести указатель отсортированный по алфавиту'));
  Writeln(RusWR('   sortp - вывести указатель отсортированный по страницам'));
  Writeln(RusWR('   print - вывести содержимое указателя'));
  Writeln(RusWR('   help  - показать данный справочник'));
  Writeln(RusWR('   exit  - выход'));
end;

var
  com:string;
  upterm,p:string;
  frez:TPT;
  find:FPT;
  AddHT:THashTable;
  page,prev:PPT;
begin
  Initialize(Terms);     //Инициализируем основную хеш-таблицу указателей

  //Начальное заполнение таблицы
  AddTerm(Terms,GetTPT(('табурет'),GetPPT(250)));
  AddPage(Terms[H(('табурет'))]^.Next^.Pages,GetPPT(252));
  AddPage(Terms[H(('табурет'))]^.Next^.Pages,GetPPT(870));
  AddPage(Terms[H(('табурет'))]^.Next^.Pages,GetPPT(963));

  AddTerm(Terms[H(('табурет'))]^.Next^.SubTerm,GetTPT('новый',GetPPT(542)));
  AddTerm(Terms[H(('табурет'))]^.Next^.SubTerm,GetTPT('старый',GetPPT(987)));
  AddTerm(Terms[H(('табурет'))]^.Next^.SubTerm,GetTPT('желтый',GetPPT(570)));
  AddTerm( FindTerm(GetTPT('желтый',nil))^.Next^.Result^.SubTerm, GetTPT(('деревяный'),GetPPT(100)));

  AddTerm(Terms,GetTPT(('стол'),nil));
  AddPage(Terms[H(('стол'))]^.Next^.Pages,GetPPT(180));
  AddPage(Terms[H(('стол'))]^.Next^.Pages,GetPPT(258));
  AddPage(Terms[H(('стол'))]^.Next^.Pages,GetPPT(300));

  AddTerm(Terms[H(('стол'))]^.Next^.SubTerm,GetTPT('красный',GetPPT(400)));
  AddTerm(Terms[H(('стол'))]^.Next^.SubTerm,GetTPT('синий',GetPPT(580)));
  AddTerm(Terms[H(('стол'))]^.Next^.SubTerm,GetTPT('желтый',GetPPT(503)));

  AddTerm(Terms,GetTPT(('желтый'),GetPPT(259)));




  WriteHelp;
  Writeln;

  Write(RusWR('Команда: '));
  Readln(com);

  while com <> 'exit' do
  begin
    if (com = 'sorta') or (com='print') then
      WriteHT(Terms,0)
    else if com =  'help' then
      WriteHelp

    //Добавление элемента
    else if com = 'add' then
    begin
      Write(RusWR('Введите надтермин добавляемого термина ('''' - корень указателя): '));
      Readln(upterm);
      upterm:=RusRD(upterm);

      if upterm = '' then  AddHT:=Terms //Добавляем в голову
      else
      begin
        //Результат поиска
        frez:=GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm,nil))));
        if frez=nil then //Надтермин не найден
        begin
          WriteLn(RusWR('Надтермин не найден'));
          continue;
        end;

        //Хеш-таблица для добавления
        AddHT:=frez^.SubTerm;
      end;//if upterm = ''

      //Наконец дбавление
      Write(RusWR('Введите добавляемый термин: '));
      Readln(upterm);
      upterm:=RusRD(upterm);

      if LittleFindTerm(GetTPT(upterm,nil),AddHT) = nil then //Такого ещё нет
      begin
        //Ввод страницы
        Write(RusWR('Введите номер страницы: '));
        Readln(p);

        AddTerm(AddHT,GetTPT(upterm,GetPPT(StrToInt(p))));
        Writeln(RusWR('Термин успешно добавлен'));
      end
      else //Такой уже есть
        Writeln(RusWR('Такой термин уже есть'));
    end
    //Добавление страницы
    else if com='addp' then
    begin
      Write(RusWR('Введите термин: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      frez:=GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm,nil))));

      if frez=nil then
        Writeln(RusWR('Термин не найден'))
      else
      begin
        Write(RusWR('Введите номер страницы: '));
        Readln(upterm);

        AddPage(frez^.Pages,GetPPT(StrToInt(upterm)));
        Writeln(RusWR('Страница успешно добавлена'));
      end;
    end

    //Изменить термин
    else if com='edit' then
    begin
      Write(RusWR('Введите термин: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      find:=FindOneTerm(FindTerm(GetTPT(upterm,nil)));
      frez:=GetTermFormFind(find);

      if frez=nil then
        Writeln(RusWR('Термин не найден'))
      else
      begin
        Write(RusWR('Введите новое значение: '));
        Readln(upterm);
        upterm:=RusRD(upterm);

        //Просто заменить название - нельза разрушится сортировка. Поэтому вместо
        // полного перехеширования удалим староы и добавим новый термин
        AddHT:=GetParrent(find);
        DeleteTerm(AddHT,frez);
        frez^.Word:=upterm;
        AddTerm(AddHT,frez);

        Writeln(RusWR('Термин успешно изменён'));
      end;
    end

    //Изменить страницу
    else if com='editp' then
    begin
      Write(RusWR('Введите термин: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      frez:=GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm,nil))));

      if frez=nil then
        Writeln(RusWR('Термин не найден'))
      else
      begin
        Write(RusWR('Введите старое значение: '));
        Readln(upterm);

        //Находи данную страницу
        page:=FindPage(frez^.Pages,GetPPT(StrToInt(upterm)),prev);

        if page=nil then
          Writeln(RusWR('Страница не найдена'))
        else
        begin
          Write(RusWR('Введите новое значение: '));
          Readln(upterm);

          page^.Page:=StrToInt(upterm);
          Writeln(RusWR('Страница успешно изменёна'));
        end;
      end;
    end

    //Поиск
    else if com='find' then
    begin
      Write(RusWR('Введите термин: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      WriteFindResult(FindTerm(GetTPT(upterm,nil)),true);
    end

    //Удалеие термина
    else if com='del' then
    begin
      Write(RusWR('Введите термин: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      //Запоминаем и искомый термин и результат посика для получения родителя
      find:=FindOneTerm(FindTerm(GetTPT(upterm,nil)));
      frez:=GetTermFormFind(find);

      if frez=nil then
        Writeln(RusWR('Термин не найден'))
      else
      begin
        AddHT:=GetParrent(find);
        DeleteTerm(AddHT,frez);
        Writeln(RusWR('Термин удалён успешно'))
      end;
    end

    //Удалить страницу
    else if com='delp' then
    begin
      Write(RusWR('Введите термин: '));
      Readln(upterm);
      upterm:=RusRD(upterm);
      frez:=GetTermFormFind(FindOneTerm(FindTerm(GetTPT(upterm,nil))));

      if frez=nil then
        Writeln(RusWR('Термин не найден'))
      else if frez^.Pages^.Next^.Next = nil then //Удалить последнюю страницу нельзя
        Writeln(RusWR('Невозможно удалить единственную страницу'))
      else
      begin
        Write(RusWR('Введите номер страницы: '));
        Readln(upterm);

        //Находи данную страницу
        page:=FindPage(frez^.Pages,GetPPT(StrToInt(upterm)),prev);

        if page=nil then
          Writeln(RusWR('Страница не найдена'))
        else
        begin
          prev^.Next:=page^.Next;

          Writeln(RusWR('Страница успешно удалена'));
        end;
      end;
    end

    //Сортировка по страницам
    else if com='sortp' then
      SortByPages;

    Writeln;
    Write(RusWR('Команда: '));
    Readln(com);
  end; //while true
end.



//128-159,240   Е-133