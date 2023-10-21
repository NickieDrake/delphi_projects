program avcase;

uses
  Vcl.Forms,
  uComponents in 'uComponents.pas' {AVIACASE},
  uMain in 'uMain.pas',
  uSearch in 'uSearch.pas' {tfrmSearch},
  uInsertData in 'uInsertData.pas' {tfrmInsertData},
  uDocs in 'uDocs.pas' {tfrmDocs},
  uAsk in 'uAsk.pas' {tfrmAsk};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TAVIACASE, AVIACASE);
  Application.CreateForm(TtfrmSearch, tfrmSearch);
  Application.CreateForm(TtfrmInsertData, tfrmInsertData);
  Application.CreateForm(TtfrmDocs, tfrmDocs);
  Application.CreateForm(TtfrmAsk, tfrmAsk);
  Application.Run;
end.
