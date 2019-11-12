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
