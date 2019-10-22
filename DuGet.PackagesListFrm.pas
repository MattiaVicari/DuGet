unit DuGet.PackagesListFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UCL.TUForm, UCL.TUThemeManager, Vcl.StdCtrls, UCL.TUText, UCL.TUSeparator,
  UCL.TUScrollBox, Vcl.ExtCtrls, UCL.TUPanel, Vcl.ComCtrls,
  DuGet.Proxy, DuGet.Proxy.GitHub;

type
  TfrmPackagesList = class(TFrame)
    AppThemeManager: TUThemeManager;
    txtTitle: TUText;
    splitter: TUSeparator;
    boxPackageInfo: TUPanel;
    txtPackageInfo: TUText;
    listPackages: TListView;
    procedure listPackagesCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure listPackagesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FItemSelected: Integer;
    FProxy: TDuGetProxyGitHub;
    procedure LoadList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  DuGet.Utils;

{ TfrmPackagesList }

constructor TfrmPackagesList.Create(AOwner: TComponent);
begin
  inherited;

  FItemSelected := -1;
  FProxy := TDuGetProxyGitHub.Create;

  TUtils.DoTranslation(Self);
  TUtils.SetupThemeManager(AppThemeManager);

  LoadList;
end;

destructor TfrmPackagesList.Destroy;
begin
  FProxy.Free;
  inherited;
end;

procedure TfrmPackagesList.listPackagesCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Rect: TRect;
  Info: TPackageInfo;
begin
  DefaultDraw := False;
  Rect := Item.DisplayRect(drBounds);
  Info := Item.Data;
  if FItemSelected = Item.Index then
  begin
    listPackages.Canvas.Brush.Style := bsSolid;
    listPackages.Canvas.Brush.Color := RGB(200, 200, 200);
    listPackages.Canvas.FillRect(Rect);
  end;
  listPackages.Canvas.TextOut(Rect.Left + 5, Rect.Top + 5, Info.Name);
end;

procedure TfrmPackagesList.listPackagesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  FItemSelected := Item.Index;
end;

procedure TfrmPackagesList.LoadList;
var
  Info: TPackageInfo;
begin
  listPackages.Items.BeginUpdate;
  try
    FProxy.AccessToken := 'TO BE DEFINED';

    for Info in FProxy.Packages do
    begin
      with listPackages.Items.Add do
      begin
        Data := Info;
      end;
    end;
  finally
    listPackages.Items.EndUpdate;
  end;
end;

initialization
  RegisterClassAlias(TfrmPackagesList, 'PackagesListPage');

end.
