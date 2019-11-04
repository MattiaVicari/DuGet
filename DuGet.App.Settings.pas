unit DuGet.App.Settings;

{$I 'duget.inc'}

interface

uses
  System.SysUtils, System.Classes, System.IOUtils;

type
  TDuGetTheme = (dgtLight, dgtDark, dgtSystem);

  TAppSettings = class
  class var
    FAppSettings: TAppSettings;
  private
    FSettingsFilePath: string;
    FToken: string;
    FTheme: TDuGetTheme;
    FPrivacyPolicyAgree: Boolean;
    function GetInit: Boolean;
    function GetFirstLaunch: Boolean;
  public
    class function Instance: TAppSettings;
    class destructor Destroy;
  public
    property Token: string read FToken write FToken;
    property Theme: TDuGetTheme read FTheme write FTheme;
    property PrivacyPolicyAgree: Boolean read FPrivacyPolicyAgree write FPrivacyPolicyAgree;

    property Init: Boolean read GetInit;
    property FirstLaunch: Boolean read GetFirstLaunch;

    procedure Load;
    procedure Save;

    constructor Create;
  end;

implementation

uses
{$IFDEF GNUGETTEXT}
  JvGnugettext,
{$ELSE}
  DuGet.Translator,
{$ENDIF}
  DuGet.Utils,
  System.JSON;

const
  SettingsFileName = 'duget.settings';

{ TAppSettings }

constructor TAppSettings.Create;
begin
  FSettingsFilePath := TPath.Combine(ExtractFileDir(ParamStr(0)), SettingsFileName);
  FToken := '';
  FPrivacyPolicyAgree := False;
  FTheme := dgtSystem;

  Load;
end;

class destructor TAppSettings.Destroy;
begin
  if Assigned(FAppSettings) then
    FAppSettings.Free;
end;

function TAppSettings.GetFirstLaunch: Boolean;
begin
  Result := not FPrivacyPolicyAgree;
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
      if Assigned(SettingsJSON.GetValue('theme')) then
        FTheme := TDuGetTheme(TJSONNumber(SettingsJSON.GetValue('theme')).AsInt)
      else
        FTheme := dgtSystem;
      if Assigned(SettingsJSON.GetValue('privacypolicy')) then
        FPrivacyPolicyAgree := TJSONBool(SettingsJSON.GetValue('privacypolicy')).AsBoolean
      else
        FPrivacyPolicyAgree := False;
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
      SettingsJSON.AddPair('theme', TJSONNumber.Create(Ord(FTheme)));
      SettingsJSON.AddPair('privacypolicy', TJSONBool.Create(FPrivacyPolicyAgree));
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
