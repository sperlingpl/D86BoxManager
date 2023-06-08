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

unit uVMManager;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Generics.Collections, fpjson;

type
  TVirtualMachine = class
  public
    Name: String;
    Description: String;
  end;

  TEmulator = class

  end;

  { TVMManager }

  TVMManager = class
  public
    Machines: specialize TObjectList<TVirtualMachine>;

    constructor Create;
    destructor Destroy; override;

    procedure Add(const AMachine: TVirtualMachine);

    function Serialize: TJSONObject;
    procedure Deserialize(AJsonObject: TJSONObject);
  end;

var
  VMManager: TVMManager;

implementation

{ TVMManager }

const
  MachinesNode = 'machines';
  NameNode = 'name';
  DescriptionNode = 'description';

constructor TVMManager.Create;
begin
  Machines := specialize TObjectList<TVirtualMachine>.Create;
end;

destructor TVMManager.Destroy;
begin
  Machines.Free;

  inherited Destroy;
end;

procedure TVMManager.Add(const AMachine: TVirtualMachine);
var
  Machine: TVirtualMachine;
begin
  for Machine in Machines do
  begin
    if AMachine.Name = Machine.Name then
      raise Exception.Create('Machine with this name already exists.');
  end;

  Machines.Add(AMachine);
end;

function TVMManager.Serialize: TJSONObject;
var
  JsonObject: TJSONObject;
  Machine: TVirtualMachine;
  MachinesArray: TJSONArray;
  VMObject: TJSONObject;
begin
  JsonObject := TJSONObject.Create;
  MachinesArray := TJSONArray.Create;

  for Machine in Machines do
  begin
    VMObject := TJSONObject.Create;
    VMObject.Add(NameNode, Machine.Name);
    VMObject.Add(DescriptionNode, Machine.Description);
    MachinesArray.Add(VMObject);
  end;

  JsonObject.Add(MachinesNode, MachinesArray);

  Result := JsonObject;
end;

procedure TVMManager.Deserialize(AJsonObject: TJSONObject);
var
  MachinesArray: TJSONArray;
  MachineEnum: TJSONEnum;
  MachineObject: TJSONObject;
  Machine: TVirtualMachine;
begin
  MachinesArray := TJSONArray(AJsonObject.FindPath(MachinesNode));

  if Assigned(MachinesArray) then
  begin
    for MachineEnum in MachinesArray do
    begin
      MachineObject := TJSONObject(MachineEnum.Value);
      Machine := TVirtualMachine.Create;
      Machine.Name := MachineObject.Get(NameNode);
      Machine.Description := MachineObject.Get(DescriptionNode);
      Machines.Add(Machine);
    end;
  end;
end;

initialization
  VMManager := TVMManager.Create;

finalization
  VMManager.Free;

end.

