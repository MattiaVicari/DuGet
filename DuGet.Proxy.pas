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

unit DuGet.Proxy;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,
  System.IOUtils, System.DateUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  { Owner info }
  TOwnerInfo = class
  private
    FAvatarUrl: string;
    FId: Integer;
    FLogin: string;
    FNodeId: string;
  public
    property Login: string read FLogin write FLogin;
    property Id: Integer read FId write FId;
    property NodeId: string read FNodeId write FNodeId;
    property AvatarUrl: string read FAvatarUrl write FAvatarUrl;

    procedure LoadJSON(JsonData: TJSONObject);
    procedure CreateFromCDS(CDS: TFDMemTable);
    procedure SaveToCDS(CDS: TFDMemTable);
  end;

  { Package info }
  TPackageInfo = class
  private
    FName: string;
    FHtmlUrl: string;
    FDefaultBranch: string;
    FOwnerInfo: TOwnerInfo;
    FDownloadUrl: string;
    FUpdatedAt: TDate;
    FId: Integer;
    FNodeId: string;
    FDescription: string;
    FFullName: string;
    FCreatedAt: TDate;
    FUrl: string;
    FCloneUrl: string;
    { From Delphinus.Info.json file }
    FPackageId: string;
    FAlternativeName: string;
    FLogoFileName: string;
    FLogoCachedFilePath: string;
    FLicensesType: TArray<string>;
  public
    class function ParseJSON(JsonData: TJSONObject): TPackageInfo;
    class function CreateFromCDS(CDS: TFDMemTable): TPackageInfo;
  public
    property Id: Integer read FId write FId;
    property NodeId: string read FNodeId write FNodeId;
    property Name: string read FName write FName;
    property FullName: string read FFullName write FFullName;
    property HtmlUrl: string read FHtmlUrl write FHtmlUrl;
    property Description: string read FDescription write FDescription;
    property Url: string read FUrl write FUrl;
    property DownloadUrl: string read FDownloadUrl write FDownloadUrl;
    property CreatedAt: TDate read FCreatedAt write FCreatedAt;
    property UpdatedAt: TDate read FUpdatedAt write FUpdatedAt;
    property CloneUrl: string read FCloneUrl write FCloneUrl;
    property DefaultBranch: string read FDefaultBranch write FDefaultBranch;
    property Owner: TOwnerInfo read FOwnerInfo;

    { From Delphinus.Info.json file }
    property PackageId: string read FPackageId write FPackageId;
    property AlternativeName: string read FAlternativeName write FAlternativeName;
    property LogoFileName: string read FLogoFileName write FLogoFileName;
    property LogoCachedFilePath: string read FLogoCachedFilePath write FLogoCachedFilePath;
    property LicensesType: TArray<string> read FLicensesType write FLicensesType;

    procedure LoadJSON(JsonData: TJSONObject);
    procedure LoadFromCDS(CDS: TFDMemTable);
    procedure SaveToCDS(CDS: TFDMemTable);

    constructor Create;
    destructor Destroy; override;
  end;

  TProxyType = class of TDuGetProxyBase;

  { Interface of the proxy for get the packages info }
  IDuGetProxy = interface(IInterface)
  ['{696D11D8-861B-4433-839D-E9D5B8AC1CA2}']
    procedure LoadPackagesList;
    procedure ClearData;
    function GetPackagesList: TObjectList<TPackageInfo>;
    function GetAccessToken: string;
    procedure SetAccessToken(const Token: string);
    procedure SetCacheContainer(CDS: TFDMemTable);
    function GetCacheContainer: TFDMemTable;
  end;

  { Base class for proxy }
  TDuGetProxyBase = class(TInterfacedObject, IDuGetProxy)
  protected
    FAccessToken: string;
    FCDSCache: TFDMemTable;
    FCacheFilePath: string;
    FPackagesList: TObjectList<TPackageInfo>;
    function LookupCache: Boolean;
    procedure UpdateCache(Info: TPackageInfo);
    procedure SaveCache;
  public
    property CacheFilePath: string read FCacheFilePath;

    function GetPackagesList: TObjectList<TPackageInfo>; virtual; abstract;
    procedure LoadPackagesList; virtual; abstract;
    function GetAccessToken: string;
    procedure SetAccessToken(const Token: string);
    procedure SetCacheContainer(CDS: TFDMemTable);
    function GetCacheContainer: TFDMemTable;
    procedure ClearData;

    constructor Create; virtual;
    destructor Destroy; override;
  end;

  { Factory for proxy object }
  TProxyFactory = class
  class var
    FProxiesList: TDictionary<string, TProxyType>;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure RegistryForProxy(ProxyClass: TProxyType; const Alias: string);
    class function GetProxy(const Alias: string): IDuGetProxy;
  end;

implementation

uses
  DuGet.Utils;

{ TPackageInfo }

constructor TPackageInfo.Create;
begin
  FOwnerInfo := TOwnerInfo.Create;
end;

class function TPackageInfo.CreateFromCDS(CDS: TFDMemTable): TPackageInfo;
begin
  Result := TPackageInfo.Create;
  Result.LoadFromCDS(CDS);
end;

destructor TPackageInfo.Destroy;
begin
  FreeAndNil(FOwnerInfo);
  inherited;
end;

procedure TPackageInfo.LoadFromCDS(CDS: TFDMemTable);
var
  LicensesList: TStringList;
begin
  FId := CDS.FieldByName('ID').AsInteger;
  FNodeId := CDS.FieldByName('NODE_ID').AsString;
  FName := CDS.FieldByName('NAME').AsString;
  FFullName := CDS.FieldByName('FULL_NAME').AsString;
  FHtmlUrl := CDS.FieldByName('HTML_URL').AsString;
  FDescription := CDS.FieldByName('DESCRIPTION').AsString;
  FUrl := CDS.FieldByName('URL').AsString;
  FDownloadUrl := CDS.FieldByName('DOWNLOADS_URL').AsString;
  FCreatedAt := CDS.FieldByName('CREATED_AT').AsDateTime;
  FUpdatedAt := CDS.FieldByName('UPDATED_AT').AsDateTime;
  FCloneUrl := CDS.FieldByName('CLONE_URL').AsString;
  FDefaultBranch := CDS.FieldByName('DEFAULT_BRANCH').AsString;

  FOwnerInfo.CreateFromCDS(CDS);

  FPackageId := CDS.FieldByName('PACKAGE_ID').AsString;
  FAlternativeName := CDS.FieldByName('ALTERNATIVE_NAME').AsString;
  FLogoFileName := CDS.FieldByName('LOGO_FILENAME').AsString;
  FLogoCachedFilePath := CDS.FieldByName('LOGO_CACHED_FILEPATH').AsString;

  LicensesList := TStringList.Create;
  try
    LicensesList.Delimiter := ',';
    LicensesList.StrictDelimiter := True;
    LicensesList.DelimitedText := CDS.FieldByName('LICENSES_TYPE').AsString;
    FLicensesType := LicensesList.ToStringArray;
  finally
    LicensesList.Free;
  end;
end;

procedure TPackageInfo.LoadJSON(JsonData: TJSONObject);
begin
  FId := JsonData.GetValue<Integer>('id', -1);
  FNodeId := JsonData.GetValue<string>('node_id', '');
  FName := JsonData.GetValue<string>('name', '');
  FFullName := JsonData.GetValue<string>('full_name', '');
  FHtmlUrl := JsonData.GetValue<string>('html_url', '');
  FDescription := JsonData.GetValue<string>('description', '');
  FUrl := JsonData.GetValue<string>('url', '');
  FDownloadUrl := JsonData.GetValue<string>('downloads_url', '');
  FCreatedAt := ISO8601ToDate(JsonData.GetValue<string>('created_at', ''));
  FUpdatedAt := ISO8601ToDate(JsonData.GetValue<string>('updated_at', ''));
  FCloneUrl := JsonData.GetValue<string>('clone_url', '');
  FDefaultBranch := JsonData.GetValue<string>('default_branch', '');

  FOwnerInfo.LoadJSON(TJSONObject(JsonData.GetValue('owner')));
end;

class function TPackageInfo.ParseJSON(JsonData: TJSONObject): TPackageInfo;
begin
  Result := TPackageInfo.Create;
  Result.LoadJSON(JsonData);
end;

procedure TPackageInfo.SaveToCDS(CDS: TFDMemTable);
var
  I: Integer;
  LicensesList: TStringList;
begin
  CDS.FieldByName('ID').AsInteger := FId;
  CDS.FieldByName('NODE_ID').AsString := FNodeId;
  CDS.FieldByName('NAME').AsString := FName;
  CDS.FieldByName('FULL_NAME').AsString := FFullName;
  CDS.FieldByName('HTML_URL').AsString := FHtmlUrl;
  CDS.FieldByName('DESCRIPTION').AsString := FDescription;
  CDS.FieldByName('URL').AsString := FUrl;
  CDS.FieldByName('DOWNLOADS_URL').AsString := FDownloadUrl;
  CDS.FieldByName('CREATED_AT').AsDateTime := FCreatedAt;
  CDS.FieldByName('UPDATED_AT').AsDateTime := FUpdatedAt;
  CDS.FieldByName('CLONE_URL').AsString := FCloneUrl;
  CDS.FieldByName('DEFAULT_BRANCH').AsString := FDefaultBranch;

  FOwnerInfo.SaveToCDS(CDS);

  CDS.FieldByName('PACKAGE_ID').AsString := FPackageId;
  CDS.FieldByName('ALTERNATIVE_NAME').AsString := FAlternativeName;
  CDS.FieldByName('LOGO_FILENAME').AsString := FLogoFileName;
  CDS.FieldByName('LOGO_CACHED_FILEPATH').AsString := FLogoCachedFilePath;

  LicensesList := TStringList.Create;
  try
    LicensesList.Delimiter := ',';
    LicensesList.StrictDelimiter := True;
    for I := 0 to Length(FLicensesType) - 1 do
      LicensesList.Add(FLicensesType[I]);
    CDS.FieldByName('LICENSES_TYPE').AsString := LicensesList.DelimitedText;
  finally
    LicensesList.Free;
  end;
end;

{ TOwnerInfo }

procedure TOwnerInfo.CreateFromCDS(CDS: TFDMemTable);
begin
  FId := CDS.FieldByName('OWNER_ID').AsInteger;
  FLogin := CDS.FieldByName('OWNER_LOGIN').AsString;
  FNodeId := CDS.FieldByName('OWNER_NODE_ID').AsString;
  FAvatarUrl := CDS.FieldByName('OWNER_AVATAR_URL').AsString;
end;

procedure TOwnerInfo.LoadJSON(JsonData: TJSONObject);
begin
  FId := JsonData.GetValue<Integer>('id', -1);
  FLogin := JsonData.GetValue<string>('login', '');
  FNodeId := JsonData.GetValue<string>('node_id', '');
  FAvatarUrl := JsonData.GetValue<string>('avatar_url', '');
end;

procedure TOwnerInfo.SaveToCDS(CDS: TFDMemTable);
begin
  CDS.FieldByName('OWNER_ID').AsInteger := FId;
  CDS.FieldByName('OWNER_LOGIN').AsString := FLogin;
  CDS.FieldByName('OWNER_NODE_ID').AsString := FNodeId;
  CDS.FieldByName('OWNER_AVATAR_URL').AsString := FAvatarUrl;
end;

{ TProxyFactory }

class constructor TProxyFactory.Create;
begin
  FProxiesList := TDictionary<string, TProxyType>.Create;
end;

class destructor TProxyFactory.Destroy;
begin
  FProxiesList.Free;
end;

class function TProxyFactory.GetProxy(const Alias: string): IDuGetProxy;
var
  ProxyClass: TProxyType;
begin
  if not FProxiesList.ContainsKey(Alias) then
    raise Exception.CreateFmt('No class found for alias %s', [Alias]);

  ProxyClass := FProxiesList.Items[Alias];
  if not Supports(ProxyClass, IDuGetProxy) then
    raise Exception.CreateFmt('Class %s does not support the interface %s', [ProxyClass.ClassName, 'IDuGetProxy']);

  Result := ProxyClass.Create as IDuGetProxy;
end;

class procedure TProxyFactory.RegistryForProxy(ProxyClass: TProxyType;
  const Alias: string);
begin
  FProxiesList.Add(Alias, ProxyClass);
end;

{ TDuGetProxyBase }

procedure TDuGetProxyBase.ClearData;
begin
  FPackagesList.Clear;
end;

constructor TDuGetProxyBase.Create;
begin
  FAccessToken := '';
  FPackagesList := TObjectList<TPackageInfo>.Create(True);
  FCacheFilePath := TPath.Combine(TUtils.GetCacheFolder, 'packages.cache');
end;

destructor TDuGetProxyBase.Destroy;
begin
  FPackagesList.Free;
  inherited;
end;

function TDuGetProxyBase.GetAccessToken: string;
begin
  Result := FAccessToken;
end;

function TDuGetProxyBase.GetCacheContainer: TFDMemTable;
begin
  Result := FCDSCache;
end;

function TDuGetProxyBase.LookupCache: Boolean;
var
  Info: TPackageInfo;
begin
  Result := False;

  if not Assigned(FCDSCache) then
    Exit(False);

  if FCDSCache.Active then
    FCDSCache.EmptyDataSet;
  FCDSCache.Open;

  if TFile.Exists(CacheFilePath) then
  begin
    Result := True;
    FCDSCache.LoadFromFile(CacheFilePath, sfBinary);
    FCDSCache.First;
    while not FCDSCache.Eof do
    begin
      Info := TPackageInfo.CreateFromCDS(FCDSCache);
      try
        FPackagesList.Add(Info);
        FCDSCache.Next;
      except
          on E: Exception do
          begin
            Info.Free;
            raise;
          end;
        end;
    end;
  end;

end;

procedure TDuGetProxyBase.SaveCache;
begin
  if not Assigned(FCDSCache) then
    Exit;
  FCDSCache.SaveToFile(FCacheFilePath, sfBinary);
  FCDSCache.Close;
  FCDSCache.LoadFromFile(FCacheFilePath, sfBinary);
  FCDSCache.First;
end;

procedure TDuGetProxyBase.SetAccessToken(const Token: string);
begin
  FAccessToken := Token;
end;

procedure TDuGetProxyBase.SetCacheContainer(CDS: TFDMemTable);
begin
  FCDSCache := CDS;
end;

procedure TDuGetProxyBase.UpdateCache(Info: TPackageInfo);
begin
  if not Assigned(FCDSCache) then
    Exit;
  FCDSCache.Insert;
  Info.SaveToCDS(FCDSCache);
  FCDSCache.Post;
end;

end.
