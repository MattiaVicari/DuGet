unit DuGet.NavigationManager;

interface

uses
  Vcl.Controls, Vcl.Forms, System.IOUtils, System.SysUtils, System.Classes,
  System.Types, System.Generics.Collections,
  Vcl.WinXPanels, WinApi.Windows,
  UCL.Classes, UCL.TUThemeManager;

type
  TPageType = class of TFrame;

  TNavigationManager = class
  private
    FPageContainer: TCardPanel;
    FCurrentPage: TFrame;
    FCurrentPageName: string;
    FCurrentTheme: TUTheme;
    FListOfPages: TObjectList<TFrame>;
    procedure EnableBackButton;
  public
    procedure Push(PageType: TPageType); overload;
    procedure Push(const PageName: string); overload;
    procedure Pop;

    procedure SetUTheme(const Theme: TUTheme);

    destructor Destroy; override;
    constructor Create(APageContainer: TCardPanel);

    property AppPageContainer: TCardPanel read FPageContainer;
    property CurrentPage: string read FCurrentPageName;
  end;

var
  PageContainer: TCardPanel;
  _NavigationManager: TNavigationManager;

function NavigationManager: TNavigationManager;

implementation

uses
  DuGet.BaseFrm,
  DuGet.Constants;

function NavigationManager: TNavigationManager;
begin
  if not Assigned(_NavigationManager) then
    _NavigationManager := TNavigationManager.Create(PageContainer);
  Result := _NavigationManager;
end;

{ TNavigationManager }

constructor TNavigationManager.Create(APageContainer: TCardPanel);
begin
  if not Assigned(APageContainer) then
    raise Exception.Create('Set a valid page container before invoke the NavigationManager');

  FCurrentPageName := '';
  FPageContainer := APageContainer;
  FListOfPages := TObjectList<TFrame>.Create(False);
  FCurrentTheme := utLight;
end;

destructor TNavigationManager.Destroy;
begin
  FListOfPages.Free;
  inherited;
end;

procedure TNavigationManager.EnableBackButton;
begin
  if FListOfPages.Count > 0 then
    PostMessage(Screen.Forms[0].Handle, WM_OWN_ENABLE_BACKBUTTON, 1, 0)
  else
    PostMessage(Screen.Forms[0].Handle, WM_OWN_ENABLE_BACKBUTTON, 0, 0);
end;

procedure TNavigationManager.Pop;
begin
  if Assigned(FCurrentPage) then
  begin
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

    EnableBackButton;
  end;
end;

procedure TNavigationManager.Push(const PageName: string);
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

  EnableBackButton;
  SetUTheme(FCurrentTheme);
end;

procedure TNavigationManager.SetUTheme(const Theme: TUTheme);
var
  FramePage: TFrame;
  Component: TComponent;
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
        (Component as TUThemeManager).CustomTheme := Theme;
        break;
      end;
    end;

    if FramePage is TfrmBase then
      (FramePage as TfrmBase).UpdateTheme;
  end; 
end;

procedure TNavigationManager.Push(PageType: TPageType);
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

  EnableBackButton;
  SetUTheme(FCurrentTheme);
end;

initialization
  PageContainer := nil;
  _NavigationManager := nil;

finalization
  FreeAndNil(_NavigationManager);

end.
