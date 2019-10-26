unit DuGet.SettingsFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.TUThemeManager,
  Vcl.StdCtrls, System.UITypes, JvGnugettext,
  DuGet.BaseFrm, UCL.TUText, Vcl.ExtCtrls, UCL.TUPanel, UCL.TUEdit, UCL.TUButton;

type
  TfrmSettings = class(TfrmBase)
    txtMessage: TUText;
    boxToken: TUPanel;
    txtToken: TUText;
    edtToken: TUEdit;
    btnSaveSettings: TUButton;
    procedure FrameResize(Sender: TObject);
    procedure btnSaveSettingsClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  Math,
  DuGet.App.Settings;

procedure TfrmSettings.btnSaveSettingsClick(Sender: TObject);
begin
  inherited;
  if edtToken.Edit.Text = '' then
    raise Exception.Create(_('You have to type your personal access token'));

  TAppSettings.Instance.Token := edtToken.Edit.Text;
  TAppSettings.Instance.Save;

  MessageDlg(_('Settings are saved'), mtInformation, [mbOK], 0);
end;

constructor TfrmSettings.Create(AOwner: TComponent);
begin
  inherited;
  edtToken.Edit.Text := TAppSettings.Instance.Token;

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

initialization
  RegisterClassAlias(TfrmSettings, 'SettingsPage');

end.
