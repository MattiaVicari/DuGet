unit DuGet.App.Settings;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  JvGnugettext;

type
  TAppSettings = class
  class var
    FAppSettings: TAppSettings;
  private
    FSettingsFilePath: string;
    FToken: string;
    function GetInit: Boolean;
  public
    class function Instance: TAppSettings;
    class destructor Destroy;
  public
    property Token: string read FToken write FToken;
    property Init: Boolean read GetInit;

    procedure Load;
    procedure Save;

    constructor Create;
  end;

implementation

uses
  System.JSON;

const
  SettingsFileName = 'duget.settings';

{ TAppSettings }

constructor TAppSettings.Create;
begin
  FSettingsFilePath := TPath.Combine(ExtractFileDir(ParamStr(0)), SettingsFileName);
  FToken := '';

  Load;
end;

class destructor TAppSettings.Destroy;
begin
  if Assigned(FAppSettings) then
    FAppSettings.Free;
end;

function TAppSettings.GetInit: Boolean;
begin
  Result := FToken <> '';
end;

class function TAppSettings.Instance: TAppSettings;
begin
  if not Assigned(FAppSettings) then
    FAppSettings := TAppSettings.Create;
  Result := FAppSettings;
end;

procedure TAppSettings.Load;
var
  SettingsJSON: TJSONObject;
  JsonData: TBytes;
begin
  if not TFile.Exists(FSettingsFilePath) then
  begin
    Save;
    Exit;
  end;

  try
    SettingsJSON := TJSONObject.Create;
    try
      JsonData := TFile.ReadAllBytes(FSettingsFilePath);
      if SettingsJSON.Parse(JsonData, 0, True) = -1 then
        raise Exception.Create(_('Settings are invalid'));

      FToken := SettingsJSON.GetValue('token').Value;
    finally
      SettingsJSON.Free;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt(_('Unable to load the application settings. Error: %s'), [E.Message]);
  end;
end;

procedure TAppSettings.Save;
var
  SettingsJSON: TJSONObject;
begin
  try
    SettingsJSON := TJSONObject.Create;
    try
      SettingsJSON.AddPair('token', FToken);
      TFile.WriteAllText(FSettingsFilePath, SettingsJSON.ToJSON); // No BOM
    finally
      SettingsJSON.Free;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt(_('Unable to update the application settings. Error: %s'), [E.Message]);
  end;
end;

end.