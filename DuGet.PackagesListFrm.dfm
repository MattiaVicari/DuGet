inherited frmPackagesList: TfrmPackagesList
  Width = 603
  Height = 432
  ExplicitWidth = 603
  ExplicitHeight = 432
  inherited boxMain: TUPanel
    Width = 603
    Height = 432
    ExplicitWidth = 603
    ExplicitHeight = 432
    inherited txtTitle: TUText
      Width = 603
      Caption = 'Packages list'
      ExplicitWidth = 156
    end
    object boxContent: TUPanel
      Left = 0
      Top = 38
      Width = 603
      Height = 394
      ThemeManager = AppThemeManager
      CustomTextColor = clBlack
      CustomBackColor = 15132390
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object boxPackageInfo: TUPanel
        Left = 360
        Top = 0
        Width = 243
        Height = 394
        ThemeManager = AppThemeManager
        CustomTextColor = clBlack
        CustomBackColor = 15132390
        Align = alRight
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Padding.Left = 15
        Padding.Top = 5
        Padding.Right = 15
        Padding.Bottom = 15
        ParentBackground = False
        ParentFont = False
        ShowCaption = False
        TabOrder = 0
        object txtPackageInfo: TUText
          Left = 15
          Top = 5
          Width = 213
          Height = 28
          Align = alTop
          Alignment = taCenter
          Caption = 'Package info'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -20
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          WordWrap = True
          ThemeManager = AppThemeManager
          TextKind = tkHeading
          ExplicitWidth = 110
        end
      end
      object listPackages: TListView
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 340
        Height = 384
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clWhite
        Columns = <
          item
            AutoSize = True
          end>
        ColumnClick = False
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        FlatScrollBars = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentDoubleBuffered = False
        ParentFont = False
        ShowColumnHeaders = False
        TabOrder = 1
        ViewStyle = vsReport
        OnCustomDrawItem = listPackagesCustomDrawItem
        OnSelectItem = listPackagesSelectItem
      end
    end
  end
  inherited ActivityIndicator: TActivityIndicator
    ExplicitWidth = 64
    ExplicitHeight = 64
  end
  object fdmPackages: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 248
    Top = 230
    object fdmPackagesID: TIntegerField
      FieldName = 'ID'
    end
    object fdmPackagesNODE_ID: TStringField
      FieldName = 'NODE_ID'
      Size = 100
    end
    object fdmPackagesNAME: TStringField
      FieldName = 'NAME'
      Size = 100
    end
    object fdmPackagesFULL_NAME: TStringField
      FieldName = 'FULL_NAME'
      Size = 100
    end
    object fdmPackagesHTML_URL: TStringField
      FieldName = 'HTML_URL'
      Size = 1000
    end
    object fdmPackagesDESCRIPTION: TStringField
      FieldName = 'DESCRIPTION'
      Size = 1000
    end
    object fdmPackagesURL: TStringField
      FieldName = 'URL'
      Size = 1000
    end
    object fdmPackagesDOWNLOADS_URL: TStringField
      FieldName = 'DOWNLOADS_URL'
      Size = 1000
    end
    object fdmPackagesCREATED_AT: TDateTimeField
      FieldName = 'CREATED_AT'
    end
    object fdmPackagesUPDATED_AT: TDateTimeField
      FieldName = 'UPDATED_AT'
    end
    object fdmPackagesCLONE_URL: TStringField
      FieldName = 'CLONE_URL'
      Size = 1000
    end
    object fdmPackagesDEFAULT_BRANCH: TStringField
      FieldName = 'DEFAULT_BRANCH'
      Size = 100
    end
    object fdmPackagesPACKAGE_ID: TStringField
      FieldName = 'PACKAGE_ID'
      Size = 100
    end
    object fdmPackagesALTERNATIVE_NAME: TStringField
      FieldName = 'ALTERNATIVE_NAME'
      Size = 100
    end
    object fdmPackagesLOGO_FILENAME: TStringField
      FieldName = 'LOGO_FILENAME'
      Size = 100
    end
    object fdmPackagesLOGO_CACHED_FILEPATH: TStringField
      FieldName = 'LOGO_CACHED_FILEPATH'
      Size = 1000
    end
    object fdmPackagesLICENSES_TYPE: TStringField
      FieldName = 'LICENSES_TYPE'
      Size = 1000
    end
    object fdmPackagesOWNER_ID: TIntegerField
      FieldName = 'OWNER_ID'
    end
    object fdmPackagesOWNER_LOGIN: TStringField
      FieldName = 'OWNER_LOGIN'
      Size = 100
    end
    object fdmPackagesOWNER_NODE_ID: TStringField
      FieldName = 'OWNER_NODE_ID'
      Size = 100
    end
    object fdmPackagesOWNER_AVATAR_URL: TStringField
      FieldName = 'OWNER_AVATAR_URL'
      Size = 1000
    end
  end
end
