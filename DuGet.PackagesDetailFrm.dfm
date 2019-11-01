inherited frmPackageDetail: TfrmPackageDetail
  Width = 665
  Height = 502
  ExplicitWidth = 665
  ExplicitHeight = 502
  inherited boxMain: TUPanel
    Width = 665
    Height = 502
    ExplicitWidth = 665
    ExplicitHeight = 502
    inherited txtTitle: TUText
      Width = 665
      Caption = 'Package detail'
      ExplicitWidth = 177
    end
    object boxContent: TUPanel
      Left = 0
      Top = 38
      Width = 665
      Height = 464
      ThemeManager = AppThemeManager
      CustomTextColor = clBlack
      CustomBackColor = 15132390
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentBackground = False
      ParentFont = False
      ShowCaption = False
      TabOrder = 0
      DesignSize = (
        665
        464)
      object imgLogo: TImage
        Left = 16
        Top = 24
        Width = 200
        Height = 200
        Center = True
        Proportional = True
      end
      object txtLblName: TUText
        Left = 240
        Top = 24
        Width = 87
        Height = 17
        Caption = 'Package name:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtName: TUText
        Left = 360
        Top = 24
        Width = 9
        Height = 17
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtLblDescription: TUText
        Left = 240
        Top = 47
        Width = 69
        Height = 17
        Caption = 'Description:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtLblAuthour: TUText
        Left = 16
        Top = 230
        Width = 42
        Height = 17
        Caption = 'Author:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtAuthor: TUText
        Left = 128
        Top = 230
        Width = 9
        Height = 17
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtLblLicenses: TUText
        Left = 16
        Top = 253
        Width = 51
        Height = 17
        Caption = 'Licenses:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtLicenses: TUText
        Left = 128
        Top = 253
        Width = 9
        Height = 17
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtLblCreatedAt: TUText
        Left = 16
        Top = 276
        Width = 64
        Height = 17
        Caption = 'Created at:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtCreatedAt: TUText
        Left = 128
        Top = 276
        Width = 9
        Height = 17
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtLblUpdatedAt: TUText
        Left = 216
        Top = 276
        Width = 69
        Height = 17
        Caption = 'Updated at:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtUpdatedAt: TUText
        Left = 328
        Top = 276
        Width = 9
        Height = 17
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object txtLblUrl: TUText
        Left = 16
        Top = 299
        Width = 20
        Height = 17
        Caption = 'Url:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object linkUrl: TUHyperLink
        Left = 128
        Top = 299
        Width = 9
        Height = 17
        Cursor = crHandPoint
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 4552068
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
        CustomTextColors.None = 14120960
        CustomTextColors.Hover = clGray
        CustomTextColors.Press = clMedGray
        CustomTextColors.Disabled = clMedGray
        CustomTextColors.Focused = 14120960
        URL = 'https://embarcadero.com/'
      end
      object txtLblCloneUrl: TUText
        Left = 16
        Top = 322
        Width = 55
        Height = 17
        Caption = 'Clone url:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
      end
      object linkCloneUrl: TUHyperLink
        Left = 128
        Top = 322
        Width = 9
        Height = 17
        Cursor = crHandPoint
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 4552068
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        ThemeManager = AppThemeManager
        CustomTextColors.None = 14120960
        CustomTextColors.Hover = clGray
        CustomTextColors.Press = clMedGray
        CustomTextColors.Disabled = clMedGray
        CustomTextColors.Focused = 14120960
        URL = 'https://embarcadero.com/'
      end
      object memDescription: TMemo
        Left = 240
        Top = 70
        Width = 409
        Height = 154
        Anchors = [akLeft, akTop, akRight]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
end
