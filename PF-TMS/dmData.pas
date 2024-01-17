unit dmData;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Aurelius.Bind.BaseDataset, Aurelius.Bind.Dataset, DBScheme, System.IOUtils,
  Aurelius.Comp.Connection, Aurelius.Drivers.Interfaces,  Aurelius.Sql.SQLite,  Aurelius.Schema.SQLite,
  Aurelius.Drivers.SQLite, Aurelius.Engine.ObjectManager, Aurelius.Engine.DatabaseManager, System.Generics.Collections,
  Aurelius.Criteria.Linq;

type
  TDM = class(TDataModule)
    adExpenses: TAureliusDataset;
    adExpensesId: TIntegerField;
    adExpensesDate: TDateField;
    adExpensesAmount: TCurrencyField;
    adExpensesProduct: TStringField;
    adExpensesCategory: TStringField;
    adExpensesStore: TStringField;
    adExpensesProductIdId: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure adExpensesFilterRecord(DataSet: TDataSet; var Accept: Boolean);
  private
    FDBPath: string;
    FConnection: IDBConnection;
    FManager: TObjectManager;
    FVisibleCategories: TDictionary<Integer, Integer>;
    procedure FillCategories;
    procedure FillStores;
    procedure FillProducts;
    procedure FillExpenses;
  public
    property DBPath: string read FDBPath;
    property Manager: TObjectManager read FManager;
    property VisibleCategories: TDictionary<Integer, Integer> read FVisibleCategories;
    procedure RefreshExpenses;
    procedure SetDateFilter(ADateFrom, ADateTo: TDateTime);
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDM }

procedure TDM.adExpensesFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  var CategoryID := TAureliusDataset(Dataset).Current<TExpense>.ProductID.CategoryId.Id;
  Accept := VisibleCategories.ContainsKey(CategoryId);
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  FDBPath := IncludeTrailingPathDelimiter(TPath.Combine(TPath.GetDocumentsPath, 'PersonalFinance'));
  ForceDirectories(FDBPath);
  FDBPath := FDBPath + 'PrivateFinance.db3';
  var bInit := not TFile.Exists(FDBPath);

  FConnection := TSQLiteNativeConnectionAdapter.Create(FDBPath);
  TDatabaseManager.Update(FConnection);
  FManager := TObjectManager.Create(FConnection);

  if bInit then
  begin
    FillCategories;
    FillStores;
    FillProducts;
    FillExpenses;
  end;

  adExpenses.Manager := FManager;
  adExpenses.SetSourceCriteria(FManager.Find<TExpense>);
  adExpenses.Open;

  FVisibleCategories := TDictionary<Integer, Integer>.Create;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FVisibleCategories);
  FreeAndNil(FManager);
end;

procedure TDM.FillCategories;

  function Add(AOwner: TCategory; const AName: string): TCategory;
  begin
    Result := TCategory.Create;
    try
      Result.Name := AName;
      if Assigned(AOwner) then
        Result.OwnerID := AOwner;

      FManager.Save(Result);
    except
      if not FManager.IsAttached(Result) then
        Result.Free;
      raise;
    end;
  end;

var
  Owner: TCategory;
begin
  Owner := Add(nil, 'Products');
  // Add Product categories
  Add(Owner, 'Basic');
  Add(Owner, 'Alcohol');
  Add(Owner, 'Delicacies');
  Owner := Add(nil, 'Manufactured goods');
  // Add Manufactured goods categories
  Add(Owner, 'Household chemicals');
  Add(Owner, 'Textile');
  Add(Owner, 'Miscellaneous');
  Owner := Add(nil, 'Entertainment');
  // Add Entertainment categories
  Add(Owner, 'Movie');
  Add(Owner, 'Clubs');
  Add(Owner, 'Restaurants');
  Add(Owner, 'Just');
  Owner := Add(nil, 'House');
  // Add House categories
  Add(Owner, 'Bills');
  Add(Owner, 'Loans');
  Add(Owner, 'Automobile');
  Add(nil, 'Other'); // Add category Other
end;

procedure TDM.FillExpenses;
const
  CExpenses: array[0..3] of record
    StoreID: Integer;
    ProductID: Integer;
    Amount: Double;
  end = (
    (StoreID: 1; ProductID: 1; Amount: 10.2),
    (StoreID: 1; ProductID: 2; Amount: 12.4),
    (StoreID: 2; ProductID: 4; Amount: 15.1),
    (StoreID: 0; ProductID: 5; Amount: 100.22)
  );
begin
  for var I := Low(CExpenses) to High(CExpenses) do
  begin
    var Expense := TExpense.Create;
    try
      if CExpenses[I].StoreID > 0 then
        Expense.StoreId := Manager.Find<TStore>(CExpenses[I].StoreID);
      Expense.ProductId := Manager.Find<TProduct>(CExpenses[I].ProductID);
      Expense.Amount := CExpenses[i].Amount;
      Expense.Date := Date - Random(10);
      FManager.Save(Expense);
    except
      if not FManager.IsAttached(Expense) then
        Expense.Free;
      raise;
    end;
  end;
end;

procedure TDM.FillProducts;
const
  CProducts: array[0..4] of record
    CategoryID: Integer;
    Name: string;
  end = (
    (CategoryID: 2; Name: 'Bread'),
    (CategoryID: 3; Name: 'Whisky'),
    (CategoryID: 6; Name: 'Soap'),
    (CategoryID: 11; Name: 'Petrol'),
    (CategoryID: 12; Name: 'Girls')
  );
begin
  for var I := Low(CProducts) to High(CProducts) do
  begin
    var Product := TProduct.Create;
    try
      Product.CategoryId := Manager.Find<TCategory>(CProducts[I].CategoryID);
      Product.Name := CProducts[I].Name;
      FManager.Save(Product);
    except
      if not FManager.IsAttached(Product) then
        Product.Free;
      raise;
    end;
  end;
end;

procedure TDM.FillStores;
const
  CStores: array[0..1] of string = ('Walmart', 'Ikea');
begin
  for var I := Low(CStores) to High(CStores) do
  begin
    var Store := TStore.Create;
    try
      Store.Name := CStores[I];
      FManager.Save(Store);
    except
      if not FManager.IsAttached(Store) then
        Store.Free;
      raise;
    end;
  end;
end;

procedure TDM.RefreshExpenses;
begin
  adExpenses.DisableControls;
  try
    adExpenses.Filtered := False;
    adExpenses.Filtered := True;
  finally
    adExpenses.EnableControls;
  end;
end;

procedure TDM.SetDateFilter(ADateFrom, ADateTo: TDateTime);
begin
  adExpenses.DisableControls;
  try
    adExpenses.Close;
    adExpenses.SetSourceCriteria( FManager.Find<TExpense>
      .Where(
        (Linq['Date'] >= ADateFrom) and
        (Linq['Date'] <= ADateTo)
      )
    );
    adExpenses.Open;
  finally
    adExpenses.EnableControls;
  end;
end;

end.
