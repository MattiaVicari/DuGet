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
    { Private declarations }
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
end;

initialization
  RegisterClassAlias(TfrmPackagesList, 'PackagesListPage');

end.
