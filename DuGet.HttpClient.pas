unit DuGet.HttpClient;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  IdHttp, IdBaseComponent, IdComponent, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL;

type
  THttpClient = class
  private
    FToken: string;
    FHttpClient: TIdHttp;
    FIOHandler: TIdSSLIOHandlerSocketOpenSSL;
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

constructor THttpClient.Create;
begin
  FHttpClient := TIdHttp.Create(nil);
  FIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  FIOHandler.SSLOptions.Method := TIdSSLVersion.sslvSSLv23;
  FHttpClient.IOHandler := FIOHandler;
end;

destructor THttpClient.Destroy;
begin
  FHttpClient.Free;
  FIOHandler.Free;
  inherited;
end;

procedure THttpClient.Get(const Url: string; ResponseStream: TStream);
begin
  FHttpClient.Request.CustomHeaders.Clear;
  FHttpClient.Request.CustomHeaders.Add('Authorization: token ' + FToken);
  FHttpClient.Request.UserAgent := UserAgentDuGet;

  FHttpClient.Get(Url, ResponseStream);
end;

function THttpClient.Get(const Url: string): string;
begin
  FHttpClient.Request.CustomHeaders.Clear;
  FHttpClient.Request.CustomHeaders.Add('Authorization: token ' + FToken);
  FHttpClient.Request.UserAgent := UserAgentDuGet;

  Result := FHttpClient.Get(Url);
end;

end.
