object DM: TDM
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object adExpenses: TAureliusDataset
    FieldDefs = <>
    OnFilterRecord = adExpensesFilterRecord
    Left = 53
    Top = 33
    object adExpensesId: TIntegerField
      FieldName = 'Id'
    end
    object adExpensesDate: TDateField
      FieldName = 'Date'
    end
    object adExpensesAmount: TCurrencyField
      FieldName = 'Amount'
    end
    object adExpensesProduct: TStringField
      FieldName = 'ProductId.Name'
    end
    object adExpensesCategory: TStringField
      FieldName = 'ProductId.CategoryId.Name'
      Size = 255
    end
    object adExpensesStore: TStringField
      FieldName = 'StoreId.Name'
    end
    object adExpensesProductIdId: TIntegerField
      FieldName = 'ProductId.CategoryId.Id'
    end
  end
end
