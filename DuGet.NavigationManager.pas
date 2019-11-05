unit DuGet.NavigationManager;

interface

uses
  Vcl.Controls, Vcl.Forms, System.IOUtils, System.SysUtils, System.Classes,
  System.Types, System.Generics.Collections,
  Vcl.WinXPanels, WinApi.Windows,
  UCL.Classes, UCL.TUThemeManager,
  DuGet.App.Settings;

type
  TPageType = class of TFrame;

  TNavigationManager = class
  private
    FPageContainer: TCardPanel;
    FCurrentPage: TFrame;
    FCurrentPageAsModal: Boolean;
    FCurrentPageName: string;
    FCurrentTheme: TDuGetTheme;
    FListOfPages: TObjectList<TFrame>;
    procedure EnableBackButton;
    procedure ShowMenu(Show: Boolean);
    procedure InjectContext(Page: TFrame; Context: TObject);
    procedure AppThemeChanged(Page: TFrame);
    procedure PageAppear(Page: TFrame);
    procedure DoPush(PageType: TPageType; Context: TObject = nil); overload;
    procedure DoPush(const PageName: string; Context: TObject = nil); overload;
    procedure DoPop;
    procedure AfterPush(Context: TObject);
    procedure AfterPop;
    function GetHistorySize: Integer;
  public
    procedure Push(PageType: TPageType; Context: TObject = nil); overload;
    procedure Push(const PageName: string; Context: TObject = nil); overload;
    procedure PushAsModal(PageType: TPageType; Context: TObject = nil); overload;
    procedure PushAsModal(const PageName: string; Context: TObject = nil); overload;
    procedure Pop;
    procedure PopAsModal;
    procedure PopToRoot;

    procedure SetUTheme(const Theme: TDuGetTheme);

    destructor Destroy; override;
    constructor Create(APageContainer: TCardPanel);

    property AppPageContainer: TCardPanel read FPageContainer;
    property CurrentPage: string read FCurrentPageName;
    property IsModal: Boolean read FCurrentPageAsModal;
    property HistorySize: Integer read GetHistorySize;
  end;

var
  PageContainer: TCardPanel;
  _NavigationManager: TNavigationManager;

function NavigationManager: TNavigationManager;

implementation

uses
  RTTI,
  DuGet.Attributes,
  DuGet.Constants;

function NavigationManager: TNavigationManager;
begin
  if not Assigned(_NavigationManager) then
    _NavigationManager := TNavigationManager.Create(PageContainer);
  Result := _NavigationManager;
end;

{ TNavigationManager }

procedure TNavigationManager.AfterPop;
begin
  EnableBackButton;
  ShowMenu(not FCurrentPageAsModal);
end;

procedure TNavigationManager.AfterPush(Context: TObject);
begin
  if Assigned(Context) then
    InjectContext(FCurrentPage, Context);
  EnableBackButton;
  ShowMenu(not FCurrentPageAsModal);
  SetUTheme(FCurrentTheme);
  PageAppear(FCurrentPage);
end;

procedure TNavigationManager.AppThemeChanged(Page: TFrame);
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  RttiAttr: TCustomAttribute;
  RttiMethod: TRttiMethod;
begin
  RttiContext := TRttiContext.Create;
  try
    RttiType := RttiContext.GetType(Page.ClassType);
    for RttiMethod in RttiType.GetMethods do
    begin
      for RttiAttr in RttiMethod.GetAttributes do
      begin
        if RttiAttr is AppThemeChangedAttribute then
          RttiMethod.Invoke(Page, []);
      end;
    end;
  finally
    RttiContext.Free;
  end;
end;

constructor TNavigationManager.Create(APageContainer: TCardPanel);
begin
  if not Assigned(APageContainer) then
    raise Exception.Create('Set a valid page container before invoke the NavigationManager');

  FCurrentPageName := '';
  FCurrentPageAsModal := False;
  FPageContainer := APageContainer;
  FListOfPages := TObjectList<TFrame>.Create(False);
  FCurrentTheme := TAppSettings.Instance.Theme;
end;

destructor TNavigationManager.Destroy;
begin
  FListOfPages.Free;
  inherited;
end;

procedure TNavigationManager.DoPop;
begin
  if not Assigned(FCurrentPage) then
    Exit;

  FListOfPages.RemoveItem(FCurrentPage, FromEnd);
  FreeAndNil(FCurrentPage);
  FCurrentPageName := '';

  // The card with index 0 is reserved to the welcome page
  if PageContainer.CardCount > 1 then
  begin
    PageContainer.DeleteCard(PageContainer.CardCount - 1);
    PageContainer.ActiveCardIndex := PageContainer.CardCount - 1;
  end;

  if FListOfPages.Count > 0 then
  begin
    FCurrentPage := FListOfPages.Last;
    FCurrentPageName := FCurrentPage.ClassName;
  end;
end;

procedure TNavigationManager.DoPush(const PageName: string; Context: TObject);
var
  PageClass: TPageType;
  Card: TCard;
begin
  Card := PageContainer.CreateNewCard;
  PageContainer.ActiveCard := Card;

  PageClass := TPageType(FindClass(PageName));

  FCurrentPage := PageClass.Create(Card);
  FCurrentPage.Parent := Card;
  FListOfPages.Add(FCurrentPage);
  FCurrentPageName := FCurrentPage.ClassName;
  FCurrentPage.Width := Card.Width;
  FCurrentPage.Height := Card.Height;
end;

procedure TNavigationManager.DoPush(PageType: TPageType; Context: TObject);
var
  Card: TCard;
begin
  Card := PageContainer.CreateNewCard;
  PageContainer.ActiveCard := Card;

  FCurrentPage := PageType.Create(Card);
  FCurrentPage.Parent := Card;
  FListOfPages.Add(FCurrentPage);
  FCurrentPageName := PageType.ClassName;
  FCurrentPage.Width := Card.Width;
  FCurrentPage.Height := Card.Height;
end;

procedure TNavigationManager.EnableBackButton;
begin
  if (FListOfPages.Count > 0) and (not FCurrentPageAsModal) then
    PostMessage(Screen.Forms[0].Handle, WM_OWN_ENABLE_BACKBUTTON, 1, 0)
  else
    PostMessage(Screen.Forms[0].Handle, WM_OWN_ENABLE_BACKBUTTON, 0, 0);
end;

function TNavigationManager.GetHistorySize: Integer;
begin
  Result := FListOfPages.Count;
end;

procedure TNavigationManager.InjectContext(Page: TFrame; Context: TObject);
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  RttiAttr: TCustomAttribute;
  RttiField: TRttiField;
begin
  RttiContext := TRttiContext.Create;
  try
    RttiType := RttiContext.GetType(Page.ClassType);
    for RttiField in RttiType.GetFields do
    begin
      for RttiAttr in RttiField.GetAttributes do
      begin
        if RttiAttr is PageContextAttribute then
          RttiField.SetValue(Page, Context);
      end;
    end;
  finally
    RttiContext.Free;
  end;
end;

procedure TNavigationManager.PageAppear(Page: TFrame);
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  RttiAttr: TCustomAttribute;
  RttiMethod: TRttiMethod;
begin
  RttiContext := TRttiContext.Create;
  try
    RttiType := RttiContext.GetType(Page.ClassType);
    for RttiMethod in RttiType.GetMethods do
    begin
      for RttiAttr in RttiMethod.GetAttributes do
      begin
        if RttiAttr is PageAppearAttribute then
          RttiMethod.Invoke(Page, []);
      end;
    end;
  finally
    RttiContext.Free;
  end;
end;

procedure TNavigationManager.Pop;
begin
  DoPop;
  AfterPop;
end;

procedure TNavigationManager.PopAsModal;
begin
  DoPop;
  FCurrentPageAsModal := False;
  AfterPop;
end;

procedure TNavigationManager.PopToRoot;
begin
  repeat
    DoPop;
  until (FListOfPages.Count = 0);
  FCurrentPageAsModal := False;
  AfterPop;
end;

procedure TNavigationManager.Push(const PageName: string; Context: TObject);
begin
  DoPush(PageName, Context);
  FCurrentPageAsModal := False;
  AfterPush(Context);
end;

procedure TNavigationManager.PushAsModal(const PageName: string;
  Context: TObject);
begin
  DoPush(PageName, Context);
  FCurrentPageAsModal := True;
  AfterPush(Context);
end;

procedure TNavigationManager.PushAsModal(PageType: TPageType; Context: TObject);
begin
  DoPush(PageType, Context);
  FCurrentPageAsModal := True;
  AfterPush(Context);
end;

procedure TNavigationManager.SetUTheme(const Theme: TDuGetTheme);
var
  FramePage: TFrame;
  Component: TComponent;
  ThemeManager: TUThemeManager;
  I: Integer;
begin
  FCurrentTheme := Theme;
  for FramePage in FListOfPages do
  begin
    for I := 0 to FramePage.ComponentCount - 1 do
    begin
      Component := FramePage.Components[I];
      if Component is TUThemeManager then
      begin
        ThemeManager := (Component as TUThemeManager);
        ThemeManager.UseSystemTheme := (Theme = dgtSystem);
        if not ThemeManager.UseSystemTheme then
        begin
          if Theme = dgtLight then
            ThemeManager.CustomTheme := utLight
          else
            ThemeManager.CustomTheme := utDark;
        end;
        break;
      end;
    end;
    AppThemeChanged(FramePage)
  end; 
end;

procedure TNavigationManager.ShowMenu(Show: Boolean);
begin
  if Show then
    PostMessage(Screen.Forms[0].Handle, WM_OWN_SHOW_MENU, 1, 0)
  else
    PostMessage(Screen.Forms[0].Handle, WM_OWN_SHOW_MENU, 0, 0);
end;

procedure TNavigationManager.Push(PageType: TPageType; Context: TObject);
begin
  DoPush(PageType, Context);
  FCurrentPageAsModal := False;
  AfterPush(Context);
end;

initialization
  PageContainer := nil;
  _NavigationManager := nil;

finalization
  FreeAndNil(_NavigationManager);

end.
