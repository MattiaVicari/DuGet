unit DuGet.MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.WinXPanels,

  UCL.TUForm, UCL.TUThemeManager, UCL.TUCaptionBar, UCL.Classes,
  UCL.TUQuickButton, UCL.TUPanel, UCL.TUSymbolButton, UCL.TUScrollBox,
  UCL.IntAnimation, UCL.IntAnimation.Helpers, UCL.TUText,

  DuGet.Constants;

type
  TfrmMain = class(TUForm)
    AppThemeManager: TUThemeManager;
    AppCaptionBar: TUCaptionBar;
    btnSwitchTheme: TUQuickButton;
    btnMinimize: TUQuickButton;
    btnMaximize: TUQuickButton;
    btnQuit: TUQuickButton;
    boxHamburgerMenu: TUPanel;
    btnMenu: TUSymbolButton;
    btnSettings: TUSymbolButton;
    btnAbout: TUSymbolButton;
    txtPageTitle: TUText;
    btnPackagesList: TUSymbolButton;
    btnBack: TUQuickButton;
    cardContentPage: TCardPanel;
    cardWelcome: TCard;
    imgDuGetLogo: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSwitchThemeClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnPackagesListClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    procedure MessageHandlerEnableBackButton(var Msg: TMessage); message WM_OWN_ENABLE_BACKBUTTON;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  DuGet.Utils,
  DuGet.App.Settings,
  DuGet.NavigationManager;

procedure TfrmMain.btnBackClick(Sender: TObject);
begin
  NavigationManager.Pop;
end;

procedure TfrmMain.btnMenuClick(Sender: TObject);
var
  MenuOffsetWidth: Integer;
begin
  // 225 = width of opened menu
  // 45 = width of closed menu
  MenuOffsetWidth := TUtils.FromPixelToScreen(225 - 45, PPI);
  if boxHamburgerMenu.Width <> TUtils.FromPixelToScreen(45, PPI) then
    MenuOffsetWidth := -1 * MenuOffsetWidth;

  boxHamburgerMenu.AnimationFromCurrent(apWidth, MenuOffsetWidth, 20, 200, akOut, afkQuartic, nil);
end;

procedure TfrmMain.btnPackagesListClick(Sender: TObject);
begin
  if NavigationManager.CurrentPage <> 'PackagesListPage' then
    NavigationManager.Push('PackagesListPage');
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
begin
  NavigationManager.Pop;
  NavigationManager.Push('SettingsPage');
end;

procedure TfrmMain.btnSwitchThemeClick(Sender: TObject);
begin
  if ThemeManager.Theme = utLight then
    ThemeManager.CustomTheme := utDark
  else
    ThemeManager.CustomTheme := utLight;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  TUtils.DoTranslation(Self);
  TUtils.SetupThemeManager(AppThemeManager);

  // Where to show the pages
  PageContainer := cardContentPage;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  // Setup UForm properties
  ThemeManager := AppThemeManager;
  CaptionBar := AppCaptionBar;

  // Splash screen
  SplashImage := TUtils.GetAsset('SplashScreen.png');
  SplashScreenDelay := 1000;
  StartSplashScreen;

  if not TAppSettings.Instance.Init then
  begin
    // You have to insert your personal token for GitHub API
    NavigationManager.Push('SettingsPage');
  end;
end;

procedure TfrmMain.MessageHandlerEnableBackButton(var Msg: TMessage);
begin
  btnBack.Visible := (Msg.WParam = 1);
end;

end.
