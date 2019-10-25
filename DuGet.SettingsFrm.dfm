inherited frmSettings: TfrmSettings
  Width = 564
  Height = 316
  OnResize = FrameResize
  ExplicitWidth = 564
  ExplicitHeight = 316
  inherited txtTitle: TUText
    Width = 564
    Caption = 'Settings'
    ExplicitWidth = 99
  end
  object txtMessage: TUText [1]
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
  object boxToken: TPanel [2]
    Left = 0
    Top = 126
    Width = 337
    Height = 121
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object txtToken: TUText
      Left = 123
      Top = 6
      Width = 105
      Height = 29
      Alignment = taCenter
      AutoSize = False
      Caption = 'Token'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
      ThemeManager = AppThemeManager
      TextKind = tkEntry
    end
    object edtToken: TUEdit
      Left = 0
      Top = 41
      Width = 337
      Height = 30
      ThemeManager = AppThemeManager
      Edit.Left = 4
      Edit.Top = 4
      Edit.Width = 330
      Edit.Height = 23
      Edit.Align = alClient
      Edit.BorderStyle = bsNone
      Edit.Color = clWhite
      Edit.Font.Charset = DEFAULT_CHARSET
      Edit.Font.Color = clBlack
      Edit.Font.Height = -13
      Edit.Font.Name = 'Segoe UI'
      Edit.Font.Style = []
      Edit.ParentFont = False
      Edit.TabOrder = 0
      Edit.ExplicitWidth = 293
      BevelOuter = bvNone
      Padding.Left = 4
      Padding.Top = 4
      Padding.Right = 3
      Padding.Bottom = 3
      ParentFont = False
      TabOrder = 0
    end
    object btnSaveSettings: TUButton
      Left = 116
      Top = 77
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
  end
end
