unit DBScheme;

interface

uses
  SysUtils,
  Generics.Collections,
  Aurelius.Mapping.Attributes,
  Aurelius.Types.Blob,
  Aurelius.Types.DynamicProperties,
  Aurelius.Types.Nullable,
  Aurelius.Types.Proxy,
  Aurelius.Criteria.Dictionary;

type
  TCategory = class;
  TExpense = class;
  TProduct = class;
  TStore = class;
  TCategoryTableDictionary = class;
  TExpenseTableDictionary = class;
  TProductTableDictionary = class;
  TStoreTableDictionary = class;

  [Entity]
  [Table('CATEGORIES')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TCategory = class
  private
    [Column('ID', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FId: Integer;

    [Column('NAME', [TColumnProp.Required], 50)]
    FName: string;

    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('OWNER_ID', [], 'ID')]
    FOwnerId: Proxy<TCategory>;
    function GetOwnerId: TCategory;
    procedure SetOwnerId(const Value: TCategory);
  public
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property OwnerId: TCategory read GetOwnerId write SetOwnerId;
  end;

  [Entity]
  [Table('EXPENSES')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TExpense = class
  private
    [Column('ID', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FId: Integer;

    [Column('DATE', [TColumnProp.Required])]
    FDate: TDateTime;

    [Column('AMOUNT', [TColumnProp.Required])]
    FAmount: Double;

    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('PRODUCT_ID', [TColumnProp.Required], 'ID')]
    FProductId: Proxy<TProduct>;

    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('STORE_ID', [], 'ID')]
    FStoreId: Proxy<TStore>;
    function GetProductId: TProduct;
    procedure SetProductId(const Value: TProduct);
    function GetStoreId: TStore;
    procedure SetStoreId(const Value: TStore);
  public
    property Id: Integer read FId write FId;
    property Date: TDateTime read FDate write FDate;
    property Amount: Double read FAmount write FAmount;
    property ProductId: TProduct read GetProductId write SetProductId;
    property StoreId: TStore read GetStoreId write SetStoreId;
  end;

  [Entity]
  [Table('PRODUCTS')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TProduct = class
  private
    [Column('ID', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FId: Integer;

    [Column('NAME', [TColumnProp.Required], 50)]
    FName: string;

    [Association([TAssociationProp.Lazy, TAssociationProp.Required], CascadeTypeAll - [TCascadeType.Remove])]
    [JoinColumn('CATEGORY_ID', [TColumnProp.Required], 'ID')]
    FCategoryId: Proxy<TCategory>;
    function GetCategoryId: TCategory;
    procedure SetCategoryId(const Value: TCategory);
  public
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property CategoryId: TCategory read GetCategoryId write SetCategoryId;
  end;

  [Entity]
  [Table('STORES')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TStore = class
  private
    [Column('ID', [TColumnProp.Required, TColumnProp.NoInsert, TColumnProp.NoUpdate])]
    FId: Integer;

    [Column('NAME', [TColumnProp.Required], 50)]
    FName: string;
  public
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
  end;

  TDicDictionary = class
  private
    FCategory: TCategoryTableDictionary;
    FExpense: TExpenseTableDictionary;
    FProduct: TProductTableDictionary;
    FStore: TStoreTableDictionary;
    function GetCategory: TCategoryTableDictionary;
    function GetExpense: TExpenseTableDictionary;
    function GetProduct: TProductTableDictionary;
    function GetStore: TStoreTableDictionary;
  public
    destructor Destroy; override;
    property Category: TCategoryTableDictionary read GetCategory;
    property Expense: TExpenseTableDictionary read GetExpense;
    property Product: TProductTableDictionary read GetProduct;
    property Store: TStoreTableDictionary read GetStore;
  end;

  TCategoryTableDictionary = class
  private
    FId: TDictionaryAttribute;
    FName: TDictionaryAttribute;
    FOwnerId: TDictionaryAssociation;
  public
    constructor Create;
    property Id: TDictionaryAttribute read FId;
    property Name: TDictionaryAttribute read FName;
    property OwnerId: TDictionaryAssociation read FOwnerId;
  end;

  TExpenseTableDictionary = class
  private
    FId: TDictionaryAttribute;
    FDate: TDictionaryAttribute;
    FAmount: TDictionaryAttribute;
    FProductId: TDictionaryAssociation;
    FStoreId: TDictionaryAssociation;
  public
    constructor Create;
    property Id: TDictionaryAttribute read FId;
    property Date: TDictionaryAttribute read FDate;
    property Amount: TDictionaryAttribute read FAmount;
    property ProductId: TDictionaryAssociation read FProductId;
    property StoreId: TDictionaryAssociation read FStoreId;
  end;

  TProductTableDictionary = class
  private
    FId: TDictionaryAttribute;
    FName: TDictionaryAttribute;
    FCategoryId: TDictionaryAssociation;
  public
    constructor Create;
    property Id: TDictionaryAttribute read FId;
    property Name: TDictionaryAttribute read FName;
    property CategoryId: TDictionaryAssociation read FCategoryId;
  end;

  TStoreTableDictionary = class
  private
    FId: TDictionaryAttribute;
    FName: TDictionaryAttribute;
  public
    constructor Create;
    property Id: TDictionaryAttribute read FId;
    property Name: TDictionaryAttribute read FName;
  end;

function Dic: TDicDictionary;

implementation

var
  __Dic: TDicDictionary;

function Dic: TDicDictionary;
begin
  if __Dic = nil then __Dic := TDicDictionary.Create;
  result := __Dic
end;

{ TCategory }

function TCategory.GetOwnerId: TCategory;
begin
  result := FOwnerId.Value;
end;

procedure TCategory.SetOwnerId(const Value: TCategory);
begin
  FOwnerId.Value := Value;
end;

{ TExpense }

function TExpense.GetProductId: TProduct;
begin
  result := FProductId.Value;
end;

procedure TExpense.SetProductId(const Value: TProduct);
begin
  FProductId.Value := Value;
end;

function TExpense.GetStoreId: TStore;
begin
  result := FStoreId.Value;
end;

procedure TExpense.SetStoreId(const Value: TStore);
begin
  FStoreId.Value := Value;
end;

{ TProduct }

function TProduct.GetCategoryId: TCategory;
begin
  result := FCategoryId.Value;
end;

procedure TProduct.SetCategoryId(const Value: TCategory);
begin
  FCategoryId.Value := Value;
end;

{ TDicDictionary }

destructor TDicDictionary.Destroy;
begin
  if FStore <> nil then FStore.Free;
  if FProduct <> nil then FProduct.Free;
  if FExpense <> nil then FExpense.Free;
  if FCategory <> nil then FCategory.Free;
  inherited;
end;

function TDicDictionary.GetCategory: TCategoryTableDictionary;
begin
  if FCategory = nil then FCategory := TCategoryTableDictionary.Create;
  result := FCategory;
end;

function TDicDictionary.GetExpense: TExpenseTableDictionary;
begin
  if FExpense = nil then FExpense := TExpenseTableDictionary.Create;
  result := FExpense;
end;

function TDicDictionary.GetProduct: TProductTableDictionary;
begin
  if FProduct = nil then FProduct := TProductTableDictionary.Create;
  result := FProduct;
end;

function TDicDictionary.GetStore: TStoreTableDictionary;
begin
  if FStore = nil then FStore := TStoreTableDictionary.Create;
  result := FStore;
end;

{ TCategoryTableDictionary }

constructor TCategoryTableDictionary.Create;
begin
  inherited;
  FId := TDictionaryAttribute.Create('Id');
  FName := TDictionaryAttribute.Create('Name');
  FOwnerId := TDictionaryAssociation.Create('OwnerId');
end;

{ TExpenseTableDictionary }

constructor TExpenseTableDictionary.Create;
begin
  inherited;
  FId := TDictionaryAttribute.Create('Id');
  FDate := TDictionaryAttribute.Create('Date');
  FAmount := TDictionaryAttribute.Create('Amount');
  FProductId := TDictionaryAssociation.Create('ProductId');
  FStoreId := TDictionaryAssociation.Create('StoreId');
end;

{ TProductTableDictionary }

constructor TProductTableDictionary.Create;
begin
  inherited;
  FId := TDictionaryAttribute.Create('Id');
  FName := TDictionaryAttribute.Create('Name');
  FCategoryId := TDictionaryAssociation.Create('CategoryId');
end;

{ TStoreTableDictionary }

constructor TStoreTableDictionary.Create;
begin
  inherited;
  FId := TDictionaryAttribute.Create('Id');
  FName := TDictionaryAttribute.Create('Name');
end;

initialization
  RegisterEntity(TCategory);
  RegisterEntity(TExpense);
  RegisterEntity(TProduct);
  RegisterEntity(TStore);

finalization
  if __Dic <> nil then __Dic.Free

end.
