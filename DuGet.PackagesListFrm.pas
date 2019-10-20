unit DuGet.PackagesListFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  UCL.TUForm, UCL.TUThemeManager, Vcl.StdCtrls, UCL.TUText, UCL.TUSeparator,
  UCL.TUScrollBox, Vcl.ExtCtrls, UCL.TUPanel;

type
  TfrmPackagesList = class(TFrame)
    AppThemeManager: TUThemeManager;
    txtTitle: TUText;
    scrollPackagesList: TUScrollBox;
    splitter: TUSeparator;
    boxPackageInfo: TUPanel;
    txtPackageInfo: TUText;
  private
    procedure LoadList;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  DuGet.Utils;

{ TfrmPackagesList }

constructor TfrmPackagesList.Create(AOwner: TComponent);
begin
  inherited;
  TUtils.DoTranslation(Self);
  TUtils.SetupThemeManager(AppThemeManager);

  LoadList;
end;

procedure TfrmPackagesList.LoadList;
var
  ItemPanel: TUPanel;
  I: Integer;
begin
  for I := 1 to 10 do
  begin
    ItemPanel := TUPanel.Create(scrollPackagesList);
    ItemPanel.Align := alTop;
    ItemPanel.Height := 50;
    ItemPanel.Caption := 'Item ' + IntToStr(I);
    ItemPanel.Parent := scrollPackagesList;
  end;
end;

initialization
  RegisterClassAlias(TfrmPackagesList, 'PackagesListPage');

end.
