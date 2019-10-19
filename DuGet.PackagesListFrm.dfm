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
    Caption = 'Packages list'
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
    ExplicitWidth = 156
  end
  object scrollPackagesList: TUScrollBox
    Left = 0
    Top = 38
    Width = 398
    Height = 394
    Align = alClient
    BorderStyle = bsNone
    DoubleBuffered = True
    Color = 15132390
    ParentBackground = True
    ParentColor = False
    ParentDoubleBuffered = False
    TabOrder = 0
    ThemeManager = AppThemeManager
    MaxScrollCount = 6
    ExplicitTop = 44
  end
  object splitter: TUSeparator
    Left = 398
    Top = 38
    Width = 20
    Height = 394
    ThemeManager = AppThemeManager
    CustomColor = clWhite
    Align = alRight
    ExplicitTop = 44
  end
  object boxPackageInfo: TUPanel
    Left = 418
    Top = 38
    Width = 185
    Height = 394
    ThemeManager = AppThemeManager
    CustomTextColor = clBlack
    CustomBackColor = 15132390
    Align = alRight
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ShowCaption = False
    TabOrder = 2
    ExplicitLeft = 424
    object txtPackageInfo: TUText
      Left = 0
      Top = 0
      Width = 185
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
  object AppThemeManager: TUThemeManager
    Left = 280
    Top = 320
  end
end
