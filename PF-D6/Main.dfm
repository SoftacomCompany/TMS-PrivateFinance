object MainForm: TMainForm
  Left = 527
  Top = 265
  Width = 898
  Height = 689
  Caption = 'Personal finance'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 273
    Top = 0
    Width = 5
    Height = 650
    Cursor = crHSplit
  end
  object pnCategories: TPanel
    Left = 0
    Top = 0
    Width = 273
    Height = 650
    Align = alLeft
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 0
    object pnCategoriesCaption: TPanel
      Left = 4
      Top = 4
      Width = 265
      Height = 28
      Align = alTop
      BevelOuter = bvNone
      Color = clGray
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 5
        Width = 70
        Height = 16
        Caption = 'Categories'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object tvCategories: TTreeView
      Left = 4
      Top = 32
      Width = 265
      Height = 614
      Align = alClient
      BevelInner = bvSpace
      BevelOuter = bvNone
      BorderStyle = bsNone
      Indent = 19
      TabOrder = 1
      OnMouseDown = tvCategoriesMouseDown
    end
  end
  object pnGrid: TPanel
    Left = 278
    Top = 0
    Width = 604
    Height = 650
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 4
    TabOrder = 1
    object Panel1: TPanel
      Left = 4
      Top = 4
      Width = 596
      Height = 28
      Align = alTop
      BevelOuter = bvNone
      Color = clGray
      TabOrder = 0
      object Label2: TLabel
        Left = 16
        Top = 5
        Width = 60
        Height = 16
        Caption = 'Expenses'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnFilters: TPanel
      Left = 4
      Top = 32
      Width = 596
      Height = 47
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lbFrom: TLabel
        Left = 16
        Top = 16
        Width = 28
        Height = 13
        Caption = 'From:'
      end
      object Label3: TLabel
        Left = 168
        Top = 17
        Width = 16
        Height = 13
        Caption = 'To:'
      end
      object DateTimePicker1: TDateTimePicker
        Left = 62
        Top = 12
        Width = 89
        Height = 21
        CalAlignment = dtaLeft
        Date = 45288.9867404861
        Time = 45288.9867404861
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
      end
      object DateTimePicker2: TDateTimePicker
        Left = 214
        Top = 13
        Width = 89
        Height = 21
        CalAlignment = dtaLeft
        Date = 45288.9867404861
        Time = 45288.9867404861
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 1
      end
    end
    object DBGrid: TDBGrid
      Left = 4
      Top = 79
      Width = 596
      Height = 526
      Align = alClient
      DataSource = DataSource
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
    object pnGridControls: TPanel
      Left = 4
      Top = 605
      Width = 596
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      object btnAdd: TButton
        Left = 16
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Add'
        TabOrder = 0
        OnClick = btnModifyClick
      end
      object btnEdit: TButton
        Left = 104
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Edit'
        TabOrder = 1
        OnClick = btnModifyClick
      end
      object btnDelete: TButton
        Left = 208
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 2
      end
      object btnReport: TButton
        Left = 496
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Report'
        TabOrder = 3
        OnClick = btnReportClick
      end
    end
  end
  object DataSource: TDataSource
    DataSet = DM.TableExpenses
    OnDataChange = DataSourceDataChange
    Left = 192
    Top = 272
  end
end
