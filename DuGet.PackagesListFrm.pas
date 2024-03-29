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

unit DuGet.PackagesListFrm;

{$I 'duget.inc'}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, System.Types, System.IOUtils,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UCL.TUForm, UCL.TUThemeManager, Vcl.StdCtrls, UCL.TUText, UCL.TUSeparator,
  UCL.Classes, UCL.Utils,
  Vcl.ExtCtrls, UCL.TUPanel, Vcl.ComCtrls,
  Vcl.WinXCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, UCL.TUSymbolButton,
  DuGet.BaseFrm, DuGet.Proxy, DuGet.Modules.Package, Vcl.Imaging.pngimage,
  Vcl.WinXPanels;

type
  TfrmPackagesList = class(TfrmBase)
    listPackages: TListView;
    boxPackageFilter: TUPanel;
    btnRefresh: TUSymbolButton;
    searchBox: TSearchBox;
    txtPackagesFound: TUText;
    txtPackagesProgress: TUText;
    boxLoadingMsg: TStackPanel;
    procedure listPackagesCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure listPackagesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnRefreshClick(Sender: TObject);
    procedure searchBoxInvokeSearch(Sender: TObject);
    procedure listPackagesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FrameResize(Sender: TObject);
  private
    FItemSelected, FItemOver: Integer;
    FFilter: string;
    FModulePackage: TmodPackage;
    FProxy: IDuGetProxy;
    FDefaultLogoGraphic: TGraphic;
    FCacheLogoList: TObjectDictionary<string, TGraphic>;
    procedure LoadTerminated(Sender: TObject);
    procedure UpdateProgress(Sender: TObject; NumberOfItems, CurrentItem: Integer);
    procedure AddPackage(Sender: TObject; PackageInfo: TPackageInfo);
    procedure LoadList;
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); override;
    procedure OnAppear(Sender: TObject); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TAddPackage = procedure(Sender: TObject; PackageInfo: TPackageInfo) of object;

  TLoadDataThread = class(TThread)
  private
    FProxy: IDuGetProxy;
    FCacheCDS: TFDMemTable;
    FFilter: string;
    FUpdateProgress: TUpdateProgressFunc;
    FAddPackage: TAddPackage;
    procedure UpdateProgress(Sender: TObject; NumberOfItems, CurrentItem: Integer);
  protected
    procedure Execute; override;
  public
    property Proxy: IDuGetProxy read FProxy write FProxy;
    property Filter: string read FFilter write FFilter;
    property CacheCDS: TFDMemTable read FCacheCDS write FCacheCDS;
    property OnUpdateProgress: TUpdateProgressFunc read FUpdateProgress write FUpdateProgress;
    property OnAddPackage: TAddPackage read FAddPackage write FAddPackage;
  end;

implementation

{$R *.dfm}

uses
{$IFDEF GNUGETTEXT}
  JvGnugettext,
{$ELSE}
  DuGet.Translator,
{$ENDIF}
  DuGet.Utils,
  DuGet.Constants,
  DuGet.App.Settings,
  DuGet.NavigationManager;

const
  LogoSize = 100;

{ TfrmPackagesList }

procedure TfrmPackagesList.AddPackage(Sender: TObject; PackageInfo: TPackageInfo);
begin
  listPackages.Items.BeginUpdate;
  try
    with listPackages.Items.Add do
    begin
      Data := PackageInfo;
    end;
  finally
    listPackages.Items.EndUpdate;
  end;
end;

procedure TfrmPackagesList.btnRefreshClick(Sender: TObject);
begin
  inherited;
  TUtils.ClearCache;
  FProxy.ClearData;
  FModulePackage.ClearData;
  LoadList;
end;

constructor TfrmPackagesList.Create(AOwner: TComponent);
var
  DefaultLogoFileName: string;
begin
  inherited;

  FModulePackage := TmodPackage.Create(nil);
  FFilter := '';
  listPackages.Font.Height := LogoSize + 80;

  FItemSelected := -1;
  FItemOver := -1;
  FProxy := TProxyFactory.GetProxy('GitHubProxy');

  DefaultLogoFileName := TUtils.GetAsset('Logo_100x100.png');
  TUtils.CreateGraphic(ExtractFileExt(DefaultLogoFileName), FDefaultLogoGraphic);
  FDefaultLogoGraphic.LoadFromFile(DefaultLogoFileName);
  FDefaultLogoGraphic.SetSize(LogoSize, LogoSize);

  FCacheLogoList := TObjectDictionary<string, TGraphic>.Create([doOwnsValues]);
end;

destructor TfrmPackagesList.Destroy;
begin
  FModulePackage.Free;
  FDefaultLogoGraphic.Free;
  FCacheLogoList.Free;
  inherited;
end;

procedure TfrmPackagesList.FrameResize(Sender: TObject);
begin
  inherited;
  boxLoadingMsg.Top := ActivityIndicator.Top + ActivityIndicator.Height + 10;
  boxLoadingMsg.Left := (ClientWidth - boxLoadingMsg.Width) div 2;
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

  if (FItemSelected = Item.Index) or (FItemOver = Item.Index) then
  begin
    ViewCanvas.Brush.Style := bsSolid;
    if AppThemeManager.Theme = utLight then
      ViewCanvas.Brush.Color := LightSelectionColor
    else
      ViewCanvas.Brush.Color := DarkSelectionColor;
    ViewCanvas.FillRect(Rect);
  end;

  // Package logo
  if (Info.LogoCachedFilePath <> '') and (TFile.Exists(Info.LogoCachedFilePath)) then
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
  ViewCanvas.TextOut(Rect.Left + LogoSize + 10, Rect.Top + 5, PackageName);
  // Description
  TextRect.Left := Rect.Left + LogoSize + 10;
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
  ViewCanvas.TextOut(Rect.Left + 5, Rect.Top + 115, Format(_('Author: %s'), [Info.Owner.Login]));
  // Licenses
  Licenses := '-';
  if Length(Info.LicensesType) > 0 then
  begin
    Licenses := '';
    for I := Low(Info.LicensesType) to High(Info.LicensesType) do
    begin
      if Licenses <> '' then
        Licenses := Licenses + ', ';
      Licenses := Info.LicensesType[I];
    end;
  end;
  ViewCanvas.Font.Color := listPackages.Font.Color;
  ViewCanvas.Font.Name := listPackages.Font.Name;
  ViewCanvas.Font.Style := [];
  ViewCanvas.Font.Size := 12;
  ViewCanvas.Refresh;
  ViewCanvas.TextOut(Rect.Left + 5, Rect.Top + LogoSize + 50, Format(_('Licenses: %s'), [Licenses]));
end;

procedure TfrmPackagesList.listPackagesMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(listPackages.GetItemAt(X, Y)) then
    FItemOver := listPackages.GetItemAt(X, Y).Index;
end;

procedure TfrmPackagesList.listPackagesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if not Selected then
    Exit;
  FItemSelected := Item.Index;
  FModulePackage.FindPackage(TPackageInfo(Item.Data).PackageId);
  listPackages.Selected := nil; // In order to allow the selection of the same item
  NavigationManager.Push('PackagesDetailPage', FModulePackage);
end;

procedure TfrmPackagesList.LoadList;
  procedure ClearPackagesList;
  begin
    listPackages.Items.BeginUpdate;
    try
      listPackages.Items.Clear;
    finally
      listPackages.Items.EndUpdate;
    end;
  end;
var
  LoadThread: TLoadDataThread;
begin
  IsBusy := True;
  ClearPackagesList;

  LoadThread := TLoadDataThread.Create(True);
  LoadThread.FreeOnTerminate := True;
  LoadThread.Proxy := FProxy;
  LoadThread.Filter := FFilter;
  LoadThread.CacheCDS := FModulePackage.Data;
  LoadThread.OnTerminate := LoadTerminated;
  LoadThread.OnUpdateProgress := UpdateProgress;
  LoadThread.OnAddPackage := AddPackage;
  LoadThread.Start;
end;

procedure TfrmPackagesList.LoadTerminated(Sender: TObject);
begin
  IsBusy := False;
  boxLoadingMsg.Visible := False;
end;

procedure TfrmPackagesList.OnAppear(Sender: TObject);
begin
  inherited;
  LoadList;
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

procedure TfrmPackagesList.UpdateProgress(Sender: TObject; NumberOfItems,
  CurrentItem: Integer);
begin
  boxLoadingMsg.Visible := True;
  txtPackagesFound.Caption := Format(_('%d packages found'), [NumberOfItems]);
  txtPackagesProgress.Caption := Format(_('Loading %d of %d...'), [CurrentItem, NumberOfItems]);
end;

procedure TfrmPackagesList.searchBoxInvokeSearch(Sender: TObject);
begin
  inherited;
  FFilter := searchBox.Text;
  LoadList;
end;

{ TLoadDataThread }

procedure TLoadDataThread.Execute;
  function CheckFilter(AInfo: TPackageInfo): Boolean;
  begin
    Result := True;
    if FFilter <> '' then
    begin
      Result := AInfo.Name.ToUpper.Contains(FFilter.ToUpper);
      Result := Result or AInfo.FullName.ToUpper.Contains(FFilter.ToUpper);
      Result := Result or AInfo.AlternativeName.ToUpper.Contains(FFilter.ToUpper);
    end;
  end;
var
  Info: TPackageInfo;
begin
  inherited;

  FProxy.SetAccessToken(TAppSettings.Instance.Token);
  FProxy.SetCacheContainer(FCacheCDS);
  FProxy.SetOnUpdateProgress(UpdateProgress);

  for Info in FProxy.GetPackagesList do
  begin
    if CheckFilter(Info) then
    begin
      Synchronize(procedure
        begin
          if Assigned(FAddPackage) then
            FAddPackage(Self, Info);
        end);
    end;
  end;
end;

procedure TLoadDataThread.UpdateProgress(Sender: TObject; NumberOfItems,
  CurrentItem: Integer);
begin
  if Assigned(FUpdateProgress) then
  begin
    Synchronize(procedure
      begin
        FUpdateProgress(Sender, NumberOfItems, CurrentItem);
      end);
  end;
end;

initialization
  RegisterClassAlias(TfrmPackagesList, 'PackagesListPage');

end.
