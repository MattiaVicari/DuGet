{-------------------------------------------------------------------------------

  Project DuGet

  The contents of this file are subject to the MIT License (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at https://opensource.org/licenses/MIT

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied.
  See the License for the specific language governing rights and limitations
  under the License.

  Author: Mattia Vicari

-------------------------------------------------------------------------------}

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
    fdmPackagesPACKAGE_NAME: TStringField;
    procedure fdmPackagesCalcFields(DataSet: TDataSet);
  private
    function GetData: TFDMemTable;
  public
    procedure LoadPackageData(Data: TPackageInfo);
    procedure FindPackage(const PackageId: string);
    procedure ClearData;
    property Data: TFDMemTable read GetData;
  end;

//var
//  modPackage: TmodPackage;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TmodPackage }

procedure TmodPackage.ClearData;
begin
  if fdmPackages.Active then
    fdmPackages.EmptyDataSet;
end;

procedure TmodPackage.fdmPackagesCalcFields(DataSet: TDataSet);
begin
  fdmPackagesPACKAGE_NAME.AsString := fdmPackagesNAME.AsString;
  if fdmPackagesALTERNATIVE_NAME.AsString <> '' then
    fdmPackagesPACKAGE_NAME.AsString := fdmPackagesALTERNATIVE_NAME.AsString;
end;

procedure TmodPackage.FindPackage(const PackageId: string);
begin
  if not fdmPackages.Active then
    fdmPackages.Open;
  fdmPackages.First;
  fdmPackages.Locate('PACKAGE_ID', PackageId, [loCaseInsensitive]);
end;

function TmodPackage.GetData: TFDMemTable;
begin
  Result := fdmPackages;
end;

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
