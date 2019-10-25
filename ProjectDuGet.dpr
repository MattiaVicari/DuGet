program ProjectDuGet;

uses
  Vcl.Forms,
  DuGet.MainFrm in 'DuGet.MainFrm.pas' {frmMain},
  DuGet.Utils in 'DuGet.Utils.pas',
  DuGet.PackagesListFrm in 'DuGet.PackagesListFrm.pas' {frmPackagesList: TFrame},
  DuGet.NavigationManager in 'DuGet.NavigationManager.pas',
  DuGet.Proxy.GitHub in 'DuGet.Proxy.GitHub.pas',
  DuGet.Proxy in 'DuGet.Proxy.pas',
  DuGet.SettingsFrm in 'DuGet.SettingsFrm.pas' {frmSettings: TFrame},
  DuGet.BaseFrm in 'DuGet.BaseFrm.pas' {frmBase: TFrame},
  DuGet.App.Settings in 'DuGet.App.Settings.pas',
  DuGet.Constants in 'DuGet.Constants.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  // Set the current language
  TUtils.SetupTranslation;
  TUtils.SetupAppLanguage;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
