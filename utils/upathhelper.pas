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

unit uPathHelper;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

const AppDataFolderName = 'D86BoxManager';
const ConfigFileName = 'config.json';

function GetAppDataFolderPath: String;
function GetConfigFilePath: String;
procedure DeleteDirectory(const Path: String);

implementation

function GetAppDataFolderPath: String;
begin
  Result := ConcatPaths([GetEnvironmentVariable('appdata'), AppDataFolderName]);
end;

function GetConfigFilePath: String;
begin
  Result := ConcatPaths([GetAppDataFolderPath, ConfigFileName]);
end;

procedure DeleteDirectory(const Path: String);
var
  SearchRec: TSearchRec;
begin
  if FindFirst(Path + '\*', faAnyFile, SearchRec) = 0 then
  begin
    try
      repeat
        if (SearchRec.Attr and faDirectory <> 0) then
        begin
          if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
          begin
            DeleteDirectory(ConcatPaths([Path, SearchRec.Name]));
          end;
        end else
        begin
          DeleteFile(ConcatPaths([Path, SearchRec.Name]));
        end;
      until FindNext(SearchRec) <> 0;
    finally
      FindClose(SearchRec);
    end;
    RemoveDir(Path);
  end;
end;

end.

