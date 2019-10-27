unit DuGet.Proxy.GitHub;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, System.IOUtils, System.NetEncoding,
  JvGnugettext,
  DuGet.Proxy;

type
  { Proxy implementation for GitHub }
  TDuGetProxyGitHub = class(TDuGetProxyBase)
  private
    FPackagesList: TObjectList<TPackageInfo>;
    procedure LoadMetadata(Info: TPackageInfo);
  public
    procedure LoadPackagesList; override;
    function GetPackagesList: TObjectList<TPackageInfo>; override;

    destructor Destroy; override;
    constructor Create; override;
  end;

implementation

uses
  JSON, IdURI,
  DuGet.Utils, DuGet.HttpClient;

const
  GitHubTokenHelpUrl = 'https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line';
  // I use the Delphinus system to find the packages (Delphinus-Support)
  GitHubSearchUrl = 'https://api.github.com/search/repositories?q="Delphinus-Support"+in:readme&per_page=100';
  GitHubContentUrl = 'https://api.github.com/repos/%s/%s/contents/%s?ref=%s';

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

procedure TDuGetProxyGitHub.LoadMetadata(Info: TPackageInfo);

  function GetFileNameFromGUID(const GUID: string): string;
  begin
    Result := GUID.Replace('{', '', [rfReplaceAll]).Replace('}', '', [rfReplaceAll]);
  end;

var
  HttpClient: DuGet.HttpClient.THttpClient;
  Url, Response, DownloadUrl: string;
  JsonResponse, JsonMetadata, JsonPicture: TJSONObject;
  Item: TJSONValue;
  Items: TJSONArray;
  Licenses: TArray<string>;
  PictureBytes: TBytes;
  LogoFileStream: TFileStream;
begin
  Url := Format(GitHubContentUrl, [Info.Owner.Login, Info.Name, 'Delphinus.Info.json', Info.DefaultBranch]);
  try
    HttpClient := DuGet.HttpClient.THttpClient.Create;
    try
      HttpClient.Token := FAccessToken;

      JsonResponse := TJSONObject.Create;
      try
        Response := HttpClient.Get(TIdURI.URLEncode(Url));
        JsonResponse.Parse(TEncoding.UTF8.GetBytes(Response), 0);

        DownloadUrl := JsonResponse.GetValue('download_url').Value;
        Response := HttpClient.Get(DownloadUrl);

        JsonMetadata := TJSONObject.Create;
        try
          JsonMetadata.Parse(TEncoding.UTF8.GetBytes(Response), 0);

          Info.PackageId := TUtils.JsonCoalesceValue(JsonMetadata.GetValue('id'));
          Info.AlternativeName := TUtils.JsonCoalesceValue(JsonMetadata.GetValue('name'));
          Info.LogoFileName := TUtils.JsonCoalesceValue(JsonMetadata.GetValue('picture'));
          if Assigned(JsonMetadata.GetValue(('licenses'))) then
          begin
            Items := TJSONArray(JsonMetadata.GetValue(('licenses')));
            for Item in Items do
              Licenses := Licenses + [TJSONObject(Item).GetValue('type').Value];
            Info.LicensesType := Licenses;
          end;

          if Info.LogoFileName <> '' then
          begin
            Url := Format(GitHubContentUrl, [Info.Owner.Login, Info.Name, Info.LogoFileName, Info.DefaultBranch]);
            Info.LogoCachedFilePath := TPath.Combine(TUtils.GetCacheFolder, GetFileNameFromGUID(Info.PackageId)) + ExtractFileExt(Info.LogoFileName);
            // Download the file if it's not in cache
            if not TFile.Exists(Info.LogoCachedFilePath) then
            begin
              LogoFileStream := TFileStream.Create(Info.LogoCachedFilePath, fmCreate);
              try
                Response := HttpClient.Get(TIdURI.URLEncode(Url));
                JsonPicture := TJSONObject.Create;
                try
                  JsonPicture.Parse(TEncoding.UTF8.GetBytes(Response), 0);
                  PictureBytes := TNetEncoding.Base64.DecodeStringToBytes(JsonPicture.GetValue('content').Value);
                  LogoFileStream.WriteData(PictureBytes, Length(PictureBytes));
                finally
                  JsonPicture.Free;
                end;
              finally
                LogoFileStream.Free;
              end;
            end;
          end;
        finally
          JsonMetadata.Free;
        end;

      finally
        JsonResponse.Free;
      end;
    finally
      HttpClient.Free;
    end;
  except
    // No metdata available
  end;
end;

procedure TDuGetProxyGitHub.LoadPackagesList;
var
  HttpClient: DuGet.HttpClient.THttpClient;
  Info: TPackageInfo;
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
    HttpClient := DuGet.HttpClient.THttpClient.Create;
    try
      HttpClient.Token := FAccessToken;

      JsonResponse := TJSONObject.Create;
      try
        Response := HttpClient.Get(GitHubSearchUrl);

        JsonResponse.Parse(TEncoding.UTF8.GetBytes(Response), 0);
        Items := TJSONArray(JsonResponse.GetValue('items'));
        for Item in Items do
        begin
          Info := TPackageInfo.ParseJSON(TJSONObject(Item));

          try
            LoadMetadata(Info); // Extra info from metadata file
            FPackagesList.Add(Info);
          except
            on E: Exception do
            begin
              Info.Free;
              raise;
            end;
          end;

        end;
      finally
        JsonResponse.Free;
      end;

    finally
      HttpClient.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create(Format(_('Unable to get the list of packages.' + sLineBreak + 'Error: %s'), [E.Message]));
  end;
end;

initialization
  TProxyFactory.RegistryForProxy(TDuGetProxyGitHub, 'GitHubProxy');

end.
