unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TMSFNCRibbon, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCPageControl, FMX.TMSFNCTabSet, FMX.TMSFNCHTMLText,
  FMX.TMSFNCToolBar, FMX.TMSFNCCustomControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.TMSFNCTreeViewBase,
  FMX.TMSFNCTreeViewData, FMX.TMSFNCCustomTreeView, FMX.TMSFNCTreeView, FMX.TMSFNCGridCell, FMX.TMSFNCGridOptions,
  FMX.TMSFNCCustomScrollControl, FMX.TMSFNCGridData, FMX.TMSFNCCustomGrid, FMX.TMSFNCGrid, Data.DB,
  Aurelius.Bind.BaseDataset, Aurelius.Bind.Dataset, FMX.TMSFNCCustomComponent, FMX.TMSFNCGridDatabaseAdapter, dmData,
  DBScheme, System.Generics.Collections, FMX.TMSFNCSplitter, FMX.TMSFNCCustomPicker, FMX.TMSFNCDatePicker, EditDlg,
  System.IOUtils;

type
  TMainForm = class(TTMSFNCRibbonForm)
    Ribbon: TTMSFNCRibbon;
    TMSFNCRibbon1QAT: TTMSFNCRibbonQAT;
    TMSFNCRibbon1Caption: TTMSFNCRibbonCaption;
    TMSFNCRibbon1BottomContainer: TTMSFNCRibbonBottomContainer;
    TMSFNCRibbon1Icon: TTMSFNCRibbonIcon;
    TMSFNCRibbon1SystemMenu: TTMSFNCRibbonSystemMenu;
    TMSFNCRibbon1SystemMenuHelpButton: TTMSFNCRibbonSystemMenuToolBarButton;
    TMSFNCRibbon1SystemMenuMaximizeButton: TTMSFNCRibbonSystemMenuToolBarButton;
    TMSFNCRibbon1SystemMenuMinimizeButton: TTMSFNCRibbonSystemMenuToolBarButton;
    TMSFNCRibbon1SystemMenuCloseButton: TTMSFNCRibbonSystemMenuToolBarButton;
    TMSFNCRibbon1Wrapper: TTMSFNCRibbonToolBarWrapper;
    TMSFNCRibbon1PageControl: TTMSFNCRibbonPageControl;
    RibbonButtonFile: TTMSFNCRibbonFileButton;
    TMSFNCRibbon1PageControlContainer: TTMSFNCRibbonContainer;
    TMSFNCRibbon1PageControlPage0: TTMSFNCRibbonPageControlContainer;
    TMSFNCRibbon1PageControlPage1: TTMSFNCRibbonPageControlContainer;
    TMSFNCRibbon1PageControlPage2: TTMSFNCRibbonPageControlContainer;
    ToolbarExpenses: TTMSFNCRibbonToolBar;
    btnAdd: TTMSFNCRibbonDefaultToolBarButton;
    btnEdit: TTMSFNCRibbonDefaultToolBarButton;
    TMSFNCRibbonToolBarSeparator1: TTMSFNCRibbonToolBarSeparator;
    TMSFNCRibbonDefaultToolBarButton1: TTMSFNCRibbonDefaultToolBarButton;
    tvCategories: TTMSFNCTreeView;
    Grid: TTMSFNCGrid;
    gdaExpenses: TTMSFNCGridDatabaseAdapter;
    dsExpenses: TDataSource;
    TMSFNCSplitter1: TTMSFNCSplitter;
    dtFrom: TTMSFNCDatePicker;
    Label1: TLabel;
    Label2: TLabel;
    dtTo: TTMSFNCDatePicker;
    TMSFNCRibbonToolBarSeparator2: TTMSFNCRibbonToolBarSeparator;
    btnHTMLReport: TTMSFNCRibbonDefaultToolBarButton;
    btnReportExcel: TTMSFNCRibbonDefaultToolBarButton;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure tvCategoriesAfterCheckNode(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer);
    procedure tvCategoriesAfterUnCheckNode(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer);
    procedure DateFilterSelected(Sender: TObject; ADate: TDate);
    procedure btnModifyClick(Sender: TObject);
    procedure btnHTMLReportClick(Sender: TObject);
  private
    procedure BuildTree;
    procedure BuildToolbars;
    procedure CheckNode(ANode: TTMSFNCTreeViewNode; AChecked: Boolean);
    procedure DoExitClick(Sender: TObject);
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.btnHTMLReportClick(Sender: TObject);
begin
  var Dlg := TSaveDialog.Create(Self);
  try
    Dlg.Title := 'Export to HTML';
    Dlg.Filter := 'HTML files (*.htm;*.html)|*.htm;*.html|Any files (*.*)|*.*';
    if Dlg.Execute then
    begin
      var FileName := Dlg.FileName;
      if not TPath.HasExtension(FileName) then
        FileName := FileName + '.html';
      Grid.SaveToHTML(FileName);
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TMainForm.btnModifyClick(Sender: TObject);
var
  Dlg: TEditDialog;
begin
  if Sender = btnAdd then
  begin
    Dm.adExpenses.Append;
  end
  else
    Dm.adExpenses.Edit;
  Dlg := TEditDialog.Create(Self);
  try
    if Dlg.Open(Dm.adExpenses.Current<TExpense>) then
      Dm.adExpenses.Post
    else
      Dm.adExpenses.Cancel;
  finally
    Dlg.Free;
  end;
end;

procedure TMainForm.BuildToolbars;
begin
  var tbo := TTMSFNCRibbonToolBar.Create(Self);
  TTMSFNCUtils.SetFontSize(tbo.Font, 11);
  tbo.Text := 'File';
  tbo.OptionsMenu.ShowButton := False;
  tbo.Appearance.DragGrip := False;
  tbo.SetControlMargins(1, 1, 1, 1);
  tbo.AutoSize := False;
  tbo.AutoAlign := False;
  tbo.Width := 115;
  tbo.Height := 85;
  RibbonButtonFile.DropDownControl := tbo;

  var btn := tbo.AddButton;
  btn.ControlAlignment := caTop;
  btn.Text := 'Exit';
  btn.HorizontalTextAlign := gtaLeading;
  btn.Height := 25;
  btn.SetControlMargins(3, 3, 3, 3);
  btn.OnClick := DoExitClick;

end;

procedure TMainForm.BuildTree;
var
  OwnerNode: TTMSFNCTreeViewNode;
begin
  var Categories := DM.Manager.Find<TCategory>.OrderBy('ID').List;
  var Owners := TDictionary<TCategory, TTMSFNCTreeViewNode>.Create;
  tvCategories.BeginUpdate;
  try
    tvCategories.ClearNodes;
    tvCategories.ClearColumns;
    tvCategories.Columns.Add.Text := 'Categories';
    for var Category in Categories do
    begin
      if (Category.OwnerID = nil) or not Owners.TryGetValue(Category.OwnerID, OwnerNode) then
        OwnerNode := nil;
      var Node := tvCategories.AddNode(OwnerNode);
      Node.Text[0] := Category.Name;
      Node.CheckTypes[0] := tvntCheckBox;
      Node.Checked[0] := True;
      Node.DataInteger := Category.Id;
      Node.Expanded := True;
      Owners.Add(Category, Node);
      Dm.VisibleCategories.Add(Node.DataInteger, 0);
    end;
  finally
    tvCategories.EndUpdate;
    Owners.Free;
    Categories.Free;
  end;
end;

procedure TMainForm.CheckNode(ANode: TTMSFNCTreeViewNode; AChecked: Boolean);
begin
  ANode.Checked[0] := AChecked;
  if AChecked then
    Dm.VisibleCategories.TryAdd( ANode.DataInteger, 0 )
  else
    Dm.VisibleCategories.Remove( ANode.DataInteger );
  var Node := ANode.GetFirstChild;
  while Assigned(Node) do
  begin
    CheckNode(Node, AChecked);
    Node := ANode.GetNextChild(Node);
  end;
end;

procedure TMainForm.DateFilterSelected(Sender: TObject; ADate: TDate);
begin
  Dm.SetDateFilter(dtFrom.SelectedDate, dtTo.SelectedDate);
end;

procedure TMainForm.DoExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  BuildToolbars;
  BuildTree;
  gdaExpenses.Active := True;
end;

procedure TMainForm.tvCategoriesAfterCheckNode(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer);
begin
  CheckNode(ANode.Node, True);
  Dm.RefreshExpenses;
end;

procedure TMainForm.tvCategoriesAfterUnCheckNode(Sender: TObject; ANode: TTMSFNCTreeViewVirtualNode; AColumn: Integer);
begin
  CheckNode(ANode.Node, False);
  Dm.RefreshExpenses;
end;

end.
