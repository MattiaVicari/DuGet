object modPackage: TmodPackage
  OldCreateOrder = False
  Height = 200
  Width = 288
  object fdmPackages: TFDMemTable
    OnCalcFields = fdmPackagesCalcFields
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 31
    Top = 14
    object fdmPackagesID: TIntegerField
      FieldName = 'ID'
    end
    object fdmPackagesNODE_ID: TStringField
      FieldName = 'NODE_ID'
      Size = 100
    end
    object fdmPackagesNAME: TStringField
      FieldName = 'NAME'
      Size = 100
    end
    object fdmPackagesFULL_NAME: TStringField
      FieldName = 'FULL_NAME'
      Size = 100
    end
    object fdmPackagesHTML_URL: TStringField
      FieldName = 'HTML_URL'
      Size = 1000
    end
    object fdmPackagesDESCRIPTION: TStringField
      FieldName = 'DESCRIPTION'
      Size = 1000
    end
    object fdmPackagesURL: TStringField
      FieldName = 'URL'
      Size = 1000
    end
    object fdmPackagesDOWNLOADS_URL: TStringField
      FieldName = 'DOWNLOADS_URL'
      Size = 1000
    end
    object fdmPackagesCREATED_AT: TDateTimeField
      FieldName = 'CREATED_AT'
    end
    object fdmPackagesUPDATED_AT: TDateTimeField
      FieldName = 'UPDATED_AT'
    end
    object fdmPackagesCLONE_URL: TStringField
      FieldName = 'CLONE_URL'
      Size = 1000
    end
    object fdmPackagesDEFAULT_BRANCH: TStringField
      FieldName = 'DEFAULT_BRANCH'
      Size = 100
    end
    object fdmPackagesPACKAGE_ID: TStringField
      FieldName = 'PACKAGE_ID'
      Size = 100
    end
    object fdmPackagesALTERNATIVE_NAME: TStringField
      FieldName = 'ALTERNATIVE_NAME'
      Size = 100
    end
    object fdmPackagesLOGO_FILENAME: TStringField
      FieldName = 'LOGO_FILENAME'
      Size = 100
    end
    object fdmPackagesLOGO_CACHED_FILEPATH: TStringField
      FieldName = 'LOGO_CACHED_FILEPATH'
      Size = 1000
    end
    object fdmPackagesLICENSES_TYPE: TStringField
      FieldName = 'LICENSES_TYPE'
      Size = 1000
    end
    object fdmPackagesOWNER_ID: TIntegerField
      FieldName = 'OWNER_ID'
    end
    object fdmPackagesOWNER_LOGIN: TStringField
      FieldName = 'OWNER_LOGIN'
      Size = 100
    end
    object fdmPackagesOWNER_NODE_ID: TStringField
      FieldName = 'OWNER_NODE_ID'
      Size = 100
    end
    object fdmPackagesOWNER_AVATAR_URL: TStringField
      FieldName = 'OWNER_AVATAR_URL'
      Size = 1000
    end
    object fdmPackagesPACKAGE_NAME: TStringField
      FieldKind = fkCalculated
      FieldName = 'PACKAGE_NAME'
      Size = 100
      Calculated = True
    end
  end
end
