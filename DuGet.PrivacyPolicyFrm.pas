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

unit DuGet.PrivacyPolicyFrm;

{$I 'duget.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.UITypes, Vcl.ComCtrls,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DuGet.BaseFrm, UCL.TUThemeManager,
  Vcl.WinXCtrls, Vcl.StdCtrls, UCL.TUText, Vcl.ExtCtrls,
  UCL.TUPanel, UCL.Classes, UCL.TUButton;

type
  TfrmPrivacyPolicy = class(TfrmBase)
    boxPrivacyPolicy: TUPanel;
    boxButtons: TUPanel;
    btnAgree: TUButton;
    btnNotAgree: TUButton;
    memPrivacyPolicy: TRichEdit;
    procedure FrameResize(Sender: TObject);
    procedure btnAgreeClick(Sender: TObject);
    procedure btnNotAgreeClick(Sender: TObject);
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); override;
    procedure OnAppear(Sender: TObject); override;
  private
    procedure UpdateTextColor(Theme: TUTheme);
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
end;

procedure TfrmPrivacyPolicy.FrameResize(Sender: TObject);
begin
  inherited;
  boxPrivacyPolicy.Width := Min(800, Max(400, ClientWidth - 200));
  boxPrivacyPolicy.Left := Max((ClientWidth - boxPrivacyPolicy.Width) div 2, 0);
  boxButtons.Left := Max((boxPrivacyPolicy.Width - boxButtons.Width) div 2, 0);
end;

procedure TfrmPrivacyPolicy.OnAppear(Sender: TObject);
begin
  inherited;
  try
    memPrivacyPolicy.Lines.LoadFromFile(TUtils.GetPrivacyPolicy('privacypolicy.rtf'));
    UpdateTextColor(AppThemeManager.Theme);
  except
    on E: Exception do
      raise Exception.CreateFmt(_('Unable to load the privacy policy information. Error: %s'), [E.Message]);
  end;
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
  UpdateTextColor(Theme);
end;

procedure TfrmPrivacyPolicy.UpdateTextColor(Theme: TUTheme);
begin
  if Theme = utLight then
  begin
    memPrivacyPolicy.SelectAll;
    memPrivacyPolicy.SelAttributes.Color := clBlack;
    memPrivacyPolicy.SelStart := 0;
  end
  else
  begin
    memPrivacyPolicy.SelectAll;
    memPrivacyPolicy.SelAttributes.Color := clWhite;
    memPrivacyPolicy.SelStart := 0;
  end;
end;

initialization
  RegisterClassAlias(TfrmPrivacyPolicy, 'PrivacyPolicyPage');

end.
