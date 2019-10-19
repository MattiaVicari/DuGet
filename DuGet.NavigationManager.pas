unit DuGet.NavigationManager;

interface

uses
  Vcl.Controls, Vcl.Forms, System.IOUtils, System.SysUtils, System.Classes,
  System.Types, System.Generics.Collections;

type
  TPageType = class of TFrame;

  TNavigationManager = class
  private
    FPageContainer: TWinControl;
    FCurrentPage: TFrame;
    FListOfPages: TObjectList<TFrame>;
  public
    procedure Push(PageType: TPageType); overload;
    procedure Push(const PageName: string); overload;
    procedure Pop;

    destructor Destroy; override;
    constructor Create(APageContainer: TWinControl);

    property AppPageContainer: TWinControl read FPageContainer;
  end;

var
  PageContainer: TWinControl;
  _NavigationManager: TNavigationManager;

function NavigationManager: TNavigationManager;

implementation

function NavigationManager: TNavigationManager;
begin
  if not Assigned(_NavigationManager) then
    _NavigationManager := TNavigationManager.Create(PageContainer);
  Result := _NavigationManager;
end;

{ TNavigationManager }

constructor TNavigationManager.Create(APageContainer: TWinControl);
begin
  if not Assigned(APageContainer) then
    raise Exception.Create('Set a valid page container pointer before invoke the NavigationManager');

  FPageContainer := APageContainer;
  FListOfPages := TObjectList<TFrame>.Create(False);
end;

destructor TNavigationManager.Destroy;
begin
  FListOfPages.Free;
  inherited;
end;

procedure TNavigationManager.Pop;
begin
  if Assigned(FCurrentPage) then
  begin
    FListOfPages.RemoveItem(FCurrentPage, FromEnd);
    FreeAndNil(FCurrentPage);
  end;
end;

procedure TNavigationManager.Push(const PageName: string);
var
  PageClass: TPageType;
begin
  PageClass := TPageType(FindClass(PageName));

  FCurrentPage := PageClass.Create(PageContainer);
  FCurrentPage.Parent := PageContainer;
  FListOfPages.Add(FCurrentPage);
end;

procedure TNavigationManager.Push(PageType: TPageType);
begin
  FCurrentPage := PageType.Create(PageContainer);
  FCurrentPage.Parent := PageContainer;
  FListOfPages.Add(FCurrentPage);
end;

initialization
  PageContainer := nil;
  _NavigationManager := nil;

finalization
  FreeAndNil(_NavigationManager);

end.
