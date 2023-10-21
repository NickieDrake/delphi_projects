unit uDocs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TtfrmDocs = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    function Show():TModalResult;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  tfrmDocs: TtfrmDocs;

implementation

{$R *.dfm}



procedure TtfrmDocs.FormCreate(Sender: TObject);
begin
  Label1.Caption:= '';

end;

function TtfrmDocs.Show():TModalResult;
begin
  Label1.Caption:= 'Приложение "AVIACASE" предназначено для'+#10#13+
                   'оптимизации работы аэропортов. В функционал'+#10#13+
                   'входит просмотр и добавление рейсов, работа'+#10#13+
                   'с файлами, а также возможность протестировать'+#10#13+
                   'приложение с рандомно сгенерированными'+#10#13+
                   'тестовыми рейсами.';
  Result:= ShowModal;
end;

end.
