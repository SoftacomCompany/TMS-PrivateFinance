program PersonalFinance;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  dmData in 'dmData.pas' {DM: TDataModule},
  EditDlg in 'EditDlg.pas' {EditDialog},
  ExpensesRpt in 'ExpensesRpt.pas' {ExpensesReport: TQuickRep};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
