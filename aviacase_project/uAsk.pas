unit uAsk;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TtfrmAsk = class(TForm)
    lbAsk: TLabel;
    btOK: TButton;
    btNo: TButton;
    procedure FormCreate(Sender: TObject);
    function  AskForSureness(): TModalResult;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  tfrmAsk: TtfrmAsk;

implementation

{$R *.dfm}

procedure TtfrmAsk.FormCreate(Sender: TObject);
begin
  lbAsk.Caption:= 'Вы еще не сохранили данные!';
end;

function  TtfrmAsk.AskForSureness(): TModalResult;

begin

  Result:= ShowModal;

end;

end.
