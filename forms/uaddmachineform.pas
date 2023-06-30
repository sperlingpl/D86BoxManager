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

unit uAddMachineForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, Sysutils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  uVMManager;

type

  { TAddMachineForm }

  TAddMachineForm = class(Tform)
    BtnCancel: Tbutton;
    BtnOk: Tbutton;
    BtnAddEmulator: Tbutton;
    CbEmulators: Tcombobox;
    Groupbox1: Tgroupbox;
    Groupbox2: Tgroupbox;
    EdtName: TLabeledEdit;
    EdtDescription: TLabeledEdit;
    LblEmulators: Tlabel;
    procedure BtnAddEmulatorClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure CbEmulatorsChange(Sender: TObject);
    procedure EdtNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  Private
    FMachine: TVirtualMachine;

    procedure Validate;
    procedure FillEmulators;
  Public
    procedure SetMachine(AMachine: TVirtualMachine);

    class procedure Execute(AOwner: TComponent; AMachine: TVirtualMachine = nil);
  end;

implementation

{$R *.lfm}

uses
  uConfigManager, uAddEmulatorForm;

var
  AddMachineForm: TAddMachineForm;

{ TAddMachineForm }

procedure TAddMachineForm.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TAddMachineForm.BtnAddEmulatorClick(Sender: TObject);
begin
  TAddEmulatorForm.Execute(nil);
  FillEmulators;
end;

procedure TAddMachineForm.BtnOkClick(Sender: TObject);
var
  Machine: TVirtualMachine;
begin
  Machine := TVirtualMachine.Create;
  try
    Machine.Name := Trim(EdtName.Text);
    Machine.Description := EdtDescription.Text;
    Machine.Emulator := TEmulator(CbEmulators.Items.Objects[CbEmulators.ItemIndex]);
    VMManager.Add(Machine);
    ConfigManager.Save;
    Close;
  except
    on E: Exception do
    begin
      Machine.Free;
      MessageDlg('Error', E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TAddMachineForm.CbEmulatorsChange(Sender: TObject);
begin
  Validate;
end;

procedure TAddMachineForm.EdtNameChange(Sender: TObject);
begin
  Validate;
end;

procedure TAddMachineForm.FormCreate(Sender: TObject);
begin
  FillEmulators;
  Validate;
end;

procedure TAddMachineForm.FormShow(Sender: TObject);
var
  Emulator: TEmulator;
  I: Integer;
begin
  if Assigned(FMachine) then
  begin
    EdtName.Text := FMachine.Name;
    EdtDescription.Text := FMachine.Description;

    for I := 0 to CbEmulators.Items.Count - 1 do
    begin
      Emulator := TEmulator(CbEmulators.Items.Objects[I]);
      if Emulator = FMachine.Emulator then
      begin
        CbEmulators.ItemIndex := I;
      end;
    end;

    Validate;
  end;
end;

procedure TAddMachineForm.Validate;
begin
  BtnOk.Enabled := (Trim(EdtName.Text) <> '') and (CbEmulators.ItemIndex >= 0);
end;

procedure TAddMachineForm.FillEmulators;
var
  Emulator: TEmulator;
  TypeString: String;
begin
  CbEmulators.Clear;

  for Emulator in VMManager.Emulators do
  begin
    if Emulator.Imported then
    begin
      TypeString := 'Imported'
    end else
    begin
      if Emulator.Release then
        TypeString := 'Release'
      else
        TypeString := 'Beta';
    end;

    CbEmulators.AddItem(
      Format('%s (%s)', [Emulator.Version, TypeString]),
      Emulator
    );
  end;
end;

procedure TAddMachineForm.SetMachine(AMachine: TVirtualMachine);
begin
  FMachine := AMachine;
end;

class procedure TAddMachineForm.Execute(AOwner: TComponent; AMachine: TVirtualMachine = nil);
begin
  AddMachineForm := TAddMachineForm.Create(AOwner);
  AddMachineForm.SetMachine(AMachine);
  AddMachineForm.ShowModal;
  AddMachineForm.Free;
end;

end.

