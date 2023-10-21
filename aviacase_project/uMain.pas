unit uMain;

interface

uses
  System.SysUtils;

const
  N = 103680;
  //N = 10;



type
  TOnModelChanged = procedure of object;

  Tinfo = record
    ID: integer;
    Date: string[6];
    Time: string[5];
    FromCity: string[20];
    ToCity: string[20];
    AviaCo: string[20];
  end;

  TShortInfo = record
    ID: integer;
    Date: string[6];
  end;

  TIndex = record
    A: byte;
    B: byte;
    C: byte;
    D: byte;
    E: byte;
  end;

  PRecInterval = ^TIntElement;
  TIntElement = record
    Next: PRecInterval;
    Index: TIndex;
    MaxDate: string[6];
  end;

  PRecRangeOne = ^TRangeOneElement;
  TRangeOneElement = record
    Next: PRecRangeOne;
    NInt: PRecInterval;
    MaxDate: string[6];
  end;

  PRecRangeTwo = ^TRangeTwoElement;
  TRangeTwoElement = record
    Next: PRecRangeTwo;
    NROne: PRecRangeOne;
    MaxDate: string[6];
  end;

  PRecRangeThree = ^TRangeThreeElement;
  TRangeThreeElement = record
    Next: PRecRangeThree;
    NRTwo: PRecRangeTwo;
    MaxDate: string[6];
  end;

  PRecBin = ^TBinElement;
  TBinElement = record
    Next: PRecBin;
    NRThree: PRecRangeThree;
    MaxDate: string[6];
  end;

  TMonth = array [0 .. 11] of string[3];
  TDay = array [0..30] of string[2];
  THour = array [0 .. 23] of string[2];
  TMinutes = array [0 .. 5] of string[2];
  TCities = array [0 .. 49] of string[20];
  TCompanies = array [0 .. 14] of string[20];

  TArray = array of Tinfo;
  TArraySup = array [1 .. N] of Tinfo;
  FileArray = file of TInfo;

  TArrayStructure = array of array of array of array of array of TShortInfo;
  // [8, 8, 10, 9, 18]



  const
  Mon: TMonth = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
    'Oct', 'Nov', 'Dec');

  Day: TDay = ('1', '2', '3', '4', '5', '6', '7', '8', '9',
  '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22',
  '23', '24', '25', '26', '27', '28','29', '30', '31' );


  Hour: THour = ('00', '01', '02', '03', '04', '05', '06', '07', '08', '09',
    '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21',
    '22', '23');

  Minutes: TMinutes = ('00', '10', '20', '30', '40', '50');

  Cities: TCities = ('Берлин', 'Чикаго', 'Мадрид', 'Рим', 'Вена', 'Мюнхен',
    'Вильнюс', 'Рига', 'Таллин', 'Варшава', 'Москва', 'Санкт-Петербург',
    'Париж', 'Осло', 'Загреб', 'Сплит', 'Брюссель', 'Дубай', 'Абу-Даби',
    'Стамбул', 'Анкара', 'Измир', 'Барселона', 'Вашингтон',
    'Франкфурт-на-Майне', 'Нью-Йорк', 'Кёльн', 'Джакарта', 'Калининград',
    'Киев', 'Львов', 'Минск', 'Лиссабон', 'Бразилиа', 'Мехико', 'Торонто',
    'Лос-Анджелес', 'Бостон', 'Коппенгаген', 'Лондон', 'Владивосток', 'Сеул',
    'Пекин', 'Пусан', 'Гонг-Конг', 'Токио', 'Киото', 'Нур-Султан', 'Бухарест',
    'Майами');

  AviaCompanies: TCompanies = ('Qatar Airways', 'United Airlines', 'Qantas',
    'Eurowings', 'China Airlines', 'Japan Airlines', 'airBaltic', 'Aeromexico',
    'Air France', 'Belavia', 'Emirates', 'Finnair', 'Transavia', 'SunExpress',
    'Turkish Airlines');


    procedure newMakingArrayStructure(SomeArray: TArray;
                              var SomeStructure: TArrayStructure; FileLen: integer);
    procedure ArrayMaking(var MainArray: TArraySup);

    procedure QuickSort(var SomeArray: TArray; left, right: integer);

    function IntervalsCreating( DataStr: TArrayStructure; var Ind: TIndex;
                     var FileLen: integer; var EndOfData: boolean):PRecInterval;
    function RangesOneCreating( DataStr: TArrayStructure; var Ind: TIndex;
                var FileLen: integer; var EndOfData: boolean):PRecRangeOne;
    function RangesTwoCreating( DataStr: TArrayStructure; var Ind: TIndex;
                       var FileLen: integer; var EndOfData: boolean):PRecRangeTwo;
    function RangesThreeCreating( DataStr: TArrayStructure; var Ind: TIndex;
                  var FileLen: integer; var EndOfData: boolean; count: byte ):PRecRangeThree;
    procedure IndexSequenceCreating( DataStr: TArrayStructure;
                               var FirstElement:PRecBin; FileLen: integer );

    function SearchElement(Index: TIndex; SuchDate: string;
             DataStr: TArrayStructure; var Number: TIndex; key: integer): boolean;
    function SearchInterval(HighElement: PRecInterval;SuchDate: string; DataStr: TArrayStructure;
             var Number: TIndex; key: integer; var OblElement: PRecRangeOne): boolean;
    function SearchRange1(HighElement: PRecRangeOne;SuchDate: string;
                DataStr: TArrayStructure; var Number: TIndex; key: integer): boolean;
    function SearchRange2(HighElement: PRecRangeTwo;SuchDate: string;
        DataStr: TArrayStructure; var Number: TIndex; key: integer): boolean;
    function SearchRange3(HighElement: PRecRangeThree; SuchDate: string;
             DataStr: TArrayStructure; var Number: TIndex; key: integer): boolean;
    procedure AllElementsSearch (SearchID: integer; SortedArray: TArray;
          var FindArray: TArray; var amount: integer);
    procedure InsertProcesing(Number: TIndex; var FileLen: integer;var DataStr: TArrayStructure;
    SuchDate: string; var SortedArray, FFileArray: TArray; var NewRecord: TInfo);

    procedure Searching(FirstElement: PRecBin; var DataStr: TArrayStructure;
         var SortedArray, FFileArray: TArray; var key: integer;var FileLen: integer;
         var existflag: boolean; Date: String; var FindArray: TArray; var NewRecord: TInfo);

    procedure DisposeAll( var DataStr: TArrayStructure;
             var FFileArray, SortedArray: TArray; var FirstIndSec:PRecBin);



implementation



procedure newMakingArrayStructure(SomeArray: TArray;
                             var SomeStructure: TArrayStructure; FileLen: integer);
  var a, b, c, d, e, i: integer;
  const range3 = 12;
        range2 = 8;
        range1 = 10;
        interval = 9;
        int_elements = 18;
  begin
     i:= 0;
     a:= 0;
     b:= 0;
     c:= 0;
     d:= 0;
     e:= 0;
     while (a < range3) and (i <= FileLen) do
       begin
        while (b < range2) and (i <= FileLen) do
          begin
           while (c < range1) and (i <= FileLen) do
             begin
              while (d < interval) and (i <= FileLen) do
                begin
                 while (e < int_elements) and (i <= FileLen) do
                    begin
                      SomeStructure[a,b,c,d,e].ID:= SomeArray[i].ID;
                      SomeStructure[a,b,c,d,e].Date:= SomeArray[i].Date;
                      i:= i + 1;
                      e:= e + 1;
                    end;
                 d:= d + 1;
                 e:= 0;
                end;
              c:= c + 1;
              d:= 0;
             end;
           b:= b + 1;
           c:= 0;
          end;
        a:= a + 1;
        b:= 0;
       end;


  end;


// для создания файла -------------------------------------------------------
  procedure ArrayMaking(var MainArray: TArraySup);
var
  i, day, cityfrom, cityto, monthnumber: integer;
  month: string[3];

begin
  randomize;
  for i := 1 to N do
    begin
      MainArray[i].ID := i;

      monthnumber := random(12);

      case monthnumber of
        1:
          day := 1 + random(28);
        0,2,4,6,7,9,11:
          day := 1 + random(31);
        else
          day := 1 + random(30);
      end;

      month:= Mon[monthnumber];

      MainArray[i].Date := month + '.' + inttostr(day);

      MainArray[i].Time := Hour[random(23)] + ':' + Minutes[random(5)];

      cityfrom := random(49);
      cityto := (cityfrom + random(17) + 1) mod 49;
      MainArray[i].FromCity := Cities[cityfrom];
      MainArray[i].ToCity := Cities[cityto];

      MainArray[i].AviaCo := AviaCompanies[random(14)];
    end;
  //writeln(MainArray[1].FromCity);
end;


  // быстрая сортировка одномерного массива
  procedure QuickSort(var SomeArray: TArray; left, right: integer);
 var
    i, j: integer;
    mid: string[6];
    temp: TInfo;
begin
    i := left;
    j := right;
    mid := SomeArray[(left + right) div 2].Date;
    repeat
        while SomeArray[i].Date < mid do
          begin
            inc(i);
          end;
        while SomeArray[j].Date > mid do
          begin
            dec(j);
          end;
        if i <= j then
          begin
            temp := SomeArray[i];
            SomeArray[i] := SomeArray[j];
            SomeArray[j] := temp;
            inc(i);
            dec(j);
          end
    until i > j;
    if left < j then
        QuickSort(SomeArray, left, j);
    if i < right then
        QuickSort(SomeArray, i, right)
end;




  // создание индексированной последовательности---------------------------
  //создание списка из 9 интервалов
 function IntervalsCreating( DataStr: TArrayStructure; var Ind: TIndex;
                     var FileLen: integer; var EndOfData: boolean):PRecInterval;
   var  curr, temp, FirstElement, help: PRecInterval;
        i: byte;
 begin
    new(FirstElement);
    curr:= FirstElement;
    i:= 0;
    while (i <= 8) and (EndOfData = false) do
      begin
        if FileLen <= 18 then
          begin
            EndOfData:= true;
            Ind.E:= FileLen - 1;
          end
        else
          begin
            FileLen:= FileLen - 18;
          end;
        curr^.Index:= Ind;                                    //!!!
        curr^.MaxDate:= DataStr[Ind.A, Ind.B, Ind.C, Ind.D, (Ind.E)].Date;
        new(temp);
        curr^.Next:= temp;
        curr:= temp;
        Ind.D:= Ind.D + 1;
        i:= i + 1;


      end;

      // создание дополнительных пустых интервалов
      while i<=9 do
       begin
         curr^.MaxDate:= '0';
         if i=9 then
           curr^.next:= nil
         else
           begin
             new(temp);
             curr^.Next:= temp;
             curr:= temp;
           end;
         i:= i+1;
       end;
      Ind.D:= Ind.D - 1;
   Result:= FirstElement;
 end;

  //создание списка из 10 областей 1-го уровня
 function RangesOneCreating( DataStr: TArrayStructure; var Ind: TIndex;
                var FileLen: integer; var EndOfData: boolean):PRecRangeOne;
   var  curr, temp, FirstElement: PRecRangeOne;
        i: byte;
 begin
    new(FirstElement);
    curr:= FirstElement;
    i:= 0;
    while (i <= 9) and (EndOfData = false) do
      begin
        Ind.D:= 0;
        curr^.NInt:= IntervalsCreating(DataStr, Ind, FileLen, EndOfData);

        curr^.MaxDate:= DataStr[Ind.A, Ind.B, Ind.C, (Ind.D), (Ind.E)].Date;

        if i=9 then
           curr^.next:= nil
         else
           begin
             new(temp);
             curr^.Next:= temp;
             curr:= temp;
           end;
        Ind.C:= Ind.C + 1;
        i:= i + 1;
      end;

    Ind.C:= Ind.C - 1;

   Result:= FirstElement;
 end;

 //создание списка из 8 областей 2-го уровня
 function RangesTwoCreating( DataStr: TArrayStructure; var Ind: TIndex;
                       var FileLen: integer; var EndOfData: boolean):PRecRangeTwo;
   var  curr, temp, FirstElement: PRecRangeTwo;
        i: byte;
 begin
    new(FirstElement);
    curr:= FirstElement;
    i:= 0;
    while (i <= 7) and (EndOfData = false) do
      begin
        Ind.C:= 0;
        curr^.NROne:= RangesOneCreating(DataStr, Ind, FileLen, EndOfData);

        curr^.MaxDate:= DataStr[Ind.A, Ind.B, Ind.C, (Ind.D), (Ind.E)].Date;

        if i=7 then
           curr^.next:= nil
         else
           begin
             new(temp);
             curr^.Next:= temp;
             curr:= temp;
           end;
        Ind.B:= Ind.B + 1;
        i:= i + 1;
      end;
    //curr:= nil;
    Ind.B:= Ind.B - 1;
   Result:= FirstElement;
 end;


 //создание списка областей 3-го уровня
 function RangesThreeCreating( DataStr: TArrayStructure; var Ind: TIndex;
                  var FileLen: integer; var EndOfData: boolean; count: byte ):PRecRangeThree;
 var  curr, temp, FirstElement: PRecRangeThree;
      i: byte;


 begin
    new(FirstElement);
    curr:= FirstElement;
    i:= 0;


    while (i <= count) and (EndOfData = false) do
      begin
        Ind.B:= 0;
        curr^.NRTwo:= RangesTwoCreating(DataStr, Ind, FileLen, EndOfData);

        curr^.MaxDate:= DataStr[Ind.A, Ind.B, Ind.C, (Ind.D), (Ind.E)].Date;

        if i=count then
           curr^.next:= nil
         else
           begin
             new(temp);
             curr^.Next:= temp;
             curr:= temp;
           end;
        Ind.A:= Ind.A + 1;
        i:= i + 1;
      end;
    //curr:= nil;
    Ind.A:= Ind.A - 1;
   Result:= FirstElement;
 end;

  //создание списка из 2 бин-элементов
  procedure IndexSequenceCreating( DataStr: TArrayStructure;
                               var FirstElement:PRecBin; FileLen: integer );
  var Ind: TIndex;
      curr, temp: PRecBin;
      i, count: byte;
      EndOfData: boolean;
      SupFileLen: integer;
  begin
    Ind.A:= 0;
    Ind.B:= 0;
    Ind.C:= 0;
    Ind.D:= 0;
    Ind.E:= 17;
    SupFileLen:= FileLen;
    EndOfData:= false;

    // сколько будет областей 3-го уровня в каждом бин-элементе
    if FileLen > 129600 then
       count:= 5
    else if FileLen > 103680 then
       count:= 4
    else
       count:= 3;


    curr:= FirstElement;
    i:= 0;
    while (i <= 1) and (EndOfData = false) do
      begin
        curr^.NRThree:= RangesThreeCreating(DataStr, Ind, SupFileLen, EndOfData, count);

        curr^.MaxDate:= DataStr[Ind.A, Ind.B, Ind.C, (Ind.D), (Ind.E)].Date;
        //writeln(curr^.MaxDate);
        if i=1 then
           curr^.next:= nil
         else
           begin
             new(temp);
             curr^.Next:= temp;
             curr:= temp;
           end;
        Ind.A:= Ind.A + 1;
        i:= i + 1;
      end;
    curr:= nil;

  end;
  //---------------------------------------------------------------------------

   function SearchElement(Index: TIndex; SuchDate: string;
             DataStr: TArrayStructure; var Number: TIndex; key: integer): boolean;
    var i, help: integer;
        //flag: boolean;
   begin
      if key = 1 then
       begin
         i:= 0;
         help:= Index.E;
         while i <= help do
           begin
             if DataStr[Index.A, Index.B, Index.C, Index.D, i].Date = SuchDate then
               begin
                 //Number:= DataStr[Index.A, Index.B, Index.C, Index.D, i].ID;
                 Index.E:= i;
                 Number:= Index;
                 i:= help + 1;
                 result:= true;
               end
             else
               i:= i + 1;
           end;
       end
      else
       begin
         result:= true;
         Number:= Index;
       end;
   end;

  function SearchInterval(HighElement: PRecInterval;SuchDate: string;
  DataStr: TArrayStructure; var Number: TIndex; key: integer; var OblElement: PRecRangeOne): boolean;
  var Ind, FrInd, SecInd, NewOblintindex: TIndex;
      fCicle, helpflag: boolean;
      i, j, newoblnum: integer;
      FrElementFrPart, HelpElement, SubHelpElement, MidInt, NewInt, SubNewInt : PRecInterval;
      ActualObl, HelpObl, SubHelpObl: PRecRangeOne;
  begin
    fCicle:= true;
    while (HighElement <> nil) and (fCicle = true) do
    begin
      if HighElement^.MaxDate < SuchDate then
        begin
          if HighElement^.Next = nil then
             begin
               fCicle:= false;
               Result:= false;
             end
          else
             begin
               HighElement:= HighElement^.Next;
             end;
        end
      else
        begin
          Ind:= HighElement^.Index;
          fCicle:= false;
          Result:= SearchElement(Ind, SuchDate, DataStr, Number, key);

           if Number.E = 19 then
              begin
                FrElementFrPart:= HighElement;
                SubHelpElement:= HighElement;
                helpflag:= false;
                while (SubHelpElement^.Next<> nil) and (helpflag = false) do
                  begin
                    if SubHelpElement^.Next.MaxDate = '0' then
                      helpflag:= true
                    else
                      SubHelpElement:= SubHelpElement^.Next;
                  end;
                if helpflag = false then
                  begin

                    SubHelpObl:= OblElement;
                    while SubHelpObl^.Next <> nil do
                       begin
                         SubHelpObl:= SubHelpObl^.Next;
                       end;
                    newoblnum:= SubHelpObl^.NInt^.Index.C +1;
                    NewOblintindex:= OblElement^.NInt^.Index;
                    new(HelpObl);

                    HelpObl^.Next:= OblElement^.Next;
                    OblElement^.Next:= HelpObl;

                    MidInt:= OblElement^.NInt;
                    for i := 1 to 4 do
                      MidInt:= MidInt^.Next;
                    OblElement^.MaxDate:= MidInt^.MaxDate;

                    new(NewInt);
                    HelpObl^.NInt:= NewInt;
                    SubNewInt:= NewInt;
                    for i := 5 to 9 do
                      begin

                        MidInt:= MidInt^.Next;
                        DataStr[NewOblintindex.A, NewOblintindex.B, newoblnum, i-5]:= DataStr[NewOblintindex.A, NewOblintindex.B, NewOblintindex.C, i];

                        SubNewInt^.Index:= NewOblintindex;
                        SubNewInt^.Index.C:= newoblnum;
                        SubNewInt^.Index.D:= i;
                        SubNewInt^.Index.E:= MidInt^.Index.E;
                        SubNewInt^.MaxDate:= MidInt^.MaxDate;
                        new(NewInt);
                        SubNewInt^.Next:= NewInt;
                        SubNewInt:= NewInt;

                        if i = 9 then
                          HelpObl^.MaxDate:= MidInt^.MaxDate;

                        if MidInt^.Index.D = HighElement^.Index.D then
                             HighElement:= SubNewInt;
                        MidInt^.MaxDate:= '0';
                        //MidInt:= MidInt^.Next;
                      end;

                     for i := 1 to 5 do
                       begin
                         SubNewInt^.MaxDate:= '0';
                         new(NewInt);
                         SubNewInt^.Next:= NewInt;
                         SubNewInt:= NewInt;
                       end;

                     SubNewInt:= nil;

                        SubHelpElement:= HighElement;
                        helpflag:= false;
                        while (SubHelpElement^.Next<> nil) and (helpflag = false) do
                          begin
                            if SubHelpElement^.Next.MaxDate = '0' then
                               helpflag:= true
                            else
                               SubHelpElement:= SubHelpElement^.Next;
                          end;
                  end;

                //деление интервалов
                 HelpElement:= SubHelpElement^.Next;

                 SubHelpElement^.Next:= HelpElement^.Next;
                 HelpElement^.Next:= FrElementFrPart^.Next;
                 FrElementFrPart^.Next:= HelpElement;

                 HelpElement^.Index:= FrElementFrPart^.Index;
                 HelpElement^.Index.D:= SubHelpElement.Index.D+1;
                 HelpElement^.Index.E:= 0;
                 FrInd:= FrElementFrPart^.Index;
                 SecInd:= HelpElement^.Index;
                 FrElementFrPart^.MaxDate:= DataStr[FrInd.A, FrInd.B, FrInd.C, FrInd.D, 9].Date;
                 i:= 0;
                 j:= 10;
                 while i<= 9 do
                   begin
                     DataStr[SecInd.A, SecInd.B, SecInd.C, SecInd.D, i]:= DataStr[FrInd.A, FrInd.B, FrInd.C, FrInd.D, j];
                     DataStr[FrInd.A, FrInd.B, FrInd.C, FrInd.D, j].Date:= '0';
                     i:=i+1;
                     j:=j+1;
                   end;
                 HelpElement^.MaxDate:= DataStr[SecInd.A, SecInd.B, SecInd.C, SecInd.D, i-1].Date;

                 if SuchDate <= FrElementFrPart^.MaxDate then
                   Number:= FrInd
                 else
                   Number:= SecInd;

                 Number.E:= 9;
                 HighElement^.Index.E:= Number.E;

              end;
        end;
    end;

    if key <> 1 then
      inc(HighElement^.Index.E);

  end;

  function SearchRange1(HighElement: PRecRangeOne;SuchDate: string;
  DataStr: TArrayStructure; var Number: TIndex; key: integer): boolean;
  var CurrElement: PRecInterval;
      fCicle: boolean;
  begin
    fCicle:= true;
    while (HighElement <> nil) and (fCicle = true) do
    begin
      if HighElement^.MaxDate < SuchDate then
        begin
          if HighElement^.Next = nil then
             begin
               fCicle:= false;
               Result:= false;
             end
          else
             begin
               HighElement:= HighElement^.Next;
             end;
        end
      else
        begin
          CurrElement:= HighElement^.NInt;
          fCicle:= false;
          //writeln(HighElement^.MaxDate);
          Result:= SearchInterval(CurrElement, SuchDate, DataStr, Number, key, HighElement);
        end;
    end;
    //result:= false;
  end;

  function SearchRange2(HighElement: PRecRangeTwo;SuchDate: string;
        DataStr: TArrayStructure; var Number: TIndex; key: integer): boolean;
  var CurrElement: PRecRangeOne;
      fCicle: boolean;
  begin
    fCicle:= true;
    while (HighElement <> nil) and (fCicle = true) do
    begin
      if HighElement^.MaxDate < SuchDate then
        begin
          if HighElement^.Next = nil then
             begin
               fCicle:= false;
               Result:= false;
             end
          else
             begin
               HighElement:= HighElement^.Next;
             end;
        end
      else
        begin
          CurrElement:= HighElement^.NROne;
          fCicle:= false;
         // writeln(HighElement^.MaxDate);
          Result:= SearchRange1(CurrElement, SuchDate, DataStr, Number, key);
        end;
    end;
    //result:= false;
  end;

  function SearchRange3(HighElement: PRecRangeThree; SuchDate: string;
             DataStr: TArrayStructure; var Number: TIndex; key: integer): boolean;
  var CurrElement: PRecRangeTwo;
      fCicle: boolean;
  begin
    //result:= false;
    fCicle:= true;
    while (HighElement <> nil) and (fCicle = true) do
    begin
      if HighElement^.MaxDate < SuchDate then
        begin
          if HighElement^.Next = nil then
             begin
               fCicle:= false;
               Result:= false;
             end
          else
             begin
               HighElement:= HighElement^.Next;
             end;
        end
      else
        begin
          CurrElement:= HighElement^.NRTwo;
          fCicle:= false;
          Result:= SearchRange2(CurrElement, SuchDate, DataStr, Number, key);
        end;
    end;
  end;




  procedure AllElementsSearch (SearchID: integer; SortedArray: TArray;
                   var FindArray: TArray; var amount: integer);
  var i, j: integer;
      flag: boolean;
      Date: string;
      count: integer;
  begin
    flag:= false;
    i:= -1;
    while flag = false do
      begin
        i:= i+1;
        if SortedArray[i].ID = SearchID  then
        begin
           flag := true;
           Date:= SortedArray[i].Date;
        end;
      end;
    count:= 400;
    flag:= false;
    j:= 0;
    SetLength(FindArray, count);
    while flag = false do
      begin
        if SortedArray[i].Date = Date  then
          begin
             FindArray[j]:= SortedArray[i];
             j:= j+1;

             if j>count then
             begin
               count:= count*2;
               SetLength(FindArray, count);
             end;
          end
        else
          flag:= true;
        i:= i+1;
      end;
    amount:= j-1;

  end;


  procedure InsertProcesing(Number: TIndex; var FileLen: integer;var DataStr: TArrayStructure;
       SuchDate: string; var SortedArray, FFileArray: TArray; var NewRecord: TInfo);
  var InsertElement, SubElement: TShortInfo;
      i, preID, len, lerni: integer;
      SubRecord: TInfo;
      PositionInArrayStr: TIndex;
      Time: string;

  begin

    FileLen:= FileLen + 1;

    InsertElement.ID:= FileLen;
    NewRecord.ID:= InsertElement.ID;
    InsertElement.Date:= SuchDate;


    SubElement:= InsertElement;

    PositionInArrayStr:= Number;


    i:= 0;
    while (i <= Number.E) and
       (DataStr[Number.A, Number.B, Number.C, Number.D, i].Date < SuchDate) do
     inc(i);

    preID:= DataStr[Number.A, Number.B, Number.C, Number.D, i].ID;
    lerni:= i;
    //writeln(preID);
    while (i <= Number.E) do
        begin
          SubElement:= DataStr[Number.A, Number.B, Number.C, Number.D, i];
          DataStr[Number.A, Number.B, Number.C, Number.D, i]:= InsertElement;
          InsertElement:= SubElement;
          inc(i);
        end;
     DataStr[Number.A, Number.B, Number.C, Number.D, i]:= InsertElement;


     FFileArray[FileLen-1]:= NewRecord;

     i:= 0;
     while SortedArray[i].ID <> preID do
        inc(i);

     while i < FileLen do
       begin
         SubRecord:= SortedArray[i];
         SortedArray[i]:= NewRecord;
         NewRecord:= SubRecord;
         inc(i);
       end;
     SortedArray[i]:= NewRecord;
  end;


  procedure Searching(FirstElement: PRecBin; var DataStr: TArrayStructure;
  var SortedArray, FFileArray: TArray; var key: integer;
   var FileLen: integer; var existflag: boolean;
   Date: string; var FindArray: TArray; var NewRecord: TInfo);
  var
      Half: PRecRangeThree;
      SuchDate, InsertDate: string;
      Number: TIndex;
      ID, amount: integer;
      badstr, flag: boolean;
  begin


     SuchDate:= Date;
     InsertDate:= Date;

     if FirstElement^.MaxDate >= SuchDate then
        Half:= FirstElement^.NRThree
     else
        Half:= FirstElement^.Next^.NRThree;

     if key = 1 then
       begin
         if SearchRange3(Half, SuchDate, DataStr, Number, key) = false then
           existflag:= false
         else
           begin
             ID:= DataStr[Number.A, Number.B, Number.C, Number.D, Number.E].ID;
             AllElementsSearch(ID, SortedArray, FindArray, amount);
             key:= amount;
           end;

       end
     else
       begin
            if SearchRange3(Half, SuchDate, DataStr, Number, key) = false then
              flag:= false;
            InsertProcesing(Number, FileLen, DataStr, SuchDate, SortedArray, FFileArray, NewRecord);

       end;

  end;

  procedure DisposeAll( var DataStr: TArrayStructure;
    var FFileArray, SortedArray: TArray; var FirstIndSec:PRecBin);

  var ElemRB, SupRB: PRecBin;
      ElemR3, SupR3: PRecRangeThree;
      ElemR2, SupR2: PRecRangeTwo;
      ElemR1, SupR1: PRecRangeOne;
      ElemInt, SupInt: PRecInterval;
  begin
    FFileArray:= nil;
    SortedArray:= nil;
    DataStr:= nil;

    ElemRB:= FirstIndSec;
    while ElemRB <> nil do
      begin
        ElemR3:= ElemRB^.NRThree;
        while ElemR3 <> nil do
          begin
            ElemR2:= ElemR3^.NRTwo;
            while ElemR2 <> nil do
              begin
                ElemR1:= ElemR2^.NROne;
                while ElemR1 <> nil do
                  begin
                    ElemInt:= ElemR1^.NInt;
                    while ElemInt <> nil do
                      begin
                        SupInt := ElemInt;
                        ElemInt := ElemInt^.Next;
                        Dispose(SupInt);

                      end;
                    SupR1 := ElemR1;
                    ElemR1 := ElemR1^.Next;
                    Dispose(SupR1);
                  end;
                SupR2 := ElemR2;
                ElemR2 := ElemR2^.Next;
                Dispose(SupR2);
              end;
            SupR3 := ElemR3;
            ElemR3 := ElemR3^.Next;
            Dispose(SupR3);
          end;
        SupRB := ElemRB;
        ElemRB := ElemRB^.Next;
        Dispose(SupRB);
      end;
  end;



end.
