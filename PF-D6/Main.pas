unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids, DBGrids, DB, dmData, Contnrs, CommCtrl,
  EditDlg, ExpensesRpt;

type
  TMainForm = class(TForm)
    pnCategories: TPanel;
    Splitter1: TSplitter;
    pnGrid: TPanel;
    pnCategoriesCaption: TPanel;
    Label1: TLabel;
    tvCategories: TTreeView;
    Panel1: TPanel;
    Label2: TLabel;
    pnFilters: TPanel;
    lbFrom: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label3: TLabel;
    DateTimePicker2: TDateTimePicker;
    DBGrid: TDBGrid;
    pnGridControls: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    DataSource: TDataSource;
    btnReport: TButton;
    procedure FormCreate(Sender: TObject);
    procedure tvCategoriesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnModifyClick(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure btnReportClick(Sender: TObject);
  private
    FUpdating: Boolean;
    procedure BuildTree;
    procedure CheckSubNode(Node: TTreeNode);
    function GetChecked(Node: TTreeNode): Boolean;
    procedure SetChecked(Node: TTreeNode; Checked: Boolean);
    procedure UpdateCategoryFilter;
    function FindCategoryNode(CategoryID: Integer): TTreeNode;
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

const
  TVIS_CHECKED = $2000;

{ TMainForm }

procedure TMainForm.BuildTree;
var
  Owners: TBucketList;
  Item, OwnerItem: TTreeNode;
begin
  FUpdating := True;
  tvCategories.Items.BeginUpdate;
  try
    Owners := TBucketList.Create;
    try
      with DM.TableCategories do
      begin
        First;
        while not EOF do
        begin
          if FieldByName('OwnerID').AsInteger > 0 then
          begin
            if not Owners.Find(Pointer(FieldByName('OwnerID').AsInteger), Pointer(OwnerItem)) then
              OwnerItem := nil;
          end
          else
            OwnerItem := nil;
          Item := tvCategories.Items.AddChild(OwnerItem, FieldByName('Name').AsString);
          Item.Data := Pointer(FieldByName('ID').AsInteger);
          SetChecked(Item, True);
          Owners.Add(Item.Data, Item);
          Next;
        end;
      end;
    finally
      Owners.Free;
    end;
    tvCategories.FullExpand;
  finally
    tvCategories.Items.EndUpdate;
    FUpdating := False;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
const
  TVS_CHECKBOXES          = $0100;
begin
  SetWindowLong(tvCategories.Handle, GWL_STYLE, GetWindowLong(tvCategories.Handle, GWL_STYLE) or TVS_CHECKBOXES);
  BuildTree;
end;

procedure TMainForm.tvCategoriesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NodeParent, Node: TTreeNode;
  Checked: Boolean;
begin
    Node := tvCategories.GetNodeAt(X, Y);
    if (Node <> nil) and  (tvCategories.GetHitTestInfoAt(X, Y) = [htOnItem, htOnStateIcon]) then
    begin
      SetChecked(Node, GetChecked(Node));
      CheckSubNode(Node);
    end;
    if Node.Parent<>nil then
    begin
      NodeParent := Node.Parent;
      Node := NodeParent.getFirstChild;
      Checked := False;
      while Assigned(Node) do
      begin
        if GetChecked(Node) then
          Checked := True;
        Node := NodeParent.GetNextChild(Node);
      end;
      if not Checked then
        SetChecked(NodeParent, false)
      else
        SetChecked(NodeParent, true);
    end;
end;

procedure TMainForm.CheckSubNode(Node: TTreeNode);
var
  flag: boolean;
begin
  if not Node.HasChildren then Exit;
  flag := GetChecked(Node);
  Node := Node.getFirstChild;
  while Assigned(Node) do
  begin
    SetChecked(Node, flag);
    CheckSubNode(Node);
    Node := Node.GetNextChild(Node);
  end;
end;

function TMainForm.GetChecked(Node: TTreeNode): Boolean;
var
  Item: TTVItem;
begin
  Item.Mask  := TVIF_STATE;
  Item.hItem := Node.ItemId;
  TreeView_GetItem(Node.TreeView.Handle, Item);
  Result := (Item.State and TVIS_CHECKED) = TVIS_CHECKED;
end;

procedure TMainForm.SetChecked(Node: TTreeNode; Checked: Boolean);
var
  Item: TTVItem;
begin
  FillChar(Item, SizeOf(TTVItem), 0);
  with Item do
  begin
    hItem     := Node.ItemId;
    Mask      := TVIF_STATE;
    StateMask := TVIS_STATEIMAGEMASK;
    if Checked then
      Item.State :=TVIS_CHECKED
    else
      Item.State :=TVIS_CHECKED shr 1;
    TreeView_SetItem(Node.TreeView.Handle, Item);
  end;
  if Checked then
  begin
    if not DM.VisibleCategories.Exists(Node.Data) then
      DM.VisibleCategories.Add(Node.Data, nil)
  end
  else
    DM.VisibleCategories.Remove(Node.Data);
  UpdateCategoryFilter;
end;

procedure TMainForm.UpdateCategoryFilter;
begin
  if FUpdating then
    Exit;
  DM.TableExpenses.Filtered := False;
  DM.TableExpenses.Filtered := True;
end;

procedure TMainForm.btnModifyClick(Sender: TObject);
var
  Dlg: TEditDialog;
  Node: TTreeNode;
begin
  if Sender = btnAdd then
    DM.TableExpenses.Append
  else
    DM.TableExpenses.Edit;
  Dlg := TEditDialog.Create(Self);
  try
    if Dlg.ShowModal <> mrOk then
      DM.TableExpenses.Cancel
    else
    begin
      Node := FindCategoryNode(DM.TableExpenses.FieldByName('CategoryID').AsInteger);
      DM.TableExpenses.Post;
      if Node <> nil then
        SetChecked(Node, True);
    end;
  finally
    Dlg.Free;
  end;
end;

function TMainForm.FindCategoryNode(CategoryID: Integer): TTreeNode;
var
  i: Integer;
begin
  for i := 0 to tvCategories.Items.Count-1 do
    if Integer(tvCategories.Items[i].Data) = CategoryID then
    begin
      Result := tvCategories.Items[i];
      Exit;
    end;
  Result := nil;
end;

procedure TMainForm.DataSourceDataChange(Sender: TObject; Field: TField);
begin
  btnEdit.Enabled := not DM.TableExpenses.EOF;
  btnDelete.Enabled := not DM.TableExpenses.EOF;
end;

procedure TMainForm.btnReportClick(Sender: TObject);
begin
  with TExpensesReport.Create(Application) do
  try
    Preview;
  finally
    Free;
  end;
end;

end.
