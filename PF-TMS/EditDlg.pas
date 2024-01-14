unit EditDlg;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TMSFNCButton, FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, Data.DB,
  Aurelius.Bind.BaseDataset, Aurelius.Bind.Dataset, FMX.TMSFNCCustomControl, FMX.TMSFNCCustomPicker, FMX.TMSFNCComboBox,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, FMX.ListBox, dmData, DBScheme, FMX.Edit, FMX.TMSFNCEdit, Aurelius.Criteria.Linq;

type
  TEditDialog = class(TForm)
    btnOk: TTMSFNCButton;
    btnCancel: TTMSFNCButton;
    lbCategory: TLabel;
    adCategories: TAureliusDataset;
    adCategoriesId: TIntegerField;
    adCategoriesName: TStringField;
    cbCategories: TComboBox;
    bsCategories: TBindSourceDB;
    BindingsList1: TBindingsList;
    lbStore: TLabel;
    cbStores: TComboBox;
    adStores: TAureliusDataset;
    adStoresId: TIntegerField;
    adStoresName: TStringField;
    bsStores: TBindSourceDB;
    lbProduct: TLabel;
    cbProducts: TComboBox;
    adProducts: TAureliusDataset;
    adProductsId: TIntegerField;
    adProductsName: TStringField;
    bsProducts: TBindSourceDB;
    lbAmount: TLabel;
    edAmount: TTMSFNCEdit;
    LinkListControlToField1: TLinkListControlToField;
    LinkListControlToField2: TLinkListControlToField;
    LinkProducts: TLinkListControlToField;
    procedure FormCreate(Sender: TObject);
    procedure cbCategoriesChange(Sender: TObject);
    procedure ControlChange(Sender: TObject);
  private
    procedure SetButtons;
  public
    function Open(AExpense: TExpense): Boolean;
  end;

implementation

{$R *.fmx}

procedure TEditDialog.cbCategoriesChange(Sender: TObject);
begin
  LinkProducts.Active := False;
  try
    adProducts.Close;
    adProducts.SetSourceCriteria(Dm.Manager.Find(TProduct)
      .Where(
        Linq['CategoryId'] = adCategories.Current<TCategory>.Id
      )
    );
    adProducts.Open;
  finally
    LinkProducts.Active := True;
  end;
end;

procedure TEditDialog.ControlChange(Sender: TObject);
begin
  SetButtons;
end;

procedure TEditDialog.FormCreate(Sender: TObject);
begin
  adProducts.Manager := Dm.Manager;

  adCategories.Manager := Dm.Manager;
  adCategories.SetSourceCriteria(Dm.Manager.Find<TCategory>);
  adCategories.Open;
  cbCategories.ItemIndex := 0;

  adStores.Manager := Dm.Manager;
  adStores.SetSourceCriteria(Dm.Manager.Find<TStore>);
  adStores.Open;
end;

function TEditDialog.Open(AExpense: TExpense): Boolean;
begin
  if Assigned(AExpense.ProductId) then
  begin
    adProducts.Locate('Id', AExpense.ProductId.Id, []);
    adCategories.Locate('Id', AExpense.ProductId.CategoryId.Id, []);
  end;
  if Assigned(AExpense.StoreId) then
    adStores.Locate('Id', AExpense.StoreId.Id, []);
  if AExpense.Amount > 0 then
    edAmount.FloatValue := AExpense.Amount;

  SetButtons;

  Result := ShowModal = mrOk;

  if Result then
  begin
    AExpense.ProductId := adProducts.Current<TProduct>;
    AExpense.StoreId := adStores.Current<TStore>;
    AExpense.Amount := edAmount.FloatValue;
  end;
end;

procedure TEditDialog.SetButtons;
begin
  btnOk.Enabled := (cbProducts.ItemIndex > -1) and (edAmount.FloatValue > 0);
end;

end.
