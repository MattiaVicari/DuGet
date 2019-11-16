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
    FLocalDataFolder: string;
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
  DuGet.Constants,
  Math,
  DuGet.Utils,
  CNGCrypt.Core,
  System.JSON;

const
  SettingsFileName = 'duget.settings';
  Key = 'akfoior$=?sfdklfmsk23SDLSki3034idmkmaAÁDKSk340ifsklfsd';

// For AES the IV size is equal to the block size that is 128 bits (16 bytes)
function GenerateIV(BlockLen: Integer = 16): TBytes;
var
  I: Integer;
begin
  SetLength(Result, BlockLen);
  for I := Low(Result) to High(Result) do
    Result[I] := RandomRange(0, 255);
end;

{ TAppSettings }

constructor TAppSettings.Create;
begin
  FLocalDataFolder := GetEnvironmentVariable('APPDATA');
  FSettingsFilePath := TPath.Combine(FLocalDataFolder, DuGetAppDataFolder);
  ForceDirectories(FSettingsFilePath);

  FSettingsFilePath := TPath.Combine(FSettingsFilePath, SettingsFileName);
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
  CipherData: TFileStream;
  PlainTextData: TMemoryStream;
  Crypt: TCNGCrypt;
begin
  if not TFile.Exists(FSettingsFilePath) then
  begin
    Save;
    Exit;
  end;

  Crypt := TCNGCrypt.Create;
  try
    Crypt.Key := TEncoding.UTF8.GetBytes(Key);
    //Crypt.IV := GenerateIV;
    try
      SettingsJSON := TJSONObject.Create;
      try
        CipherData := TFileStream.Create(FSettingsFilePath, fmOpenRead);
        try
          PlainTextData := TMemoryStream.Create;
          try
            Crypt.Decrypt(CipherData, PlainTextData);

            SetLength(JsonData, PlainTextData.Size);
            PlainTextData.Position := 0;
            PlainTextData.Read(JsonData, PlainTextData.Size);
          finally
            PlainTextData.Free;
          end;
        finally
          CipherData.Free;
        end;
        if SettingsJSON.Parse(JsonData, 0, True) = -1 then
          raise Exception.Create(_('Settings are invalid'));

        FToken := SettingsJSON.GetValue<string>('token', '');
        FTheme := TDuGetTheme(SettingsJSON.GetValue<Integer>('theme', Ord(dgtSystem)));
        FPrivacyPolicyAgree := SettingsJSON.GetValue<Boolean>('privacypolicy', False);
      finally
        SettingsJSON.Free;
      end;
    except
      on E: Exception do
        raise Exception.CreateFmt(_('Unable to load the application settings. Error: %s'), [E.Message]);
    end;
  finally
    Crypt.Free;
  end;
end;

procedure TAppSettings.Save;
var
  SettingsJSON: TJSONObject;
  PlainTextData: TStringStream;
  CipherData: TFileStream;
  Crypt: TCNGCrypt;
begin
  try
    SettingsJSON := TJSONObject.Create;
    try
      SettingsJSON.AddPair('token', FToken);
      SettingsJSON.AddPair('theme', TJSONNumber.Create(Ord(FTheme)));
      SettingsJSON.AddPair('privacypolicy', TJSONBool.Create(FPrivacyPolicyAgree));

      Crypt := TCNGCrypt.Create;
      try
        Crypt.Key := TEncoding.UTF8.GetBytes(Key);
        Crypt.IV := GenerateIV;
        PlainTextData := TStringStream.Create(SettingsJSON.ToJSON);
        try
          CipherData := TFileStream.Create(FSettingsFilePath, fmCreate);
          try
            Crypt.Encrypt(PlainTextData, CipherData);
          finally
            CipherData.Free;
          end;
        finally
          PlainTextData.Free;
        end;
      finally
        Crypt.Free;
      end;
    finally
      SettingsJSON.Free;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt(_('Unable to update the application settings. Error: %s'), [E.Message]);
  end;
end;

end.
