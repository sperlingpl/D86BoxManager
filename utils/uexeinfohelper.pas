{
    D86Box Manager - Simple 86Box emulator manager
    Copyright (C) 2023  Paweł Wróblewski

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

unit uExeInfoHelper;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TExeVersionInfo }

  TExeVersionInfo = class
  private
    FHasVersionInfo: Boolean;
    FVersion: String;

    function GetVersionSize(const AFileName: String): Cardinal;
  public
    property HasVersionInfo: Boolean read FHasVersionInfo;
    property Version: String read FVersion;

    constructor Create(const AFileName: String);
  end;

implementation

uses
  windows;

{ TExeVersionInfo }

function TExeVersionInfo.GetVersionSize(const AFileName: String): Cardinal;
begin
  Result := GetFileVersionInfoSize(PChar(AFileName), nil);
end;

constructor TExeVersionInfo.Create(const AFileName: String);
var
  VerInfoSize: Cardinal;
  PVerInfo: Pointer;
  PVerValue: PVSFIXEDFILEINFO;
begin
  VerInfoSize := GetVersionSize(AFileName);
  FHasVersionInfo := VerInfoSize > 0;

  if FHasVersionInfo then
  begin
    GetMem(PVerInfo, VerInfoSize);
    try
      if not GetFileVersionInfo(PChar(AFileName), 0, VerInfoSize, PVerInfo) then
      begin
        FHasVersionInfo := False;
      end;

      VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerInfoSize);

      with PVerValue^ do
      begin
        FVersion := Format('%d.%d.%d.%d', [
          HIWORD(dwFileVersionMS),
          LOWORD(dwFileVersionMS),
          HIWORD(dwFileVersionLS),
          LOWORD(dwFileVersionLS)
        ]);
      end;
    finally
      Freemem(PVerInfo);
    end;
  end;
end;

end.

