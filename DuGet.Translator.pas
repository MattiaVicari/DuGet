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
{-------------------------------------------------------------------------------
  Place where you can implement your procedure for translations.
  Here you can find the same functions of JvGnugettext... but you can implement
  them like you need.
  This file is included when the preprocessor directive GNUGETTEXT is not
  defined (see file duget.inc).
-------------------------------------------------------------------------------}
unit DuGet.Translator;

interface

uses
  System.Classes;

procedure TranslateComponent(AnObject: TComponent; const TextDomain: string='');
procedure UseLanguage(const LanguageCode: string);
function _(const Text: string): string;

implementation

procedure TranslateComponent(AnObject: TComponent; const TextDomain: string='');
begin
  // Your code here
end;

procedure UseLanguage(const LanguageCode: string);
begin
  // Your code here
end;

function _(const Text: string): string;
begin
  Result := Text;
  // Your code here
end;

end.
