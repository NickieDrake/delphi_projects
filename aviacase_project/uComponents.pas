unit uComponents;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  System.Actions, Vcl.ActnList, Vcl.ComCtrls;

type
  TAVIACASE = class(TForm)
    Panel1: TPanel;
    ActionList1: TActionList;
    actReadFromFile: TAction;
    actInsideCreating: TAction;
    actSearch: TAction;
    actAdd: TAction;
    actSave: TAction;
    btReadFromFiles: TButton;
    btInsideCreating: TButton;
    btSearch: TButton;
    btAdd: TButton;
    btExitWSave: TButton;
    lvRecords: TListView;
    opdiMain: TOpenDialog;
    svdiMain: TSaveDialog;
    btDocs: TButton;
    procedure actReadFromFileExecute(Sender: TObject);
    procedure actSearchExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actInsideCreatingExecute(Sender: TObject);
    procedure btDocsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AVIACASE: TAVIACASE;

implementation

uses   uMain, uSearch, uInsertData, uDocs, uAsk;
{$R *.dfm}

  var FFileArray, SortedArray, FindArray: TArray;
   MainFile: FileArray;
   MainArrStr: TArrayStructure;
   key, FileLen: integer;
   FirstIndSec:PRecBin;
   keyword: string;
   keyflag, flag, existflag, saveflag: boolean;
   ArrayTo: TArraySup;



procedure TAVIACASE.actAddExecute(Sender: TObject);
var Res: TModalResult;
     Date: string;
     Item: TListItem;
     i, num: integer;
     NewRecord: TInfo;
begin
   Res := tfrmInsertData.MakingInsert(NewRecord);
   if Res = mrCancel then Exit;
   Date:= NewRecord.Date;
   key:= 2;
   existflag:= true;
   Searching(FirstIndSec, MainArrStr, SortedArray, FFileArray, key, FileLen, existflag, Date, FindArray, NewRecord);

   showmessage('Рейс успешно добавлен!');
end;



procedure TAVIACASE.actSaveExecute(Sender: TObject);
var
    i: integer;
begin
  if svdiMain.Execute then
   begin
    assignfile(MainFile, svdiMain.FileName);
    rewrite(MainFile);
    for i := 0 to FileLen-1 do
      write(MainFile, FFileArray[i]);
    closefile(MainFile);

    saveflag:= true;

   end;
end;

procedure TAVIACASE.actInsideCreatingExecute(Sender: TObject);
var Res: TModalResult;
    i: integer;
begin
    if saveflag = false then
   begin
     Res:= tfrmAsk.AskForSureness;
     if Res = mrCancel then Exit;
   end;

     if flag = true then
      begin
        DisposeAll(MainArrStr, FFileArray, SortedArray, FirstIndSec);
      end;

     ArrayMaking(ArrayTo);

     SetLength(FFileArray, 135000);
     for I := 1 to 103680 do
       begin
         FFileArray[i-1]:= ArrayTo[i];
       end;
     FileLen:= N;
     SortedArray:= Copy(FFileArray);
     QuickSort(SortedArray, 0, FileLen-1);


     Setlength(MainArrStr, 12, 8, 20, 10, 20);
     newMakingArrayStructure(SortedArray, MainArrStr, FileLen);

     new(FirstIndSec);
     IndexSequenceCreating(MainArrStr, FirstIndSec, FileLen);

     flag:= true;

     btExitWSave.Enabled := true;
     btSearch.Enabled := true;
     btAdd.Enabled := true;
     lvRecords.Items.Clear;
     saveflag:= false;
     showmessage('Данные успешно созданы!');
end;

procedure TAVIACASE.actReadFromFileExecute(Sender: TObject);
var
    i: integer;
    Res: TModalResult;
begin
  if saveflag = false then
   begin
     Res:= tfrmAsk.AskForSureness;
     if Res = mrCancel then Exit;
   end;

  if opdiMain.Execute then
   begin
     if flag = true then
      begin
        DisposeAll(MainArrStr, FFileArray, SortedArray, FirstIndSec);
      end;

     assignfile(MainFile, opdiMain.FileName);
     reset(MainFile);
     i:= 0;
     Setlength(FFileArray, 135000);
     while not(Eof(MainFile)) do
        begin
           read(MainFile, FFileArray[i]);
           i:= i+1;
        end;
     FileLen:= i;

     SortedArray:= Copy(FFileArray);
    QuickSort(SortedArray, 0, FileLen-1);

     Setlength(MainArrStr, 12, 8, 20, 10, 20);
     newMakingArrayStructure(SortedArray, MainArrStr, FileLen);

     new(FirstIndSec);
     IndexSequenceCreating(MainArrStr, FirstIndSec, FileLen);

     flag:= true;

     btExitWSave.Enabled := true;
     btSearch.Enabled := true;
     btAdd.Enabled := true;
     closefile(MainFile);
     lvRecords.Items.Clear;
     saveflag:= false;
     showmessage('Файл успешно загружен!');
   end;
  //showmessage('iiiiiiiiiiiiiiiiii');
end;



procedure TAVIACASE.actSearchExecute(Sender: TObject);
 var Res: TModalResult;
     Date: string;
     Item: TListItem;
     i, num: integer;
     NewRecord: TInfo;
begin
  Res := tfrmSearch.MakingDate(Date);

  if Res = mrCancel then Exit;

  key:= 1;
  existflag:= true;
  Searching(FirstIndSec, MainArrStr, SortedArray, FFileArray, key, FileLen, existflag, Date, FindArray, NewRecord);

  if existflag = false then
     showmessage('Введенной даты не существует в базе рейсов!')
  else
    begin
      lvRecords.Items.Clear;
      for i := 0 to key do
       begin
          Item:= lvRecords.Items.Add;

          Item.Caption := inttostr(FindArray[i].ID);
          Item.SubItems.Add(FindArray[i].Date);
          Item.SubItems.Add(FindArray[i].Time);
          Item.SubItems.Add(FindArray[i].FromCity);
          Item.SubItems.Add(FindArray[i].ToCity);
          Item.SubItems.Add(FindArray[i].AviaCo);
       end;
    end;
  FindArray:= nil;
end;

procedure TAVIACASE.btDocsClick(Sender: TObject);
var Res: TModalResult;
begin
  Res := tfrmDocs.Show;
end;

procedure TAVIACASE.FormCreate(Sender: TObject);
begin
  flag:= false;
  saveflag:= true;
  showmessage('                   Компания "РаХом" приветствует Вас!                                           Давайте начнем работу с AVIACASE.');
end;

procedure TAVIACASE.FormDestroy(Sender: TObject);
begin
  if flag = true then
    DisposeAll(MainArrStr, FFileArray, SortedArray, FirstIndSec);
end;

end.
