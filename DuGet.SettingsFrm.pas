unit DuGet.SettingsFrm;

{$I 'duget.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.TUThemeManager, UCL.Classes,
  Vcl.StdCtrls, System.UITypes,
  DuGet.BaseFrm, DuGet.App.Settings,  UCL.TUText, Vcl.ExtCtrls, UCL.TUPanel, UCL.TUEdit, UCL.TUButton,
  Vcl.WinXCtrls, UCL.TUCheckBox, UCL.TURadioButton, Vcl.Imaging.pngimage;

type
  TfrmSettings = class(TfrmBase)
    txtMessage: TUText;
    boxToken: TUPanel;
    txtToken: TUText;
    edtToken: TUEdit;
    btnSaveSettings: TUButton;
    txtThemeSettings: TUText;
    radioDefaultTheme: TURadioButton;
    radioLightTheme: TURadioButton;
    radioDarkTheme: TURadioButton;
    procedure FrameResize(Sender: TObject);
    procedure btnSaveSettingsClick(Sender: TObject);
    procedure radioAppThemeClick(Sender: TObject);
  private
    function GetAppThemeOption: TDuGetTheme;
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
{$IFDEF GNUGETTEXT}
  JvGnugettext,
{$ELSE}
  DuGet.Translator,
{$ENDIF}
  Math,
  DuGet.NavigationManager,
  DuGet.Constants;

procedure TfrmSettings.btnSaveSettingsClick(Sender: TObject);
begin
  inherited;
  if edtToken.Edit.Text = '' then
    raise Exception.Create(_('You have to type your personal access token'));

  TAppSettings.Instance.Token := edtToken.Edit.Text;
  TAppSettings.Instance.Theme := GetAppThemeOption;
  TAppSettings.Instance.Save;

  MessageDlg(_('Settings are saved'), mtInformation, [mbOK], 0);
  if NavigationManager.IsModal then
    NavigationManager.PopAsModal;
end;

constructor TfrmSettings.Create(AOwner: TComponent);
begin
  inherited;
  edtToken.Edit.Text := TAppSettings.Instance.Token;
  case TAppSettings.Instance.Theme of
    dgtSystem: radioDefaultTheme.IsChecked := True;
    dgtDark: radioDarkTheme.IsChecked := True;
    dgtLight: radioLightTheme.IsChecked := True;
  else
    radioDefaultTheme.IsChecked := True;
  end;

  if TAppSettings.Instance.Token = '' then
  begin
    txtMessage.Caption := _('You have to type your personal access token in order to get the list of packages');
    txtMessage.Visible := True;
  end;
end;

procedure TfrmSettings.FrameResize(Sender: TObject);
begin
  inherited;
  boxToken.Left := Max((ClientWidth - boxToken.Width) div 2, 0);
end;

function TfrmSettings.GetAppThemeOption: TDuGetTheme;
begin
  Result := dgtSystem;
  if radioLightTheme.IsChecked then
    Result := dgtLight
  else if radioDarkTheme.IsChecked then
    Result := dgtDark;
end;

procedure TfrmSettings.OnChangeTheme(Sender: TObject; Theme: TUTheme);
begin
  inherited;
  if Theme = utLight then
  begin
    boxToken.CustomBackColor := clWhite;
    boxToken.CustomTextColor := clBlack;
  end
  else
  begin
    boxToken.CustomBackColor := clBlack;
    boxToken.CustomTextColor := clWhite;
  end;
end;

procedure TfrmSettings.radioAppThemeClick(Sender: TObject);
begin
  inherited;
  AppThemeManager.UseSystemTheme := radioDefaultTheme.IsChecked;
  if not AppThemeManager.UseSystemTheme then
  begin
    if radioLightTheme.IsChecked then
      AppThemeManager.CustomTheme := utLight
    else if radioDarkTheme.IsChecked then
      AppThemeManager.CustomTheme := utDark;
  end;
  PostMessage(Screen.Forms[0].Handle, WM_OWN_UPDATE_APPTHEME, Ord(GetAppThemeOption), 0);
end;

initialization
  RegisterClassAlias(TfrmSettings, 'SettingsPage');

end.
