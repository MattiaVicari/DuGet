unit DuGet.PrivacyPolicyFrm;

{$I 'duget.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DuGet.BaseFrm, UCL.TUThemeManager,
  Vcl.WinXCtrls, Vcl.StdCtrls, UCL.TUText, Vcl.ExtCtrls,
  UCL.TUPanel, UCL.Classes, UCL.TUButton;

type
  TfrmPrivacyPolicy = class(TfrmBase)
    boxPrivacyPolicy: TUPanel;
    memPrivacyPolicy: TMemo;
    boxButtons: TUPanel;
    btnAgree: TUButton;
    btnNotAgree: TUButton;
    procedure FrameResize(Sender: TObject);
    procedure btnAgreeClick(Sender: TObject);
    procedure btnNotAgreeClick(Sender: TObject);
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

//var
//  frmPrivacyPolicy: TfrmPrivacyPolicy;

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
  DuGet.App.Settings,
  DuGet.Utils;

procedure TfrmPrivacyPolicy.btnAgreeClick(Sender: TObject);
begin
  inherited;
  TAppSettings.Instance.PrivacyPolicyAgree := True;
  TAppSettings.Instance.Save;
  if NavigationManager.IsModal then
    NavigationManager.PopAsModal
  else
    NavigationManager.Pop;

  if not TAppSettings.Instance.Init then
    NavigationManager.PushAsModal('SettingsPage');
end;

procedure TfrmPrivacyPolicy.btnNotAgreeClick(Sender: TObject);
begin
  inherited;
  TAppSettings.Instance.PrivacyPolicyAgree := False;
  TAppSettings.Instance.Save;
  MessageDlg(_('The application will be closed.' + sLineBreak + 'If you don''t agree with the privacy policy, you have to uninstall this software from your device.'),
            mtInformation, [mbOK], 0);
  Application.Terminate;
end;

constructor TfrmPrivacyPolicy.Create(AOwner: TComponent);
begin
  inherited;
  boxButtons.Visible := TAppSettings.Instance.FirstLaunch;
  try
    memPrivacyPolicy.Lines.LoadFromFile(TUtils.GetPrivacyPolicy('privacypolicy.txt'), TEncoding.UTF8);
  except
    on E: Exception do
      raise Exception.CreateFmt(_('Unable to load the privacy policy information. Error: %s'), [E.Message]);
  end;
end;

procedure TfrmPrivacyPolicy.FrameResize(Sender: TObject);
begin
  inherited;
  boxPrivacyPolicy.Width := Min(800, Max(400, ClientWidth - 200));
  boxPrivacyPolicy.Left := Max((ClientWidth - boxPrivacyPolicy.Width) div 2, 0);
  boxButtons.Left := Max((boxPrivacyPolicy.Width - boxButtons.Width) div 2, 0);
end;

procedure TfrmPrivacyPolicy.OnChangeTheme(Sender: TObject; Theme: TUTheme);
begin
  inherited;
  if Theme = utLight then
  begin
    boxPrivacyPolicy.CustomBackColor := clWhite;
    boxPrivacyPolicy.CustomTextColor := clBlack;
    boxButtons.CustomBackColor := clWhite;
    boxButtons.CustomTextColor := clBlack;
    memPrivacyPolicy.Color := clWhite;
    memPrivacyPolicy.Font.Color := clBlack;
  end
  else
  begin
    boxPrivacyPolicy.CustomBackColor := clBlack;
    boxPrivacyPolicy.CustomTextColor := clWhite;
    boxButtons.CustomBackColor := clBlack;
    boxButtons.CustomTextColor := clWhite;
    memPrivacyPolicy.Color := clBlack;
    memPrivacyPolicy.Font.Color := clWhite;
  end;
end;

initialization
  RegisterClassAlias(TfrmPrivacyPolicy, 'PrivacyPolicyPage');

end.
