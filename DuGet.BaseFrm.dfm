object frmBase: TfrmBase
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  Anchors = [akLeft, akTop, akRight, akBottom]
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object txtTitle: TUText
    Left = 0
    Top = 0
    Width = 320
    Height = 38
    Align = alTop
    Alignment = taCenter
    Caption = 'Page title'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -28
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
    ThemeManager = AppThemeManager
    TextKind = tkTitle
    ExplicitWidth = 115
  end
  object AppThemeManager: TUThemeManager
    Left = 40
    Top = 12
  end
end
