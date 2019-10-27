unit DuGet.BaseFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.TUThemeManager,
  Vcl.StdCtrls, UCL.TUText, Vcl.ExtCtrls, UCL.TUPanel, UCL.Classes, UCL.Utils,
  Vcl.WinXCtrls;

type
  TfrmBase = class(TFrame)
    AppThemeManager: TUThemeManager;
    boxMain: TUPanel;
    txtTitle: TUText;
    ActivityIndicator: TActivityIndicator;
    procedure FrameResize(Sender: TObject);
  private
    FIsBusy: Boolean;
    procedure SetIsBusy(const Value: Boolean);
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); virtual;
  public
    property IsBusy: Boolean read FIsBusy write SetIsBusy;
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
  FIsBusy := False;
  ActivityIndicator.Visible := False;
  TUtils.DoTranslation(Self);
  TUtils.SetupThemeManager(AppThemeManager);
end;

procedure TfrmBase.FrameResize(Sender: TObject);
begin
  ActivityIndicator.Left := (ClientWidth - ActivityIndicator.Width) div 2;
  ActivityIndicator.Top := (ClientHeight - ActivityIndicator.Height) div 2;
end;

procedure TfrmBase.OnChangeTheme(Sender: TObject; Theme: TUTheme);
begin
  // Implement if needed
end;

procedure TfrmBase.SetIsBusy(const Value: Boolean);
begin
  FIsBusy := Value;
  ActivityIndicator.Animate := Value;
  ActivityIndicator.Visible := Value;
  boxMain.Visible := not Value;
end;

procedure TfrmBase.UpdateTheme;
begin
  if AppThemeManager.Theme = utLight then
  begin
    boxMain.CustomBackColor := clWhite;
    ActivityIndicator.IndicatorColor := aicBlack;
  end
  else
  begin
    boxMain.CustomBackColor := clBlack;
    ActivityIndicator.IndicatorColor := aicWhite;
  end;
  boxMain.CustomTextColor := GetTextColorFromBackground(boxMain.CustomBackColor);

  OnChangeTheme(Self, AppThemeManager.Theme);
end;

end.
