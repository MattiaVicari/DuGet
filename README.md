# DuGet
Package Manager for Delphi

## Requirement
- [GNU GetText](http://dxgettext.po.dk/Home) for translations
- [JEDI](https://github.com/project-jedi) for use the unit JvGnugettext for translations
- [UniversalCL](https://github.com/VuioVuio/UniversalCL) by VuioVuvio

## Introduction
DuGet is a package manager for Delphi.
It is based on the [Delphinus](https://github.com/Memnarch/Delphinus) mechanism for find the packages on GitHub.
A characteristic of the DuGet Application is the fluent design that make the application similar to an UWP App.

For the translations I have used the JvGnugettext unit distributed by JEDI instead of the gnugettext.pas available at the website of GNU GetText (because it is few dated for Delphi Rio).

If you don't want to use gnugettext for translations, you can comment the definition of GNUGETTEXT in duget.inc.
If GNUGETTEXT is not defined, the unit DuGet.Translator will be used. In this unit you have to implement your system for translations. 
