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

unit DuGet.Attributes;

interface

type
  PageContextAttribute = class(TCustomAttribute)
  end;

  AppThemeChangedAttribute = class(TCustomAttribute)
  end;

  PageAppearAttribute = class(TCustomAttribute)
  end;

implementation

end.
