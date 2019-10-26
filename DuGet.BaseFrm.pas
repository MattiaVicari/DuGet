unit DuGet.BaseFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.TUThemeManager,
  Vcl.StdCtrls, UCL.TUText, Vcl.ExtCtrls, UCL.TUPanel, UCL.Classes, UCL.Utils;

type
  TfrmBase = class(TFrame)
    AppThemeManager: TUThemeManager;
    boxMain: TUPanel;
    txtTitle: TUText;
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); virtual; abstract;
  public
    procedure UpdateTheme;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  DuGet.Utils;

{ TfrmBase }

constructor TfrmBase.Create(AOwner: TComponent);
begin
  inherited;
  TUtils.DoTranslation(Self);
  TUtils.SetupThemeManager(AppThemeManager);
end;

procedure TfrmBase.UpdateTheme;
begin
  if AppThemeManager.Theme = utLight then
    boxMain.CustomBackColor := clWhite
  else
    boxMain.CustomBackColor := clBlack;
  boxMain.CustomTextColor := GetTextColorFromBackground(boxMain.CustomBackColor);

  OnChangeTheme(Self, AppThemeManager.Theme);
end;

end.
