unit DuGet.Proxy.GitHub;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, System.IOUtils, System.NetEncoding,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.StorageBin,
  JvGnugettext,
  DuGet.Proxy;

type
  { Proxy implementation for GitHub }
  TDuGetProxyGitHub = class(TDuGetProxyBase)
  private
    procedure LoadMetadata(Info: TPackageInfo);
  public
    procedure LoadPackagesList; override;
    function GetPackagesList: TObjectList<TPackageInfo>; override;
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
  HttpClient: TDuGetHttpClient;
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
    HttpClient := TDuGetHttpClient.Create;
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
              Response := HttpClient.Get(TIdURI.URLEncode(Url));
              JsonPicture := TJSONObject.Create;
              try
                JsonPicture.Parse(TEncoding.UTF8.GetBytes(Response), 0);
                if Assigned(JsonPicture.GetValue('content')) then
                begin
                  PictureBytes := TNetEncoding.Base64.DecodeStringToBytes(JsonPicture.GetValue('content').Value);
                  LogoFileStream := TFileStream.Create(Info.LogoCachedFilePath, fmCreate);
                  try
                    LogoFileStream.WriteData(PictureBytes, Length(PictureBytes));
                  finally
                    LogoFileStream.Free;
                  end;
                end;
              finally
                JsonPicture.Free;
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
    // No metadata available
  end;
end;

procedure TDuGetProxyGitHub.LoadPackagesList;
var
  HttpClient: TDuGetHttpClient;
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
    // Look up in cache
    if LookupCache then
      Exit;

    // Do request for packages
    HttpClient := TDuGetHttpClient.Create;
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
            UpdateCache(Info);
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

    SaveCache;

  except
    on E: Exception do
      raise Exception.Create(Format(_('Unable to get the list of packages.' + sLineBreak + 'Error: %s'), [E.Message]));
  end;
end;

initialization
  TProxyFactory.RegistryForProxy(TDuGetProxyGitHub, 'GitHubProxy');

end.
