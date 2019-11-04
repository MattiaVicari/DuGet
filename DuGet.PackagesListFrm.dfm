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
      Width = 156
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
      object listPackages: TListView
        AlignWithMargins = True
        Left = 10
        Top = 59
        Width = 583
        Height = 335
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
        TabOrder = 0
        ViewStyle = vsReport
        OnCustomDrawItem = listPackagesCustomDrawItem
        OnMouseMove = listPackagesMouseMove
        OnSelectItem = listPackagesSelectItem
      end
      object boxPackageFilter: TUPanel
        Left = 0
        Top = 0
        Width = 603
        Height = 49
        ThemeManager = AppThemeManager
        CustomTextColor = clBlack
        CustomBackColor = 15132390
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Padding.Top = 5
        Padding.Bottom = 5
        ParentBackground = False
        ParentFont = False
        ShowCaption = False
        TabOrder = 1
        object btnRefresh: TUSymbolButton
          Left = 520
          Top = 5
          Width = 83
          Height = 39
          ThemeManager = AppThemeManager
          SymbolFont.Charset = DEFAULT_CHARSET
          SymbolFont.Color = clWindowText
          SymbolFont.Height = -16
          SymbolFont.Name = 'Segoe MDL2 Assets'
          SymbolFont.Style = []
          TextFont.Charset = DEFAULT_CHARSET
          TextFont.Color = clWindowText
          TextFont.Height = -13
          TextFont.Name = 'Segoe UI'
          TextFont.Style = []
          DetailFont.Charset = DEFAULT_CHARSET
          DetailFont.Color = clWindowText
          DetailFont.Height = -13
          DetailFont.Name = 'Segoe UI'
          DetailFont.Style = []
          Orientation = oVertical
          SymbolChar = #57623
          Text = 'Refresh'
          TextOffset = 20
          Detail = 'Detail'
          ShowDetail = False
          Transparent = True
          Align = alRight
          TabOrder = 0
          TabStop = True
          OnClick = btnRefreshClick
        end
        object searchBox: TSearchBox
          AlignWithMargins = True
          Left = 10
          Top = 15
          Width = 500
          Height = 24
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 5
          Align = alLeft
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelInner = bvNone
          BevelOuter = bvNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnInvokeSearch = searchBoxInvokeSearch
          ExplicitHeight = 23
        end
      end
    end
  end
end
