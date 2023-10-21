unit uSearch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uMain;

type
  TtfrmSearch = class(TForm)
    cbbxMonth: TComboBox;
    cbbxDay: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btOK: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
     function MakingDate(var Date: string): TModalResult;

  end;

var
  tfrmSearch: TtfrmSearch;

implementation

{$R *.dfm}





procedure TtfrmSearch.FormCreate(Sender: TObject);
var i: integer;
begin
  for I := Low(TMonth) to High(TMonth) do
    cbbxMonth.Items.Add(Mon[I]);

  for I := Low(TDay) to High(TDay) do
    cbbxDay.Items.Add(Day[I]);
end;

function  TtfrmSearch.MakingDate(var Date: string): TModalResult;
  var smonth, sday: string;
  //fl: boolean;
begin
  cbbxMonth.ItemIndex := 0;
  cbbxDay.ItemIndex:= 0;
  //cbPriority.ItemIndex := 0;

  Result:= ShowModal;
  if Result = mrOK then
   begin
    smonth:= Mon[cbbxMonth.ItemIndex];
    sday:= Day[cbbxDay.ItemIndex];
    Date:= smonth + '.' + sday;
   end;
end;

end.
