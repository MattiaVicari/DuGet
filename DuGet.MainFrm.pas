unit DuGet.MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.WinXPanels,

  UCL.TUForm, UCL.TUThemeManager, UCL.TUCaptionBar, UCL.Classes,
  UCL.TUQuickButton, UCL.TUPanel, UCL.TUSymbolButton,
  UCL.IntAnimation, UCL.IntAnimation.Helpers, UCL.TUText,

  DuGet.Constants, DuGet.App.Settings;

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
    btnPackagesList: TUSymbolButton;
    btnBack: TUQuickButton;
    cardContentPage: TCardPanel;
    cardWelcome: TCard;
    imgDuGetLogo: TImage;
    btnPrivacyPolicy: TUSymbolButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSwitchThemeClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnPackagesListClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnPrivacyPolicyClick(Sender: TObject);
  private
    procedure SetupBackground;
    procedure UpdateCaptionBar;
    procedure UpdateAppTheme(Theme: TDuGetTheme);

    procedure MessageHandlerEnableBackButton(var Msg: TMessage); message WM_OWN_ENABLE_BACKBUTTON;
    procedure MessageHandlerUpdateAppTheme(var Msg: TMessage); message WM_OWN_UPDATE_APPTHEME;
    procedure MessageHandlerShowMenu(var Msg: TMessage); message WM_OWN_SHOW_MENU;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  DuGet.Utils,
  DuGet.NavigationManager;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  if NavigationManager.CurrentPage <> 'AboutPage' then
  begin
    NavigationManager.PopToRoot;
    NavigationManager.Push('AboutPage');
  end;
end;

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
  if boxHamburgerMenu.Width > TUtils.FromPixelToScreen(45, PPI) then
    MenuOffsetWidth := -1 * MenuOffsetWidth;

  boxHamburgerMenu.AnimationFromCurrent(apWidth, MenuOffsetWidth, 20, 200, akOut, afkQuartic, nil);
end;

procedure TfrmMain.btnPackagesListClick(Sender: TObject);
begin
  if NavigationManager.CurrentPage <> 'PackagesListPage' then
  begin
    NavigationManager.PopToRoot;
    NavigationManager.Push('PackagesListPage');
  end;
end;

procedure TfrmMain.btnPrivacyPolicyClick(Sender: TObject);
begin
  if NavigationManager.CurrentPage <> 'PrivacyPolicyPage' then
  begin
    NavigationManager.PopToRoot;
    NavigationManager.Push('PrivacyPolicyPage');
  end;
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
begin
  if NavigationManager.CurrentPage <> 'SettingsPage' then
  begin
    NavigationManager.PopToRoot;
    NavigationManager.Push('SettingsPage');
  end;
end;

procedure TfrmMain.btnSwitchThemeClick(Sender: TObject);
begin
  if ThemeManager.Theme = utLight then
    UpdateAppTheme(dgtDark)
  else
    UpdateAppTheme(dgtLight);
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

  ThemeManager.UseSystemTheme := (TAppSettings.Instance.Theme = dgtSystem);
  case TAppSettings.Instance.Theme of
    dgtLight: ThemeManager.CustomTheme := utLight;
    dgtDark: ThemeManager.CustomTheme := utDark;
  end;

  UpdateCaptionBar;

  // Splash screen
  SplashImage := TUtils.GetAsset('SplashScreen.png');
  SplashScreenDelay := 1000;
  StartSplashScreen;

  SetupBackground;

  if TAppSettings.Instance.FirstLaunch then
    NavigationManager.PushAsModal('PrivacyPolicyPage')
  else if not TAppSettings.Instance.Init then
  begin
    // You have to insert your personal token for GitHub API
    NavigationManager.PushAsModal('SettingsPage');
  end;
end;

procedure TfrmMain.MessageHandlerEnableBackButton(var Msg: TMessage);
begin
  btnBack.Visible := (Msg.WParam = 1);
end;

procedure TfrmMain.MessageHandlerShowMenu(var Msg: TMessage);
begin
  if Msg.WParam = 1 then
    boxHamburgerMenu.Width := 45
  else
    boxHamburgerMenu.Width := 0;
end;

procedure TfrmMain.MessageHandlerUpdateAppTheme(var Msg: TMessage);
begin
  UpdateAppTheme(TDuGetTheme(Msg.WParam));
end;

procedure TfrmMain.SetupBackground;
begin
  if ThemeManager.Theme = utLight then
    imgDuGetLogo.Picture.LoadFromFile(TUtils.GetAsset('Logo_300x300alpha.png'))
  else
    imgDuGetLogo.Picture.LoadFromFile(TUtils.GetAsset('Logo_black_300x300alpha.png'));
end;

procedure TfrmMain.UpdateAppTheme(Theme: TDuGetTheme);
begin
  if Theme = dgtDark then
    ThemeManager.CustomTheme := utDark
  else
    ThemeManager.CustomTheme := utLight;
  ThemeManager.UseSystemTheme := (Theme = dgtSystem);

  UpdateCaptionBar;
  SetupBackground;
  // Update theme for other pages
  NavigationManager.SetUTheme(Theme);
end;

procedure TfrmMain.UpdateCaptionBar;
begin
  AppCaptionBar.Caption := #9 + Trim(AppCaptionBar.Caption);
  btnSwitchTheme.Visible := not ThemeManager.UseSystemTheme;
end;

end.
