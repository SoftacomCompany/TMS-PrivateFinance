object EditDialog: TEditDialog
  Left = 537
  Top = 366
  BorderStyle = bsDialog
  Caption = 'EditDialog'
  ClientHeight = 220
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 32
    Width = 49
    Height = 13
    Caption = 'Category:'
  end
  object Label2: TLabel
    Left = 32
    Top = 64
    Width = 30
    Height = 13
    Caption = 'Store:'
  end
  object Label3: TLabel
    Left = 32
    Top = 96
    Width = 41
    Height = 13
    Caption = 'Product:'
  end
  object Label4: TLabel
    Left = 32
    Top = 128
    Width = 41
    Height = 13
    Caption = 'Amount:'
  end
  object cbStore: TDBLookupComboBox
    Left = 104
    Top = 60
    Width = 145
    Height = 21
    DataField = 'StoreID'
    DataSource = dsExpenses
    KeyField = 'ID'
    ListField = 'Name'
    ListSource = dsStores
    TabOrder = 1
  end
  object cbProduct: TDBLookupComboBox
    Left = 104
    Top = 92
    Width = 145
    Height = 21
    DataField = 'ProductID'
    DataSource = dsExpenses
    KeyField = 'ID'
    ListField = 'Name'
    ListSource = dsProducts
    TabOrder = 2
  end
  object edAmount: TDBEdit
    Left = 104
    Top = 124
    Width = 121
    Height = 21
    DataField = 'Amount'
    DataSource = dsExpenses
    TabOrder = 3
  end
  object btnOK: TButton
    Left = 200
    Top = 168
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object btnCancel: TButton
    Left = 296
    Top = 168
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object cbCategories: TComboBox
    Left = 104
    Top = 28
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbCategoriesChange
  end
  object dsExpenses: TDataSource
    DataSet = DM.TableExpenses
    Left = 288
    Top = 72
  end
  object dsStores: TDataSource
    DataSet = DM.TableStores
    Left = 312
    Top = 24
  end
  object dsProducts: TDataSource
    DataSet = DM.TableProducts
    Left = 328
    Top = 80
  end
end
