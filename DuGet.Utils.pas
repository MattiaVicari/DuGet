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

unit DuGet.Utils;

{$I 'duget.inc'}

interface

uses
  Vcl.Graphics, Vcl.Dialogs, Vcl.Forms, System.IOUtils, System.SysUtils, System.Classes, System.StrUtils,
  System.JSON, WinApi.Windows,
{$IFDEF GNUGETTEXT}
  // Additional units for GNUGetText configuration (see SetupTranslation)
  Vcl.Controls, Vcl.DBCtrls, Data.DB, Datasnap.DBClient,
{$ENDIF}
  UCL.TUThemeManager, UCL.Classes;

type
  TUtils = class
  public
    { Translations }
    class procedure SetupTranslation;
    class procedure DoTranslation(Sender: TComponent);
    { Theme }
    class procedure SetupThemeManager(ThemeManager: TUThemeManager);
    { Asset }
    class function GetAsset(const AssetName: string): string;
    class function GetLicense(const LicenseName: string): string;
    class function GetPrivacyPolicy(const PrivacyPolicyName: string): string;
    { Cache }
    class function GetCacheFolder: string;
    class procedure ClearCache;
    { Utilities }
    class function FromPixelToScreen(Pixel, PPI: Single): Integer;
    class function GetSystemLanguage: string;
    class procedure SetupAppLanguage;
    class procedure CreateGraphic(const ImageType: string; out Graphic: TGraphic);
    class function ShowFluentMessageDialog(const Msg: string; Buttons: TMsgDlgButtons; Theme: TUTheme): Integer;
  end;

implementation


uses
{$IFDEF GNUGETTEXT}
  JvGnugettext,
{$ELSE}
  DuGet.Translator,
{$ENDIF}
  DuGet.Constants,
  PNGImage,
  JPeg;

{ TUtils }

class procedure TUtils.DoTranslation(Sender: TComponent);
begin
  TranslateComponent(Sender);
end;

class function TUtils.FromPixelToScreen(Pixel, PPI: Single): Integer;
var
  DPI: Single;
begin
  DPI := PPI / 96;
  Result := Round(Pixel * DPI);
end;

class function TUtils.GetAsset(const AssetName: string): string;
begin
  Result := TPath.Combine(TPath.Combine(ExtractFileDir(ParamStr(0)), 'Assets'), AssetName);
end;

class procedure TUtils.ClearCache;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(TPath.Combine(GetCacheFolder, '*.*'), faAnyFile, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Attr and faDirectory) <> faDirectory then
        TFile.Delete( TPath.Combine(GetCacheFolder, SearchRec.Name));
    until FindNext(SearchRec) <> 0;
  end;
end;

class procedure TUtils.CreateGraphic(const ImageType: string; out Graphic: TGraphic);
begin
  case IndexText(ImageType, ['.png', '.jpg', '.jpeg']) of
    0: Graphic := TPngImage.Create;
    1, 2: Graphic := TJPEGImage.Create;
  else
    raise Exception.CreateFmt('Unable to handle the image type %s', [ImageType]);
  end;

end;

class function TUtils.GetSystemLanguage: string;
const
  Size: Integer = 20;
var
  MyLang: PChar;
begin
  GetMem(MyLang, Size);
  try
    // This retrieve the current language for UI in Windows.
    // The best choice should be the current App language... but it is not (currently) available
    // the access to the API Windows.Globalization.ApplicationLanguages.GetLanguageForUser
    // https://docs.microsoft.com/en-us/uwp/api/windows.globalization.applicationlanguages.getlanguagesforuser
    if GetUserDefaultLocaleName(MyLang, Size) <> 0 then
      Result := ReplaceStr(StrPas(MyLang), '-', '_');
  finally
    FreeMem(MyLang);
  end;
end;

class function TUtils.GetCacheFolder: string;
var
  AppDataFolder: string;
begin
  AppDataFolder := GetEnvironmentVariable('APPDATA');
  Result := TPath.Combine(AppDataFolder, DuGetAppDataFolder);
  Result := TPath.Combine(Result, 'cache');
  ForceDirectories(Result);
end;

class function TUtils.GetLicense(const LicenseName: string): string;
var
  Lang, Ext: string;

  function GetLicenseFileByLang: string;
  begin
    Result := ReplaceStr(LicenseName, Ext, '_' + Lang + Ext);
  end;

begin
  Ext := ExtractFileExt(LicenseName);
  Lang := TUtils.GetSystemLanguage;
  Result := TPath.Combine(TPath.Combine(ExtractFileDir(ParamStr(0)), 'Licenses'), GetLicenseFileByLang);
  if not TFile.Exists(Result) then
  begin
    Lang := 'en_US';  // Default
    Result := TPath.Combine(TPath.Combine(ExtractFileDir(ParamStr(0)), 'Licenses'), GetLicenseFileByLang);
  end;
end;

class function TUtils.GetPrivacyPolicy(const PrivacyPolicyName: string): string;
var
  Lang, Ext: string;

  function GetPrivacyPolicyFileByLang: string;
  begin
    Result := ReplaceStr(PrivacyPolicyName, Ext, '_' + Lang + Ext);
  end;

begin
  Ext := ExtractFileExt(PrivacyPolicyName);
  Lang := TUtils.GetSystemLanguage;
  Result := TPath.Combine(TPath.Combine(ExtractFileDir(ParamStr(0)), 'PrivacyPolicy'), GetPrivacyPolicyFileByLang);
  if not TFile.Exists(Result) then
  begin
    Lang := 'en_US';  // Default
    Result := TPath.Combine(TPath.Combine(ExtractFileDir(ParamStr(0)), 'PrivacyPolicy'), GetPrivacyPolicyFileByLang);
  end;
end;

class procedure TUtils.SetupAppLanguage;
const
  DefLang = 'en';
var
  Lang: string;
begin
  Lang := DefLang;

  try
    Lang := TUtils.GetSystemLanguage;
  except
    Lang := DefLang;
  end;

  UseLanguage(Lang);
end;

class procedure TUtils.SetupThemeManager(ThemeManager: TUThemeManager);
begin
  ThemeManager.CustomAccentColor := clRed;
end;

class procedure TUtils.SetupTranslation();
begin
{$IFDEF GNUGETTEXT}
  // Ignore settings for GNUGetText
  // Uncomment and/or add the lines that you need

  //TP_GlobalIgnoreClassProperty(TAction,'Category');
  TP_GlobalIgnoreClassProperty(TControl,'HelpKeyword');
  //TP_GlobalIgnoreClassProperty(TNotebook,'Pages');
  TP_GlobalIgnoreClassProperty(TControl,'ImeName');
  TP_GlobalIgnoreClass(TFont);
  TP_GlobalIgnoreClassProperty(TField,'DefaultExpression');
  TP_GlobalIgnoreClassProperty(TField,'FieldName');
  TP_GlobalIgnoreClassProperty(TField,'KeyFields');
  TP_GlobalIgnoreClassProperty(TField,'DisplayName');
  TP_GlobalIgnoreClassProperty(TField,'LookupKeyFields');
  TP_GlobalIgnoreClassProperty(TField,'LookupResultField');
  TP_GlobalIgnoreClassProperty(TField,'Origin');
  TP_GlobalIgnoreClass(TParam);
  TP_GlobalIgnoreClassProperty(TFieldDef,'Name');
  TP_GlobalIgnoreClassProperty(TClientDataset,'CommandText');
  TP_GlobalIgnoreClassProperty(TClientDataset,'Filename');
  TP_GlobalIgnoreClassProperty(TClientDataset,'Filter');
  TP_GlobalIgnoreClassProperty(TClientDataset,'IndexFieldnames');
  TP_GlobalIgnoreClassProperty(TClientDataset,'IndexName');
  TP_GlobalIgnoreClassProperty(TClientDataset,'MasterFields');
  TP_GlobalIgnoreClassProperty(TClientDataset,'Params');
  TP_GlobalIgnoreClassProperty(TClientDataset,'ProviderName');
  TP_GlobalIgnoreClassProperty(TDBComboBox,'DataField');
  TP_GlobalIgnoreClassProperty(TDBCheckBox,'DataField');
  TP_GlobalIgnoreClassProperty(TDBEdit,'DataField');
  TP_GlobalIgnoreClassProperty(TDBImage,'DataField');
  TP_GlobalIgnoreClassProperty(TDBListBox,'DataField');
  TP_GlobalIgnoreClassProperty(TDBLookupControl,'DataField');
  TP_GlobalIgnoreClassProperty(TDBLookupControl,'KeyField');
  TP_GlobalIgnoreClassProperty(TDBLookupControl,'ListField');
  TP_GlobalIgnoreClassProperty(TDBMemo,'DataField');
  TP_GlobalIgnoreClassProperty(TDBRadioGroup,'DataField');
  TP_GlobalIgnoreClassProperty(TDBRichEdit,'DataField');
  TP_GlobalIgnoreClassProperty(TDBText,'DataField');
  //TP_GlobalIgnoreClass(TIBDatabase);
  //TP_GlobalIgnoreClass(TIBTransaction);
  //TP_GlobalIgnoreClassProperty(TIBSQL,'UniqueRelationName');
  //TP_GlobalIgnoreClass(TADOConnection);
  //TP_GlobalIgnoreClassProperty(TADOQuery,'CommandText');
  //TP_GlobalIgnoreClassProperty(TADOQuery,'ConnectionString');
  //TP_GlobalIgnoreClassProperty(TADOQuery,'DatasetField');
  //TP_GlobalIgnoreClassProperty(TADOQuery,'Filter');
  //TP_GlobalIgnoreClassProperty(TADOQuery,'IndexFieldNames');
  //TP_GlobalIgnoreClassProperty(TADOQuery,'IndexName');
  //TP_GlobalIgnoreClassProperty(TADOQuery,'MasterFields');
  //TP_GlobalIgnoreClassProperty(TADOTable,'IndexFieldNames');
  //TP_GlobalIgnoreClassProperty(TADOTable,'IndexName');
  //TP_GlobalIgnoreClassProperty(TADOTable,'MasterFields');
  //TP_GlobalIgnoreClassProperty(TADOTable,'TableName');
  //TP_GlobalIgnoreClassProperty(TADODataset,'CommandText');
  //TP_GlobalIgnoreClassProperty(TADODataset,'ConnectionString');
  //TP_GlobalIgnoreClassProperty(TADODataset,'DatasetField');
  //TP_GlobalIgnoreClassProperty(TADODataset,'Filter');
  //TP_GlobalIgnoreClassProperty(TADODataset,'IndexFieldNames');
  //TP_GlobalIgnoreClassProperty(TADODataset,'IndexName');
  //TP_GlobalIgnoreClassProperty(TADODataset,'MasterFields');
  //TP_GlobalIgnoreClass(TWebBrowser);
{$ELSE}
  // Your code for translations settings
{$ENDIF}
end;

class function TUtils.ShowFluentMessageDialog(const Msg: string;
  Buttons: TMsgDlgButtons; Theme: TUTheme): Integer;
var
  DlgForm: TForm;
begin
  DlgForm := CreateMessageDialog(Msg, mtCustom, Buttons);
  Dlgform.BorderStyle := bsSingle;
  Dlgform.BorderIcons := [biSystemMenu];
  if Theme = utDark then
  begin
    DlgForm.Color := clBlack;
    DlgForm.Font.Color := clWhite;
  end
  else
  begin
    DlgForm.Color := clWhite;
    DlgForm.Font.Color := clBlack;
  end;
  DlgForm.Font.Name := 'Segoe UI';
  DlgForm.Font.Size := 9;
  DlgForm.Caption := 'DuGet';
  DlgForm.Position := poScreenCenter;
  Result := DlgForm.ShowModal;
end;

end.
