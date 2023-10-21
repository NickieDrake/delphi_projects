program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  pt=^elem;
  elem = record
            Pow:Integer;
            Koef:Integer;
            Next:pt;
  end;
var
  A,B,C:pt;
  x:integer;
{function ReadMN(str:string):elem;
var
  i:Integer;
  first,x,y:^elem;
  zn:integer;
begin
  i:=Pos('x',str);
  New(first);
  first^.Koef := Copy(str,1,i);
  first^.Pow :=Copy(str,

  while i <= length(str) do
  begin
    if str[i] = '-' then zn:=-1
                    else zh:=1;

  i:=i+4;
  end
end;}

function ReadMN(): pt;
var
  rez,x,y:pt;
  i,t,n:integer;
begin
  write('Vvedite stepen: ');
  read(n);
  writeln('Vvedite koeficienty cherz probel');
  new(x);
  rez:=x;
  for i :=n downto 0 do
  begin
    read(t);
    if t<>0 then
    begin
      x^.Koef := t;
      x^.Pow:=i;
      y:=x;
      new(x);
      y^.Next :=x;
    end;
  end;
  y^.Next:=nil;
  Readln;

  ReadMN:=rez;
end;


procedure WriteMN(mn:pt);
var
  start:boolean;
begin
  start:=true;
  while mn <> nil do
  begin
    if (mn^.Koef >0) and (not start) then write('+');
    start:=false;
    if mn^.Pow <> 0 then write(IntToStr(mn^.Koef),'x^',IntToStr(mn^.Pow))
                    else write(IntToStr(mn^.Koef));
    mn:=mn^.Next;
  end;
  writeln;
end;

function Equality(p,q:pt):boolean;
var
  rez:boolean;
begin
  rez:=true;
  while (p<>nil) and (q<>nil) and rez do
  begin
    if (p=nil) and (q=nil) then
      rez:=false
    else
    begin
      if (p^.Pow <> q^.Pow) or (p^.Koef <> q^.Koef) then
        rez:=false;
      p:=p^.Next;
      q:=q^.Next;
    end
  end;
  Equality:=rez;
end;

function Meaning(p:pt;x:integer):integer;
var
  rez:integer;
begin
  rez:=0;
  while p <> nil do
  begin
    rez:=rez + p^.Koef * Round(exp( p^.Pow * ln(x)));
    p:=p^.Next;
  end;
  Meaning:=rez;
end;

procedure Add (out p:pt; q,r:pt);
var
  x,y:pt;
begin
  new(x);
  p:=x;
  while (q<>nil) and (r<>nil) do
  begin
    if q^.Pow > r^.Pow then
    begin
      x^.Pow := q^.Pow;
      x^.Koef := q^.Koef;
      q:=q^.Next;
    end
    else if q^.Pow < r^.Pow then
    begin
      x^.Pow := r^.Pow;
      x^.Koef := r^.Koef;
      r:=r^.Next;
    end
    else
    begin
      x^.Pow := r^.Pow;
      x^.Koef := r^.Koef + q^.Koef;
      q:=q^.Next;
      r:=r^.Next;
    end;
    y:=x;
    new(x);
    y^.Next := x;
  end;
  y^.Next := nil;
end;

{new(x);
  rez:=x;
  for i :=n downto 0 do
  begin
    read(t);
    if t<>0 then
    begin
      x^.Koef := t;
      x^.Pow:=i;
      y:=x;
      new(x);
      y^.Next :=x;
    end;
  end;
  y^.Next:=nil;}

begin
  A:=ReadMN;
  write('Vash mnogochlen: ');
  WriteMN(A);
  writeln;

  writeln('Vtoroy mnogochlen.');
  B:=ReadMN;
  write('Vash mnogochlen: ');
  WriteMN(B);
  writeln;

  write('Vashi mnogochleny ');
  if not Equality(A,B) then write('ne ');
  write('ravny');
  writeln;
  writeln;

  write('Toch rascheta znacheniya: ');
  readln(x);
  writeln('Znachenie pervogo mnogochlena: ',Meaning(A,x));
  writeln;

  Add(C,A,B);
  write('Summa mnogochlenov: ');
  WriteMN(C);
  readln;
end.
