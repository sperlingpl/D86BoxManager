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

unit VM.Manager;

interface

uses
  Generics.Collections, System.SysUtils, VM.Machine, VM.Emulator;

type
  TVMManager = class
  private
    FVirtualMachines: TObjectList<TVirtualMachine>;
    FEmulators: TObjectList<TEmulator>;

    procedure SaveConfig;
  public
    property VirtualMachines: TObjectList<TVirtualMachine> read FVirtualMachines;

    constructor Create;
    destructor Destroy; override;

    procedure Load;
    procedure Add(AMachine: TVirtualMachine);
  end;

  EMachineNameExists = class(Exception);

implementation

uses
  System.IOUtils, System.Classes, System.JSON.Builders, System.JSON.Writers, System.JSON.Types, System.JSON;

const
  VirtualMachinesPath = 'VM';
  ConfigurationFile = 'config.json';
  MachinesKey = 'machines';
  NameKey = 'name';
  DescriptionKey = 'description';

{ TVMManager }

function GetHomePath: String;
begin
  Result := TPath.Combine(TPath.GetHomePath, 'D86BoxManager');
end;

procedure TVMManager.Add(AMachine: TVirtualMachine);
var
  Machine: TVirtualMachine;
begin
  for Machine in FVirtualMachines do
  begin
    if Machine.Name = AMachine.Name then
      raise EMachineNameExists.Create('Virtual machine with this name already exists.');
  end;

  FVirtualMachines.Add(AMachine);
  SaveConfig;
end;

constructor TVMManager.Create;
begin
  FVirtualMachines := TObjectList<TVirtualMachine>.Create;
  FEmulators := TObjectList<TEmulator>.Create;
end;

destructor TVMManager.Destroy;
begin
  FVirtualMachines.Free;
  FEmulators.Free;

  inherited;
end;

procedure TVMManager.Load;
var
  JsonData: String;
  JsonObject: TJSONObject;
  JsonValue: TJSONValue;
  JsonArray: TJSONArray;
  Machine: TVirtualMachine;
begin
  if not TDirectory.Exists(GetHomePath) then
    Exit;

  if not TFile.Exists(TPath.Combine(GetHomePath, ConfigurationFile)) then
    Exit;

  JsonData := TFile.ReadAllText(TPath.Combine(GetHomePath, ConfigurationFile));
  JsonObject := TJSONObject.ParseJSONValue(JsonData) as TJSONObject;

  try
    JsonArray := JsonObject.Get(MachinesKey).JsonValue as TJSONArray;

    for JsonValue in JsonArray do
    begin
      Machine := TVirtualMachine.Create;
      Machine.Name := JsonValue.GetValue<String>(NameKey);
      Machine.Description := JsonValue.GetValue<String>(DescriptionKey);
      FVirtualMachines.Add(Machine);
    end;
  finally
    JsonObject.Free;
  end;
end;

procedure TVMManager.SaveConfig;
var
  Builder: TJSONObjectBuilder;
  Writer: TJsonTextWriter;
  Stream: TFileStream;
  Machine: TVirtualMachine;
  MachinesArray: TJSONCollectionBuilder.TElements;
begin
  if not TDirectory.Exists(GetHomePath) then
    TDirectory.CreateDirectory(GetHomePath);

  Stream := TFileStream.Create(TPath.Combine(GetHomePath, ConfigurationFile), fmCreate);
  Writer := TJsonTextWriter.Create(Stream);
  Builder := TJSONObjectBuilder.Create(Writer);
  try
    Writer.Formatting := TJsonFormatting.Indented;
  
    MachinesArray := Builder.BeginObject
      .BeginArray(MachinesKey);

      for Machine in VirtualMachines do
      begin
        MachinesArray.BeginObject
          .Add(NameKey, Machine.Name)
          .Add(DescriptionKey, Machine.Description)
        .EndObject;
      end;

      MachinesArray.EndArray
    .EndObject;
  finally
    Builder.Free;
    Writer.Free;
    Stream.Free;
  end;
end;

end.
