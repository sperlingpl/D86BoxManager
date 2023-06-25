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

unit uAddEmulatorForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  windows;

type

  { TAddEmulatorForm }

  TAddEmulatorForm = class(TForm)
    BtnChoose: TButton;
    BtnCancel: TButton;
    BtnOk: TButton;
    GroupBox1: TGroupBox;
    EdtPath: TLabeledEdit;
    LblVersion: TLabel;
    Notebook1: TNotebook;
    OdFile: TOpenDialog;
    Page1: TPage;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnChooseClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
  private

  public
    class procedure Execute(AOwner: TComponent);
  end;

implementation

{$R *.lfm}

uses
  uExeInfoHelper, uVMManager, uConfigManager;

var
  AddEmulatorForm: TAddEmulatorForm;

{ TAddEmulatorForm }

procedure TAddEmulatorForm.BtnChooseClick(Sender: TObject);
var
  ExeVersionInfo: TExeVersionInfo;
begin
  if OdFile.Execute then
  begin
    EdtPath.Text := OdFile.FileName;
    ExeVersionInfo := TExeVersionInfo.Create(OdFile.FileName);
    try
      if ExeVersionInfo.HasVersionInfo then
      begin
        LblVersion.Caption := ExeVersionInfo.Version
      end
      else
      begin
        LblVersion.Caption := 'No info available';
      end;
    finally
      ExeVersionInfo.Free;
    end;
  end;
end;

procedure TAddEmulatorForm.BtnOkClick(Sender: TObject);
var
  ExeVersionInfo: TExeVersionInfo;
  Emulator: TEmulator;
begin
  ExeVersionInfo := TExeVersionInfo.Create(EdtPath.Text);
  try
    Emulator := TEmulator.Create;
    Emulator.Imported := True;
    Emulator.Path := EdtPath.Text;
    Emulator.Release := False;
    Emulator.Version := ExeVersionInfo.Version;
    VMManager.AddEmulator(Emulator);
    ConfigManager.Save;
  finally
    ExeVersionInfo.Free;
  end;

  Close;
end;

procedure TAddEmulatorForm.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

class procedure TAddEmulatorForm.Execute(AOwner: TComponent);
begin
  AddEmulatorForm := TAddEmulatorForm.Create(AOwner);
  AddEmulatorForm.ShowModal;
  AddEmulatorForm.Free;
end;

end.

