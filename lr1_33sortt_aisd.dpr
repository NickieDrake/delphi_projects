program lr1_33sortt_aisd;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
  pelem = ^elem;

  elem = record
    surname: string;
    number: integer;
    next: pelem;
  end;

 var list: pelem;
 quantity: byte;
 suchname: string;
 suchphone: integer;


 function numvalue( var phone: string): integer;
var flag: boolean;
    ectphone, errorcode: integer;
    //checknum: string;
begin
  flag:= false;
  while flag = false do
     begin
       //readln(num);
       trim(phone);
       val(phone, ectphone, errorcode);
       if (errorcode = 0) and (length(phone) = 7) then
          flag:= true
       else
         begin
          writeln('Неверный ввод, введите число из 7 цифр');
          readln(phone);
         end;
     end;
  result:= ectphone;
end;





procedure add(var a : pelem; name : string; phone: integer);
var
  x, y : pelem;
  found : boolean;
Begin
  x := a;
  found := false;

  while found = false do
  begin
    if (x^.next = nil) or ((x^.next)^.surname > name) or (((x^.next)^.surname = name) and ((x^.next)^.number > phone)) Then
    begin
      new(y);
      y^.surname := name;
      y^.number := phone;
      if x^.next <> nil then
         begin
           y^.next := x^.Next;
           x^.next := y;
         end
      else
         begin
           y^.next := nil;
           x^.next := y;
         end;
      found := true;
    end;
    x := x^.next;
  end;

end;



 function input(quantity: integer): pelem;
var
  name: string[20];
  phone: string;
  i, nphone: integer;
  x, firstelem, y: pelem;
begin
  new(x);
  x^.next:= nil;
  firstelem := x;
  for i := 1 to quantity do
    begin
      writeln('Введите имя ', i, 'го абонента:');
      readln(name);
      writeln;
      writeln('Введите номер ', i, 'го абонента:');
      readln(phone);
       nphone:= numvalue(phone);
       Add(firstelem, name, nphone);
      writeln('____________________________________________');
      writeln;
    end;
  result:= firstelem;
end;



procedure output(list:pelem);
 //var i: integer;
begin
  list:= list^.next;
  while list<>nil do
     begin
       writeln('Ваши абоненты:');
       writeln;
       writeln('Имя: ', list^.surname );
       writeln('Номер телефона: ', list^.number);
       writeln('______________________________');
       list:= list^.next;
     end;
end;


procedure numbersuch(phone:integer; list: pelem);
var find: boolean;
begin
  find:= false;
  writeln('Абоненты с подобным номером:');
  while list<>nil do
    begin
      if list^.number = phone then
        begin
          writeln(list^.surname);
          find:= true;
        end;
      list:= list^.next;
    end;
  if find = false then
    writeln('Абонентов с подобным номером не существует!');
end;


procedure surnamesuch(name: string; list: pelem);
var find: boolean;
begin
  find:= false;
  writeln('Номера абонентов с подобным именем:');
  while list<>nil do
    begin
      if list^.surname = name then
        begin
          writeln(list^.number);
          find:= true;
        end;
      list:= list^.next;
    end;
  if find = false then
    writeln('Абонентов с подобным именем не существует!');
end;

begin

  //quantity:= 0;
  writeln('Введите количество абонентов:');
  readln(quantity);
  while quantity <= 0 do
     readln(quantity);
  list:= input(quantity);
  writeln;
  output(list);
  readln;

  writeln('Введите искомый номер:');
  readln(suchphone);
  numbersuch(suchphone, list);
  readln;

  writeln('Введите искомое имя:');
  readln(suchname);
  surnamesuch(suchname, list);
  readln;

end.
