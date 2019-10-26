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
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object splitter: TUSeparator
        Left = 413
        Top = 0
        Width = 5
        Height = 394
        ThemeManager = AppThemeManager
        CustomColor = clWhite
        Align = alRight
      end
      object boxPackageInfo: TUPanel
        Left = 418
        Top = 0
        Width = 185
        Height = 394
        CustomTextColor = clBlack
        CustomBackColor = 15132390
        Align = alRight
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        Padding.Left = 15
        Padding.Top = 5
        Padding.Right = 15
        Padding.Bottom = 15
        ParentFont = False
        ShowCaption = False
        TabOrder = 1
        object txtPackageInfo: TUText
          Left = 15
          Top = 5
          Width = 155
          Height = 28
          Align = alTop
          Alignment = taCenter
          Caption = 'Package info'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
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
        Left = 0
        Top = 0
        Width = 413
        Height = 394
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
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = []
        FlatScrollBars = True
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentDoubleBuffered = False
        ParentFont = False
        ShowColumnHeaders = False
        TabOrder = 2
        ViewStyle = vsReport
        OnCustomDrawItem = listPackagesCustomDrawItem
        OnSelectItem = listPackagesSelectItem
      end
    end
  end
end
