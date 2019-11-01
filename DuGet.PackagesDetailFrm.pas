unit DuGet.PackagesDetailFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DuGet.BaseFrm, UCL.TUThemeManager,
  Vcl.WinXCtrls, Vcl.StdCtrls, UCL.TUText, Vcl.ExtCtrls, UCL.TUPanel,
  UCL.TUHyperLink, UCL.Classes, DuGet.Proxy, DuGet.Modules.Package;

type
  TfrmPackageDetail = class(TfrmBase)
    boxContent: TUPanel;
    imgLogo: TImage;
    txtLblName: TUText;
    txtName: TUText;
    txtLblDescription: TUText;
    memDescription: TMemo;
    txtLblAuthour: TUText;
    txtAuthor: TUText;
    txtLblLicenses: TUText;
    txtLicenses: TUText;
    txtLblCreatedAt: TUText;
    txtCreatedAt: TUText;
    txtLblUpdatedAt: TUText;
    txtUpdatedAt: TUText;
    txtLblUrl: TUText;
    linkUrl: TUHyperLink;
    txtLblCloneUrl: TUText;
    linkCloneUrl: TUHyperLink;
  private
    FModulePackage: TmodPackage;
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); override;
    procedure OnAppear(Sender: TObject); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

//var
//  frmPackageDetail: TfrmPackageDetail;

implementation

{$R *.dfm}

uses
  JvGnugettext;

{ TfrmPackageDetail }

constructor TfrmPackageDetail.Create(AOwner: TComponent);
begin
  inherited;
  FModulePackage := TmodPackage.Create(nil);
end;

destructor TfrmPackageDetail.Destroy;
begin
  FModulePackage.Free;
  inherited;
end;

procedure TfrmPackageDetail.OnAppear(Sender: TObject);
begin
  inherited;
  if not Assigned(BindingContext) or not (BindingContext is TPackageInfo) then
    raise Exception.Create(_('Invalid context for the page'));

  FModulePackage.LoadPackageData((BindingContext as TPackageInfo));
end;

procedure TfrmPackageDetail.OnChangeTheme(Sender: TObject; Theme: TUTheme);
begin
  inherited;
  if Theme = utLight then
  begin
    memDescription.Color := clWhite;
    memDescription.Font.Color := clBlack;
  end
  else
  begin
    memDescription.Color := clBlack;
    memDescription.Font.Color := clWhite;
  end;
end;

initialization
  RegisterClassAlias(TfrmPackageDetail, 'PackagesDetailPage');

end.
