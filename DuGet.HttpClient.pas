unit DuGet.HttpClient;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  System.Net.HTTPClient;

type
  TDuGetHttpClient = class
  private
    FToken: string;
    FHttpClient: THttpClient;
  public
    function Get(const Url: string): string; overload;
    procedure Get(const Url: string; ResponseStream: TStream); overload;

    property Token: string read FToken write FToken;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  DuGet.Constants;

{ THttpClient }

constructor TDuGetHttpClient.Create;
begin
  FHttpClient := THttpClient.Create;
end;

destructor TDuGetHttpClient.Destroy;
begin
  FHttpClient.Free;
  inherited;
end;

procedure TDuGetHttpClient.Get(const Url: string; ResponseStream: TStream);
begin
  FHttpClient.CustomHeaders['Authorization'] := 'token ' + FToken;
  FHttpClient.UserAgent := UserAgentDuGet;

  FHttpClient.Get(Url, ResponseStream);
end;

function TDuGetHttpClient.Get(const Url: string): string;
var
  Response: IHTTPResponse;
begin
  FHttpClient.CustomHeaders['Authorization'] := 'token ' + FToken;
  FHttpClient.UserAgent := UserAgentDuGet;

  Response := FHttpClient.Get(Url);
  Result := Response.ContentAsString(TEncoding.UTF8);
end;

end.
