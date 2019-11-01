unit DuGet.PackagesDetailFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.IOUtils,
  DuGet.BaseFrm, UCL.TUThemeManager,
  Vcl.WinXCtrls, Vcl.StdCtrls, UCL.TUText, Vcl.ExtCtrls, UCL.TUPanel,
  UCL.TUHyperLink, UCL.Classes, DuGet.Proxy, DuGet.Modules.Package,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope;

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
    BindSource: TBindSourceDB;
    BindingsList: TBindingsList;
    LinkPropertyToFieldCaption: TLinkPropertyToField;
    LinkPropertyToFieldCaption4: TLinkPropertyToField;
    LinkPropertyToFieldCaption2: TLinkPropertyToField;
    LinkControlToField1: TLinkControlToField;
    LinkPropertyToFieldCaption5: TLinkPropertyToField;
    LinkPropertyToFieldCaption6: TLinkPropertyToField;
    LinkPropertyToFieldCaption7: TLinkPropertyToField;
    LinkPropertyToFieldCaption3: TLinkPropertyToField;
    LinkPropertyToFieldURL: TLinkPropertyToField;
    LinkPropertyToFieldURL2: TLinkPropertyToField;
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); override;
    procedure OnAppear(Sender: TObject); override;
  end;

//var
//  frmPackageDetail: TfrmPackageDetail;

implementation

{$R *.dfm}

uses
  JvGnugettext,
  DuGet.Utils;

{ TfrmPackageDetail }

procedure TfrmPackageDetail.OnAppear(Sender: TObject);
var
  DataModule: TmodPackage;
begin
  inherited;
  if not Assigned(BindingContext) or not (BindingContext is TmodPackage) then
    raise Exception.Create(_('Invalid context for the page'));

  DataModule := (BindingContext as TmodPackage);
  if (DataModule.fdmPackagesLOGO_CACHED_FILEPATH.AsString <> '')
    and (TFile.Exists(DataModule.fdmPackagesLOGO_CACHED_FILEPATH.AsString)) then
    imgLogo.Picture.LoadFromFile(DataModule.fdmPackagesLOGO_CACHED_FILEPATH.AsString)
  else
    imgLogo.Picture.LoadFromFile(TUtils.GetAsset('Logo_150x150.png'));
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
