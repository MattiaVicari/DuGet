unit DuGet.Proxy.GitHub;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections,
  JvGnugettext,
  DuGet.Proxy;

type
  { Proxy implementation for GitHub }
  TDuGetProxyGitHub = class(TDuGetProxyBase)
  private
    FPackagesList: TObjectList<TPackageInfo>;
  public
    procedure LoadPackagesList; override;
    function GetPackagesList: TObjectList<TPackageInfo>; override;

    destructor Destroy; override;
    constructor Create; override;
  end;

implementation

uses
  IdHttp,
  IdBaseComponent, IdComponent, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  JSON;

const
  GitHubTokenHelpUrl = 'https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line';
  // I use the Delphinus mechanism to find the packages (Delphinus-Support)
  GitHubSearchUrl = 'https://api.github.com/search/repositories?q="Delphinus-Support"+in:readme&per_page=100';

{ TDuGetProxyGitHub }

constructor TDuGetProxyGitHub.Create;
begin
  inherited;
  FPackagesList := TObjectList<TPackageInfo>.Create(True);
end;

destructor TDuGetProxyGitHub.Destroy;
begin
  FPackagesList.Free;
  inherited;
end;

function TDuGetProxyGitHub.GetPackagesList: TObjectList<TPackageInfo>;
begin
  if FPackagesList.Count = 0 then
    LoadPackagesList;
  Result := FPackagesList;
end;

procedure TDuGetProxyGitHub.LoadPackagesList;
var
  HttpClient: TIdHttp;
  IOHandler: TIdSSLIOHandlerSocketOpenSSL;
  Response: string;
  JsonResponse: TJSONObject;
  Items: TJSONArray;
  Item: TJSONValue;
begin
  if FAccessToken = '' then
    raise Exception.Create(Format(_('You have to provide your personal access token for GitHub API.' + sLineBreak +
                            'See here %s'), [GitHubTokenHelpUrl]));

  FPackagesList.Clear;

  try

    HttpClient := TIdHttp.Create(nil);
    IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      IOHandler.SSLOptions.Method := TIdSSLVersion.sslvTLSv1_2;

      HttpClient.IOHandler := IOHandler;
      HttpClient.Request.CustomHeaders.Clear;
      HttpClient.Request.CustomHeaders.Add('Authorization: token ' + FAccessToken);
      HttpClient.Request.UserAgent := 'DuGet, v1.0';

      JsonResponse := TJSONObject.Create;
      try
        Response := HttpClient.Get(GitHubSearchUrl);

        JsonResponse.Parse(TEncoding.UTF8.GetBytes(Response), 0);
        Items := TJSONArray(JsonResponse.GetValue('items'));
        for Item in Items do
          FPackagesList.Add(TPackageInfo.ParseJSON(TJSONObject(Item)));
      finally
        JsonResponse.Free;
      end;

    finally
      HttpClient.Free;
      IOHandler.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create(Format(_('Unable to get the list of packages.' + sLineBreak + 'Error: %s'), [E.Message]));
  end;
end;

initialization
  TProxyFactory.RegistryForProxy(TDuGetProxyGitHub, 'GitHubProxy');

end.
