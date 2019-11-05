object frmBase: TfrmBase
  Left = 0
  Top = 0
  Width = 597
  Height = 473
  Anchors = [akLeft, akTop, akRight, akBottom]
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  OnResize = FrameResize
  object boxMain: TUPanel
    Left = 0
    Top = 0
    Width = 597
    Height = 473
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
      Width = 597
      Height = 38
      Align = alTop
      Alignment = taCenter
      Caption = 'Page title'
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
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
  object ActivityIndicator: TActivityIndicator
    Left = 176
    Top = 128
    IndicatorSize = aisXLarge
  end
  object AppThemeManager: TUThemeManager
    Left = 40
    Top = 12
  end
end
