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

unit DuGet.Constants;

interface

uses
  Messages;

const
  UserAgentDuGet = 'DuGet, v1.0';
  DuGetAppDataFolder = 'DuGet';

  { Messages }
  WM_OWN_ENABLE_BACKBUTTON  = WM_USER + 1;
  WM_OWN_UPDATE_APPTHEME    = WM_USER + 2;
  WM_OWN_SHOW_MENU          = WM_USER + 3;

  { Colors }
  LightSelectionColor = $00E6E6E6;
  DarkSelectionColor = $001F1F1F;

implementation

end.
