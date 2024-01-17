program PFTMS;

uses
  FastMM4,
  FMX.Forms,
  Main in 'Main.pas' {MainForm},
  dmData in 'dmData.pas' {DM: TDataModule},
  DBScheme in 'DBScheme.pas',
  EditDlg in 'EditDlg.pas' {EditDialog};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.