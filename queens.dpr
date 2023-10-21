program ферзи;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

const N=8;

type Index = 1..N;
	places = array [Index] of 0..N;
  tmatrix = array[Index,Index] of 0..N;

var X: places;
    count: word;
    mas: tmatrix;
    i, j: Index;

function check(var X: places; column,row: Index): boolean;
var i: Index;
   begin
     i:= 1;
     while (i<column)and(row<>X[i])and(abs(column-i)<>abs(row-X[i])) do
        inc(i);
     check:= (i=column);
   end;

procedure queenplace(column: Index);
var i, j, row: Index;
   begin
     for row:= 1 to N do
       if check(X,column,row) then
         begin
           X[column]:= row;
	         if (column = N) then
	           begin
                write(count, ': ');
	             for i:= 1 to N do
                begin
                 write('[', chr(i+64),X[i], '] ');
                 mas[X[i],i]:= 1;
                end;
               writeln;
               writeln;
               for i := 1 to N do
                 begin
                   for j := 1 to N do
                     begin
                       write(mas[i,j], ' ');
                       mas[i,j]:= 0;
                     end;
                   writeln;
                 end;
               writeln;
               writeln;
               inc(count)
	           end;
	         queenplace(column + 1)
	       end

   end;

 begin
    for i := 1 to N do
      begin
        for j := 1 to N do
          begin
            mas[i,j]:= 0;
          end;
        //writeln;
      end;
   count:=1;
   writeln('Расстановки ',N,' ферзей:');
   writeln;
   queenplace(1);
   writeln('Количество возможных расстановок: ', (count - 1));
   readln;
 end.
