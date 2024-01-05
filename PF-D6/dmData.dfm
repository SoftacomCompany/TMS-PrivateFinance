object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 347
  Top = 438
  Height = 208
  Width = 382
  object TableCategories: TTable
    DatabaseName = 'Finance'
    StoreDefs = True
    TableName = 'Categories'
    Left = 32
    Top = 24
  end
  object TableExpenses: TTable
    AfterInsert = TableExpensesAfterInsert
    OnCalcFields = TableExpensesCalcFields
    DatabaseName = 'Finance'
    OnFilterRecord = TableExpensesFilterRecord
    TableName = 'Expenses'
    Left = 160
    Top = 32
  end
  object TableStores: TTable
    DatabaseName = 'Finance'
    TableName = 'Stores'
    Left = 240
    Top = 40
  end
  object TableProducts: TTable
    DatabaseName = 'Finance'
    TableName = 'Products'
    Left = 88
    Top = 96
  end
end
