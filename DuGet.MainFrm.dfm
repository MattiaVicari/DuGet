object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'DuGet - Delphi package manager'
  ClientHeight = 500
  ClientWidth = 634
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AppCaptionBar: TUCaptionBar
    Left = 0
    Top = 0
    Width = 634
    Height = 32
    ThemeManager = AppThemeManager
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Color = 15921906
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      634
      32)
    object txtPageTitle: TUText
      Left = 15
      Top = 0
      Width = 74
      Height = 32
      Anchors = [akLeft, akTop, akBottom]
      AutoSize = False
      Caption = 'Packages list'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ThemeManager = AppThemeManager
    end
    object btnSwitchTheme: TUQuickButton
      Left = 454
      Top = 0
      Width = 45
      Height = 32
      Hint = 'Change theme'
      ThemeManager = AppThemeManager
      ButtonStyle = qbsSysButton
      LightColor = 13619151
      DarkColor = 3947580
      PressBrightnessDelta = -32
      Align = alRight
      BevelOuter = bvNone
      Caption = #59144
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Segoe MDL2 Assets'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      OnClick = btnSwitchThemeClick
    end
    object btnMinimize: TUQuickButton
      Left = 499
      Top = 0
      Width = 45
      Height = 32
      ThemeManager = AppThemeManager
      ButtonStyle = qbsMin
      LightColor = 13619151
      DarkColor = 3947580
      PressBrightnessDelta = -32
      Align = alRight
      BevelOuter = bvNone
      Caption = #59192
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Segoe MDL2 Assets'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 1
    end
    object btnMaximize: TUQuickButton
      Left = 544
      Top = 0
      Width = 45
      Height = 32
      ThemeManager = AppThemeManager
      ButtonStyle = qbsMax
      LightColor = 13619151
      DarkColor = 3947580
      PressBrightnessDelta = -32
      Align = alRight
      BevelOuter = bvNone
      Caption = #57347
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Segoe MDL2 Assets'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 2
    end
    object btnQuit: TUQuickButton
      Left = 589
      Top = 0
      Width = 45
      Height = 32
      ThemeManager = AppThemeManager
      ButtonStyle = qbsQuit
      LightColor = 2298344
      DarkColor = 2298344
      PressBrightnessDelta = 32
      Align = alRight
      BevelOuter = bvNone
      Caption = #57606
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Segoe MDL2 Assets'
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 3
    end
  end
  object boxHamburgerMenu: TUPanel
    Left = 0
    Top = 32
    Width = 45
    Height = 468
    ThemeManager = AppThemeManager
    CustomTextColor = clBlack
    CustomBackColor = 15132390
    Align = alLeft
    BevelOuter = bvNone
    DoubleBuffered = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
    ParentDoubleBuffered = False
    ParentFont = False
    TabOrder = 1
    object btnMenu: TUSymbolButton
      Left = 0
      Top = 0
      Width = 45
      Height = 40
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
      SymbolChar = #59136
      Text = 'Menu'
      TextOffset = 45
      Detail = 'Detail'
      ShowDetail = False
      Align = alTop
      Constraints.MaxWidth = 45
      TabOrder = 0
      TabStop = True
      OnClick = btnMenuClick
    end
    object btnSettings: TUSymbolButton
      Left = 0
      Top = 40
      Width = 45
      Height = 40
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
      SymbolChar = #59155
      Text = 'Settings'
      TextOffset = 45
      Detail = 'Detail'
      ShowDetail = False
      Align = alTop
      TabOrder = 1
      TabStop = True
      OnClick = btnSettingsClick
    end
    object btnAbout: TUSymbolButton
      Left = 0
      Top = 428
      Width = 45
      Height = 40
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
      SymbolChar = #59267
      Text = 'About'
      TextOffset = 45
      Detail = 'Detail'
      ShowDetail = False
      Align = alBottom
      TabOrder = 2
      TabStop = True
    end
  end
  object boxPageContent: TUPanel
    Left = 45
    Top = 32
    Width = 589
    Height = 468
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
    TabOrder = 2
  end
  object AppThemeManager: TUThemeManager
    Left = 456
    Top = 48
  end
end
