program ProjectDuGet;

uses
  Vcl.Forms,
  DuGet.MainFrm in 'DuGet.MainFrm.pas' {frmMain},
  DuGet.Utils in 'DuGet.Utils.pas',
  DuGet.PackagesListFrm in 'DuGet.PackagesListFrm.pas' {frmPackagesList: TFrame},
  DuGet.NavigationManager in 'DuGet.NavigationManager.pas';

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
