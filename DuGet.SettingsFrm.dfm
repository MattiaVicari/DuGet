inherited frmSettings: TfrmSettings
  Width = 564
  Height = 399
  ExplicitWidth = 564
  ExplicitHeight = 399
  inherited boxMain: TUPanel
    Width = 564
    Height = 399
    ExplicitWidth = 564
    ExplicitHeight = 399
    DesignSize = (
      564
      399)
    inherited txtTitle: TUText
      Width = 564
      Caption = 'Settings'
      ExplicitWidth = 99
    end
    object txtMessage: TUText
      Left = 0
      Top = 58
      Width = 564
      Height = 62
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Message'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 6710886
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
      ThemeManager = AppThemeManager
      TextKind = tkDescription
    end
    object boxToken: TUPanel
      Left = 77
      Top = 126
      Width = 409
      Height = 267
      CustomTextColor = clBlack
      CustomBackColor = 15132390
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      ShowCaption = False
      TabOrder = 0
      object txtToken: TUText
        Left = 155
        Top = 6
        Width = 105
        Height = 29
        Alignment = taCenter
        AutoSize = False
        Caption = 'Token'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI Semibold'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
        TextKind = tkEntry
      end
      object txtThemeSettings: TUText
        Left = 159
        Top = 88
        Width = 97
        Height = 28
        Caption = 'App theme'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -20
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
        TextKind = tkHeading
      end
      object edtToken: TUEdit
        Left = 39
        Top = 41
        Width = 337
        Height = 30
        ThemeManager = AppThemeManager
        Edit.Left = 4
        Edit.Top = 4
        Edit.Width = 330
        Edit.Height = 23
        Edit.Align = alClient
        Edit.Alignment = taCenter
        Edit.BorderStyle = bsNone
        Edit.Color = clBlack
        Edit.Font.Charset = DEFAULT_CHARSET
        Edit.Font.Color = clWhite
        Edit.Font.Height = -13
        Edit.Font.Name = 'Segoe UI'
        Edit.Font.Style = []
        Edit.ParentFont = False
        Edit.PasswordChar = '*'
        Edit.TabOrder = 0
        BevelOuter = bvNone
        Padding.Left = 4
        Padding.Top = 4
        Padding.Right = 3
        Padding.Bottom = 3
        ParentFont = False
        TabOrder = 0
      end
      object btnSaveSettings: TUButton
        Left = 152
        Top = 231
        Width = 112
        Height = 30
        ThemeManager = AppThemeManager
        CustomBorderColors.None = 15921906
        CustomBorderColors.Hover = 15132390
        CustomBorderColors.Press = 13421772
        CustomBorderColors.Disabled = 15921906
        CustomBorderColors.Focused = 15921906
        CustomBackColors.None = 15921906
        CustomBackColors.Hover = 15132390
        CustomBackColors.Press = 13421772
        CustomBackColors.Disabled = 15921906
        CustomBackColors.Focused = 15921906
        CustomTextColors.Disabled = clGray
        Text = 'Save'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = btnSaveSettingsClick
      end
      object radioDefaultTheme: TURadioButton
        Left = 80
        Top = 131
        Width = 145
        Height = 30
        ThemeManager = AppThemeManager
        IconFont.Charset = DEFAULT_CHARSET
        IconFont.Color = clWindowText
        IconFont.Height = -20
        IconFont.Name = 'Segoe MDL2 Assets'
        IconFont.Style = []
        Group = 'AppTheme'
        CustomActiveColor = 14120960
        Text = 'Use system setting'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        OnClick = radioAppThemeClick
      end
      object radioLightTheme: TURadioButton
        Left = 80
        Top = 156
        Width = 64
        Height = 30
        ThemeManager = AppThemeManager
        IconFont.Charset = DEFAULT_CHARSET
        IconFont.Color = clWindowText
        IconFont.Height = -20
        IconFont.Name = 'Segoe MDL2 Assets'
        IconFont.Style = []
        Group = 'AppTheme'
        CustomActiveColor = 14120960
        Text = 'Light'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        OnClick = radioAppThemeClick
      end
      object radioDarkTheme: TURadioButton
        Left = 80
        Top = 186
        Width = 63
        Height = 30
        ThemeManager = AppThemeManager
        IconFont.Charset = DEFAULT_CHARSET
        IconFont.Color = clWindowText
        IconFont.Height = -20
        IconFont.Name = 'Segoe MDL2 Assets'
        IconFont.Style = []
        Group = 'AppTheme'
        CustomActiveColor = 14120960
        Text = 'Dark'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        OnClick = radioAppThemeClick
      end
    end
  end
  inherited ActivityIndicator: TActivityIndicator
    Top = 126
    ExplicitTop = 126
  end
end
