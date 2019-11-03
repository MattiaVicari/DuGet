inherited frmPrivacyPolicy: TfrmPrivacyPolicy
  Width = 586
  ExplicitWidth = 586
  inherited boxMain: TUPanel
    Width = 586
    ExplicitWidth = 597
    ExplicitHeight = 473
    inherited txtTitle: TUText
      Width = 586
      Caption = 'Privacy policy'
      ExplicitWidth = 168
    end
    object boxPrivacyPolicy: TUPanel
      Left = 40
      Top = 88
      Width = 481
      Height = 353
      CustomTextColor = clBlack
      CustomBackColor = 15132390
      Anchors = [akLeft, akTop, akBottom]
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
      DesignSize = (
        481
        353)
      object memPrivacyPolicy: TMemo
        Left = 16
        Top = 16
        Width = 457
        Height = 265
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object boxButtons: TUPanel
        Left = 120
        Top = 304
        Width = 249
        Height = 41
        CustomTextColor = clBlack
        CustomBackColor = 15132390
        Anchors = [akLeft, akBottom]
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        ShowCaption = False
        TabOrder = 1
        object btnAgree: TUButton
          Left = 10
          Top = 3
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
          Text = 'Agree'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TabStop = True
          OnClick = btnAgreeClick
        end
        object btnNotAgree: TUButton
          Left = 128
          Top = 3
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
          Text = 'Not agree'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          TabStop = True
          OnClick = btnNotAgreeClick
        end
      end
    end
  end
  inherited ActivityIndicator: TActivityIndicator
    Left = 296
    Top = 122
    ExplicitLeft = 296
    ExplicitTop = 122
  end
end
