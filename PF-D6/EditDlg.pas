unit EditDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, StdCtrls, Mask, dmData, DB;

type
  TEditDialog = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    cbStore: TDBLookupComboBox;
    Label3: TLabel;
    cbProduct: TDBLookupComboBox;
    Label4: TLabel;
    edAmount: TDBEdit;
    btnOK: TButton;
    btnCancel: TButton;
    dsExpenses: TDataSource;
    cbCategories: TComboBox;
    dsStores: TDataSource;
    dsProducts: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure cbCategoriesChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure FillCategories;  
  public
  end;

implementation

{$R *.dfm}

procedure TEditDialog.FillCategories;
begin
  cbCategories.Items.BeginUpdate;
  try
    cbCategories.Items.Clear;
    DM.TableCategories.First;
    while not DM.TableCategories.EOF do
    begin
      cbCategories.Items.AddObject(
        DM.TableCategories.FieldByName('Name').AsString,
        TObject(DM.TableCategories.FieldByName('ID').AsInteger));
      DM.TableCategories.Next;
    end;
    cbCategories.ItemIndex := 0;
  finally
    cbCategories.Items.EndUpdate;
  end;
end;

procedure TEditDialog.FormCreate(Sender: TObject);
begin
  FillCategories;
end;

procedure TEditDialog.cbCategoriesChange(Sender: TObject);
begin
  DM.TableProducts.Filtered := False;
  try
    if cbCategories.ItemIndex < 0 then
      DM.TableProducts.Filter := ''
    else
      DM.TableProducts.Filter := 'CategoryID=' + IntToStr(Integer(cbCategories.Items.Objects[cbCategories.ItemIndex]));
  finally
    DM.TableProducts.Filtered := True;
  end;
end;

procedure TEditDialog.FormDestroy(Sender: TObject);
begin
  DM.TableProducts.Filtered := False;
end;

end.
