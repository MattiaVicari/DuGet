object frmBase: TfrmBase
  Left = 0
  Top = 0
  Width = 391
  Height = 291
  Anchors = [akLeft, akTop, akRight, akBottom]
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object boxMain: TUPanel
    Left = 0
    Top = 0
    Width = 391
    Height = 291
    CustomTextColor = clBlack
    CustomBackColor = clWhite
    Align = alClient
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
    object txtTitle: TUText
      Left = 0
      Top = 0
      Width = 391
      Height = 38
      Align = alTop
      Alignment = taCenter
      Caption = 'Page title'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -28
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      WordWrap = True
      ThemeManager = AppThemeManager
      TextKind = tkTitle
      ExplicitWidth = 115
    end
  end
  object AppThemeManager: TUThemeManager
    Left = 40
    Top = 12
  end
end
