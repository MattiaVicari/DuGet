unit DuGet.Constants;

interface

uses
  Messages;

const
  UserAgentDuGet = 'DuGet, v1.0';

  { Messages }
  WM_OWN_ENABLE_BACKBUTTON  = WM_USER + 1;
  WM_OWN_UPDATE_APPTHEME    = WM_USER + 2;
  WM_OWN_SHOW_MENU          = WM_USER + 3;

  { Colors }
  LightSelectionColor = $00E6E6E6;
  DarkSelectionColor = $001F1F1F;

implementation

end.
