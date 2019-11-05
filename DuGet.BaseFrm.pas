unit DuGet.BaseFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UCL.TUThemeManager,
  Vcl.StdCtrls, UCL.TUText, Vcl.ExtCtrls, UCL.TUPanel, UCL.Classes, UCL.Utils,
  Vcl.WinXCtrls,
  DuGet.Attributes, Vcl.Imaging.pngimage;

type
  TfrmBase = class(TFrame)
    AppThemeManager: TUThemeManager;
    boxMain: TUPanel;
    txtTitle: TUText;
    ActivityIndicator: TActivityIndicator;
    procedure FrameResize(Sender: TObject);
  private
    [PageContext]
    FContext: TObject;
    FIsBusy: Boolean;
    procedure SetIsBusy(const Value: Boolean);
  protected
    procedure OnChangeTheme(Sender: TObject; Theme: TUTheme); virtual;
    procedure OnAppear(Sender: Tobject); virtual;
  public
    [AppThemeChanged]
    procedure UpdateTheme;
    [PageAppear]
    procedure PageAppear;

    property IsBusy: Boolean read FIsBusy write SetIsBusy;
    property BindingContext: TObject read FContext write FContext;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

uses
  DuGet.Constants,
  DuGet.NavigationManager,
  DuGet.Utils;

{ TfrmBase }

constructor TfrmBase.Create(AOwner: TComponent);
begin
  inherited;
  FContext := nil;
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

procedure TfrmBase.OnAppear(Sender: Tobject);
begin
  // Implement if needed
end;

procedure TfrmBase.OnChangeTheme(Sender: TObject; Theme: TUTheme);
begin
  // Implement if needed
end;

procedure TfrmBase.PageAppear;
begin
  OnAppear(Self);
end;

procedure TfrmBase.SetIsBusy(const Value: Boolean);
begin
  FIsBusy := Value;
  ActivityIndicator.Animate := Value;
  ActivityIndicator.Visible := Value;
  boxMain.Visible := not Value;
  if not NavigationManager.IsModal then
  begin
    if FIsBusy then
    begin
      PostMessage(Screen.Forms[0].Handle, WM_OWN_SHOW_MENU, 0, 0);
      PostMessage(Screen.Forms[0].Handle, WM_OWN_ENABLE_BACKBUTTON, 0, 0);
    end
    else
    begin
      PostMessage(Screen.Forms[0].Handle, WM_OWN_SHOW_MENU, 1, 0);
      if NavigationManager.HistorySize > 1 then
        PostMessage(Screen.Forms[0].Handle, WM_OWN_ENABLE_BACKBUTTON, 1, 0);
    end;
  end;
end;

procedure TfrmBase.UpdateTheme;
begin
  if AppThemeManager.Theme = utLight then
  begin
    boxMain.CustomBackColor := clWhite;
    ActivityIndicator.IndicatorColor := aicBlack;
    Self.Color := clWhite;
  end
  else
  begin
    boxMain.CustomBackColor := clBlack;
    ActivityIndicator.IndicatorColor := aicWhite;
    Self.Color := clBlack;
  end;
  boxMain.CustomTextColor := GetTextColorFromBackground(boxMain.CustomBackColor);

  OnChangeTheme(Self, AppThemeManager.Theme);
end;

end.
