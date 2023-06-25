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
  Classes, SysUtils, Generics.Collections, fpjson, process, uProcessMonitor;

type
  TEmulator = class
  public
    ID: String;
    Release: Boolean;
    Imported: Boolean;
    Path: String;
    Version: String;
  end;

  { TVirtualMachine }

  TVirtualMachine = class
  private
    CheckRunningThread: TCheckRunningThread;

    procedure OnProcessExit;
  public
    Name: String;
    Description: String;
    Emulator: TEmulator;

    OnStopped: procedure(AVM: TVirtualMachine) of object;

    destructor Destroy; override;

    procedure Run;
    procedure Configure;
  end;

  { TVMManager }

  TVMManager = class
  private
    function GetEmulatorById(AID: String): TEmulator;

  public
    Machines: specialize TObjectList<TVirtualMachine>;
    Emulators: specialize TObjectList<TEmulator>;

    constructor Create;
    destructor Destroy; override;

    procedure Add(const AMachine: TVirtualMachine);
    procedure AddEmulator(AEmulator: TEmulator);

    function Serialize: TJSONObject;
    procedure Deserialize(AJsonObject: TJSONObject);
  end;

var
  VMManager: TVMManager;

implementation

uses
  uPathHelper;

const
  MachinesNode = 'machines';
  NameNode = 'name';
  DescriptionNode = 'description';
  MachineEmulatorId = 'emulator';
  EmulatorsNode = 'emulators';
  EmulatorPathNode = 'path';
  EmulatorImportNode = 'imported';
  EmulatorReleaseNode = 'release';
  EmulatorVersionNode = 'version';
  EmulatorIdNode = 'id';

{ TVirtualMachine }

procedure TVirtualMachine.OnProcessExit;
begin
  OnStopped(Self);
end;

destructor TVirtualMachine.Destroy;
begin
  inherited Destroy;
end;

procedure TVirtualMachine.Run;
var
  Process: TProcess;
  ConfigPath: String;
begin
  Process := TProcess.Create(nil);
  Process.Executable := Emulator.Path;

  ConfigPath := ConcatPaths([GetAppDataFolderPath, Name]);
  if not DirectoryExists(ConfigPath) then
    CreateDir(ConfigPath);

  if not FileExists(ConcatPaths([ConfigPath, '86box.cfg'])) then
    Process.Parameters.Add('--settings --vmpath "%s"', [ConfigPath])
  else
    Process.Parameters.Add('--vmpath "%s"', [ConfigPath]);

  Process.Execute;

  CheckRunningThread := TCheckRunningThread.Create(True);
  CheckRunningThread.OnProcessExit := @OnProcessExit;
  CheckRunningThread.FreeOnTerminate := True;
  CheckRunningThread.Process := Process;
  CheckRunningThread.Start;
end;

procedure TVirtualMachine.Configure;
var
  Process: TProcess;
  ConfigPath: String;
begin
  Process := TProcess.Create(nil);
  Process.Executable := Emulator.Path;

  ConfigPath := ConcatPaths([GetAppDataFolderPath, Name]);
  if not DirectoryExists(ConfigPath) then
    CreateDir(ConfigPath);

  Process.Parameters.Add('--settings --vmpath "%s"', [ConfigPath]);
  Process.Execute;

  CheckRunningThread := TCheckRunningThread.Create(True);
  CheckRunningThread.FreeOnTerminate := True;
  CheckRunningThread.Process := Process;
  CheckRunningThread.Start;
end;

{ TVMManager }

function TVMManager.GetEmulatorById(AID: String): TEmulator;
var
  Emulator: TEmulator;
begin
  Result := nil;

  for Emulator in Emulators do
  begin
    if Emulator.ID = AID then
    begin
      Result := Emulator;
      Exit;
    end;
  end;
end;

constructor TVMManager.Create;
begin
  Machines := specialize TObjectList<TVirtualMachine>.Create;
  Emulators := specialize TObjectList<TEmulator>.Create;
end;

destructor TVMManager.Destroy;
begin
  Machines.Free;
  Emulators.Free;

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

procedure TVMManager.AddEmulator(AEmulator: TEmulator);
begin
  AEmulator.ID := TGuid.NewGuid.ToString;
  Emulators.Add(AEmulator);
end;

function TVMManager.Serialize: TJSONObject;
var
  MainJsonObject: TJSONObject;
  Machine: TVirtualMachine;
  Emulator: TEmulator;
  JsonArray: TJSONArray;
  JsonObject: TJSONObject;
begin
  MainJsonObject := TJSONObject.Create;
  JsonArray := TJSONArray.Create;

  for Machine in Machines do
  begin
    JsonObject := TJSONObject.Create;
    JsonObject.Add(NameNode, Machine.Name);
    JsonObject.Add(DescriptionNode, Machine.Description);
    JsonObject.Add(MachineEmulatorId, Machine.Emulator.ID);
    JsonArray.Add(JsonObject);
  end;

  MainJsonObject.Add(MachinesNode, JsonArray);

  JsonArray := TJSONArray.Create;

  for Emulator in Emulators do
  begin
    JsonObject := TJSONObject.Create;
    JsonObject.Add(EmulatorIdNode, Emulator.ID);
    JsonObject.Add(EmulatorPathNode, Emulator.Path);
    JsonObject.Add(EmulatorImportNode, Emulator.Imported);
    JsonObject.Add(EmulatorReleaseNode, Emulator.Release);
    JsonObject.Add(EmulatorVersionNode, Emulator.Version);
    JsonArray.Add(JsonObject);
  end;

  MainJsonObject.Add(EmulatorsNode, JsonArray);

  Result := MainJsonObject;
end;

procedure TVMManager.Deserialize(AJsonObject: TJSONObject);
var
  JsonArray: TJSONArray;
  JsonEnum: TJSONEnum;
  JsonObject: TJSONObject;
  Machine: TVirtualMachine;
  Emulator: TEmulator;
begin
  JsonArray := TJSONArray(AJsonObject.FindPath(EmulatorsNode));

  if Assigned(JsonArray) then
  begin
    for JsonEnum in JsonArray do
    begin
      JsonObject := TJSONObject(JsonEnum.Value);
      Emulator := TEmulator.Create;
      Emulator.ID := JsonObject.Get(EmulatorIdNode);
      Emulator.Path := JsonObject.Get(EmulatorPathNode);
      Emulator.Release := JsonObject.Get(EmulatorReleaseNode);
      Emulator.Imported := JsonObject.Get(EmulatorImportNode);
      Emulator.Version := JsonObject.Get(EmulatorVersionNode);
      Emulators.Add(Emulator);
    end;
  end;

  JsonArray := TJSONArray(AJsonObject.FindPath(MachinesNode));

  if Assigned(JsonArray) then
  begin
    for JsonEnum in JsonArray do
    begin
      JsonObject := TJSONObject(JsonEnum.Value);
      Machine := TVirtualMachine.Create;
      Machine.Name := JsonObject.Get(NameNode);
      Machine.Description := JsonObject.Get(DescriptionNode);
      Machine.Emulator := GetEmulatorById(JsonObject.Get(MachineEmulatorId));
      Machines.Add(Machine);
    end;
  end;
end;

initialization
  VMManager := TVMManager.Create;

finalization
  VMManager.Free;

end.

