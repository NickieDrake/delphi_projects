unit uInsertData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, uMain;

type
  TtfrmInsertData = class(TForm)
    lbTime: TLabel;
    lbHours: TLabel;
    lbMinutes: TLabel;
    edFromCity: TLabeledEdit;
    edToCity: TLabeledEdit;
    edAviaCo: TLabeledEdit;
    cbbxMinutes: TComboBox;
    cbbxHours: TComboBox;
    lbInsertData: TLabel;
    lbMonth: TLabel;
    lbDay: TLabel;
    cbbxMonth: TComboBox;
    cbbxDay: TComboBox;
    lbDate: TLabel;
    btOK: TButton;
    btCancel: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function MakingInsert(var NewRecord: TInfo): TModalResult;
  end;





var
  tfrmInsertData: TtfrmInsertData;

implementation

{$R *.dfm}

procedure TtfrmInsertData.FormCreate(Sender: TObject);
var i: integer;
begin
  for I := Low(THour) to High(THour) do
    cbbxHours.Items.Add(Hour[I]);

  for I := Low(TMinutes) to High(TMinutes) do
    cbbxMinutes.Items.Add(Minutes[I]);

  for I := Low(TMonth) to High(TMonth) do
    cbbxMonth.Items.Add(Mon[I]);

  for I := Low(TDay) to High(TDay) do
    cbbxDay.Items.Add(Day[I]);

  edFromCity.Text:='';
  edToCity.Text:='';
  edAviaCo.Text:='';
end;


function  TtfrmInsertData.MakingInsert(var NewRecord: TInfo): TModalResult;
  var stime, smonth, sday: string;
  //fl: boolean;
begin
  cbbxHours.ItemIndex := 0;
  cbbxMinutes.ItemIndex:= 0;
  cbbxMonth.ItemIndex := 0;
  cbbxDay.ItemIndex:= 0;

  Result:= ShowModal;
  if Result = mrOK then
   begin
     smonth:= Mon[cbbxMonth.ItemIndex];
     sday:= Day[cbbxDay.ItemIndex];
     NewRecord.Date:= smonth + '.' + sday;

     stime:= Hour[cbbxHours.ItemIndex] + ':' + Minutes[cbbxMinutes.ItemIndex];
     NewRecord.Time:= stime;

     NewRecord.FromCity:= edFromCity.Text;
     NewRecord.ToCity:= edToCity.Text;
     NewRecord.AviaCo:= edAviaCo.Text;

   end;
end;
end.
