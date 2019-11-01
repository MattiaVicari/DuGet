unit DuGet.Modules.Package;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  DuGet.Proxy;

type
  TmodPackage = class(TDataModule)
    fdmPackages: TFDMemTable;
    fdmPackagesID: TIntegerField;
    fdmPackagesNODE_ID: TStringField;
    fdmPackagesNAME: TStringField;
    fdmPackagesFULL_NAME: TStringField;
    fdmPackagesHTML_URL: TStringField;
    fdmPackagesDESCRIPTION: TStringField;
    fdmPackagesURL: TStringField;
    fdmPackagesDOWNLOADS_URL: TStringField;
    fdmPackagesCREATED_AT: TDateTimeField;
    fdmPackagesUPDATED_AT: TDateTimeField;
    fdmPackagesCLONE_URL: TStringField;
    fdmPackagesDEFAULT_BRANCH: TStringField;
    fdmPackagesPACKAGE_ID: TStringField;
    fdmPackagesALTERNATIVE_NAME: TStringField;
    fdmPackagesLOGO_FILENAME: TStringField;
    fdmPackagesLOGO_CACHED_FILEPATH: TStringField;
    fdmPackagesLICENSES_TYPE: TStringField;
    fdmPackagesOWNER_ID: TIntegerField;
    fdmPackagesOWNER_LOGIN: TStringField;
    fdmPackagesOWNER_NODE_ID: TStringField;
    fdmPackagesOWNER_AVATAR_URL: TStringField;
  public
    procedure LoadPackageData(Data: TPackageInfo);
  end;

//var
//  modPackage: TmodPackage;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TmodPackage }

procedure TmodPackage.LoadPackageData(Data: TPackageInfo);
begin
  if fdmPackages.Active then
    fdmPackages.EmptyDataSet
  else
    fdmPackages.CreateDataSet;
  fdmPackages.Edit;
  Data.SaveToCDS(fdmPackages);
  fdmPackages.Post;
end;

end.
