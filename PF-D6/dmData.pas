unit dmData;

interface

uses
  Windows, SysUtils, Classes, DB, DBTables, ActiveX, ShlObj, Dialogs, Contnrs;

type
  TDM = class(TDataModule)
    TableCategories: TTable;
    TableExpenses: TTable;
    TableStores: TTable;
    TableProducts: TTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure TableExpensesCalcFields(DataSet: TDataSet);
    procedure TableExpensesFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure TableExpensesAfterInsert(DataSet: TDataSet);
  private
    FDBPath: string;
    FVisibleCategories: TBucketList;
    procedure FillCategories;
    procedure FillStores;
    procedure FillProducts;
    procedure FillExpenses;
    procedure CreateTables;
  public
    property DBPath: string read FDBPath;
    property VisibleCategories: TBucketList read FVisibleCategories; 
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

procedure TDM.CreateTables;
begin
  // Categories
  DeleteFile(FDBPath + TableCategories.TableName + '.db');
  with TableCategories.FieldDefs do
  begin
    Clear;
    Add('ID', ftAutoInc, 0, False);
    Add('OwnerID', ftInteger, 0, False);
    Add('Name', ftString, 100, False);
  end;
  with TableCategories.IndexDefs do
  begin
    Clear;
    Add('', 'ID', [ixPrimary, ixUnique]);
  end;
  TableCategories.CreateTable;

  // Stores
  DeleteFile(FDBPath + TableStores.TableName + '.db');
  with TableStores.FieldDefs do
  begin
    Clear;
    Add('ID', ftAutoInc, 0, False);
    Add('Name', ftString, 100, True);
  end;
  with TableStores.IndexDefs do
  begin
    Clear;
    Add('', 'ID', [ixPrimary, ixUnique]);
  end;
  TableStores.CreateTable;

  // Products
  DeleteFile(FDBPath + TableProducts.TableName + '.db');
  with TableProducts.FieldDefs do
  begin
    Clear;
    Add('ID', ftAutoInc, 0, False);
    Add('CategoryID', ftInteger, 0, False);
    Add('Name', ftString, 100, True);
  end;
  with TableProducts.IndexDefs do
  begin
    Clear;
    Add('', 'ID', [ixPrimary, ixUnique]);
  end;
  TableProducts.CreateTable;

  // Expenses
  DeleteFile(FDBPath + TableExpenses.TableName + '.db');
  with TableExpenses.FieldDefs do
  begin
    Clear;
    Add('ID', ftAutoInc, 0, False);
    Add('Date', ftDate, 0, True);
    Add('ProductID', ftInteger, 0, True);
    Add('StoreID', ftInteger, 0, False);
    Add('Amount', ftCurrency, 0, False);
  end;
  with TableExpenses.IndexDefs do
  begin
    Clear;
    Add('', 'ID', [ixPrimary, ixUnique]);
  end;
  TableExpenses.CreateTable;

  FillCategories;
  FillStores;
  FillProducts;
  FillExpenses;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
var
  Allocator: IMalloc;
  SpecialDir: PItemIdList;
  Buf: array[0..MAX_PATH] of Char;
  Field: TField;
  I: Integer;
begin
  if SHGetMalloc(Allocator) = NOERROR then
  begin
    SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, SpecialDir);
    SHGetPathFromIDList(SpecialDir, @Buf[0]);
    Allocator.Free(SpecialDir);
    FDBPath := IncludeTrailingPathDelimiter(string(Buf)) + 'PersonalFinance\';
    ForceDirectories(FDBPath);
  end
  else
  begin
    ShowMessage('Can not access Documents folder');
    Halt(1);
  end;
  FVisibleCategories := TBucketList.Create;
  TableCategories.DatabaseName := FDBPath;
  TableExpenses.DatabaseName := FDBPath;
  TableStores.DatabaseName := FDBPath;
  TableProducts.DatabaseName := FDBPath;
  if not FileExists(FDBPath + 'Categories.db') then
    CreateTables;
  TableExpenses.FieldDefs.Update;
  for I := 0 to TableExpenses.FieldDefs.Count-1 do
    TableExpenses.FieldDefs[I].CreateField(TableExpenses);

  Field := TStringField.Create(TableExpenses.Owner);
  Field.FieldName := 'Product_name';
  Field.DataSet := TableExpenses;
  Field.FieldKind := fkLookup;
  Field.KeyFields := 'ProductID';
  Field.DisplayLabel := 'Product';
  Field.LookupKeyFields := 'ID';
  Field.LookupDataSet := TableProducts;
  Field.LookupResultField := 'Name';
  TableExpenses.FieldByName('ProductID').Visible := False;

  Field := TIntegerField.Create(TableExpenses.Owner);
  Field.FieldName := 'CategoryID';
  Field.DataSet := TableExpenses;
  Field.FieldKind := fkLookup;
  Field.KeyFields := 'ProductID';
  Field.Visible := False;
  Field.LookupKeyFields := 'ID';
  Field.LookupDataSet := TableProducts;
  Field.LookupResultField := 'CategoryID';

  Field := TStringField.Create(TableExpenses.Owner);
  Field.FieldName := 'Category_name';
  Field.DataSet := TableExpenses;
  Field.FieldKind := fkCalculated;
  Field.KeyFields := 'ProductID';
  Field.DisplayLabel := 'Category';
  Field.LookupKeyFields := 'CategoryID';
  Field.LookupDataSet := TableCategories;
  Field.LookupResultField := 'Name';

  Field := TStringField.Create(TableExpenses.Owner);
  Field.FieldName := 'Store_name';
  Field.DataSet := TableExpenses;
  Field.FieldKind := fkLookup;
  Field.KeyFields := 'StoreID';
  Field.DisplayLabel := 'Store';
  Field.LookupKeyFields := 'ID';
  Field.LookupDataSet := TableStores;
  Field.LookupResultField := 'Name';
  TableExpenses.FieldByName('StoreID').Visible := False;

  TableCategories.Active := True;
  TableStores.Active := True;
  TableProducts.Active := True;
  TableExpenses.Active := True;
end;

procedure TDM.FillCategories;

  function Add(AOwnerID: Integer; const AName: string): Integer;
  begin
    TableCategories.Append;
    if AOwnerID > 0 then
      TableCategories.FieldByName('OwnerID').AsInteger := AOwnerID;
    TableCategories.FieldByName('Name').AsString := AName;
    TableCategories.Post;
    Result := TableCategories.FieldByName('ID').AsInteger;
  end;

var
  OwnerID: Integer;
begin
  TableCategories.Active := True;
  OwnerID := Add(0, 'Products');
  // Add Product categories
  Add(OwnerID, 'Basic');
  Add(OwnerID, 'Alcohol');
  Add(OwnerID, 'Delicacies');
  OwnerID := Add(0, 'Manufactured goods');
  // Add Manufactured goods categories
  Add(OwnerID, 'Household chemicals');
  Add(OwnerID, 'Textile');
  Add(OwnerID, 'Miscellaneous');
  OwnerID := Add(0, 'Entertainment');
  // Add Entertainment categories
  Add(OwnerID, 'Movie');
  Add(OwnerID, 'Clubs');
  Add(OwnerID, 'Restaurants');
  Add(OwnerID, 'Just');
  OwnerID := Add(0, 'House');
  // Add House categories
  Add(OwnerID, 'Bills');
  Add(OwnerID, 'Loans');
  Add(OwnerID, 'Automobile');
  Add(0, 'Other'); // Add category Other
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
var
  I: Integer;
begin
  TableExpenses.Active := True;
  for i := Low(CExpenses) to High(CExpenses) do
    with TableExpenses do
    begin
      Append;
      if CExpenses[I].StoreID > 0 then
        FieldByName('StoreID').AsInteger := CExpenses[I].StoreID;
      FieldByName('ProductID').AsInteger := CExpenses[I].ProductID;
      FieldByName('Amount').AsFloat := CExpenses[I].Amount;
      FieldByName('Date').AsDateTime := Date - Random(10);
      Post;
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
var
  I: Integer;
begin
  TableProducts.Active := True;
  for I := Low(CProducts) to High(CProducts) do
    with TableProducts do
    begin
      Append;
      FieldByName('CategoryID').AsInteger := CProducts[I].CategoryID;
      FieldByName('Name').AsString := CProducts[I].Name;
      Post;
    end;
end;

procedure TDM.FillStores;
const
  CStores: array[0..1] of string = ('Walmart', 'Ikea');
var
  I: Integer;
begin
  TableStores.Active := True;
  for I := Low(CStores) to High(CStores) do
    with TableStores do
    begin
      Append;
      FieldByName('Name').AsString := CStores[I];
      Post;
    end;
end;

procedure TDM.TableExpensesCalcFields(DataSet: TDataSet);
begin
  if TableCategories.FindKey([TableExpenses.FieldByName('CategoryID').AsInteger]) then
    TableExpenses.FieldByName('Category_name').AsString := TableCategories.FieldByName('Name').AsString;
end;

procedure TDM.TableExpensesFilterRecord(DataSet: TDataSet; var Accept: Boolean);
var
  ProductID: Integer;
begin
  ProductID := TableExpenses.FieldByName('ProductID').AsInteger;
  Accept := TableProducts.FindKey([ProductID]) and VisibleCategories.Exists(Pointer(TableProducts.FieldByName('CategoryID').AsInteger));
end;

procedure TDM.TableExpensesAfterInsert(DataSet: TDataSet);
begin
  TableExpenses.FieldByName('Date').AsDateTime := Date;
end;

end.
