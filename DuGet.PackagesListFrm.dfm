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
    Width = 413
    Height = 394
    Align = alClient
    BorderStyle = bsNone
    DoubleBuffered = True
    Color = 15132390
    Padding.Left = 15
    Padding.Top = 5
    Padding.Right = 15
    Padding.Bottom = 15
    ParentBackground = True
    ParentColor = False
    ParentDoubleBuffered = False
    TabOrder = 0
    ThemeManager = AppThemeManager
    WaitEventTime = 70
    MaxScrollCount = 10
    LengthPerStep = 70
    ExplicitLeft = -1
    ExplicitTop = 44
  end
  object splitter: TUSeparator
    Left = 413
    Top = 38
    Width = 5
    Height = 394
    ThemeManager = AppThemeManager
    CustomColor = clWhite
    Align = alRight
    ExplicitLeft = 414
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
    Padding.Left = 15
    Padding.Top = 5
    Padding.Right = 15
    Padding.Bottom = 15
    ParentBackground = False
    ParentFont = False
    ShowCaption = False
    TabOrder = 2
    ExplicitLeft = 419
    ExplicitTop = 44
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
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 110
    end
  end
  object AppThemeManager: TUThemeManager
    Left = 280
    Top = 320
  end
end
