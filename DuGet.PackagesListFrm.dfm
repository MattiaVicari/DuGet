object frmPackagesList: TfrmPackagesList
  Left = 0
  Top = 0
  Width = 603
  Height = 432
  Anchors = [akLeft, akTop, akRight, akBottom]
  Color = clWhite
  ParentBackground = False
  ParentColor = False
  TabOrder = 0
  object txtTitle: TUText
    Left = 0
    Top = 0
    Width = 603
    Height = 38
    Align = alTop
    Alignment = taCenter
    Caption = 'Lista dei pacchetti'
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
    ExplicitWidth = 221
  end
  object AppThemeManager: TUThemeManager
    Left = 504
    Top = 24
  end
end
