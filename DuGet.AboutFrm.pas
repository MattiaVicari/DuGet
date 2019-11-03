unit DuGet.AboutFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, DuGet.BaseFrm, UCL.TUThemeManager,
  Vcl.WinXCtrls, Vcl.StdCtrls, UCL.TUText, Vcl.ExtCtrls, UCL.TUPanel,
  Vcl.Imaging.pngimage,
  UCL.Classes;

type
  // See https://docs.microsoft.com/it-it/windows/win32/api/verrsrc/ns-verrsrc-vs_fixedfileinfo
  TVsFixedFileInfo = packed record
    Signature: DWORD;
    StrucVersion: DWORD;
    FileVersionMS: DWORD;
    FileVersionLS: DWORD;
    ProductVersionMS: DWORD;
    ProductVersionLS: DWORD;
    FileFlagsMask: DWORD;
    FileFlags: DWORD;
    FileOS: DWORD;
    FileType: DWORD;
    FileSubtype: DWORD;
    FileDateMS: DWORD;
    FileDateLS: DWORD;
  end;

  TfrmAbout = class(TfrmBase)
    boxAbout: TUPanel;
    imgLogo: TImage;
    txtName: TUText;
    txtDescription: TUText;
    txtVersion: TUText;
    txtLicense: TUText;
    memLicense: TMemo;
    procedure FrameResize(Sender: TObject);
  private
    procedure GetAppVersion;
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

//var
//  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

uses
  Math,
  JvGnugettext,
  DuGet.Utils;

constructor TfrmAbout.Create(AOwner: TComponent);
begin
  inherited;
  GetAppVersion;
  try
    memLicense.Lines.LoadFromFile(TUtils.GetLicense('license.txt'), TEncoding.UTF8);
  except
    on E: Exception do
      raise Exception.CreateFmt(_('Unable to load the license information. Error: %s'), [E.Message]);
  end;
end;

procedure TfrmAbout.FrameResize(Sender: TObject);
begin
  inherited;
  boxAbout.Width := Min(800, Max(400, ClientWidth - 200));
  boxAbout.Left := Max((ClientWidth - boxAbout.Width) div 2, 0);
end;

procedure TfrmAbout.GetAppVersion;
var
  FilePath, VersionStr: string;
  Handle: Cardinal;
  VerInfo, Block: Pointer;
  BlockSize, VerInfoSize: Cardinal;
  VerFileInfo: TVsFixedFileInfo;
begin
  FilePath := ParamStr(0);
  BlockSize := GetFileVersionInfoSize(PWideChar(FilePath), Handle);
  if BlockSize > 0 then
  begin
    GetMem(Block, BlockSize);
    try
      if GetFileVersionInfo(PWideChar(FilePath), Handle, BlockSize, Block) then
      begin
        if VerQueryValue(Block, '\', VerInfo, VerInfoSize) then
        begin
          if VerInfoSize <> SizeOf(TVsFixedFileInfo) then
            raise Exception.Create(_('Unable to retrieve the version information'));

          // See https://docs.microsoft.com/it-it/windows/win32/api/verrsrc/ns-verrsrc-vs_fixedfileinfo
          VerFileInfo := TVsFixedFileInfo(VerInfo^);
          VersionStr := Format('v.%d.%d.%d.%d', [(VerFileInfo.FileVersionMS shr 16) and $FFFF,
                                                 (VerFileInfo.FileVersionMS shr 0) and $FFFF,
                                                 (VerFileInfo.FileVersionLS shr 16) and $FFFF,
                                                 (VerFileInfo.FileVersionLS shr 0) and $FFFF]);
          txtVersion.Caption := VersionStr;
        end;
      end;
    finally
      FreeMem(Block, BlockSize);
    end;
  end;
end;

procedure TfrmAbout.OnChangeTheme(Sender: TObject; Theme: TUTheme);
begin
  inherited;
  if Theme = utLight then
  begin
    boxAbout.CustomBackColor := clWhite;
    boxAbout.CustomTextColor := clBlack;
    memLicense.Color := clWhite;
    memLicense.Font.Color := clBlack;
  end
  else
  begin
    boxAbout.CustomBackColor := clBlack;
    boxAbout.CustomTextColor := clWhite;
    memLicense.Color := clBlack;
    memLicense.Font.Color := clWhite;
  end;
end;

initialization
  RegisterClassAlias(TfrmAbout, 'AboutPage');

end.
