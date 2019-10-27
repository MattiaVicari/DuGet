unit DuGet.PackagesListFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, System.Types,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UCL.TUForm, UCL.TUThemeManager, Vcl.StdCtrls, UCL.TUText, UCL.TUSeparator,
  UCL.Classes, UCL.Utils,
  Vcl.ExtCtrls, UCL.TUPanel, Vcl.ComCtrls,
  DuGet.BaseFrm, DuGet.Proxy, Vcl.WinXCtrls;

type
  TfrmPackagesList = class(TfrmBase)
    boxPackageInfo: TUPanel;
    txtPackageInfo: TUText;
    listPackages: TListView;
    procedure listPackagesCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure listPackagesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    FItemSelected: Integer;
    FProxy: IDuGetProxy;
    FDefaultLogoGraphic: TGraphic;
    FCacheLogoList: TObjectDictionary<string, TGraphic>;
    procedure LoadTerminated(Sender: TObject);
    procedure LoadList;
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TLoadDataThread = class(TThread)
  private
    FProxy: IDuGetProxy;
    FDataList: TListView;
  protected
    procedure Execute; override;
  public
    property Proxy: IDuGetProxy read FProxy write FProxy;
    property DataList: TListView read FDataList write FDataList;
  end;

implementation

{$R *.dfm}

uses
  JvGnugettext,
  DuGet.Utils,
  DuGet.Constants,
  DuGet.App.Settings;

const
  LogoSize = 150;

{ TfrmPackagesList }

constructor TfrmPackagesList.Create(AOwner: TComponent);
var
  DefaultLogoFileName: string;
begin
  inherited;

  listPackages.Font.Height := 150;

  FItemSelected := -1;
  FProxy := TProxyFactory.GetProxy('GitHubProxy');

  DefaultLogoFileName := TUtils.GetAsset('Logo_150x150.png');
  TUtils.CreateGraphic(ExtractFileExt(DefaultLogoFileName), FDefaultLogoGraphic);
  FDefaultLogoGraphic.LoadFromFile(DefaultLogoFileName);
  FDefaultLogoGraphic.SetSize(LogoSize, LogoSize);

  FCacheLogoList := TObjectDictionary<string, TGraphic>.Create([doOwnsValues]);

  LoadList;
end;

destructor TfrmPackagesList.Destroy;
begin
  FDefaultLogoGraphic.Free;
  FCacheLogoList.Free;
  inherited;
end;

procedure TfrmPackagesList.listPackagesCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  I: Integer;
  Info: TPackageInfo;
  Rect, TextRect, LogoRect: TRect;
  ViewCanvas: TCanvas;
  LogoGraphic: TGraphic;
  LogStream: TFileStream;
  PackageName, Licenses: string;
begin
  DefaultDraw := False;

  ViewCanvas := Sender.Canvas;
  Rect := Item.DisplayRect(drBounds);
  Info := Item.Data;

  if FItemSelected = Item.Index then
  begin
    ViewCanvas.Brush.Style := bsSolid;
    if AppThemeManager.Theme = utLight then
      ViewCanvas.Brush.Color := LightSelectionColor
    else
      ViewCanvas.Brush.Color := DarkSelectionColor;
    ViewCanvas.FillRect(Rect);
  end;

  // Package logo
  if Info.LogoCachedFilePath <> '' then
  begin
    try
      if FCacheLogoList.ContainsKey(Info.PackageId) then
        LogoGraphic := FCacheLogoList.Items[Info.PackageId]
      else
      begin
        TUtils.CreateGraphic(ExtractFileExt(Info.LogoFileName), LogoGraphic);
        LogStream := TFileStream.Create(Info.LogoCachedFilePath, fmOpenRead);
        try
          LogoGraphic.LoadFromStream(LogStream);
          LogoGraphic.SetSize(LogoSize, LogoSize);
          FCacheLogoList.Add(Info.PackageId, LogoGraphic);
        finally
          LogStream.Free;
        end;
      end;
    except
      LogoGraphic := FDefaultLogoGraphic;
    end;
  end
  else
    LogoGraphic := FDefaultLogoGraphic;

  LogoRect.Left := Rect.Left;
  LogoRect.Right := LogoRect.Left + LogoSize;
  LogoRect.Top := Rect.Top;
  LogoRect.Bottom := LogoRect.Top + LogoSize;
  ViewCanvas.StretchDraw(LogoRect, LogoGraphic);

  // Package name
  PackageName := Info.Name;
  if Info.AlternativeName <> '' then
    Info.Name := Info.AlternativeName;
  ViewCanvas.Font.Color := listPackages.Font.Color;
  ViewCanvas.Font.Name := listPackages.Font.Name;
  ViewCanvas.Font.Style := [TFontStyle.fsBold];
  ViewCanvas.Font.Size := 14;
  ViewCanvas.Refresh;
  ViewCanvas.TextOut(Rect.Left + LogoSize, Rect.Top + 5, PackageName);
  // Description
  TextRect.Left := Rect.Left + LogoSize + 5;
  TextRect.Right := Rect.Width - 5;
  TextRect.Top := Rect.Top + 50;
  TextRect.Bottom := TextRect.Top + 50;
  ViewCanvas.Font.Style := [TFontStyle.fsItalic];
  ViewCanvas.Font.Size := 10;
  ViewCanvas.Refresh;
  DrawText(ViewCanvas.Handle, Info.Description, Info.Description.Length, TextRect, DT_WORDBREAK or DT_END_ELLIPSIS or DT_EDITCONTROL);
  // Author
  ViewCanvas.Font.Color := listPackages.Font.Color;
  ViewCanvas.Font.Name := listPackages.Font.Name;
  ViewCanvas.Font.Style := [];
  ViewCanvas.Font.Size := 12;
  ViewCanvas.Refresh;
  ViewCanvas.TextOut(Rect.Left + LogoSize, Rect.Top + 105, Format(_('Author: %s'), [Info.Owner.Login]));
  // Licenses
  Licenses := '';
  for I := Low(Info.LicensesType) to High(Info.LicensesType) do
  begin
    if Licenses <> '' then
      Licenses := Licenses + ', ';
    Licenses := Info.LicensesType[I];
  end;
  ViewCanvas.Font.Color := listPackages.Font.Color;
  ViewCanvas.Font.Name := listPackages.Font.Name;
  ViewCanvas.Font.Style := [];
  ViewCanvas.Font.Size := 12;
  ViewCanvas.Refresh;
  ViewCanvas.TextOut(Rect.Left + 5, Rect.Top + LogoSize + 5, Format(_('Licenses: %s'), [Licenses]));
end;

procedure TfrmPackagesList.listPackagesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  FItemSelected := Item.Index;
end;

procedure TfrmPackagesList.LoadList;
var
  LoadThread: TLoadDataThread;
begin
  IsBusy := True;
  LoadThread := TLoadDataThread.Create(True);
  LoadThread.FreeOnTerminate := True;
  LoadThread.Proxy := FProxy;
  LoadThread.DataList := listPackages;
  LoadThread.OnTerminate := LoadTerminated;
  LoadThread.Start;
end;

procedure TfrmPackagesList.LoadTerminated(Sender: TObject);
begin
  IsBusy := False;
end;

procedure TfrmPackagesList.OnChangeTheme(Sender: TObject; Theme: TUTheme);
begin
  inherited;
  if Theme = utLight then
  begin
    listPackages.Color := clWhite;
    listPackages.Font.Color := clBlack;
  end
  else
  begin
    listPackages.Color := clBlack;
    listPackages.Font.Color := clWhite;
  end;
end;

{ TLoadDataThread }

procedure TLoadDataThread.Execute;
var
  Info: TPackageInfo;
begin
  inherited;
  FProxy.SetAccessToken(TAppSettings.Instance.Token);
  for Info in FProxy.GetPackagesList do
  begin
    Synchronize(procedure
      begin
        FDataList.Items.BeginUpdate;
        try
          with FDataList.Items.Add do
          begin
            Data := Info;
          end;
        finally
          FDataList.Items.EndUpdate;
        end;
      end);
  end;
end;

initialization
  RegisterClassAlias(TfrmPackagesList, 'PackagesListPage');

end.
