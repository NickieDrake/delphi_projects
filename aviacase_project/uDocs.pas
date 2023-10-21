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
  Label1.Caption:= '���������� "AVIACASE" ������������� ���'+#10#13+
                   '����������� ������ ����������. � ����������'+#10#13+
                   '������ �������� � ���������� ������, ������'+#10#13+
                   '� �������, � ����� ����������� ��������������'+#10#13+
                   '���������� � �������� ����������������'+#10#13+
                   '��������� �������.';
  Result:= ShowModal;
end;

end.
