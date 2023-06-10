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

unit uEmulatorsForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls;

type

  { TEmulatorsForm }

  TEmulatorsForm = class(TForm)
    BtnClose: TButton;
    BtnAdd: TButton;
    BtnRemove: TButton;
    BtnShowFolder: TButton;
    LvEmulators: TListView;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnRemoveClick(Sender: TObject);
    procedure BtnShowFolderClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LvEmulatorsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure LvEmulatorsDblClick(Sender: TObject);
  private
    procedure FillEmulators;
    procedure UpdateButtons;
    procedure OpenSelectedFolder;
  public
    class procedure Execute(AOwner: TComponent);
  end;

implementation

{$R *.lfm}

uses
  uAddEmulatorForm, uVMManager, uConfigManager, LCLIntf;

var
  EmulatorsForm: TEmulatorsForm;

{ TEmulatorsForm }

procedure TEmulatorsForm.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TEmulatorsForm.FormCreate(Sender: TObject);
begin
  FillEmulators;
  UpdateButtons;
end;

procedure TEmulatorsForm.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TEmulatorsForm.BtnRemoveClick(Sender: TObject);
var
  Emulator: TEmulator;
begin
  if LvEmulators.Selected <> nil then
  begin
    Emulator := TEmulator(LvEmulators.Selected.Data);

    VMManager.Emulators.Remove(Emulator);
    LvEmulators.Items.Delete(LvEmulators.ItemIndex);
    ConfigManager.Save;
    UpdateButtons;
  end;
end;

procedure TEmulatorsForm.BtnShowFolderClick(Sender: TObject);
begin
  OpenSelectedFolder;
end;

procedure TEmulatorsForm.BtnAddClick(Sender: TObject);
begin
  TAddEmulatorForm.Execute(nil);
  FillEmulators;
end;

procedure TEmulatorsForm.FormDestroy(Sender: TObject);
begin
  EmulatorsForm := nil;
end;

procedure TEmulatorsForm.LvEmulatorsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  UpdateButtons;
end;

procedure TEmulatorsForm.LvEmulatorsDblClick(Sender: TObject);
begin
  OpenSelectedFolder;
end;

procedure TEmulatorsForm.FillEmulators;
var
  Item: TListItem;
  Emulator: TEmulator;
begin
  LvEmulators.Items.Clear;

  for Emulator in VMManager.Emulators do
  begin
    Item := LvEmulators.Items.Add;
    Item.Data := Emulator;
    Item.Caption := Emulator.Version;

    if Emulator.Imported then
    begin
      Item.SubItems.Add('Imported')
    end else
    begin
      if Emulator.Release then
        Item.SubItems.Add('Release')
      else
        Item.SubItems.Add('Beta');
    end;

    Item.SubItems.Add(Emulator.Path);
  end;
end;

procedure TEmulatorsForm.UpdateButtons;
var
  IsSelected: Boolean;
begin
  IsSelected := LvEmulators.Selected <> nil;
  BtnRemove.Enabled := IsSelected;
  BtnShowFolder.Enabled := IsSelected;
end;

procedure TEmulatorsForm.OpenSelectedFolder;
var
  Emulator: TEmulator;
begin
  Emulator := TEmulator(LvEmulators.Selected.Data);
  if Assigned(Emulator) then
  begin
    OpenDocument(ExtractFilePath(Emulator.Path));
  end;
end;

class procedure TEmulatorsForm.Execute(AOwner: TComponent);
begin
  if not Assigned(EmulatorsForm) then
    EmulatorsForm := TEmulatorsForm.Create(AOwner);

  EmulatorsForm.Show;
end;

end.

