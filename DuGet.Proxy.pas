unit DuGet.Proxy;

interface

uses
  System.SysUtils, System.Generics.Collections, System.JSON;

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
  public
    class function ParseJSON(JsonData: TJSONObject): TPackageInfo;
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

    procedure LoadJSON(JsonData: TJSONObject);

    constructor Create;
    destructor Destroy; override;
  end;

  TProxyType = class of TDuGetProxyBase;

  { Interface of the proxy for get the packages info }
  IDuGetProxy = interface(IInterface)
  ['{696D11D8-861B-4433-839D-E9D5B8AC1CA2}']
    procedure LoadPackagesList;
    function GetPackagesList: TObjectList<TPackageInfo>;
    function GetAccessToken: string;
    procedure SetAccessToken(const Token: string);
  end;

  TDuGetProxyBase = class(TInterfacedObject, IDuGetProxy)
  protected
    FAccessToken: string;
  public
    function GetPackagesList: TObjectList<TPackageInfo>; virtual; abstract;
    procedure LoadPackagesList; virtual; abstract;
    function GetAccessToken: string;
    procedure SetAccessToken(const Token: string);
    constructor Create; virtual;
  end;

  { Factory for proxies object }
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

{ TPackageInfo }

constructor TPackageInfo.Create;
begin
  FOwnerInfo := TOwnerInfo.Create;
end;

destructor TPackageInfo.Destroy;
begin
  FreeAndNil(FOwnerInfo);
  inherited;
end;

procedure TPackageInfo.LoadJSON(JsonData: TJSONObject);
begin
  FId := StrToIntDef(JsonData.GetValue('id').Value, -1);
  FNodeId := JsonData.GetValue('node_id').Value;
  FName := JsonData.GetValue('name').Value;
  FFullName := JsonData.GetValue('full_name').Value;
  FHtmlUrl := JsonData.GetValue('html_url').Value;
  FDescription := JsonData.GetValue('description').Value;
  FUrl := JsonData.GetValue('url').Value;
  FDownloadUrl := JsonData.GetValue('downloads_url').Value;
  FCreatedAt := StrToDateDef(JsonData.GetValue('created_at').Value, 0);
  FUpdatedAt := StrToDateDef(JsonData.GetValue('updated_at').Value, 0);
  FCloneUrl := JsonData.GetValue('clone_url').Value;

  FOwnerInfo.LoadJSON(TJSONObject(JsonData.GetValue('owner')));
end;

class function TPackageInfo.ParseJSON(JsonData: TJSONObject): TPackageInfo;
begin
  Result := TPackageInfo.Create;
  Result.LoadJSON(JsonData);
end;

{ TOwnerInfo }

procedure TOwnerInfo.LoadJSON(JsonData: TJSONObject);
begin
  FId := StrToIntDef(JsonData.GetValue('id').Value, -1);
  FLogin := JsonData.GetValue('login').Value;
  FNodeId := JsonData.GetValue('node_id').Value;
  FAvatarUrl := JsonData.GetValue('avatar_url').Value;
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

constructor TDuGetProxyBase.Create;
begin
  FAccessToken := '';
end;

function TDuGetProxyBase.GetAccessToken: string;
begin
  Result := FAccessToken;
end;

procedure TDuGetProxyBase.SetAccessToken(const Token: string);
begin
  FAccessToken := Token;
end;

end.
