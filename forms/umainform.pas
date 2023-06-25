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

unit uMainForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Sysutils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus,
  laz.VirtualTrees;

type

  { TMainForm }

  TMainForm = class(Tform)
    Button1: Tbutton;
    Button2: Tbutton;
    Button3: Tbutton;
    Groupbox1: Tgroupbox;
    MIRun: TMenuItem;
    MIConfigure: TMenuItem;
    PMMachines: TPopupMenu;
    VST: Tlazvirtualstringtree;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MIConfigureClick(Sender: TObject);
    procedure MIRunClick(Sender: TObject);
    procedure VSTChange(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure VSTDblClick(Sender: TObject);
    procedure VSTFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
  Private
    procedure FillData;
    procedure RunVM;
    procedure ConfigureVM;
  Public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  uAddMachineForm, uConfigManager, uEmulatorsForm, uVMManager;

type
  PTreeData = ^TTreeData;
  TTreeData = record
    Column0: String;
    Column1: String;
    Machine: TVirtualMachine;
  end;

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
begin
  TAddMachineForm.Execute(nil);
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  TEmulatorsForm.Execute(nil);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ConfigManager.Load;
  FillData;
end;

procedure TMainForm.MIConfigureClick(Sender: TObject);
begin
  ConfigureVM;
end;

procedure TMainForm.MIRunClick(Sender: TObject);
begin
  RunVM;
end;

procedure TMainForm.VSTChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  VST.Refresh;
end;

procedure TMainForm.VSTDblClick(Sender: TObject);
begin
  RunVM;
end;

procedure TMainForm.VSTFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
begin
  VST.Refresh;
end;

procedure TMainForm.VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PTreeData;
begin
  Data := VST.GetNodeData(Node);
  if Assigned(Data) then
  begin
    Data^.Column0 := '';
    Data^.Column1 := '';
    Data^.Machine := nil;
  end;
end;

procedure TMainForm.VSTGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeData);
end;

procedure TMainForm.VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PTreeData;
begin
  Data := VST.GetNodeData(Node);
  case Column of
    0: CellText := Data^.Column0;
    1: CellText := Data^.Column1;
  end;
end;

procedure TMainForm.FillData;
var
  Machine: TVirtualMachine;
  Data: PTreeData;
  Node: PVirtualNode;
begin
  for Machine in VMManager.Machines do
  begin
    Node := VST.AddChild(nil);
    Data := VST.GetNodeData(Node);
    Data^.Column0 := Machine.Name;
    Data^.Column1 := 'Stopped';
    Data^.Machine := Machine;
  end;
end;

procedure TMainForm.RunVM;
var
  Node: PVirtualNode;
  Data: PTreeData;
begin
  Node := VST.GetFirstSelected;
  if Assigned(Node) then
  begin
    Data := VST.GetNodeData(Node);
    if Assigned(Data) then
    begin
      Data^.Machine.Run;
      Data^.Column1 := 'Running';
    end;
  end;

  VST.Refresh;
end;

procedure TMainForm.ConfigureVM;
var
  Node: PVirtualNode;
  Data: PTreeData;
begin
  Node := VST.GetFirstSelected;
  if Assigned(Node) then
  begin
    Data := VST.GetNodeData(Node);
    if Assigned(Data) then
    begin
      Data^.Machine.Configure;
    end;
  end;
end;

end.

