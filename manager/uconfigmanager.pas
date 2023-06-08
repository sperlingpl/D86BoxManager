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

unit uConfigManager;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fpjson;

type

  { TConfigManager }

  TConfigManager = class
  public
    procedure Save;
    procedure Load;
  end;

var
  ConfigManager: TConfigManager;

implementation

{ TConfigManager }

uses
  uVMManager, uPathHelper;

const
  DataNode = 'data';

procedure TConfigManager.Save;
var
  JsonObject: TJSONObject;
  VMObject: TJSONObject;
  FileStream: TFileStream;
  JsonString: String;
begin
  JsonObject := TJsonObject.Create;

  VMObject := VMManager.Serialize;
  JsonObject.Add(DataNode, VMObject);

  FileStream := TFileStream.Create(GetConfigFilePath, fmCreate);
  try
    JsonString := JsonObject.FormatJSON;
    FileStream.Write(JsonString[1], Length(JsonString));
  finally
    FileStream.Free;
  end;

  JsonObject.Free;
end;

procedure TConfigManager.Load;
var
  StringList: TStringList;
  JsonObject: TJSONObject;
begin
  StringList := TStringList.Create;
  try
    StringList.LoadFromFile(GetConfigFilePath);
    JsonObject := GetJSON(StringList.Text) as TJSONObject;
    VMManager.Deserialize(TJSONObject(JsonObject.FindPath(DataNode)));
  finally
    JsonObject.Free;
    StringList.Free;
  end;
end;

initialization
  ConfigManager := TConfigManager.Create;

finalization
  ConfigManager.Free;

end.

